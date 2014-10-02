//
//  MCServer.m
//  MangoConnect
//
//  Created by Jader Feijo on 27/09/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import "MCServer.h"

@implementation MCServer

+ (instancetype)serverWithURL:(NSURL *)url authenticationToken:(NSString *)authenticationToken {
	return [[MCServer alloc] initWithURL:url authenticationToken:authenticationToken];
}

- (id)initWithURL:(NSURL *)url authenticationToken:(NSString *)authenticationToken {
	if ((self = [super init])) {
		_url = url;
		_authenticationToken = authenticationToken;
	}
	return self;
}

- (BOOL)shouldAuthenticateRequest:(MCRequest *)request {
	if ([self authenticationToken]) {
		return YES;
	} else {
		return NO;
	}
}

@end
