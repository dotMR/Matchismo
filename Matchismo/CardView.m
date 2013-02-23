//
//  CardView.m
//  SetGame
//
//  Created by Mario Russo on 2/21/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "CardView.h"

@implementation CardView

-(void)setRank:(NSUInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

-(void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // draw actual card shape and fill white
    // set clipping for further subclass drawing
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}

-(void) setup
{
    // init goes here
}

-(void) awakeFromNib
{
    [self setup];
}

@end
