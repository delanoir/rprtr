//
//  RPRProjectParserDelegate.m
//  rprtr
//
//  Created by Karolis Stasaitis on 7/23/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import "RPRProjectParserDelegate.h"
#import "RPRFreshbooksProject.h"

@interface RPRProjectParserDelegate ()

@property (nonatomic, weak) id<RACSubscriber> subscriber;

@property (nonatomic, strong) RPRFreshbooksProject *currentProject;

@property (nonatomic, strong) NSMutableArray *currentProjectTasks;
@property (nonatomic, strong) RPRFreshbooksProjectTask *currentTask;

@property (nonatomic, strong) NSMutableArray *currentProjectStaff;
@property (nonatomic, strong) RPRFreshbooksProjectStaff *currentStaffMember;

@property (nonatomic, strong) NSString *currentValueName;
@property (nonatomic, strong) NSString *currentTaskValueName;

@end

@implementation RPRProjectParserDelegate

#pragma mark - Public Interface

+ (RACSignal *)getProjectListWithParser:(NSXMLParser *)parser
{
    __block RPRProjectParserDelegate *delegate = [[self alloc] init];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        delegate.subscriber = subscriber;
        
        parser.delegate = delegate;
        if ([parser parse]) {
            [subscriber sendCompleted];
        }
        else {
            [subscriber sendError:parser.parserError];
        }
        
        return (RACDisposable *)nil;
    }];
    
    return signal;
}

#pragma mark - Parser Specifics

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentValueName = nil;
    self.currentTaskValueName = nil;
    if ([elementName isEqualToString:@"response"]) {
    }
    else if ([elementName isEqualToString:@"projects"]) {
    }
    else if ([elementName isEqualToString:@"project"]) {
        self.currentProject = [[RPRFreshbooksProject alloc] init];
        self.currentValueName = nil;
    }
    else if ([elementName isEqualToString:@"project_id"]) {
        self.currentValueName = @"projectId";
    }
    else if ([elementName isEqualToString:@"name"]) {
        self.currentValueName = @"name";
    }
    else if ([elementName isEqualToString:@"description"]) {
        self.currentValueName = @"projectDescription";
    }
    else if ([elementName isEqualToString:@"rate"]) {
        self.currentValueName = @"rate";
    }
    else if ([elementName isEqualToString:@"billMethod"]) {
        self.currentValueName = @"billMethod";
    }
    else if ([elementName isEqualToString:@"clientId"]) {
        self.currentValueName = @"clientId";
    }
    else if ([elementName isEqualToString:@"hourBudget"]) {
        self.currentValueName = @"hourBudget";
    }
    else if ([elementName isEqualToString:@"tasks"]) {
        self.currentProjectTasks = [NSMutableArray array];
    }
    else if ([elementName isEqualToString:@"task"]) {
        self.currentTask = [[RPRFreshbooksProjectTask alloc] init];
    }
    else if ([elementName isEqualToString:@"task_id"]) {
        self.currentTaskValueName = @"taskId";
    }
    else if ([elementName isEqualToString:@"rate"]) {
        self.currentTaskValueName = @"rate";
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currentValueName) {
        [self.currentProject setValue:string forKey:self.currentValueName];
    }
    else if (self.currentTaskValueName) {
        [self.currentTask setValue:string forKey:self.currentTaskValueName];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    self.currentValueName = nil;
    self.currentTaskValueName = nil;
    if ([elementName isEqualToString:@"project"]) {
        [self.subscriber sendNext:self.currentProject];
    }
    else if ([elementName isEqualToString:@"tasks"]) {
        self.currentProject.tasks = [self.currentProjectTasks copy];
    }
    else if ([elementName isEqualToString:@"task"]) {
        [self.currentProjectTasks addObject:self.currentTask];
    }
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    NSLog(@"Validation error occured!");
}

@end
