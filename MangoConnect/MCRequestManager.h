//
//  MCRequestManager.h
//  MangoConnect
//
//  Created by Jader Feijo on 24/08/2012.
//
//

#import <Foundation/Foundation.h>
#import "MCRequestManagerError.h"

@class MCModel;
@class MCRequest;
@class MCObject;

typedef void (^ResponseHandlerBlock)(NSInteger responseCode, NSArray * objects, NSError * error);

typedef enum {
	MCAuthenticationMethodBasic,
	MCAuthenticationMethodDigest
} MCAuthenticationMethod;

@interface MCRequestManager : NSObject {
	MCModel *model;
	NSString *productionServerAddress;
	NSString *developmentServerAddress;
	BOOL useProductionServer;
	NSString *username;
	NSString *password;
	MCAuthenticationMethod authenticationMethod;
}

@property (nonatomic, retain) MCModel *model;
@property (nonatomic, retain) NSString *productionServerAddress;
@property (nonatomic, retain) NSString *developmentServerAddress;
@property (assign) BOOL useProductionServer;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) MCAuthenticationMethod authenticationMethod;

+(MCRequestManager *)defaultManager;

-(NSString *)serverAddress;
-(void)sendWithAddress:(NSString *)address withBlock:(ResponseHandlerBlock)responseHandler;
-(void)sendWithRequest:(MCRequest *)request withBlock:(ResponseHandlerBlock)responseHandler;

@end
