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

-(void)setUnplayable:(BOOL)unplayable
{
    _unplayable = unplayable;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // draw actual card shape and fill white
    // set clipping for further subclass drawing
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0];
    [roundedRect addClip];
    
    // state dependent alpha and border color
    UIColor *borderColor = [UIColor blackColor];
    
    if(self.faceUp || self.unplayable) { borderColor = [UIColor grayColor]; }
    
    self.alpha = (self.unplayable) ? 0.3 : 1;
    
    // white background for card
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    // card border
    [borderColor setStroke];
    [roundedRect setLineWidth:2];
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
