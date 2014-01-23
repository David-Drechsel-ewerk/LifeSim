//
//  DDGridView.m
//  LifeSimulator
//
//  Created by David Drechsel on 23.01.14.
//  Copyright (c) 2014 David Drechsel. All rights reserved.
//

#import "DDGridView.h"
#import "DDLifeCell.h"
#import "DDMaleCell.h"
#import "DDFemaleCell.h"

@implementation DDGridView {
  CGColorRef maleColor;
  CGColorRef femaleColor;
}
@synthesize rows, columns, lifeCells;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.lifeCells = [NSMutableArray array];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.lifeCells = [NSMutableArray array];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  // Drawing code
  float width = rect.size.width / columns;
  float height = rect.size.height / rows;

  CGContextRef context = UIGraphicsGetCurrentContext();

  if (!maleColor)
    maleColor = [UIColor blueColor].CGColor;

  if (!femaleColor)
    femaleColor = [UIColor purpleColor].CGColor;

  for (DDLifeCell *cell in lifeCells) {

    CGColorRef color = [cell isKindOfClass:[DDFemaleCell class]] ? femaleColor
                                                                 : maleColor;
    CGRect rect = CGRectMake(cell->position.x * width,
                             cell->position.y * height, width, height);
    CGContextSetFillColorWithColor(context, color);
    CGContextFillRect(context, rect);
    NSString *age = [NSString stringWithFormat:@"%d", cell->age];

    NSDictionary *textAttributes = nil;

    if (cell->age >= adultAge) {
      textAttributes =
          [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                      forKey:NSForegroundColorAttributeName];
    }

    [age drawInRect:rect withAttributes:textAttributes];
  }
}

@end
