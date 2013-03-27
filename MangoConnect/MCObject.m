//
//  MCObject.m
//  MangoConnect
//
//  Created by Jader Feijo on 03/09/2012.
//
//

#import "MCObject.h"
#import "MCModel.h"
#import "NSString+Additions.h"
#import "NSData+Base64.h"

@implementation MCObject

//
// Dynamic Method Resolution
//
#pragma mark - Dynamic Method Resolution -

+ (BOOL)resolveInstanceMethod:(SEL)aSEL {
	NSString *method = NSStringFromSelector(aSEL);
	
	if ([method hasPrefix:@"set"]) {
		class_addMethod([self class], aSEL, (IMP)dynamicSetter, "v@:@");
		return YES;
	} else {
		class_addMethod([self class], aSEL, (IMP)dynamicGetter, "@@:");
		return YES;
	}
	return [super resolveInstanceMethod:aSEL];
}

void dynamicSetter(id self, SEL _cmd, NSObject *newValue) {
	NSString *propertyName = [[[NSStringFromSelector(_cmd) stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]] stringByDecapitalizingFirstCharacter];
	[self setValue:newValue forProperty:propertyName];
}

NSObject * dynamicGetter(id self, SEL _cmd) {
	NSString *propertyName = [NSStringFromSelector(_cmd) stringByDecapitalizingFirstCharacter];
	return [self valueForProperty:propertyName];
}

@synthesize entity;

//
// MCObject Methods
//
#pragma mark - MCObject Methods -

- (id)init {
	if ((self = [super init])) {
		properties = [[NSMutableDictionary alloc] init];
		relationships = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (id)initWithXML:(TBXMLElement *)xmlElement model:(MCModel *)xmlModel {
	if ((self = [self init])) {
		model = [xmlModel retain];
		entity = [[TBXML elementName:xmlElement] retain];
		
		if (xmlElement) {
			TBXMLElement *attributeElement = xmlElement->firstChild;
			while (attributeElement) {
				NSString *attributeName = [TBXML elementName:attributeElement];
				if (attributeElement->firstChild) {
					TBXMLElement *objectElement = attributeElement->firstChild;
					while (objectElement) {
						Class ObjectClass = [model classForEntityNamed:[TBXML elementName:objectElement]];
						id object = [[ObjectClass alloc] initWithXML:objectElement model:model];
						[self addObject:object toRelationship:[TBXML elementName:attributeElement]];
						[object release];
					}
				} else {
					if ([[TBXML valueOfAttributeNamed:@"type" forElement:attributeElement] isEqualToString:@"String"]) {
						[self setValue:[TBXML textForElement:attributeElement] forProperty:attributeName];
					} else if ([[TBXML valueOfAttributeNamed:@"type" forElement:attributeElement] isEqualToString:@"Integer"]) {
						[self setValue:[NSNumber numberWithInteger:[[TBXML textForElement:attributeElement] integerValue]] forProperty:attributeName];
					} else if ([[TBXML valueOfAttributeNamed:@"type" forElement:attributeElement] isEqualToString:@"Float"]) {
						[self setValue:[NSNumber numberWithFloat:[[TBXML textForElement:attributeElement] floatValue]] forProperty:attributeName];
					} else if ([[TBXML valueOfAttributeNamed:@"type" forElement:attributeElement] isEqualToString:@"Boolean"]) {
						[self setValue:[NSNumber numberWithBool:[[TBXML textForElement:attributeElement] boolValue]] forProperty:attributeName];
					} else if ([[TBXML valueOfAttributeNamed:@"type" forElement:attributeElement] isEqualToString:@"Date"]) {
						[self setValue:[NSDate dateWithTimeIntervalSince1970:[[TBXML textForElement:attributeElement] doubleValue]] forProperty:attributeName];
					} else if ([[TBXML valueOfAttributeNamed:@"type" forElement:attributeElement] isEqualToString:@"Binary"]) {
						[self setValue:[NSData dataFromBase64String:[TBXML textForElement:attributeElement]] forProperty:attributeName];
					} else { // String (default)
						[self setValue:[TBXML textForElement:attributeElement] forProperty:attributeName];
					}
				}
				attributeElement = attributeElement->nextSibling;
			}
		}
	}
	return self;
}

- (id)initWithDictionary:(NSDictionary *)dict model:(MCModel *)xmlModel {
	if ((self = [self init])) {
		// Load the properties dictionary
		[properties addEntriesFromDictionary:[dict objectForKey:@"properties"]];
		
		// Load the relationships dictionary
		NSDictionary *persistedRelationships = [dict objectForKey:@"relationships"];
		
		// Convert the persistent dictionaries into objects and load them into the relationships dictionary
		for (NSString *relationshipName in [persistedRelationships allKeys]) {
			NSDictionary *objectDict = [persistedRelationships objectForKey:relationshipName];
			Class ObjectClass = [model classForEntityNamed:[objectDict objectForKey:@"entity"]];
			id object = [[ObjectClass alloc] initWithDictionary:objectDict model:model];
			[relationships setObject:object forKey:relationshipName];
			[object release];
		}
		
		// Load the entity name for this object
		entity = [[dict objectForKey:@"entity"] retain];
	}
	return self;
}

- (void)setValue:(id)value forProperty:(NSString *)property {
	[properties setValue:value forKey:property];
}

- (id)valueForProperty:(NSString *)property {
	return [properties valueForKey:property];
}

- (void)addObject:(MCObject *)object toRelationship:(NSString *)relationship {
	NSMutableSet *set = [relationships objectForKey:relationship];
	if (!set) {
		set = [[NSMutableSet alloc] init];
		[relationships setObject:set forKey:relationship];
		[set autorelease];
	}
	[set addObject:object];
}

- (void)removeObject:(MCObject *)object fromRelationship:(NSString *)relationship {
	NSMutableSet *set = [relationships objectForKey:relationship];
	[set removeObject:object];
}

- (void)removeAllObjectsFromRelationship:(NSString *)relationship {
	NSMutableSet *set = [relationships objectForKey:relationship];
	[set removeAllObjects];
}

- (NSSet *)objectsForRelationship:(NSString *)relationship {
	return (NSSet *)[relationships objectForKey:relationship];
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
	
	// Add properties to dictionary
	[dict setObject:properties forKey:@"properties"];
	
	// Convert all objects inside relationships into dictionaries we can persist
	NSMutableDictionary *convertedRelationships = [[NSMutableDictionary alloc] initWithCapacity:[relationships count]];
	for (NSString *relationshipName in relationships) {
		NSMutableSet *relationshipObjects = [[NSMutableSet alloc] init];
		for (MCObject *object in [self objectsForRelationship:relationshipName]) {
			[relationshipObjects addObject:[object toDictionary]];
		}
		[convertedRelationships setObject:(NSSet *)relationshipObjects forKey:relationshipName];
		[relationshipObjects release];
	}
	
	// Add converted relationships to dictionary
	[dict setObject:convertedRelationships forKey:@"relationships"];
	[convertedRelationships release];
	
	// Add the entity name to dictionary
	[dict setObject:[self entity] forKey:@"entity"];

	return [dict autorelease];
}

//
// NSObject Methods
//
#pragma mark - NSObject Methods -

- (void)dealloc {
	[properties release];
	[relationships release];
	[model release];
	[entity release];
	[super dealloc];
}

@end
