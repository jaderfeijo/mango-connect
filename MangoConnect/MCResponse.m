//
//  MCResponse.m
//  MangoConnect
//
//  Created by Jader Feijo on 24/08/2012.
//
//

#import "MCResponse.h"
#import "MCRequestManager.h"

@implementation MCResponse

@synthesize requestManager;
@synthesize code;
@synthesize body;

//
// MCResponse Methods
//
#pragma mark - MCResponse Methods -

- (id)initWithRequestManager:(MCRequestManager *)manager responseCode:(NSInteger)responseCode andBody:(NSString *)responseBody {
	if ((self = [super init])) {
		requestManager = [manager retain];
		code = responseCode;
		body = [responseBody retain];
	}
	return self;
}

//
// NSObject Methods
//
#pragma mark - NSObject Methods -

- (void)dealloc {
	[requestManager release];
	[body release];
	[super dealloc];
}

@end
