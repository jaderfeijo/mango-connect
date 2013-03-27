//
//  MCObjectCollection.h
//  MangoConnect
//
//  Created by Jader Feijo on 07/09/2012.
//
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@class MCModel;
@class MCObject;

@interface MCObjectCollection : NSObject {
	MCModel *model;
	NSMutableArray *objects;
}

@property (readonly) MCModel *model;

-(id)initWithXML:(TBXML *)xml andModel:(MCModel *)model;
-(id)initWithXMLString:(NSString *)xmlString andModel:(MCModel *)model;
-(id)initWithContentsOfFile:(NSString *)fileName andModel:(MCModel *)model;

-(void)mergeWithCollection:(MCObjectCollection *)collection;
-(void)addObject:(MCObject *)object;
-(void)removeObject:(MCObject *)object;

-(NSArray *)objects;
-(NSArray *)toArray;

-(void)saveToFile:(NSString *)fileName;

@end
