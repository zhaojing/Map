//
//  ViewController.m
//  map
//
//  Created by jing zhao on 8/15/13.
//  Copyright (c) 2013 youdao. All rights reserved.
//

#import "ViewController.h"
#import "BMKMapView.h"
#import "BMKSearch.h"
#import "BMKPointAnnotation.h"
#import "FistViewController.h"
#import "BMKPinAnnotationView.h"

@interface ViewController ()<BMKMapViewDelegate,
BMKSearchDelegate,UIAlertViewDelegate>
{
    BMKMapView *_mapView;
    
    BMKSearch * _mapSearch;
    
    BOOL       _firstLocated;
    
    FistViewController *_firstviewController ;
    
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
    
    _firstviewController = [[FistViewController alloc]initWithNibName:@"FistViewController" bundle:nil];
    
    
    _firstLocated = YES;
    
    _mapView= [[BMKMapView alloc]initWithFrame:self.view.frame];
    
    _mapView.region = BMKCoordinateRegionMake(_mapView.userLocation.coordinate, BMKCoordinateSpanMake(0.1, 0.1)) ;
    
    self.view = _mapView;
    
    
    _mapView.showsUserLocation = YES;
    
    //搜素兴趣点
    
    _mapSearch = [[BMKSearch alloc]init];
    
    _mapSearch.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    
    _mapView.delegate = nil;
    
    _mapSearch.delegate = nil;
}

/**************************************************************************************/


#pragma mark -
#pragma mark Input Parameters
#pragma mark -


/**************************************************************************************/

-(void)_searchPoi
{
    
    BOOL boolPoiSeachSuccess =[_mapSearch poiSearchInCity:@"西安" withKey:@"麦当劳" pageIndex:0];
    
    if (boolPoiSeachSuccess)
    {
        NSLog(@"search success.");
    }
    else
    {
        
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"sorry"
                                                      message:@"网络差请稍后重试"
                                                     delegate:nil
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"重试" ,nil];
        [aler show];
        NSLog(@"search failed!");
    }
}


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
        
        double delayInSeconds = 4.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self _searchPoi];
        });
    }
}

/*
 定位失败
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

/*
 点击气泡
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    [self.navigationController pushViewController:_firstviewController animated:YES];
}

/*
 气泡View重写
 */

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.canShowCallout = YES;
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{


}

/**************************************************************************************/

#pragma mark -
#pragma mark UIalertView Delegate 用来以防定位失败
#pragma mark -

/**************************************************************************************/


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self _searchPoi];
        });
    }
}

/**************************************************************************************/

#pragma mark -
#pragma mark BMKMapViewDelegate Delegate
#pragma mark -

/**************************************************************************************/

- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    
    if (error == BMKErrorOk)
    {
        BMKPoiResult* result = [poiResultList objectAtIndex:0];
        for (int i = 0; i < result.poiInfoList.count; i++)
        {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [_mapView addAnnotation:item];
        }
    }
}

/**************************************************************************************/

#pragma mark -
#pragma mark UIResponder Delegate
#pragma mark -

/**************************************************************************************/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{



}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    


}

@end
