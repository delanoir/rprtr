//
//  NSURLRequest+XML.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/23/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (XML)

+ (id)requestWithURL:(NSURL *)URL token:(NSString *)token xmlString:(NSString *)xmlString;

@end
