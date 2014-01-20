//
//  MCObject.h
//  MangoConnect
//
//  Created by Jader Feijo on 03/09/2012.
//
//

#include <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "TBXML.h"

@class MCModel;

/** This is a dynamic class that stores and manages data for an entity
 
 The `MCObject` class handles all the logic behind parsing entity data
 returned by the server and dynamically generating the appropriate
 property accessor methods so you can access the entity's data in
 an object oriented manner.
 
 A subclass of this class should be implemented for each entity
 that is returned by your server's API. A subclass needs to include
 property declarations for each property in the entity and it's implementation
 should include a `@dynamic` method implementation directive for each
 property declared. This tells the compiler that the accessor methods
 for the property will provided dynamically at run-time.
 
 Let's say you have an entity with the following structure:
 
 * Customer
	* name (String)
	* address (String)
	* orders (Array<Order>)
 
 You would create a sublass of `MCObject` that looks a bit like this:
 
	#import "MCObject.h"
 
	@interface Customer : MCObject
	
	@property (readonly) NSString *name;
	@property (readonly) NSString *address;
	@property (readonly) NSSet *orders
	
	-(void)addOrder:(Order *)order;
	-(void)removeOrder:(Order *)order;
	
	@end
 
 The implementation would then look like this:
 
	@implementation Customer
	
	@dynamic name;
	@dynamic address;
	@dynamic orders;
 
	-(void)addOrder:(Order *)order {
		[self addObject:order toRelationship:@"orders"];
	}
 
	-(void)removeOrder:(Order *)order {
		[self removeObject:order fromRelationship:@"orders"];
	}
	
	@end
 
	Notice that the `Customer` entity has a relationship with another entity called `Order`.
	MCObject can handle such relationships, all you need to do is declare a property for it
	of type array and define `add` and `remove` accessor methods which take the target object
	as a parameter, in this case an `Order` object and then pass that on to the respective
	'add to relationship' or 'remove from relationship' method as shown in the example above.
 
 */
@interface MCObject : NSObject

/** Returns the entity name this object represents.
 
 @return The entity name this object represents.
 */
@property (readonly) NSString *entity;

/**-----------------------------------------------------------------------------------------
 * @name Initializing and parsing data
 * -----------------------------------------------------------------------------------------
 */

/** Initializes a new instance of MCObject by parsing the specified XML using the model
 specified.
 
 You usually don't need to call this method directly as the `MCRequest` class when properly
 configured will automatically instance the appropriate `MCObject` subclasses for you.
 
 @param xmlElement A TBXMLElement instance containing the entity data XML to be parsed.
 @param xmlModel The `MCModel` instance to use when parsing the XML.
 
 @return A new instance of `MCObject` containing the entity data from the specified XML.
 */
-(id)initWithXML:(TBXMLElement *)xmlElement model:(MCModel *)xmlModel;

/** Initializes a new instance of `MCObject` with data from the specified dictionary using
 the model specified.
 
 You usually don't need to call this method directly as the `MCRequest` class when properly
 configured will automatically instance the appropriate `MCObject` subclasses for you.
 
 @param dict A dictionary containing the entity data.
 @param xmlModel A model to be used when importing the dictionary data.
 
 @return A new instance of `MCObject` containing the entity data from the specified
 dictionary.
 */
-(id)initWithDictionary:(NSDictionary *)dict model:(MCModel *)xmlModel;

/**-----------------------------------------------------------------------------------------
 * @name Setting and getting property values
 * -----------------------------------------------------------------------------------------
 */

/** Sets the value for a given property.
 
 This method is called automatically when setting the value of a dynamic property. You can
 however call this method directly if you wish to set the value of a property directly.
 
 @param value The new value for the property.
 @param property The property name you wish to set the value for.
 */
-(void)setValue:(id)value forProperty:(NSString *)property;

/** Gets the value of a given property.
 
 This method is called automatically when getting the value of a dynamic property. You can
 however call this method directly if you wish to get the value of a property directly.
 
 @param property The property name you wish to get the value for.
 @return The value of the specified property.
 */
-(id)valueForProperty:(NSString *)property;

/**-----------------------------------------------------------------------------------------
 * @name Adding, removing & getting objects to/from a relationship
 * -----------------------------------------------------------------------------------------
 */

/** Adds an object to the specified relationship
 
 Relationships are special properties which can contain one or more objects of a given
 type. This method adds an object to the collection of objects associated with a
 relationship.
 
 Imagine you have a relationship called `orders`. In your `MCModel` subclass you could
 declare a method like this:
 
	-(void)addOrder:(Order *)order {
		[self addObject:order toRelationship:@"orders"];
	}
 
 In addition to that you could also declare a property for the given relationship like
 so:
 
	@property (readonly) NSSet *orders;
 
 And then in the implementation file simply use the `@dynamic` keyword as the actual
 implementation of the method will be automatically provided by `MCObject` for you.
 
	@dynamic orders;
 
 @param object The object to add to the relationship.
 @param relationship The name of the relationship.
 */
-(void)addObject:(MCObject *)object toRelationship:(NSString *)relationship;

/** Removes an object from the specified relationship
 
 Relationships are special properties which can contain one or more objects of a given
 type. This method removes an object to the collection of objects associated with a
 relationship.
 
 Imagine you have a relationship called `orders`. In your `MCModel` subclass you could
 declare a method like this:
 
	-(void)removeOrder:(Order *)order {
		[self removeObject:order fromRelationship:@"orders"];
	}
 
 In addition to that you could also declare a property for the given relationship like
 so:
 
	@property (readonly) NSSet *orders;
 
 And then in the implementation file simply use the `@dynamic` keyword as the actual
 implementation of the method will be automatically provided by `MCObject` for you.
 
	@dynamic orders;
 
 @param object The object to remove from the relationship.
 @param relationship The name of the relationship.
 */
-(void)removeObject:(MCObject *)object fromRelationship:(NSString *)relationship;

/** Removes all objects associated with the specified relationship
 
 Relationships are special properties which can contain one or more objects of a given
 type. This method removes all objects from the collection of objects associated with a
 relationship.
 
 @param relationship The name of the relationship to remove all objects from.
 */
-(void)removeAllObjectsFromRelationship:(NSString *)relationship;

/** Returns all objects associated with a given relationship
 
 Relationships are special properties which can contain one or more objects of a given
 type. This method returns a set containing all objects associated with a relationship.
 
 You don't need to call this method directly however. You can simply define a property
 in the header for your subclass of `MCObject` like this:
 
	@property (readonly) NSSet *orders;
 
 And then in your implementation file simply use the `@dynamic` keyword, `MCObject`
 will automatically provide a method implementation for you at run time
 
	@dynamic orders;
 
 This is equivalent to declaring a method like this:
 
	-(NSSet *)orders {
		return [self objectsForRelationship:@"orders"];
	}
 
 @param relationship The name of the relationship
 @return Returns a set containing all objects associated with the specified relationship.
 */
-(NSSet *)objectsForRelationship:(NSString *)relationship;

/**-----------------------------------------------------------------------------------------
 * @name Data Persistance
 * -----------------------------------------------------------------------------------------
 */

/** Returns a dictionary containing all data associated with this `MCObject`
 
 This method return a dictionary which contains all data and objects contained by
 this `MCObject` instance. You can use this dictionary later on to reconstruct the
 object to it's exact state whne this method was called.
 
 For example, you could persist this dictionary inside a PLIST file and then use
 `-(id)initWithDictionary:(NSDictionary *)dict model:(MCModel *)xmlModel` to reconstruct
 the object in memory.
 
 The returned dictioanry will contain values for both properties and relationships.
 Relationships are defined as sub-dictionaries.
 
 @return A dictionary containing all properties and relationships inside this `MCObject`
 instance.
 */
-(NSDictionary *)toDictionary;

@end
