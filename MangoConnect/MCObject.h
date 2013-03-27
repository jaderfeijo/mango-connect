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

@class MCModel;

@interface MCObject : NSObject {
	NSMutableDictionary *properties;
	NSMutableDictionary *relationships;
	MCModel *model;
	NSString *entity;
}

@property (readonly) NSString *entity;

-(id)initWithXML:(TBXMLElement *)xmlElement model:(MCModel *)xmlModel;
-(id)initWithDictionary:(NSDictionary *)dict model:(MCModel *)xmlModel;
-(void)setValue:(id)value forProperty:(NSString *)property;
-(id)valueForProperty:(NSString *)property;
-(void)addObject:(MCObject *)object toRelationship:(NSString *)relationship;
-(void)removeObject:(MCObject *)object fromRelationship:(NSString *)relationship;
-(void)removeAllObjectsFromRelationship:(NSString *)relationship;
-(NSSet *)objectsForRelationship:(NSString *)relationship;
-(NSDictionary *)toDictionary;

@end
