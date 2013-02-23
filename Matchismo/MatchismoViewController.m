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
    return 16;
}

-(void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if( [cell isKindOfClass:[CardViewCell class]] )
    {
        CardView *view = ((CardViewCell *)cell).cardView;
        
        if( [card isKindOfClass:[PlayingCard class]] )
        {
            PlayingCard *playingCard = (PlayingCard *)card;
            view.rank = playingCard.rank;
            view.suit = playingCard.suit;
            view.faceUp = playingCard.isFaceUp;
            view.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

@end
