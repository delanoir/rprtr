//
//  RPRFreshbooksTimeEntry.m
//  rprtr
//
//  Created by Karolis Stasaitis on 7/23/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import "RPRFreshbooksTimeEntry.h"

@implementation RPRFreshbooksTimeEntry

- (NSString *)description
{
    return [@{
              @"timeEntryId" : self.timeEntryId ?: [NSNull null],
              @"staffId" : self.staffId ?: [NSNull null],
              @"projectId" : self.projectId ?: [NSNull null],
              @"taskId" : self.taskId ?: [NSNull null],
              @"hours" : self.hours ?: [NSNull null],
              @"date" : self.date ?: [NSNull null],
              @"notes" : self.notes ?: [NSNull null],
              @"billed" : self.billed ?: [NSNull null]
              } description];
}

@end
