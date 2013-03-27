//
//  MCRequestManager.m
//  MangoConnect
//
//  Created by Jader Feijo on 24/08/2012.
//
//

#import "MCRequestManager.h"
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

//
// MCRequestManager Methods
//
#pragma mark - MCRequestManager Methods -

- (id)init {
	if ((self = [super init])) {
		model = [[MCModel alloc] init];
		requests = [[NSMutableArray alloc] init];
		productionServerAddress = nil;
		developmentServerAddress = nil;
		useProductionServer = YES;
	}
	return self;
}

- (void)addRequest:(MCRequest *)request {
	[requests addObject:request];
}

- (void)removeRequest:(MCRequest *)request {
	[requests removeObject:request];
}

- (NSArray *)requests {
	return (NSArray *)requests;
}

- (NSString *)serverAddress {
	if (useProductionServer) {
		return productionServerAddress;
	} else {
		return developmentServerAddress;
	}
}

//
// NSObject Methods
//
#pragma mark - NSObject Methods -

- (void)dealloc {
	[model release];
	[requests release];
	[productionServerAddress release];
	[developmentServerAddress release];
	[super dealloc];
}

@end
