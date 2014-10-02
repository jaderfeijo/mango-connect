//
//  MCObjectContext.h
//  MangoConnect
//
//  Created by Jader Feijo on 24/08/2012.
//
//

#import <Foundation/Foundation.h>

@class MCServer;
@class MCModel;
@class MCObject;
@class MCObjectCollection;

typedef void(^MCObjectBlock)(id object, NSError *error);
typedef void(^MCObjectCollectionBlock)(MCObjectCollection *objects, NSError *error);

@interface MCObjectContext : NSObject

@property (readonly) MCServer *server;
@property (readonly) MCModel *model;

-(id)initWithServer:(MCServer *)server model:(MCModel *)model;
-(NSOperationQueue *)operationQueue;

-(void)fetchObjects:(NSSet *)objects ofEntity:(MCEntity *)entity withBlock:(MCObjectCollectionBlock)block;
-(void)fetchObjectsFromCollection:(MCObjectCollection *)objects withBlock:(MCObjectCollectionBlock)block;

-(void)fetchObject:(MCObject *)object withBlock:(MCObjectBlock)block;
-(void)createObject:(MCObject *)object withBlock:(MCObjectBlock)block;
-(void)updateObject:(MCObject *)object withBlock:(MCObjectBlock)block;
-(void)deleteObject:(MCObject *)object withBlock:(MCObjectBlock)block;

@end
