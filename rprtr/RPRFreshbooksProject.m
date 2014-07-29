//
//  RPRFreshbooksProject.m
//  rprtr
//
//  Created by Karolis Stasaitis on 7/23/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import "RPRFreshbooksProject.h"

@implementation RPRFreshbooksProject

- (NSString *)description
{
    return [@{
              @"projectId" : self.projectId ?: [NSNull null],
              @"name" : self.name ?: [NSNull null],
              @"projectDescription" : self.projectDescription ?: [NSNull null],
              @"rate" : self.rate ?: [NSNull null],
              @"billMethod" : self.billMethod ?: [NSNull null],
              @"clientId" : self.clientId ?: [NSNull null],
              @"hourBudget" : self.hourBudget ?: [NSNull null],
              @"tasks" : [self.tasks description] ?: [NSNull null],
              @"staff" : [self.staff description] ?: [NSNull null]
              } description];
}

@end

@implementation RPRFreshbooksProjectTask

- (NSString *)description
{
    return [@{
              @"taskId" : self.taskId ?: [NSNull null],
              @"rate" : self.rate ?: [NSNull null],
              } description];
}

@end

@implementation RPRFreshbooksProjectStaff

- (NSString *)description
{
    return [@{
              @"staffId" : self.staffId ?: [NSNull null],
              } description];
}

@end
