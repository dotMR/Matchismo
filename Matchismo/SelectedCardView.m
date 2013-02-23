//
//  SelectedCardView.m
//  Matchismo
//
//  Created by Mario Russo on 2/23/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "SelectedCardView.h"
#import "SetCard.h"
#import "SetCardView.h"

@implementation SelectedCardView

-(void) setSelectedCards:(NSArray *)selectedCards
{
    _selectedCards = selectedCards;
    [self setNeedsDisplay];
}

//- (void)drawRect:(CGRect)rect
//{
//    for (Card *card in [self selectedCards])
//    {
//        if( [card isKindOfClass:[SetCard class]] )
//        {
//            SetCard *setCard = (SetCard *)card;
//            
//            SetCardView *view = [[SetCardView alloc] initWithFrame:self.bounds];
//            view.shape = setCard.shape;
//            view.rank = setCard.rank;
//            view.fillPattern = setCard.fillPattern;
//            view.color = setCard.color;
//            view.faceUp = setCard.isFaceUp;
//            
//            [view setNeedsDisplay];
//        }
//    }
//}

@end
