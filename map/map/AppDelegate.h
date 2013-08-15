//
//  AppDelegate.h
//  map
//
//  Created by jing zhao on 8/15/13.
//  Copyright (c) 2013 youdao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"   

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
    
    UINavigationController *navigationController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
