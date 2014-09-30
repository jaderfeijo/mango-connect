//
//  MCRequest.h
//  MangoConnect
//
//  Created by Jader Feijo on 23/08/2012.
//
//

#import <Foundation/Foundation.h>
#import "MCRequestDelegate.h"

typedef void (^MCRequestCompletionBlock)(MCRequest *request, id response, NSError *error);

@interface MCRequest : NSObject

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) MCObjectContext *context;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, assign) BOOL authenticate;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, assign) id<MCRequestDelegate> delegate;

+(instancetype)requestWithAddress:(NSString *)address method:(NSString *)method authenticate:(BOOL)authenticate context:(MCObjectContext *)context;
+(instancetype)requestWithAddress:(NSString *)address method:(NSString *)method context:(MCObjectContext *)context;

-(id)initWithAddress:(NSString *)address method:(NSString *)method authenticate:(BOOL)authenticate context:(MCObjectContext *)context;
-(id)initWithAddress:(NSString *)address method:(NSString *)method context:(MCObjectContext *)context;

-(NSDictionary *)parameters;
-(void)setValue:(id)value forParameter:(NSString *)parameter;
-(id)valueForParameter:(NSString *)parameter;
-(void)removeParameter:(NSString *)parameter;

-(NSData *)body;
-(NSURL *)url;

-(void)sendWithBlock:(MCRequestCompletionBlock)completionBlock;

@end
