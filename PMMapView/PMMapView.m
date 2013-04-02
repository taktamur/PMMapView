//
//  PMMapView.m
//  PMMapView
//
//  Created by Takafumi Tamura on 2013/04/02.
//  Copyright (c) 2013年 田村 孝文. All rights reserved.
//

#import "PMMapView.h"
#import <BlocksKit/BlocksKit.h>

@interface PMMapView()
@property(nonatomic,strong)UIButton *hereButton;

@end

@implementation PMMapView
@synthesize hereButton;

#pragma mark - initialize
-(id)init
{
    self = [super init];
    if( self ){
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if( self ){
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self ){
        [self setup];
    }
    return self;
}


-(void)setup
{
    self.zoomInLimit = 0.0001;
    self.zoomOutLimit = 65.0;
    self.zoomStep = 0.2;

    // Adding zoomin/out button
    
    UIButton *zoominButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zoominButton.frame = CGRectMake(0,0,44,44);
    [zoominButton setTitle:@"+" forState:UIControlStateNormal];
    
    UIButton *zoomoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zoomoutButton.frame = CGRectMake( 0,50,44,44);
    [zoomoutButton setTitle:@"-" forState:UIControlStateNormal];
    
    self.hereButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];    
    [self.hereButton setTitle:@"here" forState:UIControlStateNormal];

    [self addSubview:zoominButton];
    [self addSubview:zoomoutButton];
    [self addSubview:self.hereButton];

    
    // Add Events.
    __block __weak MKMapView *weakSelf = self;
    [zoominButton addEventHandler:^(id sender){
        MKCoordinateSpan span = weakSelf.region.span;
        MKCoordinateSpan newSpan = MKCoordinateSpanMake(span.latitudeDelta * self.zoomStep,
                                                        span.longitudeDelta * self.zoomStep);
        if( (newSpan.latitudeDelta > self.zoomInLimit )&&
           (newSpan.longitudeDelta > self.zoomInLimit ) ){
            [weakSelf setRegion:MKCoordinateRegionMake(weakSelf.region.center,newSpan)
                       animated:YES];
        }
    }forControlEvents:UIControlEventTouchUpInside];

    [zoomoutButton addEventHandler:^(id sender){
        MKCoordinateSpan span = weakSelf.region.span;
        MKCoordinateSpan newSpan = MKCoordinateSpanMake(span.latitudeDelta / self.zoomStep,
                                                        span.longitudeDelta / self.zoomStep);
        if( (newSpan.latitudeDelta < self.zoomOutLimit )&&
           (newSpan.longitudeDelta < self.zoomOutLimit ) ){
            [weakSelf setRegion:MKCoordinateRegionMake(weakSelf.region.center,newSpan)
                       animated:YES];
        }
    }forControlEvents:UIControlEventTouchUpInside];
    
    [self.hereButton addEventHandler:^(id sender){
        [weakSelf setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - View layout
-(void)layoutSubviews
{
    hereButton.frame = CGRectMake(0,self.bounds.size.height-44,44,44);
}

@end

