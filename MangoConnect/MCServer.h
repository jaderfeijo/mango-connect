//
//  MCServer.h
//  MangoConnect
//
//  Created by Jader Feijo on 27/09/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCServer : NSObject

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *authenticationToken;

+(instancetype)serverWithURL:(NSURL *)url authenticationToken:(NSString *)authenticationToken;
-(id)initWithURL:(NSURL *)url authenticationToken:(NSString *)authenticationToken;

-(BOOL)shouldAuthenticateRequest:(MCRequest *)request;

@end
