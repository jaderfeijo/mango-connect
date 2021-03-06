//
//  MCCreateObjectRequest.h
//  MangoConnect
//
//  Created by Jader Feijo on 25/09/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import <MangoConnect/MangoConnect.h>

@interface MCCreateObjectRequest : MCRequest

@property (readonly) MCObject *object;

-(id)initWithObject:(MCObject *)object;

@end
