//
//  MCRequestManager.h
//  MangoConnect
//
//  Created by Jader Feijo on 24/08/2012.
//
//

#import <Foundation/Foundation.h>

@class MCModel;
@class MCRequest;

@interface MCRequestManager : NSObject {
	MCModel *model;
	NSMutableArray *requests;
	NSString *productionServerAddress;
	NSString *developmentServerAddress;
	BOOL useProductionServer;
}

@property (nonatomic, retain) MCModel *model;
@property (nonatomic, retain) NSString *productionServerAddress;
@property (nonatomic, retain) NSString *developmentServerAddress;
@property (assign) BOOL useProductionServer;

+(MCRequestManager *)defaultManager;

-(void)addRequest:(MCRequest *)request;
-(void)removeRequest:(MCRequest *)request;
-(NSArray *)requests;
-(NSString *)serverAddress;

@end
