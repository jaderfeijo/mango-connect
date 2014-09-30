//
//  MCEntity.m
//  MangoConnect
//
//  Created by Jader Feijo on 25/09/2014.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import "MCEntity.h"

@implementation MCEntity

+ (instancetype)entityWithName:(NSString *)name plural:(NSString *)plural class:(Class)entityClass {
	return [[MCEntity alloc] initWithName:name plural:plural class:entityClass];
}

- (id)initWithName:(NSString *)name plural:(NSString *)plural class:(Class)entityClass {
	if ((self = [super init])) {
		_name = name;
		_plural = plural;
		_entityClass = entityClass;
		_model = nil;
	}
	return self;
}

@end
