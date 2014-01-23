//
//  DDViewController.m
//  LifeSimulator
//
//  Created by David Drechsel on 23.01.14.
//  Copyright (c) 2014 David Drechsel. All rights reserved.
//

#import "DDViewController.h"
#import "DDLifeFactory.h"

@interface DDViewController ()

@end

@implementation DDViewController {
  NSMutableArray *deadCells;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  grid.rows = 100;
  grid.columns = 100;
  // Do any additional setup after loading the view, typically from a nib.

  DDLifeCell *cell = [[DDMaleCell alloc] init];
  cell->position = CGPointMake(2, 3);
  [grid.lifeCells addObject:cell];

  cell = [[DDFemaleCell alloc] init];
  cell->position = CGPointMake(6, 9);
  [grid.lifeCells addObject:cell];

  cell = [DDLifeFactory createNewLife];
  cell->position = CGPointMake(4, 1);
  [grid.lifeCells addObject:cell];

  [NSTimer scheduledTimerWithTimeInterval:1.0f
                                   target:self
                                 selector:@selector(tick)
                                 userInfo:Nil
                                  repeats:YES];
}

- (void)tick {
  deadCells = [NSMutableArray array];

  for (DDLifeCell *cell in grid.lifeCells) {
    cell->age++;

    if (cell->age > 60) {
      [self markCellAsDead:cell];
      continue;
    }
    [self searchPartnerForCell:cell];
    [self moveCell:cell];
  }
  [grid.lifeCells removeObjectsInArray:deadCells];
  [self giveBirthToChilds];
  [grid setNeedsDisplay];
}

- (void)moveCell:(DDLifeCell *)cell {
  // movements
  CGPoint newPosition = [self freePositionForCell:cell];
  if (CGPointEqualToPoint(newPosition, cell->position)) {
    [self markCellAsDead:cell];
    return;
  }

  cell->position = newPosition;
}

- (void)markCellAsDead:(DDLifeCell *)cell {
  [deadCells addObject:cell];
}

- (CGPoint)freePositionForCell:(DDLifeCell *)cell {
  CGPoint newPosition;
  BOOL newPositionIsFree = NO;
  int i = 0;
  do {
    newPosition = cell->position;

    BOOL movementX = DDRandBOOL();
    if (movementX) {

      BOOL increment = DDRandBOOL();
      if (increment)
        newPosition.x++;
      else
        newPosition.x--;

      if (newPosition.x < 0)
        newPosition.x += grid.columns;
      else if (newPosition.x >= grid.columns)
        newPosition.x -= grid.columns;
    }

    BOOL movementY = DDRandBOOL();
    if (movementY) {
      BOOL increment = DDRandBOOL();
      if (increment)
        newPosition.y++;
      else
        newPosition.y--;

      if (newPosition.y < 0)
        newPosition.y += grid.rows;
      else if (newPosition.y >= grid.rows)
        newPosition.y -= grid.rows;
    }

    // check if calculated position is free
    int index = [grid.lifeCells
                 indexOfObjectPassingTest:^BOOL(DDLifeCell *obj, NSUInteger idx,
                                                BOOL * stop) {

      BOOL samePosition = CGPointEqualToPoint(obj->position, newPosition);
      return samePosition;
    }];

    newPositionIsFree = index == NSNotFound;

    i++;
  } while (!newPositionIsFree && i < 100);

  if (i >= 100) {
    newPosition = cell->position;
  }

  return newPosition;
}

- (void)searchPartnerForCell:(DDLifeCell *)cell {

  if (cell->age < adultAge)
    return;

  if ([cell isKindOfClass:[DDFemaleCell class]]) {
    DDFemaleCell *fCell = (DDFemaleCell *)cell;
    if (fCell->isPregnant)
      return;
  }

  NSIndexSet *possiblePartners = [grid.lifeCells indexesOfObjectsPassingTest:
                      ^BOOL(DDLifeCell * obj, NSUInteger idx, BOOL * stop) {

    if (obj == cell)
      return NO;

    // same gender can't make children
    if ([obj isKindOfClass:[cell class]])
      return NO;

    // female is already pregnant
    if ([obj isKindOfClass:[DDFemaleCell class]]) {
      DDFemaleCell *fCell = (DDFemaleCell *)obj;
      if (fCell->isPregnant)
        return NO;
    }

    return YES;
  }];

  int __block partnerIndex = NSNotFound;

  [possiblePartners enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    if (DDRandBOOL()) {
      partnerIndex = idx;
      stop = YES;
    }
  }];

  if (partnerIndex == NSNotFound)
    return;

  DDLifeCell *partner = [grid.lifeCells objectAtIndex:partnerIndex];

  if ([partner isKindOfClass:[DDFemaleCell class]])
    ((DDFemaleCell *)partner)->isPregnant = YES;
  else
    ((DDFemaleCell *)cell)->isPregnant = YES;
}

- (void)giveBirthToChilds {

  NSMutableArray *newChildren = [NSMutableArray array];
  for (DDLifeCell *cell in grid.lifeCells) {
    if (![cell isKindOfClass:[DDFemaleCell class]])
      continue;

    if (cell->age < adultAge)
      continue;

    DDFemaleCell *female = (DDFemaleCell *)cell;

    if (!(female->isPregnant))
      continue;

    // she is pregnant
    female->isPregnant = NO;

    CGPoint childPosition = [self freePositionForCell:female];
    if (CGPointEqualToPoint(childPosition, female->position)) {
      // no free location for child so mother dies
      NSLog(
          @"No free location for child at position: %@ \n So the mother died.",
          NSStringFromCGPoint(childPosition));
      [self markCellAsDead:female];
    }
    DDLifeCell *child = [DDLifeFactory createNewLife];
    child->position = childPosition;
    [newChildren addObject:child];
  }
  [grid.lifeCells addObjectsFromArray:newChildren];
}

@end
