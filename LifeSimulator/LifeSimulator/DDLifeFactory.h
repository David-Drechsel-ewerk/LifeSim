//
//  DDLifeFactory.h
//  LifeSimulator
//
//  Created by David Drechsel on 23.01.14.
//  Copyright (c) 2014 David Drechsel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLifeCell.h"
#import "DDMaleCell.h"
#import "DDFemaleCell.h"

@interface DDLifeFactory : NSObject

+ (DDLifeCell *)createNewLife;

@end
