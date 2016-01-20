//
//  AppDelegate.h
//  boostertutor
//
//  Created by Al Gilardi on 11/19/15.
//  Copyright © 2015 Al Gilardi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;

@end

