//
//  MCRequestManagerError.h
//  MangoConnect
//
//  Created by Julio Cesar Flores on 1/30/14.
//  Copyright (c) 2014 Movinpixel. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * @brief The purpose of this class is to handle standard HTTP response codes.
 *
 * IMPORTANT to notice that HTTP Response codes aren't errors, they are simply response from the server.
 * However, it is very usual that one wants to handle only one or two HTTP response codes, and all else
 * one wishes to treat as an error.
 *
 * For example, one wants to retrieve a Player object with a player code 1012.
 * Possible server responses: 200 - OK, Player found; 404 - Player not found
 * All else codes are unknown response, so one wants to treat as an error.
 *
 * That's where the purpose of this class comes in. This class offers a default NSError object where:
 * domain		= com.movinpixel.MangoConnect.HttpHerror
 * code			= the HTTP status code
 * description	= The server returned HTTP status %ld (where %ld is the HTTP status code)
 * 
 * localizedDescripion not being provided for now.
 */
@interface MCRequestManagerError : NSError

+(instancetype)errorWithCode:(NSInteger)code;

@end
