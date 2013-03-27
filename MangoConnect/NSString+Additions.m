//
//  NSStringAdditions.m
//  MangoConnect
//
//  Created by Jader Feijo on 03/07/2011.
//  Copyright 2011 movinpixel. All rights reserved.
//

#import "NSString+Additions.h"


@implementation NSString (Additions)

+(NSString *)formatBytes:(NSUInteger)bytes {
	if (bytes > 0) {
		NSArray *units = [NSArray arrayWithObjects:@"B", @"KB", @"MB", @"GB", @"TB", @"PB", @"EB", @"ZB", @"YB", nil];
		
		float number = bytes;
		int unit = 0;
		
		while (number >= 1000) {
			number = number / 1000;
			unit++;
		}
		
		return [NSString stringWithFormat:@"%.2f %@", number, [units objectAtIndex:unit]];
	} else {
		return @"0.00 MB";
	}
}

-(NSString *)stringByCapitalizingFirstCharachter {
	if ([self length] > 0) {
		NSString *firstCapChar = [[self substringToIndex:1] capitalizedString];
		return [[self lowercaseString] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
	} else {
		return self;
	}
}

-(NSString *)stringByDecapitalizingFirstCharacter {
	if ([self length] > 0) {
		NSString *firstChar = [[self substringToIndex:1] lowercaseString];
		return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstChar];
	} else {
		return self;
	}
}

-(NSString *)capitalizedWordsSeparetedBy:(NSString *)separator {
	NSArray *words = [self componentsSeparatedByString:separator];
	
	NSMutableArray *capitalizedWords = [[NSMutableArray alloc] initWithCapacity:[words count]];
	for (NSString *word in words) {
		[capitalizedWords addObject:[word stringByCapitalizingFirstCharachter]];
	}
	
	NSString *capitalizedWordsString = [capitalizedWords componentsJoinedByString:separator];
	[capitalizedWords release];
	
	return capitalizedWordsString;
}

-(NSString *)capitalizedWords {
	NSArray *words = [self componentsSeparatedByString:@" "];
	
	NSMutableArray *capitalizedWords = [[NSMutableArray alloc] initWithCapacity:[words count]];
	for (NSString *word in words) {
		[capitalizedWords addObject:[word capitalizedWordsSeparetedBy:@"."]];
	}
	
	NSString *capitalizedWordsString = [capitalizedWords componentsJoinedByString:@" "];
	[capitalizedWords release];
	
	return capitalizedWordsString;
}

-(NSString *)pathTarget {
	return [[self pathComponents] lastObject];
}

@end
