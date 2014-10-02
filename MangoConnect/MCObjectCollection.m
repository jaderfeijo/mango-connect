//
//  MCObjectCollection.m
//  MangoConnect
//
//  Created by Jader Feijo on 07/09/2012.
//
//

#import "MCObjectCollection.h"
#import "MCModel.h"
#import "MCObject.h"
#import "MCObjectContext.h"

@implementation MCObjectCollection {
	NSMutableSet *_objects;
}

//
// MCObjectCollection Static Methods
//
#pragma mark - MCObjectCollection Static Methods -

+ (instancetype)collectionWithObjects:(NSSet *)objects ofEntity:(MCEntity *)entity context:(MCObjectContext *)context {
	MCObjectCollection *collection = [[MCObjectCollection alloc] initWithEntity:entity context:context];
	for (MCObject *object in objects) {
		[collection addObject:object];
	}
	return collection;
}

//
// MCObjectCollection Methods
//
#pragma mark - MCObjectCollection Methods -

- (id)initWithEntity:(MCEntity *)entity context:(MCObjectContext *)context {
	if ((self = [super init])) {
		_entity = entity;
		_context = context;
		_objects = [[NSMutableSet alloc] init];
	}
	return self;
}

- (void)mergeWithCollection:(MCObjectCollection *)collection {
	for (MCObject *object in [collection objects]) {
		[self addObject:object];
	}
}

- (void)addObject:(MCObject *)object {
	if (![[object entity] isEqual:[self entity]]) {
		@throw [NSException exceptionWithName:MCEntityMismatchException reason:MCEntityMismatchExceptionDescription userInfo:nil];
	}
	
	if ([object isNew]) {
		@throw [NSException exceptionWithName:MCObjectIsNewException reason:MCObjectIsNewExceptionDescription userInfo:nil];
	}
	
	[_objects addObject:object];
}

- (void)removeObject:(MCObject *)object {
	[_objects removeObject:object];
}

- (void)addObjects:(NSSet *)objects {
	for (MCObject *object in objects) {
		[self addObject:object];
	}
}

- (void)removeObjects:(NSSet *)objects {
	for (MCObject *object in objects) {
		[self removeObject:object];
	}
}

- (MCObject *)objectWithID:(NSString *)objectID {
	if (objectID) {
		for (MCObject *object in [self objects]) {
			if ([[object objectID] isEqualToString:objectID]) {
				return object;
			}
		}
	}
	return nil;
}

- (NSSet *)objects {
	return (NSSet *)_objects;
}

- (NSData *)toXMLData {
	TCMXMLWriter *writer = [[TCMXMLWriter alloc] initWithOptions:TCMXMLWriterOptionPrettyPrinted];
	[writer instructXML];
	[self writeXMLToWriter:writer];
	return [writer XMLData];
}

- (void)writeXMLToWriter:(TCMXMLWriter *)writer {
	[writer tag:[[self entity] plural] contentBlock:^{
		for (MCObject *object in [self objects]) {
			[object writeXMLToWriter:writer];
		}
	}];
}

- (void)updateWithDataFromXML:(TBXMLElement *)xml {
	if (xml) {
		if (!_entity) {
			NSString *entityName = [TBXML elementName:xml];
			_entity = [[[self context] model] entityWithName:entityName];
		}
		
		TBXMLElement *objectElement = xml->firstChild;
		while (objectElement) {
			NSString *objectID = [TBXML valueOfAttributeNamed:MCObjectXMLIdAttribute forElement:objectElement];
			id object = [self objectWithID:objectID];
			if (!object) {
				Class ObjectClass = [[[[self context] model] entityWithName:[TBXML elementName:objectElement]] entityClass];
				object = [[ObjectClass alloc] initWithContext:[self context]];
				[self addObject:object];
			}
			
			[object updateWithDataFromXML:objectElement];
			
			objectElement = objectElement->nextSibling;
		}
	}
}

- (MCRequest *)fetchObjectsRequest {
	return [[MCFetchObjectsRequest alloc] initWithObjects:[self objects] entity:[self entity] context:[self context]];
}

@end
