//
//  NSURLRequest+XML.m
//  rprtr
//
//  Created by Karolis Stasaitis on 7/23/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import "NSURLRequest+XML.h"

static NSString *AFBase64EncodedStringFromString(NSString *string);

@implementation NSURLRequest (XML)

+ (id)requestWithURL:(NSURL *)URL token:(NSString *)token xmlString:(NSString *)xmlString
{
    id request = [NSMutableURLRequest requestWithURL:URL];
    
    // Generate an NSData from your NSString (see below for link to more info)
    NSData *postBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Add Content-Length header if your server needs it
    unsigned long long postLength = postBody.length;
    NSString *contentLength = [NSString stringWithFormat:@"%llu", postLength];
    [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:", token];
    [request setValue:[NSString stringWithFormat:@"Basic %@", AFBase64EncodedStringFromString(basicAuthCredentials)] forHTTPHeaderField:@"Authorization"];
    
    // This should all look familiar...
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postBody];
    
    return [request copy];
}

@end

static NSString *AFBase64EncodedStringFromString(NSString *string)
{
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}