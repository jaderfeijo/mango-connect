//
//  MCRequest.m
//  MangoConnect
//
//  Created by Jader Feijo on 23/08/2012.
//
//

#import "MCRequest.h"
#import "NSString+Hashing.h"

@implementation MCRequest {
	NSMutableDictionary *_parameters;
}

//
// Static Methods
//
#pragma mark - Static Methods -

+ (instancetype)requestWithAddress:(NSString *)address method:(NSString *)method authenticate:(BOOL)authenticate context:(MCObjectContext *)context {
	return [[MCRequest alloc] initWithAddress:address method:method authenticate:authenticate context:context];
}

+ (instancetype)requestWithAddress:(NSString *)address method:(NSString *)method context:(MCObjectContext *)context {
	return [[MCRequest alloc] initWithAddress:address method:method context:context];
}

//
// MCRequest Methods
//
#pragma mark - MCRequest Methods -

- (id)initWithAddress:(NSString *)address method:(NSString *)method authenticate:(BOOL)authenticate context:(MCObjectContext *)context {
	if ((self = [super init])) {
		_context = context;
		_address = address;
		_method = method;
		_authenticate = authenticate;
		_contentType = nil;
		_parameters = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (id)initWithAddress:(NSString *)address method:(NSString *)method context:(MCObjectContext *)context {
	if ((self = [self initWithAddress:address method:method authenticate:[[context server] shouldAuthenticateRequest:self] context:context])) {
		//
	}
	return self;
}

- (void)setValue:(id)value forParameter:(NSString *)parameter {
	[_parameters setValue:value forKey:parameter];
}

- (id)valueForParameter:(NSString *)parameter {
	return [_parameters valueForKey:parameter];
}

- (void)removeParameter:(NSString *)parameter {
	[_parameters removeObjectForKey:parameter];
}

- (NSDictionary *)parameters {
	return _parameters;
}

- (NSData *)body {
	NSMutableString *parametersString = [[NSMutableString alloc] init];
	
	for (NSString *paramKey in [self parameters]) {
		[parametersString appendFormat:@"%@=%@&", [paramKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [self.parameters[paramKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
	
	return [parametersString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSURL *)url {
	return [NSURL URLWithString:[self address] relativeToURL:[[[self context] server] url]];
}

-(void)sendWithBlock:(MCRequestCompletionBlock)completionBlock {
	NSString *randomData = [NSString randomString];
	NSString *authentication = [[[[[self context] server] authenticationToken] stringByAppendingString:randomData] sha256];
	
	NSMutableURLRequest *httpRequest = [NSMutableURLRequest requestWithURL:[self url]];
	[httpRequest setHTTPMethod:[self method]];
	[httpRequest setHTTPBody:[self body]];
	[httpRequest addValue:MCVersion forHTTPHeaderField:MCProtocolVersionHeader];
	[httpRequest addValue:authentication forHTTPHeaderField:MCRequestAuthenticationTokenHeader];
	[httpRequest addValue:randomData forHTTPHeaderField:MCRequestRandomDataHeader];
	if ([self contentType]) [httpRequest addValue:[self contentType] forHTTPHeaderField:MCRequestContentTypeHeader];
	
	[NSURLConnection sendAsynchronousRequest:httpRequest queue:[[self context] operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
		if (!connectionError) {
			if ([httpResponse statusCode] == MC_BAD_REQUEST_HTTP_REPONSE) {
				if (completionBlock) completionBlock(self, nil, [NSError errorWithDomain:MCMangoConnectErrorDomain code:MCMangoConnectBadRequestError userInfo:nil]);
			} else if ([httpResponse statusCode] == MC_UNAUTHORIZED_HTTP_RESPONSE) {
				if (completionBlock) completionBlock(self, nil, [NSError errorWithDomain:MCMangoConnectErrorDomain code:MCMangoConnectUnauthorizedError userInfo:nil]);
			} else if ([httpResponse statusCode] == MC_NOT_FOUND_HTTP_RESPONSE) {
				if (completionBlock) completionBlock(self, nil, [NSError errorWithDomain:MCMangoConnectErrorDomain code:MCMangoConnectNotFoundError userInfo:nil]);
			} else if ([httpResponse statusCode] == MC_INTERNAL_SERVER_ERROR_RESPONSE) {
				if (completionBlock) completionBlock(self, nil, [NSError errorWithDomain:MCMangoConnectErrorDomain code:MCMangoConnectInternalServerError userInfo:nil]);
			} else {
				NSError *responseError = nil;
				id response = [[self delegate] parseServerResponse:httpResponse data:data error:&responseError];
				if (completionBlock) completionBlock(self, response, responseError);
			}
		} else {
			if (completionBlock) completionBlock(self, nil, [NSError errorWithDomain:MCMangoConnectErrorDomain code:MCMangoConnectConnectionError userInfo:@{MCMangoConnectErrorKey : connectionError}]);
		}
	}];
}

@end
