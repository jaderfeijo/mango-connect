//
//  MCObjectCollection.h
//  MangoConnect
//
//  Created by Jader Feijo on 07/09/2012.
//
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@class MCEntity;
@class MCObjectContext;

@interface MCObjectCollection : NSObject

@property (readonly) MCEntity *entity;
@property (readonly) MCObjectContext *context;

+(instancetype)collectionWithObjects:(NSSet *)objects ofEntity:(MCEntity *)entity context:(MCObjectContext *)context;

-(id)initWithEntity:(MCEntity *)entity context:(MCObjectContext *)context;

-(void)mergeWithCollection:(MCObjectCollection *)collection;
-(void)addObject:(MCObject *)object;
-(void)removeObject:(MCObject *)object;

-(void)addObjects:(NSSet *)objects;
-(void)removeObjects:(NSSet *)objects;

-(MCObject *)objectWithID:(NSString *)objectID;
-(NSSet *)objects;

-(NSData *)toXMLData;
-(void)writeXMLToWriter:(TCMXMLWriter *)writer;
-(void)updateWithDataFromXML:(TBXMLElement *)xml;

-(MCRequest *)fetchObjectsRequest;

@end
