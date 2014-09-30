//
//  MCEntity.h
//  MangoConnect
//
//  Created by Jader Feijo on 25/09/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCEntity : NSObject

@property (nonatomic, retain) MCModel *model;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *plural;
@property (nonatomic, assign) Class entityClass;

+(instancetype)entityWithName:(NSString *)name plural:(NSString *)plural class:(Class)entityClass;
-(id)initWithName:(NSString *)name plural:(NSString *)plural class:(Class)entityClass;

@end
