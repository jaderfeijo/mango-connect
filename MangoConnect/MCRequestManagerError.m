//
//  MCRequestManagerError.m
//  MangoConnect
//
//  Created by Julio Cesar Flores on 1/30/14.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import "MCRequestManagerError.h"

#define kErrorDomain @"com.movinpixel.MangoConnect.HttpHerror"

@interface MCRequestManagerError () {
	NSInteger errorCode;
}
@end

@implementation MCRequestManagerError

+ (instancetype)errorWithCode:(NSInteger)code {
	return [[[MCRequestManagerError alloc] initWithCode:code] autorelease];
}

- (id)initWithCode:(NSUInteger)code {
	if (self = [super init]) {
		errorCode = code;
	}
	return self;
}

- (NSInteger)code {
	return errorCode;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"The server returned HTTP status %ld.", errorCode];
}

@end
