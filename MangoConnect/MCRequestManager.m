//
//  MCRequestManager.m
//  MangoConnect
//
//  Created by Jader Feijo on 24/08/2012.
//
//

#import "MCRequestManager.h"
#import "MCObjectCollection.h"
#import "MCRequest.h"
#import "MCModel.h"

static MCRequestManager *_requestManager;

@implementation MCRequestManager

+ (MCRequestManager *)defaultManager {
	if (!_requestManager) {
		_requestManager = [[MCRequestManager alloc] init];
	}
	return _requestManager;
}

@synthesize model;
@synthesize productionServerAddress;
@synthesize developmentServerAddress;
@synthesize useProductionServer;
@synthesize username;
@synthesize password;
@synthesize authenticationMethod;

//
// MCRequestManager Methods
//
#pragma mark - MCRequestManager Methods -

- (id)init {
	if ((self = [super init])) {
		model = [[MCModel alloc] init];
		productionServerAddress = nil;
		developmentServerAddress = nil;
		useProductionServer = YES;
	}
	return self;
}

- (NSString *)serverAddress {
	if (useProductionServer) {
		return productionServerAddress;
	} else {
		return developmentServerAddress;
	}
}

-(void)sendWithAddress:(NSString *)address withBlock:(ResponseHandlerBlock)responseHandler {
	MCRequest * request = [[MCRequest alloc] initWithRequestManager:self];
	[request setAddress:address];
	[self sendWithRequest:request withBlock:responseHandler];
}

-(void)sendWithRequest:(MCRequest *)request withBlock:(ResponseHandlerBlock)responseHandler {
	//set up authentication which keeps stored somewhere in the system, via the NSURLCredentialStorage system object
	if (username) {
		NSString * authMethod;
		if (authenticationMethod == MCAuthenticationMethodBasic) {
			authMethod = NSURLAuthenticationMethodHTTPBasic;
		} else if (authenticationMethod == MCAuthenticationMethodDigest) {
			authMethod = NSURLAuthenticationMethodHTTPDigest;
		} else {
			authMethod = nil;
		}
		
		NSURLCredential * credentials = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistenceForSession];
		NSURLProtectionSpace * protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:[request.url host] port:[request.url.port integerValue] protocol:@"http" realm:nil authenticationMethod:authMethod];
		[[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credentials forProtectionSpace:protectionSpace];
		[protectionSpace release];
	}
	
	NSMutableURLRequest * httpRequest = [NSMutableURLRequest requestWithURL:[request url]];
	[httpRequest setHTTPMethod:[request requestMethod]];
	[httpRequest setURL:[request url]];
	[httpRequest setHTTPBody:[self parametersDataInRequest:request]];
	
	NSOperationQueue * httpSessionQueue = [[NSOperationQueue alloc] init];
	[NSURLConnection sendAsynchronousRequest:httpRequest queue:httpSessionQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		if ([data length]) {
			NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
			
			MCObjectCollection * collection = [[MCObjectCollection alloc] initWithXMLString:[NSString stringWithUTF8String:[data bytes]] andModel:[self model]];
			
			if (!connectionError && [httpResponse statusCode] && [httpResponse statusCode] != 200) {
				connectionError = [MCRequestManagerError errorWithCode:[httpResponse statusCode]];
			}
			
			if (responseHandler) {
				responseHandler([httpResponse statusCode], [collection objects], connectionError);
			}
			
			[collection release];
		} else {
			if (responseHandler) {
				responseHandler(0, nil, connectionError);
			}
		}
	}];
	[httpSessionQueue release];
}

- (NSData *)parametersDataInRequest:(MCRequest *)request {
	NSMutableString * parametersString = [NSMutableString stringWithString:@""];
	
	for (NSString * paramKey in [request parameters]) {
		[parametersString appendFormat:@"%@=%@&", [paramKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [request.parameters[paramKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
	
	return [parametersString dataUsingEncoding:NSUTF8StringEncoding];
}

//
// NSObject Methods
//
#pragma mark - NSObject Methods -

- (void)dealloc {
	[model release];
	[productionServerAddress release];
	[developmentServerAddress release];
	[username release];
	[password release];
	[super dealloc];
}

@end
