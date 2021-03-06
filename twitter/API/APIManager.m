//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = // Enter your consumer key here
static NSString * const consumerSecret = // Enter your consumer secret here

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * task, NSArray * tweetDictionaries) {
       
       // Cache it
       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
       [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];
       
       // Create Tweets from dictionaries
       NSMutableArray *tweets = [NSMutableArray array];
       for (NSDictionary *dictionary in tweetDictionaries) {
           Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
           [tweets addObject:tweet];
       }
       if (completion) { completion(tweets, nil); }
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       if (completion) { completion(nil, error); }
   }];
}

- (void)favoriteTweet:(Tweet *)tweet completion:(void(^)(Tweet *tweet, NSError *error))completion {
    
    NSDictionary *parameters = @{@"id": tweet.uid};
    [self POST:@"1.1/favorites/create.json"
   parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *response) {
       
       // Create Tweet from response
       if (response && task.error == nil) {
           Tweet *tweet = [[Tweet alloc] initWithDictionary:response];
           if (completion) { completion(tweet, nil); }
       } else {
           if (completion) { completion(nil, task.error); }
       }
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       if (completion) { completion(nil, error); }
   }];
}

- (void)unfavoriteTweet:(Tweet *)tweet completion:(void(^)(Tweet *tweet, NSError *error))completion {
    
    NSDictionary *parameters = @{@"id": tweet.uid};
    [self POST:@"1.1/favorites/destroy.json"
    parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *response) {
        
        // Create Tweet from response
        if (response && task.error == nil) {
            Tweet *tweet = [[Tweet alloc] initWithDictionary:response];
            if (completion) { completion(tweet, nil); }
        } else {
            if (completion) { completion(nil, task.error); }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) { completion(nil, error); }
    }];
}

- (void)retweetTweet:(Tweet *)tweet completion:(void(^)(Tweet *tweet, NSError *error))completion {
    
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.uid]
    parameters:nil progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *response) {
        
        // Create Tweet from response
        if (response && task.error == nil) {
            Tweet *tweet = [[Tweet alloc] initWithDictionary:response];
            if (completion) { completion(tweet, nil); }
        } else {
            if (completion) { completion(nil, task.error); }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) { completion(nil, error); }
    }];
}

- (void)unretweetTweet:(Tweet *)tweet completion:(void(^)(Tweet *tweet, NSError *error))completion {
    
    [self POST:[NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json", tweet.uid]
    parameters:nil progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *response) {
        
        // Create Tweet from response
        if (response && task.error == nil) {
            Tweet *tweet = [[Tweet alloc] initWithDictionary:response];
            if (completion) { completion(tweet, nil); }
        } else {
            if (completion) { completion(nil, task.error); }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) { completion(nil, error); }
    }];
}

- (void)composeTweetWithText:(NSString *)text completion:(void(^)(Tweet *tweet, NSError *error))completion {
    
    NSDictionary *parameters = @{@"status": text};
    [self POST:@"1.1/statuses/update.json"
    parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *response) {
        
        // Create Tweet from response
        if (response && task.error == nil) {
            Tweet *tweet = [[Tweet alloc] initWithDictionary:response];
            if (completion) { completion(tweet, nil); }
        } else {
            if (completion) { completion(nil, task.error); }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) { completion(nil, error); }
    }];
}

@end
