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

- (void)fetchObjects:(NSSet *)objects ofEntity:(MCEntity *)entity withBlock:(MCObjectCollectionBlock)block {
	MCObjectCollection *collection = [MCObjectCollection collectionWithObjects:objects ofEntity:entity context:self];
	[self fetchObjectsFromCollection:collection withBlock:block];
}

- (void)fetchObjectsFromCollection:(MCObjectCollection *)objects withBlock:(MCObjectCollectionBlock)block {
	[[objects fetchObjectsRequest] sendWithBlock:^(MCRequest *request, id response, NSError *error) {
		if (!error) {
			if (block) block(response, nil);
		} else {
			if (block) block(nil, error);
		}
	}];
}

- (void)fetchObject:(MCObject *)object withBlock:(MCObjectBlock)block {
	if ([object isFault]) {
		[[object fetchRequest] sendWithBlock:^(MCRequest *request, id response, NSError *error) {
			if (!error) {
				if (block) block([[(MCObjectCollection *)response objects] anyObject], nil);
			} else {
				if (block) block(nil, error);
			}
		}];
	} else {
		if (block) block(object, nil);
	}
}

- (void)createObject:(MCObject *)object withBlock:(MCObjectBlock)block {
	if (![object isNew]) {
		@throw [NSException exceptionWithName:MCObjectAlreadyExistsException reason:MCObjectAlreadyExistsExceptionDescription userInfo:@{MCExceptionObjectUserInfoKey : object}];
	}
	
	[[object createRequest] sendWithBlock:^(MCRequest *request, id response, NSError *error) {
		if (!error) {
			if (block) block([[(MCObjectCollection *)response objects] anyObject], nil);
		} else {
			if (block) block(nil, error);
		}
	}];
}

- (void)updateObject:(MCObject *)object withBlock:(MCObjectBlock)block {
	if ([object isNew]) {
		@throw [NSException exceptionWithName:MCObjectIsNewException reason:MCObjectIsNewExceptionDescription userInfo:@{MCExceptionObjectUserInfoKey : object}];
	}
	
	[[object updateRequest] sendWithBlock:^(MCRequest *request, id response, NSError *error) {
		if (!error) {
			if (block) block([[(MCObjectCollection *)response objects] anyObject], nil);
		} else {
			if (block) block(nil, error);
		}
	}];
}

- (void)deleteObject:(MCObject *)object withBlock:(MCObjectBlock)block {
	if ([object isNew]) {
		@throw [NSException exceptionWithName:MCObjectIsNewException reason:MCObjectIsNewExceptionDescription userInfo:@{MCExceptionObjectUserInfoKey : object}];
	}
	
	[[object deleteRequest] sendWithBlock:^(MCRequest *request, id response, NSError *error) {
		if (!error) {
			if (block) block([[(MCObjectCollection *)response objects] anyObject], nil);
		} else {
			if (block) block(nil, error);
		}
	}];
}

@end
