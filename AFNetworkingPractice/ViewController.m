//
//  ViewController.m
//  AFNetworkingPractice
//
//  Created by Aditya Narayan on 12/12/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HideTheseKeys" ofType:@"plist"]];
    NSString *accessToken = [dictionary objectForKey:@"AccessToken"];
    NSString *authorizationHeader = [dictionary objectForKey:@"AuthorizationHeader"];
    
    
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];

    
    //**This below step was required to make unauthenticated requests to Vimeo's API --> you need to request an access token from the server making this below POST request
    
//    [httpManager.requestSerializer setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
//
//    NSDictionary *parameters = @{
//                                 @"grant_type": @"client_credentials",
//                                 };
//    [httpManager POST:@"https://api.vimeo.com/oauth/authorize/client" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
    
    [httpManager.requestSerializer
        setValue:accessToken
        forHTTPHeaderField:@"Authorization"];
    
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/vnd.vimeo.video+json"];
    
     
    NSDictionary *parameters = @{
                                @"page": @1,
                                @"per_page": @5
                                     };
    
    [httpManager GET:@"https://api.vimeo.com/channels/staffpicks/videos" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
    
    
    
    
    
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
//    }];
    
    
//    NSURL *baseURL = [NSURL URLWithString:@"http://www.terrybu.com/index.php"];
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
//    
//    NSOperationQueue *operationQueue = manager.operationQueue;
//    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                [operationQueue setSuspended:NO];
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//            default:
//                [operationQueue setSuspended:YES];
//                break;
//        }
//    }];
//    
//    [manager.reachabilityManager startMonitoring];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
