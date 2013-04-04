/*
 Copyright (c) 2013 Takafumi Tamura(taktamur@gmail.com)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//
//  PMMapView.m
//  PMMapView
//

#import "PMMapView.h"
#import <BlocksKit/BlocksKit.h>

// TODO 状態変更時のトーストを表示したい

@interface PMMapView()
//@property(nonatomic,strong)UIButton *hereButton;

@end

@implementation PMMapView
@synthesize zoomStep,zoomInLimit,zoomOutLimit;
@synthesize zoominButton = _zoominButton;
@synthesize zoomoutButton = _zoomoutButton;
@synthesize userTrackingButton = _userTrackingButton;

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
    self.zoomOutLimit = 180.0;
    self.zoomStep = 0.2;

    // Adding zoomin/out button
    UIButton *zoominButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zoominButton.frame = CGRectMake(0,0,44,44);
    [zoominButton setTitle:@"+" forState:UIControlStateNormal];
    self.zoominButton = zoominButton;
    
    UIButton *zoomoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zoomoutButton.frame = CGRectMake( 0,50,44,44);
    [zoomoutButton setTitle:@"-" forState:UIControlStateNormal];
    self.zoomoutButton = zoomoutButton;
    
    UIButton *userTrackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [userTrackButton setTitle:@"here" forState:UIControlStateNormal];
    userTrackButton.bounds = CGRectMake(0,0,44,44);
    self.userTrackingButton = userTrackButton;
    

    // TODO test
    // setした際にeventが登録されるか
    // unsetされたときにeventが解除されるか
}

#pragma mark - control setter.
-(void)setZoominButton:(UIControl *)zoominButon
{
    if( _zoominButton != nil ){
        [_zoominButton removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        _zoominButton=nil;
    }
    __block __weak PMMapView *weakSelf = self;
    [zoominButon addEventHandler:^(id sender){
        MKCoordinateSpan span = weakSelf.region.span;
        MKCoordinateSpan newSpan = MKCoordinateSpanMake(span.latitudeDelta * weakSelf.zoomStep,
                                                        span.longitudeDelta * weakSelf.zoomStep);
        if( (newSpan.latitudeDelta > weakSelf.zoomInLimit )&&
           (newSpan.longitudeDelta > weakSelf.zoomInLimit ) ){
            [weakSelf setRegion:MKCoordinateRegionMake(weakSelf.region.center,newSpan)
                       animated:YES];
        }
    }forControlEvents:UIControlEventTouchUpInside];
    _zoominButton = zoominButon;
    
    [self addSubview:_zoominButton];

}


-(void)setZoomoutButton:(UIControl *)zoomoutButon
{
    if( _zoomoutButton != nil ){
        [_zoomoutButton removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        _zoomoutButton=nil;
    }
    __block __weak PMMapView *weakSelf = self;
    [zoomoutButon addEventHandler:^(id sender){
        MKCoordinateSpan span = weakSelf.region.span;
        MKCoordinateSpan newSpan = MKCoordinateSpanMake(span.latitudeDelta / self.zoomStep,
                                                        span.longitudeDelta / self.zoomStep);
        if( (newSpan.latitudeDelta < self.zoomOutLimit )&&
           (newSpan.longitudeDelta < self.zoomOutLimit ) ){
            [weakSelf setRegion:MKCoordinateRegionMake(weakSelf.region.center,newSpan)
                       animated:YES];
        }
    }forControlEvents:UIControlEventTouchUpInside];
    _zoomoutButton = zoomoutButon;

    [self addSubview:_zoomoutButton];

}

-(void)setUserTrackingButton:(UIControl *)userTrackingButon
{
    if( _userTrackingButton != nil ){
        [_userTrackingButton removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        _userTrackingButton=nil;
    }
    __block __weak PMMapView *weakSelf = self;
    [userTrackingButon addEventHandler:^(id sender){
        [weakSelf setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }forControlEvents:UIControlEventTouchUpInside];
    _userTrackingButton = userTrackingButon;
    
    [self addSubview:_userTrackingButton];
}

#pragma mark - View layout
-(void)layoutSubviews
{
    CGSize userTrackingButtonSize = self.userTrackingButton.bounds.size;
    self.userTrackingButton.frame = CGRectMake(0,self.bounds.size.height-userTrackingButtonSize.height,
                                               userTrackingButtonSize.width,userTrackingButtonSize.height);
    
}

@end
