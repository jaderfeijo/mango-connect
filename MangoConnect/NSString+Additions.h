//
//  NSStringAdditions.h
//  MangoConnect
//
//  Created by Jader Feijo on 03/07/2011.
//  Copyright 2011 movinpixel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Additions)

+(NSString *)formatBytes:(NSUInteger)bytes;

-(NSString *)stringByCapitalizingFirstCharacter;
-(NSString *)stringByDecapitalizingFirstCharacter;
-(NSString *)capitalizedWordsSeparetedBy:(NSString *)separator;
-(NSString *)capitalizedWords;

-(NSString *)pathTarget;

@end
