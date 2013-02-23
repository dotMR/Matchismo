//
//  CardNameViewController.m
//  Matchismo
//
//  Created by Mario Russo on 2/5/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "MatchismoViewController.h"
#import "PlayingCardDeck.h"
#import "MatchismoCardGame.h"
#import "CardViewCell.h"
#import "CardView.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"

@interface MatchismoViewController ()
@end

@implementation MatchismoViewController

-(Class) deckClassToInit
{
    return [PlayingCardDeck class];
}

-(Class) cardGameClassToInit
{
    return [MatchismoCardGame class];
}

-(NSUInteger) startingCardCount
{
    return 22;
}

-(NSString *) cardTypeIdentifier
{
    return @"PlayingCard";
}

-(void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if( [cell isKindOfClass:[CardViewCell class]] )
    {
        CardView *view = ((CardViewCell *)cell).cardView;
        
        if( [view isKindOfClass:[PlayingCardView class]] )
        {
            PlayingCardView *pCardView = (PlayingCardView *)view;

            if( [card isKindOfClass:[PlayingCard class]] )
            {
                PlayingCard *playingCard = (PlayingCard *)card;
                
                pCardView.rank = playingCard.rank;
                pCardView.suit = playingCard.suit;
                pCardView.faceUp = playingCard.isFaceUp;
                pCardView.unplayable = playingCard.isUnplayable;
            }
        }
    }
}

@end
