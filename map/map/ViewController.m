//
//  ViewController.m
//  map
//
//  Created by jing zhao on 8/15/13.
//  Copyright (c) 2013 youdao. All rights reserved.
//

#import "ViewController.h"
#import "BMKMapView.h"

@interface ViewController ()<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    
    BOOL       _firstLocated;
}

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _firstLocated = YES;
    
    _mapView= [[BMKMapView alloc]initWithFrame:self.view.frame];
    
    _mapView.region = BMKCoordinateRegionMake(_mapView.userLocation.coordinate, BMKCoordinateSpanMake(0.1, 0.1)) ;
    
    self.view = _mapView;
    
    _mapView.showsUserLocation = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    
    _mapView.delegate = nil;
}

/**************************************************************************************/


#pragma mark -
#pragma mark Input Parameters
#pragma mark -


/**************************************************************************************/


 

/**************************************************************************************/

#pragma mark -
#pragma mark BMKMapViewDelegate Delegate
#pragma mark -

/**************************************************************************************/

/*
 定位到用户的位置
 */
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    if (_firstLocated)
    {
        CLLocationCoordinate2D userCoords = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        
        [_mapView setRegion:BMKCoordinateRegionMake(userCoords, BMKCoordinateSpanMake(0.1, 0.1)) animated:YES];
        
        _firstLocated = NO;
    }
 }

/*
 定位失败
 */

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

@end
