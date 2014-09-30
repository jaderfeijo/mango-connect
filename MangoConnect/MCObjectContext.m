//
//  MCObjectContext.m
//  MangoConnect
//
//  Created by Jader Feijo on 24/08/2012.
//
//

#import "MCObjectContext.h"

@implementation MCObjectContext {
	NSOperationQueue *_operationQueue;
}

//
// MCObjectContext Methods
//
#pragma mark - MCObjectContext Methods -

- (id)initWithServer:(MCServer *)server model:(MCModel *)model {
	if ((self = [super init])) {
		_server = server;
		_model = model;
	}
	return self;
}

- (NSOperationQueue *)operationQueue {
	if (!_operationQueue) {
		_operationQueue = [[NSOperationQueue alloc] init];
	}
	return _operationQueue;
}

- (void)fetchObject:(MCObject *)object withBlock:(MCObjectBlock)block {
	[[object fetchRequest] sendWithBlock:^(MCRequest *request, MCObjectCollection *objects, NSError *error) {
		if (!error) {
			if (block) block([[objects objects] lastObject], nil);
		} else {
			if (block) block(nil, error);
		}
	}];
}

- (void)createObject:(MCObject *)object withBlock:(MCObjectBlock)block {
	[[object createRequest] sendWithBlock:^(MCRequest *request, MCObjectCollection *objects, NSError *error) {
		if (!error) {
			if (block) block([[objects objects] lastObject], nil);
		} else {
			if (block) block(nil, error);
		}
	}];
}

- (void)updateObject:(MCObject *)object withBlock:(MCObjectBlock)block {
	[[object updateRequest] sendWithBlock:^(MCRequest *request, MCObjectCollection *objects, NSError *error) {
		if (!error) {
			if (block) block([[objects objects] lastObject], nil);
		} else {
			if (block) block(nil, error);
		}
	}];
}

- (void)deleteObject:(MCObject *)object withBlock:(MCObjectBlock)block {
	[[object deleteRequest] sendWithBlock:^(MCRequest *request, MCObjectCollection *objects, NSError *error) {
		if (!error) {
			if (block) block([[objects objects] lastObject], nil);
		} else {
			if (block) block(nil, error);
		}
	}];
}

@end
