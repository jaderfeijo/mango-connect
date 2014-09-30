//
//  MCModel.h
//  MangoConnect
//
//  Created by Jader Feijo on 04/09/2012.
//
//

#import <Foundation/Foundation.h>

@interface MCModel : NSObject

-(void)addEntity:(MCEntity *)entity;
-(void)removeEntity:(MCEntity *)entity;
-(NSArray *)entities;
-(MCEntity *)entityWithName:(NSString *)entityName;

@end
