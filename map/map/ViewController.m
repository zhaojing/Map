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
    
    _mapView= [[BMKMapView alloc]initWithFrame:self.view.frame];
    self.view = _mapView;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    
}

@end
