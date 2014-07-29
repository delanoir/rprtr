//
//  WebSignals.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/28/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPRWebSignalsManager : NSObject

+ (id)sharedManager;

- (RACSignal *)getTasks;
- (RACSignal *)getProjects;
- (RACSignal *)getTimeEntries;

@end
