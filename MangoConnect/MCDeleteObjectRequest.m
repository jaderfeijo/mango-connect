//
//  MCDeleteObjectRequest.m
//  MangoConnect
//
//  Created by Jader Feijo on 30/09/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import "MCDeleteObjectRequest.h"

@implementation MCDeleteObjectRequest

- (id)initWithObject:(MCObject *)object {
	if ((self = [super initWithAddress:[NSString stringWithFormat:@"%@/%@", [[[object entity] plural] lowercaseString], [object objectID]] method:MC_DELETE_HTTP_METHOD context:[object context]])) {
		_object = object;
	}
	return self;
}

//
// MCRequestDelegate Methods
//
#pragma mark - MCRequestDelegate Methods -

- (id)parseServerResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError **)error {
	if ([response statusCode] == MC_OK_HTTP_RESPONSE) {
		return nil;
	} else {
		if (error) *error = [NSError errorWithDomain:MCMangoConnectErrorDomain code:MCMangoConnectUnknownServerError userInfo:@{MCMangoConnectErrorKey : data}];
		return nil;
	}
}

@end
