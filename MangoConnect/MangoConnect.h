//
//  MangoConnect.h
//  MangoConnect
//
//  Created by Jader Feijo on 10/10/2012.
//
//

#ifndef MangoConnect_MangoConnect_h
#define MangoConnect_MangoConnect_h

#define MCVersion @"1.0"

#define MCNewObjectID nil

#define MCObjectXMLIdAttribute @"id"
#define MCObjectXMLTypeAttribute @"type"
#define MCObjectXMLStringType @"String"
#define MCObjectXMLIntegerType @"Integer"
#define MCObjectXMLFloatType @"Float"
#define MCObjectXMLBooleanType @"Boolean"
#define MCObjectXMLDateType @"Date"
#define MCObjectXMLBinaryType @"Binary"

#define MCEntityNameKey @"name"
#define MCEntityPluralKey @"plural"
#define MCEntityClassKey @"class"

#define MCProtocolVersionHeader @"Mango-Connect-Protocol-Version"
#define MCRequestAuthenticationTokenHeader @"Authentication-Token"
#define MCRequestRandomDataHeader @"Random-Data"
#define MCRequestContentTypeHeader @"Content-Type"

#define MC_POST_HTTP_METHOD @"POST"
#define MC_GET_HTTP_METHOD @"GET"
#define MC_PUT_HTTP_METHOD @"PUT"
#define MC_DELETE_HTTP_METHOD @"DELETE"

#define MC_OK_HTTP_RESPONSE 200
#define MC_CREATED_HTTP_RESPONSE 201
#define MC_BAD_REQUEST_HTTP_REPONSE 400
#define MC_UNAUTHORIZED_HTTP_RESPONSE 401
#define MC_NOT_FOUND_HTTP_RESPONSE 404
#define MC_INTERNAL_SERVER_ERROR_RESPONSE 500

#define MCObjectIsFaultException @"MCObjectIsFaultException"
#define MCObjectIsFaultExceptionDescription @"Cannot set the value of a property or relationship on a fault object"
#define MCObjectIsNewException @"MCObjectIsNewException"
#define MCObjectIsNewExceptionDescription @"Cannot add a new object to a collection"
#define MCEntityMismatchException @"MCEntityMismatchException"
#define MCEntityMismatchExceptionDescription @"The object's entity does not match the collection's entity"
#define MCRequestMethodNotImplementedException @"MCRequestMethodNotImplementedException"
#define MCRequestMethodNotImplementedExceptionDescription @"The parsing method for this MCRequest is not implemented"

#define MCMangoConnectErrorDomain @"MCMangoConnectErrorDomain"
#define MCMangoConnectErrorKey @"error"
#define MCMangoConnectParsingError 1000
#define MCMangoConnectConnectionError 1001
#define MCMangoConnectBadRequestError 1002
#define MCMangoConnectUnauthorizedError 1003
#define MCMangoConnectNotFoundError 1004
#define MCMangoConnectInternalServerError 1005
#define MCMangoConnectUnknownServerError 1006

#import "MCObject.h"
#import "MCModel.h"
#import "MCEntity.h"
#import "MCObjectCollection.h"
#import "MCRequest.h"
#import "MCRequestDelegate.h"
#import "MCFetchObjectRequest.h"
#import "MCCreateObjectRequest.h"
#import "MCUpdateObjectRequest.h"
#import "MCDeleteObjectRequest.h"
#import "MCObjectContext.h"
#import "MCServer.h"

#endif
