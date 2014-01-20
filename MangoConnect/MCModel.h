//
//  MCModel.h
//  MangoConnect
//
//  Created by Jader Feijo on 04/09/2012.
//
//

#import <Foundation/Foundation.h>

/** This class maps objects returned by the server to subclasses of MCObject you create locally
 
 This class is usually configured inside a custom subclass of MCRequestManager. By configuring it there
 you ensure that all requests that use your custom subclass of MCRequestManager will have your model
 properly configured and available to them.
 
 Not configuring this properly will result in the responses not being parsed into the appropriate objects
 locally.
 
 Below is an example of how to configure the MCModel class, this is usually done inside the `init` method
 of a MCRequestManager subclass you create:
 
	-(id)init {
		if ((self = [super init])) {
			[[self model] setClass:[ObjectOne class] forEntityNamed:@"ObjectOne"];
			[[self model] setClass:[ObjectTwo class] forEntityNamed:@"ObjectTwo"];
		}
	}
	
 In the above example we're configuring the model to use a class type `ObjectOne` every time the server
 returns an entity named "ObjectOne". We then we do the same thing for `ObjectTwo`.
 
 Note that the second parameneter `forEntityNamed:` does not need to match the class name specified in
 `setClass:`. The two can be completely different from each other as long as the entity name matches
 something the server would return and the class name matches a subclass of MCObject defined locally.
 
*/
@interface MCModel : NSObject

/** Sets the `class` to be used for the specified entity.
 
 This method is used to match a local subcless of `MCObject` to an entity
 that is returned by the server.
 
 @param class The local subclass of MCObject to be used.
 @param name The name of the entity to match with the specified `class`.
 
 */
-(void)setClass:(Class)class forEntityNamed:(NSString *)name;

/** Returns the class that is used by this model for the specified entity name
 
 This method returns the `Class` that is used when the server returns an entity
 matching the specified entity `name`
 
 @param name The entity name you wish to retreive the class for
 
 @return Returns the class matching the specified entity `name` or `nil` if no matching
 class is found for the specified entity `name`.
 
 */
-(Class)classForEntityNamed:(NSString *)name;

/** Removes a class that was previously associated with an entity.
 
 Removes a `Class` that was associated with the speficied entity `name`. If no `Class` exists
 that is associated with the specified entity `name` this method does nothing.

 @param name The entity name
 
 */
-(void)removeClassForEntityNamed:(NSString *)name;

/** Returns a dictionary containing all entity names and their respective classes that comprise this model
 
 This method returns an `NSDictionary` containing all entity names and the respective subclasses of
 `MCObject` that were registered.
 
 The dictionary is organised as a key value pair where the entity name is the key and the class is the
 value.
 
 @return Returns a dictionary containg all entities and the respective classes for this model.
 
 */
-(NSDictionary *)model;

@end
