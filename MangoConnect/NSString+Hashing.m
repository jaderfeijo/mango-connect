//
//  NSString+MD5.m
//  CampMeeting
//
//  Created by Jader Feijo on 03/06/2011.
//  Copyright 2011 movinpixel. All rights reserved.
//

#import "NSString+Hashing.h"


@implementation NSString (Hashing)

+(NSString *)randomString {
	NSInteger len = (arc4random() % 1024) + 1;
	NSMutableString *string = [[NSMutableString alloc] initWithCapacity:len];
	for (int i = 0; i < len; i++) {
		char c = arc4random() % 256;
		[string appendFormat:@"%c", c];
	}
	return string;
}

-(NSString *)md5 {
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	return [[NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			] lowercaseString];
}

-(NSString *)sha256 {
	const char *s=[self cStringUsingEncoding:NSASCIIStringEncoding];
	NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
	
	uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
	CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
	NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
	NSString *hash=[out description];
	hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
	hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
	hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
	return hash;
}

@end
