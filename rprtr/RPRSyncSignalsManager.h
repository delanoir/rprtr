//
//  RPRSyncSignalsManager.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/28/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPRSyncSignalsManager : NSObject

+ (id)sharedManager;

- (RACSignal *)syncTasks;
- (RACSignal *)syncProjects;
- (RACSignal *)syncTimeEntries;

@end
