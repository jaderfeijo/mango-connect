//
//  MCObjectCollection.h
//  MangoConnect
//
//  Created by Jader Feijo on 07/09/2012.
//
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@class MCModel;
@class MCObject;

/** This class represents a collection of entities returned by the server
 
 Often servers return XML or JSON that contains not just one entity, but
 a collection of entities. This class handles the parsing of such a response.
 
 It does so by iterating through the server's response and calling the
 appropriate constructors in the `MCObject` subclasses which are specified
 in the model.
 
 Generally you won't use this class directly, `MCResponse` usually does
 the right thing and uses this class automatically. The only time you may
 need to use this class directly is when you're creating custom a custom
 `MCResponse` subclass that needs to handle a non-standard object collection
 returned by the server.
 */
@interface MCObjectCollection : NSObject

@property (readonly) MCModel *model;

-(id)initWithXML:(TBXML *)xml andModel:(MCModel *)model;
-(id)initWithXMLString:(NSString *)xmlString andModel:(MCModel *)model;
-(id)initWithContentsOfFile:(NSString *)fileName andModel:(MCModel *)model;

-(void)mergeWithCollection:(MCObjectCollection *)collection;
-(void)addObject:(MCObject *)object;
-(void)removeObject:(MCObject *)object;

-(NSArray *)objects;
-(NSArray *)toArray;

-(void)saveToFile:(NSString *)fileName;

@end
