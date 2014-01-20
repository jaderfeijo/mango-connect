//
//  MCModel.m
//  MangoConnect
//
//  Created by Jader Feijo on 04/09/2012.
//
//

#import "MCModel.h"

@interface MCModel () {
	NSMutableDictionary *_model;
}

@end

@implementation MCModel

//
// MCModel Methods
//
#pragma mark - MCModel Methods -

- (id)init {
	if ((self = [super init])) {
		_model = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)setClass:(Class)class forEntityNamed:(NSString *)name {
	[_model setObject:class forKey:name];
}

- (Class)classForEntityNamed:(NSString *)name {
	return [_model objectForKey:name];
}

- (void)removeClassForEntityNamed:(NSString *)name {
	[_model removeObjectForKey:name];
}

- (NSDictionary *)model {
	return (NSDictionary *)_model;
}

//
// NSObject Methods
//
#pragma mark - NSObject Methods -

- (void)dealloc {
	[_model release];
	[super dealloc];
}

@end
