//
//  WebSignals.m
//  rprtr
//
//  Created by Karolis Stasaitis on 7/28/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import "RPRWebSignalsManager.h"
#import <AFNetworking-RACExtensions/AFHTTPRequestOperationManager+RACSupport.h>
#import "NSURLRequest+XML.h"

#define FRESHBOOKS_API_TOKEN @"08fcf553188d99199053acfce6b27ee9"
#define FRESHBOOKS_URL_FORMAT @"https://%@.freshbooks.com/api/2.1/xml-in"
#define FRESHBOOKS_ORG_SUBDOMAIN @"devbridge"

@interface RPRWebSignalsManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong, readonly) NSURL *baseUrl;

@end

@implementation RPRWebSignalsManager

+ (id)sharedManager
{
    static RPRWebSignalsManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _baseUrl = [NSURL URLWithString:[NSString stringWithFormat:FRESHBOOKS_URL_FORMAT, FRESHBOOKS_ORG_SUBDOMAIN]];
        
        self.manager = [[AFHTTPRequestOperationManager alloc]
                        initWithBaseURL:self.baseUrl];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }
    return self;
}

- (NSString *)xmlRequestStringForMethod:(NSString *)method page:(NSUInteger)page perPage:(NSUInteger)perPage
{
    return [NSString stringWithFormat:@"<request method=\"%@\"><page>%lu</page><per_page>%lu</per_page></request>", method, (unsigned long)page, (unsigned long)perPage];
}

- (RACSignal *)signalForMethod:(NSString *)method page:(NSUInteger)page perPage:(NSUInteger)perPage
{
    NSString *xmlString = [self xmlRequestStringForMethod:method page:page perPage:perPage];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.baseUrl token:FRESHBOOKS_API_TOKEN xmlString:xmlString];
    AFHTTPRequestOperation *operation = [self.manager HTTPRequestOperationWithRequest:request success:nil failure:nil];
    return [self.manager rac_enqueueHTTPRequestOperation:operation];
}

- (RACSignal *)getTasks
{
    return [self signalForMethod:@"task.list" page:1 perPage:100];
}

- (RACSignal *)getProjects
{
    return [self signalForMethod:@"project.list" page:1 perPage:100];
}

- (RACSignal *)getTimeEntries
{
    NSMutableArray *signalArray = [NSMutableArray array];
    for (int i = 1; i <= 10; i++) {
        [signalArray addObject:[self signalForMethod:@"time_entry.list" page:i perPage:100]];
    }
    return [signalArray.rac_sequence.signal flatten];
    return [self signalForMethod:@"time_entry.list" page:1 perPage:100];
}

@end
