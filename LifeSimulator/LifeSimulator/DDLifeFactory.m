//
//  DDLifeFactory.m
//  LifeSimulator
//
//  Created by David Drechsel on 23.01.14.
//  Copyright (c) 2014 David Drechsel. All rights reserved.
//

#import "DDLifeFactory.h"

@implementation DDLifeFactory

+ (DDLifeCell *)createNewLife {

  BOOL isFemale = DDRandBOOL();

  if (isFemale)
    return [[DDFemaleCell alloc] init];
  else
    return [[DDMaleCell alloc] init];
}

@end
