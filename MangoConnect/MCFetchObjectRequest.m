//
//  MCFetchObjectRequest.m
//  MangoConnect
//
//  Created by Jader Feijo on 25/09/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import "MCFetchObjectRequest.h"

@implementation MCFetchObjectRequest

- (id)initWithObject:(MCObject *)object {
	if ((self = [super initWithAddress:[NSString stringWithFormat:@"%@/%@", [[[object entity] plural] lowercaseString], [object objectID]] method:MC_GET_HTTP_METHOD context:[object context]])) {
		_object = object;
		[self setDelegate:self];
	}
	return self;
}

//
// MCRequestDelegate Methods
//
#pragma mark - MCRequestDelegate Methods -

- (id)parseServerResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError **)error {
	if ([response statusCode] == MC_OK_HTTP_RESPONSE) {
		if ([data length] > 0) {
			NSError *parsingError = nil;
			TBXML *xml = [[TBXML alloc] initWithXMLData:data error:&parsingError];
			if (!parsingError) {
				MCObjectCollection *objects = [[MCObjectCollection alloc] initWithEntity:[[self object] entity] context:[self context]];
				[objects addObject:[self object]];
				
				TBXMLElement *rootElement = [xml rootXMLElement];
				if (rootElement) {
					[objects updateWithDataFromXML:rootElement];
				}
				
				return objects;
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
