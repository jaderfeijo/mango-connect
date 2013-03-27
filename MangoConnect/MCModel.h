//
//  MCModel.h
//  MangoConnect
//
//  Created by Jader Feijo on 04/09/2012.
//
//

#import <Foundation/Foundation.h>

@interface MCModel : NSObject {
	NSMutableDictionary *model;
}

-(void)setClass:(Class)class forEntityNamed:(NSString *)name;
-(Class)classForEntityNamed:(NSString *)name;
-(void)removeClassForEntityNamed:(NSString *)name;
-(NSDictionary *)model;

@end
