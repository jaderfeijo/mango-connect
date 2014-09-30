//
//  MCRequestDelegate.h
//  MangoConnect
//
//  Created by Jader Feijo on 30/09/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCRequestDelegate <NSObject>

-(id)parseServerResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError **)error;

@end
