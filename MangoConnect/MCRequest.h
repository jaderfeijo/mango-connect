//
//  MCRequest.h
//  MangoConnect
//
//  Created by Jader Feijo on 23/08/2012.
//
//

#import <Foundation/Foundation.h>

@class MCRequestManager;

@interface MCRequest : NSObject {
	MCRequestManager *requestManager;
	NSString *address;
	NSString *requestMethod;
	NSMutableDictionary *arguments;
	NSMutableDictionary *parameters;
}

@property(nonatomic, retain) MCRequestManager * requestManager;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *requestMethod;

-(id)initWithRequestManager:(MCRequestManager *)requestManager;

-(void)setValue:(id)value forArgument:(NSString *)argument;
-(id)valueForArgument:(NSString *)argument;
-(void)removeArgument:(NSString *)argument;

-(void)setValue:(id)value forParameter:(NSString *)parameter;
-(id)valueForParameter:(NSString *)parameter;
-(void)removeParameter:(NSString *)parameter;
-(NSDictionary *)parameters;

-(NSURL *)url;

@end
