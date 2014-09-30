//
//  MCCreateObjectRequest.m
//  MangoConnect
//
//  Created by Jader Feijo on 25/09/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import "MCCreateObjectRequest.h"

@implementation MCCreateObjectRequest

- (id)initWithObject:(MCObject *)object {
	if ((self = [super initWithAddress:[NSString stringWithFormat:@"%@", [[[object entity] plural] lowercaseString]] method:MC_POST_HTTP_METHOD context:[object context]])) {
		_object = object;
		[self setContentType:@"application/xml"];
	}
	return self;
}

- (NSData *)body {
	return [[self object] toXMLData];
}

//
// MCObjectDelegate Methods
//
#pragma mark - MCObjectDelegate Methods -

- (id)parseServerResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError **)error {
	if ([response statusCode] == MC_CREATED_HTTP_RESPONSE) {
		if ([data length] > 0) {
			NSError *parsingError = nil;
			TBXML *xml = [[TBXML alloc] initWithXMLData:data error:&parsingError];
			if (!parsingError) {
				TBXMLElement *rootElement = [xml rootXMLElement];
				if (rootElement) {
					[[self object] updateWithDataFromXML:rootElement];
				}
				return [self object];
			} else {
				if (error) *error = [NSError errorWithDomain:MCMangoConnectErrorDomain code:MCMangoConnectParsingError userInfo:@{MCMangoConnectErrorKey : parsingError}];
				return nil;
			}
		} else {
			if (error) *error = [NSError errorWithDomain:MCMangoConnectErrorDomain code:MCMangoConnectUnknownServerError userInfo:@{MCMangoConnectErrorKey : data}];
			return nil;
		}
	} else {
		if (error) *error = [NSError errorWithDomain:MCMangoConnectErrorDomain code:MCMangoConnectUnknownServerError userInfo:@{MCMangoConnectErrorKey : data}];
		return nil;
	}
}

@end
