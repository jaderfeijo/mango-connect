//
//  MCUpdateObjectRequest.h
//  MangoConnect
//
//  Created by Jader Feijo on 30/09/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import <MangoConnect/MangoConnect.h>

@interface MCUpdateObjectRequest : MCRequest

@property (readonly) MCObject *object;

-(id)initWithObject:(MCObject *)object;

@end
