//
//  DDGridView.h
//  LifeSimulator
//
//  Created by David Drechsel on 23.01.14.
//  Copyright (c) 2014 David Drechsel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDGridView : UIView
@property(nonatomic, assign) NSUInteger rows;
@property(nonatomic, assign) NSUInteger columns;
@property(nonatomic, retain) NSMutableArray *lifeCells;
@end
