//
//  ViewController.m
//  AFNetworkingPractice
//
//  Created by Aditya Narayan on 12/12/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "TerryCollectionViewCell.h"
#import "Video.h"
#import <UIImageView+AFNetworking.h>

@interface ViewController ()

{
    NSMutableArray *videosArray;
}

@property (strong, nonatomic) IBOutlet UIImageView *practiceImageView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end


static NSString* const reuseIdentifier = @"Cell";


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HideTheseKeys" ofType:@"plist"]];
    NSString *accessToken = [dictionary objectForKey:@"AccessToken"];
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];

    
    //**This below step was required to make unauthenticated requests to Vimeo's API --> you need to request an access token from the server making this below POST request
    //    NSString *authorizationHeader = [dictionary objectForKey:@"AuthorizationHeader"];
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
    
    //Whenever an API asks for an Authrization Header, you need to send a request with a HTTPHeaderField with a certain key and value
    
    [httpManager.requestSerializer
        setValue:accessToken
        forHTTPHeaderField:@"Authorization"];
    
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/vnd.vimeo.video+json"];
    
    NSDictionary *parameters = @{
                                @"page": @1,
                                @"per_page": @5
                                     };
    
    [httpManager GET:@"https://api.vimeo.com/channels/staffpicks/videos" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        
        NSArray *dataArrayFromJSON = responseObject[@"data"];
        videosArray = [[NSMutableArray alloc]init];
        
        NSLog(@"%lu videos are in the Data array - key named Data from the API JSON data", (unsigned long)dataArrayFromJSON.count);
        for (int i=0; i < dataArrayFromJSON.count; i++) {
            NSDictionary *oneVideoDictionary = dataArrayFromJSON[i];
            Video *video = [[Video alloc]init];
            video.videoName = [oneVideoDictionary valueForKey:@"name"];
            
            NSDictionary *user = [oneVideoDictionary valueForKey:@"user"];
            video.videoCreatorName = [user valueForKey:@"name"];
            
            NSDictionary *pictures = [oneVideoDictionary valueForKey:@"pictures"];
            NSArray *sizesArray = [pictures valueForKey:@"sizes"];
            
            NSDictionary *sizeObject = sizesArray[i];
            NSString *linkImageURL = [sizeObject valueForKey:@"link"];
            video.videoImageURL = linkImageURL;
    
            [self.practiceImageView setImageWithURL:[NSURL URLWithString:video.videoImageURL]];

            [videosArray addObject:video];


        }
        
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
    
    
    
    
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    [httpManager.reachabilityManager startMonitoring];
    
}


#pragma mark Collection View methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return videosArray.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell
    
    TerryCollectionViewCell *cell = (TerryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Video *video = [videosArray objectAtIndex:indexPath.row];

    NSLog(@"%@", video.videoImageURL);


    [cell.videoThumbImageView setImageWithURL:[NSURL URLWithString:video.videoImageURL]];
    
    cell.videoCreatorNameLabel.text = video.videoCreatorName;
    
    cell.videoLabel.text = video.videoName;

    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
