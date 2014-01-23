//
//  Functions.c
//  LifeSimulator
//
//  Created by David Drechsel on 23.01.14.
//  Copyright (c) 2014 David Drechsel. All rights reserved.
//

#import "Functions.h"

BOOL DDRandBOOL() {
  int randomval = arc4random_uniform(2);
  BOOL isFemale = (BOOL)randomval;
  return isFemale;
}
