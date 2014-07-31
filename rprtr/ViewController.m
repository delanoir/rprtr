//
//  ViewController.m
//  rprtr
//
//  Created by Karolis Stasaitis on 7/22/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import "ViewController.h"
#import "RPRLineChartCell.h"

#import "RPRSyncSignalsManager.h"

#import "RPRTaskParserDelegate.h"
#import "RPRProjectParserDelegate.h"
#import "RPRTimeEntryParserDelegate.h"

#import "RPRTimeEntry.h"
#import "RPRFreshbooksTimeEntry.h"
#import "RPRFreshbooksProject.h"
#import "RPRProject.h"
#import "RPRFreshbooksTask.h"
#import "RPRTask.h"

#import <NSDate-Escort/NSDate+Escort.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-logo"]];
    
    [self.tableView registerClass:[RPRLineChartCell class] forCellReuseIdentifier:NSStringFromClass([RPRLineChartCell class])];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navigationController.view.bounds;
    UIColor *startColour = [UIColor colorWithHex:0x60DACC];
    UIColor *endColour = [UIColor colorWithHex:0xF8F0D4];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    [self.navigationController.view.layer insertSublayer:gradient atIndex:0];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [[NSFileManager defaultManager] removeItemAtPath:[[RLMRealm defaultRealm] path] error:nil];
    
    __block RLMRealm *realmz = [RLMRealm defaultRealm];
    [realmz beginWriteTransaction];
    [realmz deleteObjects:[RPRTimeEntry allObjects]];
    [realmz deleteObjects:[RPRProject allObjects]];
    [realmz deleteObjects:[RPRTask allObjects]];
    [realmz commitWriteTransaction];

    RACSignal *merged = [RACSignal merge:@[
                                           [[RPRSyncSignalsManager sharedManager] syncTasks],
                                           [[RPRSyncSignalsManager sharedManager] syncProjects],
                                           [[RPRSyncSignalsManager sharedManager] syncTimeEntries]
                                           ]];
    
    __block int i = 0;
    [merged subscribeNext:^(NSObject *x) {
        i++;
        //NSLog(@"Entry! %d %@", i, NSStringFromClass([x class]));
        //[self.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"Error");
    } completed:^{
        [self.tableView reloadData];
        NSLog(@"Completed");
    }];
    
//    [timeEntries subscribeNext:^(id x) {
//        NSLog(@"Completed");
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RPRLineChartCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPRLineChartCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RPRLineChartCell class]) forIndexPath:indexPath];
    
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *data = [NSMutableArray array];
    NSDate *refDate = [[NSDate date] dateAtStartOfYear];
    for (int i = 1; i <= 12; i++) {
        [values addObject:@(i).stringValue];
        RLMArray *timeEntries = [RPRTimeEntry objectsWhere:@"date => %@ && date < %@", [refDate dateByAddingMonths:i-1], [refDate dateByAddingMonths:i]];
        if ([timeEntries count]) {
            NSNumber *sum = [timeEntries sumOfProperty:@"hours"];
            [data addObject:sum];
        }
        else {
            [data addObject:@0];
        }
    }
    
    [cell setData:[data copy] forValues:[values copy]];
    // Configure the cell...
    
    return cell;
}


@end
