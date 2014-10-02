//
//  MCFetchObjectsRequest.h
//  MangoConnect
//
//  Created by Jader Feijo on 02/10/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import <MangoConnect/MangoConnect.h>

@interface MCFetchObjectsRequest : MCRequest <MCRequestDelegate>

@property (readonly) NSSet *objects;
@property (readonly) MCEntity *entity;

-(id)initWithObjects:(NSSet *)objects entity:(MCEntity *)entity context:(MCObjectContext *)context;

@end
