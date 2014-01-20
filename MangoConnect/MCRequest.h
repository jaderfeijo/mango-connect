//
//  MCRequest.h
//  MangoConnect
//
//  Created by Jader Feijo on 23/08/2012.
//
//

#import <Foundation/Foundation.h>
#import "MCRequestDelegate.h"
#import "ASIHTTPRequestDelegate.h"

@class MCRequestManager;

@interface MCRequest : NSObject <ASIHTTPRequestDelegate> {
	MCRequestManager *requestManager;
	Class responseClass;
	id<MCRequestDelegate> delegate;
	NSString *address;
	NSString *requestMethod;
	
	NSMutableDictionary *arguments;
	NSMutableDictionary *parameters;
}

@property (nonatomic, retain) MCRequestManager *requestManager;
@property (assign) Class responseClass;
@property (assign) id<MCRequestDelegate>delegate;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *requestMethod;

-(id)init;
-(id)initWithRequestManager:(MCRequestManager *)manager;

-(void)setValue:(id)value forArgument:(NSString *)argument;
-(id)valueForArgument:(NSString *)argument;
-(void)removeArgument:(NSString *)argument;

-(void)setValue:(id)value forParameter:(NSString *)parameter;
-(id)valueForParameter:(NSString *)parameter;
-(void)removeParameter:(NSString *)parameter;

-(NSURL *)url;
-(void)send;

@end
