//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Mario Russo on 2/6/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "MatchismoCardGame.h"
#import "CardGame_extension.h"

@implementation MatchismoCardGame

#define MISMATCH_PENALTY (-2)
#define MATCH_BONUS (4)

-(void) doThisActionOnFlippedCard:(Card *)cardJustFlipped
{
    [super doThisActionOnFlippedCard:cardJustFlipped];
            
    if(self.numPlayableFaceUpCards == (self.numCardsToMatch-1))
    {
        int totalMoveScore = 0;
        BOOL matchFailed = FALSE;
        NSMutableArray * cardsMatched = [[NSMutableArray alloc] init];
        
        for(Card *thisCard in self.dealtCards)
        {
            if(thisCard.isFaceUp && !thisCard.isUnplayable && ![cardJustFlipped isEqual:thisCard])
            {
                [cardsMatched addObject:thisCard];
                int thisMatchScore = [cardJustFlipped match:thisCard];
                
                if(thisMatchScore > 0)
                {
                    matchFailed = FALSE;
                    totalMoveScore += thisMatchScore * MATCH_BONUS;
                }
                else
                {
                    matchFailed = TRUE;
                    totalMoveScore = MISMATCH_PENALTY;
                    break;
                }
            }
        }
        
        NSString * action = [[NSString alloc] init];
        
        if(matchFailed)
        {
            action = [NSString stringWithFormat: @"No match for %@, %@ : %d points", cardJustFlipped.contents,[cardsMatched componentsJoinedByString:@", "], totalMoveScore];
            
            for(Card *c in cardsMatched)
            {
                c.faceUp = NO;
            }
        }
        else
        {
            action = [NSString stringWithFormat: @"Matched %@, %@ for %d points!", cardJustFlipped.contents, [cardsMatched componentsJoinedByString:@", "], totalMoveScore];
            
            // cleanup cards and deck
            cardJustFlipped.unplayable = YES;
//            [self removeDealtCard:cardJustFlipped];
            
            for(Card *c in cardsMatched)
            {
                c.faceUp = c.unplayable = YES;
//                [self removeDealtCard:c];
            }
        }
        
        self.score+=totalMoveScore;
        [self recordGameAction:action];
        [cardsMatched removeAllObjects];
    }
}

@end
