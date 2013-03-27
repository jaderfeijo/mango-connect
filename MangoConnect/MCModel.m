//
//  MCModel.m
//  MangoConnect
//
//  Created by Jader Feijo on 04/09/2012.
//
//

#import "MCModel.h"

@implementation MCModel

//
// MCModel Methods
//
#pragma mark - MCModel Methods -

- (id)init {
	if ((self = [super init])) {
		model = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)setClass:(Class)class forEntityNamed:(NSString *)name {
	[model setObject:class forKey:name];
}

- (Class)classForEntityNamed:(NSString *)name {
	return [model objectForKey:name];
}

- (void)removeClassForEntityNamed:(NSString *)name {
	[model removeObjectForKey:name];
}

- (NSDictionary *)model {
	return (NSDictionary *)model;
}

//
// NSObject Methods
//
#pragma mark - NSObject Methods -

- (void)dealloc {
	[model release];
	[super dealloc];
}

@end
