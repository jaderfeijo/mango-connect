//
//  MCRequest.m
//  MangoConnect
//
//  Created by Jader Feijo on 23/08/2012.
//
//

#import "MCRequest.h"
#import "MCResponse.h"
#import "MCRequestManager.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestDelegate.h"

@implementation MCRequest

@synthesize requestManager;
@synthesize responseClass;
@synthesize delegate;
@synthesize address;
@synthesize requestMethod;

//
// MCRequest Methods
//
#pragma mark - MCRequest Methods -

- (id)init {
	if ((self = [super init])) {
		requestManager = [[MCRequestManager defaultManager] retain];
		responseClass = [MCResponse class];
		requestMethod = [@"GET" retain];
		arguments = [[NSMutableDictionary alloc] init];
		parameters = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (id)initWithRequestManager:(MCRequestManager *)manager {
	if ((self = [self init])) {
		requestManager = [manager retain];
	}
	return self;
}

- (void)setValue:(id)value forArgument:(NSString *)argument {
	[arguments setValue:value forKey:argument];
}

- (id)valueForArgument:(NSString *)argument {
	return [arguments valueForKey:argument];
}

- (void)removeArgument:(NSString *)argument {
	[arguments removeObjectForKey:argument];
}

- (void)setValue:(id)value forParameter:(NSString *)parameter {
	[parameters setValue:value forKey:parameter];
}

- (id)valueForParameter:(NSString *)parameter {
	return [parameters valueForKey:parameter];
}

- (void)removeParameter:(NSString *)parameter {
	[parameters removeObjectForKey:parameter];
}

- (NSURL *)url {
	NSMutableString *argumentsString = [[NSMutableString alloc] init];
	for (NSString *argument in [arguments allKeys]) {
		id value = [self valueForArgument:argument];
		
		if ([argumentsString isEqualToString:@""]) {
			[argumentsString appendString:@"?"];
		} else {
			[argumentsString appendString:@"&"];
		}
		
		[argumentsString appendFormat:@"%@=%@", argument, [[value description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self address], argumentsString] relativeToURL:[NSURL URLWithString:[[self requestManager] serverAddress]]];
	[argumentsString release];
	
	return url;
}

- (void)send {
	NSURL *url = [self url];
	
	NSLog(@"[MangoConnect]: Sending request to %@", [url absoluteString]);
	
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:requestMethod];
	[request setUsername:[[self requestManager] username]];
	[request setPassword:[[self requestManager] password]];
	[request setDelegate:self];
	
	for (NSString *parameter in [parameters allKeys]) {
		[request setPostValue:[self valueForParameter:parameter] forKey:parameter];
	}
	
	[[self requestManager] addRequest:self];
	
	[request startAsynchronous];
	[request release];
}

//
// ASIHTTPRequestDelegate Methods
//
#pragma mark - ASIHTTPRequestDelegate Methods -

- (void)requestFinished:(ASIHTTPRequest *)request {
	NSLog(@"[MangoConnect]: Request finished!");
	
	MCResponse *response = [[[self responseClass] alloc] initWithRequestManager:[self requestManager] responseCode:[request responseStatusCode] andBody:[request responseString]];
	[[self delegate] request:self didFinishWithResponse:response];
	[response release];
	
	[[MCRequestManager defaultManager] removeRequest:self];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSLog(@"[MangoConnect]: Request failed!");
	
	[[self delegate] request:self didFailWithError:[request error]];
	[[MCRequestManager defaultManager] removeRequest:self];
}

//
// NSObject Methods
//
#pragma mark - NSObject Methods -

- (void)dealloc {
	[requestManager release];
	[address release];
	[requestMethod release];
	[arguments release];
	[parameters release];
	[super dealloc];
}

@end
