//
//  RPRTaskParserDelegate.m
//  rprtr
//
//  Created by Karolis Stasaitis on 7/22/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import "RPRTaskParserDelegate.h"
#import "RPRFreshbooksTask.h"

@interface RPRTaskParserDelegate ()

@property (nonatomic, weak) id<RACSubscriber> subscriber;

@property (nonatomic, strong) RPRFreshbooksTask *currentTask;
@property (nonatomic, strong) NSString *currentValueName;

@end

@implementation RPRTaskParserDelegate

#pragma mark - Public Interface

+ (RACSignal *)getTaskListWithParser:(NSXMLParser *)parser;
{
    __block RPRTaskParserDelegate *delegate = [[self alloc] init];
    
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
    if ([elementName isEqualToString:@"response"]) {
    }
    else if ([elementName isEqualToString:@"tasks"]) {
    }
    else if ([elementName isEqualToString:@"task"]) {
        self.currentTask = [[RPRFreshbooksTask alloc] init];
        self.currentValueName = nil;
    }
    else if ([elementName isEqualToString:@"task_id"]) {
        self.currentValueName = @"taskId";
    }
    else if ([elementName isEqualToString:@"name"]) {
        self.currentValueName = @"name";
    }
    else if ([elementName isEqualToString:@"description"]) {
        self.currentValueName = @"taskDescription";
    }
    else if ([elementName isEqualToString:@"billable"]) {
        self.currentValueName = @"billable";
    }
    else if ([elementName isEqualToString:@"rate"]) {
        self.currentValueName = @"rate";
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currentValueName) {
        [self.currentTask setValue:string forKey:self.currentValueName];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    self.currentValueName = nil;
    if ([elementName isEqualToString:@"task"]) {
        [self.subscriber sendNext:self.currentTask];
    }
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    NSLog(@"Validation error occured!");
}

@end
