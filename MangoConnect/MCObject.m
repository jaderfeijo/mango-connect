//
//  MCObject.m
//  MangoConnect
//
//  Created by Jader Feijo on 03/09/2012.
//
//

#import "MCObject.h"
#import "NSString+Additions.h"
#import "NSData+Base64.h"

@implementation MCObject {
	NSMutableDictionary *_properties;
}

//
// Dynamic Method Resolution
//
#pragma mark - Dynamic Method Resolution -

+ (BOOL)resolveInstanceMethod:(SEL)aSEL {
	NSString *method = NSStringFromSelector(aSEL);
	
	if ([method hasPrefix:@"set"]) {
		class_addMethod([self class], aSEL, (IMP)set, "v@:@");
		return YES;
	} else if ([method hasPrefix:@"addObjectTo"]) {
		class_addMethod([self class], aSEL, (IMP)addObjectTo, "v@:@");
		return YES;
	} else if ([method hasPrefix:@"addObjectsTo"]) {
		class_addMethod([self class], aSEL, (IMP)addObjectsTo, "v@:@");
		return YES;
	} else if ([method hasPrefix:@"removeObjectFrom"]) {
		class_addMethod([self class], aSEL, (IMP)removeObjectFrom, "v@:@");
		return YES;
	} else if ([method hasPrefix:@"removeObjectsFrom"]) {
		class_addMethod([self class], aSEL, (IMP)removeObjectsFrom, "v@:@");
	} else if ([method hasPrefix:@"removeAllObjectsFrom"]) {
		class_addMethod([self class], aSEL, (IMP)removeAllObjectsFrom, "v@:");
		return YES;
	} else {
		class_addMethod([self class], aSEL, (IMP)get, "@@:");
		return YES;
	}
	
	return [super resolveInstanceMethod:aSEL];
}

void set(id self, SEL _cmd, NSObject *newValue) {
	NSString *propertyName = PropertyNameFromSelector(_cmd, @"set");
	[self setValue:newValue forProperty:propertyName];
}

void addObjectTo(id self, SEL _cmd, MCObject *object) {
	NSString *propertyName = PropertyNameFromSelector(_cmd, @"addObjectTo");
	[self addObject:object toProperty:propertyName];
}

void addObjectsTo(id self, SEL _cmd, NSSet *objects) {
	NSString *propertyName = PropertyNameFromSelector(_cmd, @"addObjectsTo");
	[self addObjects:objects toProperty:propertyName];
}

void removeObjectFrom(id self, SEL _cmd, MCObject *object) {
	NSString *propertyName = PropertyNameFromSelector(_cmd, @"removeObjectFrom");
	[self removeObject:object fromProperty:propertyName];
}

void removeObjectsFrom(id self, SEL _cmd, NSSet *objects) {
	NSString *propertyName = PropertyNameFromSelector(_cmd, @"removeObjectsFrom");
	[self removeObjects:objects fromProperty:propertyName];
}

void removeAllObjectsFrom(id self, SEL _cmd) {
	NSString *propertyName = PropertyNameFromSelector(_cmd, @"removeAllObjectsFrom");
	[self removeAllObjectsFromProperty:propertyName];
}

id get(id self, SEL _cmd) {
	NSString *propertyName = [NSStringFromSelector(_cmd) stringByDecapitalizingFirstCharacter];
	return [self valueForProperty:propertyName];
}

NSString * PropertyNameFromSelector(SEL selector, NSString *prefix) {
	return [[[NSStringFromSelector(selector) stringByReplacingCharactersInRange:NSMakeRange(0, [prefix length]) withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]] stringByDecapitalizingFirstCharacter];
}

//
// MCObject Methods
//
#pragma mark - MCObject Methods -

- (id)init {
	if ((self = [super init])) {
		_properties = nil;
	}
	return self;
}

- (id)initWithEntity:(MCEntity *)entity objectID:(NSString *)objectID context:(MCObjectContext *)context {
	if ((self = [self init])) {
		_entity = entity;
		_objectID = objectID;
		_context = context;
	}
	return self;
}

-(id)initWithObjectID:(NSString *)objectID context:(MCObjectContext *)context {
	if ((self = [self initWithEntity:[[context model] entityWithName:NSStringFromClass([self class])] objectID:objectID context:context])) {
		//
	}
	return self;
}

- (id)initWithEntity:(MCEntity *)entity context:(MCObjectContext *)context {
	if ((self = [self initWithEntity:entity objectID:MCNewObjectID context:context])) {
		//
	}
	return self;
}

- (id)initWithContext:(MCObjectContext *)context {
	if ((self = [self initWithEntity:[[context model] entityWithName:NSStringFromClass([self class])] context:context])) {
		//
	}
	return self;
}

- (BOOL)isNew {
	return ([self objectID] == MCNewObjectID);
}

- (BOOL)isFault {
	return (_properties == nil && ![self isNew]);
}

- (void)fault {
	_properties = nil;
}

- (NSArray *)propertyNames {
	if ([self isFault]) {
		@throw [NSException exceptionWithName:MCObjectIsFaultException reason:MCObjectIsFaultExceptionDescription userInfo:nil];
	}
	
	return [_properties allKeys];
}

- (void)setValue:(id)value forProperty:(NSString *)property {
	if ([self isFault]) {
		@throw [NSException exceptionWithName:MCObjectIsFaultException reason:MCObjectIsFaultExceptionDescription userInfo:nil];
	}
	
	if (!_properties) {
		_properties = [[NSMutableDictionary alloc] init];
	}
	
	[_properties setValue:value forKey:property];
}

- (id)valueForProperty:(NSString *)property {
	if ([self isFault]) {
		@throw [NSException exceptionWithName:MCObjectIsFaultException reason:MCObjectIsFaultExceptionDescription userInfo:nil];
	}
	
	return [_properties valueForKey:property];
}

- (void)addObject:(MCObject *)object toProperty:(NSString *)property {
	if ([self isFault]) {
		@throw [NSException exceptionWithName:MCObjectIsFaultException reason:MCObjectIsFaultExceptionDescription userInfo:nil];
	}
	
	if (!_properties) {
		_properties = [[NSMutableDictionary alloc] init];
	}
	
	NSMutableSet *set = [_properties objectForKey:property];
	if (!set) {
		set = [[NSMutableSet alloc] init];
		[_properties setObject:set forKey:property];
	}
	[set addObject:object];
}

- (void)addObjects:(NSSet *)objects toProperty:(NSString *)property {
	if ([self isFault]) {
		@throw [NSException exceptionWithName:MCObjectIsFaultException reason:MCObjectIsFaultExceptionDescription userInfo:nil];
	}
	
	if (!_properties) {
		_properties = [[NSMutableDictionary alloc] init];
	}
	
	for (MCObject *object in objects) {
		[self addObject:object toProperty:property];
	}
}

- (void)removeObject:(MCObject *)object fromProperty:(NSString *)property {
	if ([self isFault]) {
		@throw [NSException exceptionWithName:MCObjectIsFaultException reason:MCObjectIsFaultExceptionDescription userInfo:nil];
	}
	
	NSMutableSet *set = [_properties objectForKey:property];
	[set removeObject:object];
}

- (void)removeObjects:(NSSet *)objects fromProperty:(NSString *)property {
	if ([self isFault]) {
		@throw [NSException exceptionWithName:MCObjectIsFaultException reason:MCObjectIsFaultExceptionDescription userInfo:nil];
	}
	
	for (MCObject *object in objects) {
		[self removeObject:object fromProperty:property];
	}
}

- (void)removeAllObjectsFromProperty:(NSString *)property {
	if ([self isFault]) {
		@throw [NSException exceptionWithName:MCObjectIsFaultException reason:MCObjectIsFaultExceptionDescription userInfo:nil];
	}
	
	NSMutableSet *set = [_properties objectForKey:property];
	[set removeAllObjects];
}

- (NSData *)toXMLData {
	TCMXMLWriter *writer = [[TCMXMLWriter alloc] initWithOptions:TCMXMLWriterOptionPrettyPrinted];
	[writer instructXML];
	[self writeXMLToWriter:writer];
	return [writer XMLData];
}

- (void)writeXMLToWriter:(TCMXMLWriter *)writer {
	NSDictionary *attributes = nil;
	if (![self isNew]) {
		attributes = @{MCObjectXMLIdAttribute : [self objectID]};
	}
	
	if (![self isFault]) {
		[writer tag:[[self entity] name] attributes:attributes contentBlock:^{
			for (NSString *property in [self propertyNames]) {
				id value = [self valueForProperty:property];
				if ([value isKindOfClass:[NSSet class]]) {
					[writer tag:property contentBlock:^{
						for (MCObject *object in value) {
							[object writeXMLToWriter:writer];
						}
					}];
				} else if ([value isKindOfClass:[MCObject class]]) {
					[writer tag:property contentBlock:^{
						[value writeXMLToWriter:writer];
					}];
				} else if ([value isKindOfClass:[NSNumber class]]) {
					[writer tag:property contentText:[value stringValue]];
				} else if ([value isKindOfClass:[NSDate class]]) {
					[writer tag:property contentText:[[NSNumber numberWithDouble:[value timeIntervalSince1970]] stringValue]];
				} else if ([value isKindOfClass:[NSData class]]) {
					[writer tag:property contentText:[value base64EncodedString]];
				} else { // NSString
					[writer tag:property contentText:value];
				}
			}
		}];
	} else {
		[writer tag:[[self entity] name] attributes:attributes];
	}
}

- (void)updateWithDataFromXML:(TBXMLElement *)xml {
	TBXMLElement *attributeElement = xml->firstChild;
	while (attributeElement) {
		if (!_properties) {
			_properties = [[NSMutableDictionary alloc] init];
		}
		
		if ([self isNew]) {
			_objectID = [TBXML valueOfAttributeNamed:MCObjectXMLIdAttribute forElement:xml];
		}
		
		NSString *attributeName = [TBXML elementName:attributeElement];
		if (attributeElement->firstChild) {
			TBXMLElement *objectElement = attributeElement->firstChild;
			NSString *entityName = [TBXML elementName:objectElement];
			while (objectElement) {
				Class ObjectClass = [[[[self entity] model] entityWithName:entityName] class];
				id object = [[ObjectClass alloc] initWithContext:[self context]];
				[object updateWithDataFromXML:objectElement];
				[self addObject:object toProperty:attributeName];
				objectElement = objectElement->nextSibling;
			}
		} else {
			NSString *attributeType = [TBXML valueOfAttributeNamed:MCObjectXMLTypeAttribute forElement:attributeElement];
			NSString *attributeValue = [TBXML textForElement:attributeElement];
			if ([attributeName isEqualToString:MCObjectXMLStringType]) {
				[self setValue:attributeValue forProperty:attributeName];
			} else if ([attributeName isEqualToString:MCObjectXMLIntegerType]) {
				[self setValue:[NSNumber numberWithInteger:[attributeValue integerValue]] forProperty:attributeName];
			} else if ([attributeType isEqualToString:MCObjectXMLFloatType]) {
				[self setValue:[NSNumber numberWithFloat:[attributeValue floatValue]] forProperty:attributeName];
			} else if ([attributeType isEqualToString:MCObjectXMLBooleanType]) {
				[self setValue:[NSNumber numberWithBool:[attributeValue boolValue]] forProperty:attributeName];
			} else if ([attributeType isEqualToString:MCObjectXMLDateType]) {
				[self setValue:[NSDate dateWithTimeIntervalSince1970:[attributeValue doubleValue]] forProperty:attributeName];
			} else if ([attributeType isEqualToString:MCObjectXMLBinaryType]) {
				[self setValue:[NSData dataFromBase64String:attributeValue] forProperty:attributeName];
			} else { // String (default)
				[self setValue:attributeValue forProperty:attributeName];
			}
		}
		attributeElement = attributeElement->nextSibling;
	}
}

- (MCRequest *)fetchRequest {
	return [[MCFetchObjectRequest alloc] initWithObject:self];
}

- (MCRequest *)createRequest {
	return [[MCCreateObjectRequest alloc] initWithObject:self];
}

- (MCRequest *)updateRequest {
	return [[MCUpdateObjectRequest alloc] initWithObject:self];
}

- (MCRequest *)deleteRequest {
	return [[MCDeleteObjectRequest alloc] initWithObject:self];
}

- (void)fetchObjectsForProperty:(SEL)property withBlock:(MCObjectCompletionBlock)block {
	NSSet *allObjects = [self valueForProperty:NSStringFromSelector(property)];
	if ([allObjects isKindOfClass:[NSSet class]]) {
		NSMutableSet *faultObjects = [[NSMutableSet alloc] initWithCapacity:[allObjects count]];
		MCEntity *entity = nil;
		for (MCObject *object in allObjects) {
			if (!entity) entity = [object entity];
			if ([object isFault]) {
				[faultObjects addObject:object];
			}
		}
		
		if ([faultObjects count] > 0) {
			[[self context] fetchObjects:faultObjects ofEntity:entity withBlock:^(MCObjectCollection *objects, NSError *error) {
				if (block) block(error);
			}];
		} else {
			if (block) block(nil);
		}
	} else {
		if (block) block(nil);
	}
}

- (void)fetchWithBlock:(MCObjectCompletionBlock)block {
	[[self context] fetchObject:self withBlock:^(id object, NSError *error) {
		if (block) block(error);
	}];
}

- (void)createWithBlock:(MCObjectCompletionBlock)block {
	[[self context] createObject:self withBlock:^(id object, NSError *error) {
		if (block) block(error);
	}];
}

- (void)updateWithBlock:(MCObjectCompletionBlock)block {
	[[self context] updateObject:self withBlock:^(id object, NSError *error) {
		if (block) block(error);
	}];
}

- (void)deleteWithBlock:(MCObjectCompletionBlock)block {
	[[self context] deleteObject:self withBlock:^(id object, NSError *error) {
		if (block) block(error);
	}];
}

@end
