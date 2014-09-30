//
//  NSString+Hashing.h
//  CampMeeting
//
//  Created by Jader Feijo on 03/06/2011.
//  Copyright 2011 movinpixel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

/**
 * @brief Provides hashing functionality to an NSString
 */
@interface NSString (Hashing)

/** Retuns a randomly generated string of variable length */
+(NSString *)randomString;

/** Returns the MD5 hash of this string */
-(NSString *)md5;

/** Returns the sha256 hash of this string */
-(NSString *)sha256;

@end
