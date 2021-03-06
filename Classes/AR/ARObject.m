//
//  ARObject.m
//  PrometAR
//
// Created by Geoffroy Lesage on 4/24/13.
// Copyright (c) 2013 Promet Solutions Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ARObject.h"


@interface ARObject ()

@end


@implementation ARObject

@synthesize arTitle, address, distance;

- (id)initWithId:(int)newNid
           title:(NSString*)newTitle
         address:(NSString*)newAddress
     coordinates:(CLLocationCoordinate2D)newCoordinates
andCurrentLocation:(CLLocationCoordinate2D)currLoc {
    
    self = [super init];
    if (self) {
        nid = newNid;
        
        arTitle = [[NSString alloc] initWithString:newTitle];
        address = [[NSString alloc] initWithString:newAddress];
        
        lat = newCoordinates.latitude;
        lon = newCoordinates.longitude;
        
        distance = [[NSNumber alloc] initWithDouble:[self calculateDistanceFrom:currLoc]];
        
        [self.view setTag:newNid];
    }
    return self;
}

-(double)calculateDistanceFrom:(CLLocationCoordinate2D)user_loc_coord {
    
    CLLocationCoordinate2D object_loc_coord = CLLocationCoordinate2DMake(lat, lon);
    
    CLLocation *object_location = [[[CLLocation alloc] initWithLatitude:object_loc_coord.latitude
                                                              longitude:object_loc_coord.longitude]
                                   autorelease];
    CLLocation *user_location = [[[CLLocation alloc] initWithLatitude:user_loc_coord.latitude
                                                            longitude:user_loc_coord.longitude]
                                 autorelease];
    
    return [object_location distanceFromLocation:user_location];
}
-(NSString*)getDistanceLabelText {
    if (distance.doubleValue > POINT_ONE_MILE_METERS)
         return [NSString stringWithFormat:@"%.2f mi", distance.doubleValue*METERS_TO_MILES];
    else return [NSString stringWithFormat:@"%.0f ft", distance.doubleValue*METERS_TO_FEET];
}

- (NSDictionary*)getARObjectData {
    NSArray *keys = [NSArray arrayWithObjects:@"id",@"title", @"address", @"latitude", @"longitude", @"distance", nil];
    
    NSArray *values = [NSArray arrayWithObjects:
                       [NSNumber numberWithInt:nid],
                       arTitle,
                       address,
                       [NSNumber numberWithDouble:lat],
                       [NSNumber numberWithDouble:lon],
                       distance,
                       nil];
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [titleL setText:arTitle];
    
    [distanceL setText:[self getDistanceLabelText]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
    
    [arTitle release];
    [address release];
    [distance release];
}

@end
