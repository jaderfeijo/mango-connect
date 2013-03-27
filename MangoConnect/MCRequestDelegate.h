//
//  MCRequestDelegate.h
//  MangoConnect
//
//  Created by Jader Feijo on 24/08/2012.
//
//

#import <Foundation/Foundation.h>

@class MCRequest;
@class MCResponse;

@protocol MCRequestDelegate <NSObject>

-(void)request:(MCRequest *)request didFinishWithResponse:(MCResponse *)response;
-(void)request:(MCRequest *)request didFailWithError:(NSError *)error;

@end
