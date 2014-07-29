//
//  RPRTaskParserDelegate.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/22/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPRTaskParserDelegate : NSObject <NSXMLParserDelegate>

+ (RACSignal *)getTaskListWithParser:(NSXMLParser *)parser;

@end
