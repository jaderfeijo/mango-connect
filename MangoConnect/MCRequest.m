//
//  MCRequest.m
//  MangoConnect
//
//  Created by Jader Feijo on 23/08/2012.
//
//

#import "MCRequest.h"
#import "MCRequestManager.h"

@implementation MCRequest

@synthesize requestManager;
@synthesize address;
@synthesize requestMethod;

//
// MCRequest Methods
//
#pragma mark - MCRequest Methods -

- (id)initWithRequestManager:(MCRequestManager *)manager {
	if ((self = [super init])) {
		requestManager = [manager retain];
		requestMethod = [@"GET" retain];
		arguments = [[NSMutableDictionary alloc] init];
		parameters = [[NSMutableDictionary alloc] init];
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

- (NSDictionary *)parameters {
	return parameters;
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

//
// NSObject Methods
//
#pragma mark - NSObject Methods -

- (void)dealloc {
	[address release];
	[requestMethod release];
	[arguments release];
	[parameters release];
	
	[super dealloc];
}

@end
