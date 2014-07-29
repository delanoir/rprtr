//
//  RPRTimeEntryParserDelegate.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/25/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPRTimeEntryParserDelegate : NSObject <NSXMLParserDelegate>

+ (RACSignal *)getTimeEntryListWithParser:(NSXMLParser *)parser;

@end
