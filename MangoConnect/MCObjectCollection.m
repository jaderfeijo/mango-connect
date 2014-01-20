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

@interface MCObjectCollection () {
	NSMutableArray *_objects;
}

@end

@implementation MCObjectCollection

//
// MCObjectCollection Methods
//
#pragma mark - MCObjectCollection Methods -

-(id)initWithXML:(TBXML *)xml andModel:(MCModel *)m {
	if ((self = [super init])) {
		_model = [m retain];
		_objects = [[NSMutableArray alloc] init];
		
		TBXMLElement *rootElement = [xml rootXMLElement];
		if (rootElement) {
			TBXMLElement *objectElement = rootElement->firstChild;
			while (objectElement) {
				Class ObjectClass = [_model classForEntityNamed:[TBXML elementName:objectElement]];
				id object = [[ObjectClass alloc] initWithXML:objectElement model:_model];
				[_objects addObject:object];
				[object release];
				objectElement = objectElement->nextSibling;
			}
		}
	}
	return self;
}

-(id)initWithXMLString:(NSString *)xmlString andModel:(MCModel *)m {
	TBXML *xml = [TBXML newTBXMLWithXMLString:xmlString error:nil];
	if ((self = [self initWithXML:xml andModel:m])) {
		//
	}
	[xml release];
	return self;
}

-(id)initWithContentsOfFile:(NSString *)fileName andModel:(MCModel *)m {
	if ((self = [super init])) {
		_model = [m retain];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
			NSArray *dicts = [[NSArray alloc] initWithContentsOfFile:fileName];
			
			_objects = [[NSMutableArray alloc] initWithCapacity:[dicts count]];
			
			for (NSDictionary *dict in dicts) {
				Class ObjectClass = [_model classForEntityNamed:[dict objectForKey:@"entity"]];
				id object = [[ObjectClass alloc] initWithDictionary:dict model:_model];
				if (object) {
					[_objects addObject:object];
					[object release];
				}
			}
			
			[dicts release];
		} else {
			_objects = [[NSMutableArray alloc] init];
		}
	}
	return self;
}

-(void)mergeWithCollection:(MCObjectCollection *)collection {
	[_objects addObjectsFromArray:[collection objects]];
}

-(void)addObject:(MCObject *)object {
	[_objects addObject:object];
}

-(void)removeObject:(MCObject *)object {
	[_objects removeObject:object];
}

-(NSArray *)objects {
	return (NSArray *)_objects;
}

-(NSArray *)toArray {
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[_objects count]];
	
	for (MCObject *object in _objects) {
		[array addObject:[object toDictionary]];
	}
	
	return [array autorelease];
}

-(void)saveToFile:(NSString *)fileName {
	[[self toArray] writeToFile:fileName atomically:YES];
}

//
// NSObject Methods
//
#pragma mark - NSObject Methods -

-(void)dealloc {
	[_model release];
	[_objects release];
	[super dealloc];
}

@end
