//
//  MCObject.h
//  MangoConnect
//
//  Created by Jader Feijo on 03/09/2012.
//
//

#include <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "TCMXMLWriter.h"

typedef void(^MCObjectCompletionBlock)(NSError *error);

@class MCObjectContext;
@class MCRequest;
@class MCEntity;

@interface MCObject : NSObject

@property (readonly) MCEntity *entity;
@property (readonly) NSString *objectID;
@property (readonly) MCObjectContext *context;

-(id)initWithEntity:(MCEntity *)entity objectID:(NSString *)objectID context:(MCObjectContext *)context;
-(id)initWithObjectID:(NSString *)objectID context:(MCObjectContext *)context;
-(id)initWithEntity:(MCEntity *)entity context:(MCObjectContext *)context;
-(id)initWithContext:(MCObjectContext *)context;

-(BOOL)isNew;
-(BOOL)isFault;

-(void)fault;

-(NSArray *)propertyNames;

-(void)setValue:(id)value forProperty:(NSString *)property;
-(id)valueForProperty:(NSString *)property;

-(void)addObject:(MCObject *)object toProperty:(NSString *)property;
-(void)addObjects:(NSSet *)objects toProperty:(NSString *)property;
-(void)removeObject:(MCObject *)object fromProperty:(NSString *)property;
-(void)removeObjects:(NSSet *)objects fromProperty:(NSString *)property;
-(void)removeAllObjectsFromProperty:(NSString *)property;

-(NSData *)toXMLData;
-(void)writeXMLToWriter:(TCMXMLWriter *)writer;
-(void)updateWithDataFromXML:(TBXMLElement *)xml;

-(MCRequest *)fetchRequest;
-(MCRequest *)createRequest;
-(MCRequest *)updateRequest;
-(MCRequest *)deleteRequest;

-(void)fetchObjectsForProperty:(SEL)property withBlock:(MCObjectCompletionBlock)block;
-(void)fetchWithBlock:(MCObjectCompletionBlock)block;
-(void)createWithBlock:(MCObjectCompletionBlock)block;
-(void)updateWithBlock:(MCObjectCompletionBlock)block;
-(void)deleteWithBlock:(MCObjectCompletionBlock)block;

@end
