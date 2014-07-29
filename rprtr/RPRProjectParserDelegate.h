//
//  RPRProjectParserDelegate.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/23/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPRProjectParserDelegate : NSObject <NSXMLParserDelegate>

+ (RACSignal *)getProjectListWithParser:(NSXMLParser *)parser;

@end
