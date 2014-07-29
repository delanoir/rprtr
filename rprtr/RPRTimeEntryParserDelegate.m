//
//  RPRTimeEntryParserDelegate.m
//  rprtr
//
//  Created by Karolis Stasaitis on 7/25/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import "RPRTimeEntryParserDelegate.h"
#import "RPRFreshbooksTimeEntry.h"

@interface RPRTimeEntryParserDelegate ()

@property (nonatomic, weak) id<RACSubscriber> subscriber;
@property (nonatomic, strong) RPRFreshbooksTimeEntry *currentTimeEntry;
@property (nonatomic, strong) NSString *currentValueName;

@end

@implementation RPRTimeEntryParserDelegate

#pragma mark - Public Interface

+ (RACSignal *)getTimeEntryListWithParser:(NSXMLParser *)parser
{
    __block RPRTimeEntryParserDelegate *delegate = [[self alloc] init];
    
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
    else if ([elementName isEqualToString:@"time_entries"]) {
    }
    else if ([elementName isEqualToString:@"time_entry"]) {
        self.currentTimeEntry = [[RPRFreshbooksTimeEntry alloc] init];
        self.currentValueName = nil;
    }
    else if ([elementName isEqualToString:@"time_entry_id"]) {
        self.currentValueName = @"timeEntryId";
    }
    else if ([elementName isEqualToString:@"staff_id"]) {
        self.currentValueName = @"staffId";
    }
    else if ([elementName isEqualToString:@"project_id"]) {
        self.currentValueName = @"projectId";
    }
    else if ([elementName isEqualToString:@"task_id"]) {
        self.currentValueName = @"taskId";
    }
    else if ([elementName isEqualToString:@"hours"]) {
        self.currentValueName = @"hours";
    }
    else if ([elementName isEqualToString:@"date"]) {
        self.currentValueName = @"date";
    }
    else if ([elementName isEqualToString:@"notes"]) {
        self.currentValueName = @"notes";
    }
    else if ([elementName isEqualToString:@"billed"]) {
        self.currentValueName = @"billed";
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currentValueName) {
        [self.currentTimeEntry setValue:string forKey:self.currentValueName];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    self.currentValueName = nil;
    if ([elementName isEqualToString:@"time_entry"]) {
        [self.subscriber sendNext:self.currentTimeEntry];
    }
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    NSLog(@"Validation error occured!");
}

@end
