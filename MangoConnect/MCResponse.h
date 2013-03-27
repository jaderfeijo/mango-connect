//
//  MCResponse.h
//  MangoConnect
//
//  Created by Jader Feijo on 24/08/2012.
//
//

#import <Foundation/Foundation.h>

@class MCRequestManager;

@interface MCResponse : NSObject {
	MCRequestManager *requestManager;
	NSInteger code;
	NSString *body;
}

@property (readonly) MCRequestManager *requestManager;
@property (readonly) NSInteger code;
@property (readonly) NSString *body;

-(id)initWithRequestManager:(MCRequestManager *)manager responseCode:(NSInteger)responseCode andBody:(NSString *)responseBody;

@end
