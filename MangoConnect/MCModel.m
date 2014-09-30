//
//  MCModel.m
//  MangoConnect
//
//  Created by Jader Feijo on 04/09/2012.
//
//

#import "MCModel.h"

@implementation MCModel {
	NSMutableArray *_entities;
}

//
// MCModel Methods
//
#pragma mark - MCModel Methods -

- (id)init {
	if ((self = [super init])) {
		_entities = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addEntity:(MCEntity *)entity {
	[entity setModel:self];
	[_entities addObject:entity];
}

- (void)removeEntity:(MCEntity *)entity {
	[entity setModel:nil];
	[_entities removeObject:entity];
}

- (NSArray *)entities {
	return (NSArray *)_entities;
}

- (MCEntity *)entityWithName:(NSString *)entityName {
	for (MCEntity *entity in [self entities]) {
		if ([[entity name] isEqualToString:entityName] || [[entity plural] isEqualToString:entityName]) {
			return entity;
		}
	}
	return nil;
}

@end
