//
//  PMMapView.h
//  PMMapView
//
//  Created by Takafumi Tamura on 2013/04/02.
//  Copyright (c) 2013年 田村 孝文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PMMapView : MKMapView
@property(nonatomic)double zoomStep;
@property(nonatomic)double zoomInLimit;
@property(nonatomic)double zoomOutLimit;
@end
