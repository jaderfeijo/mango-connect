//
//  MCFetchObjectsRequest.m
//  MangoConnect
//
//  Created by Jader Feijo on 02/10/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import "MCFetchObjectsRequest.h"

@implementation MCFetchObjectsRequest

- (id)initWithObjects:(NSSet *)objects entity:(MCEntity *)entity context:(MCObjectContext *)context {
	if ((self = [super initWithAddress:[NSString stringWithFormat:@"%@/%@", [[entity plural] lowercaseString], [[objects allObjects] componentsJoinedByString:@","]] method:MC_GET_HTTP_METHOD context:context])) {
		_objects = objects;
		_entity = entity;
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
				MCObjectCollection *objects = [[MCObjectCollection alloc] initWithEntity:[self entity] context:[self context]];
				[objects addObjects:[self objects]];
				
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
