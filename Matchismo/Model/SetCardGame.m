//
//  SetCardGame.m
//  Matchismo
//
//  Created by Mario Russo on 2/13/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "SetCardGame.h"
#import "SetCard.h"
#import "CardGame_extension.h"

@implementation SetCardGame

-(int) numCardsToMatch
{
    return 3;
}

#define MISMATCH_PENALTY (-6)
#define MATCH_BONUS (12)

-(void) doThisActionOnFlippedCard:(Card *)cardJustFlipped
{
    [super doThisActionOnFlippedCard:cardJustFlipped];
    
    if([cardJustFlipped isKindOfClass:[SetCard class]])
    {
        SetCard *setCard = (SetCard *)cardJustFlipped;

        // TODO: this seems a little hackish...can I get rid of it?
        // flag in place so that matched Set cards are counted correctly as 'faceUp'
        Boolean noAction = true;
        
        if(self.numPlayableFaceUpCards == 2)
        {
            // trigger for update below
            noAction = false;
            
            NSMutableArray * selectedCards = [[NSMutableArray alloc] init];
            
            for(Card *thisCard in self.cards)
            {
                if(thisCard.isFaceUp && !thisCard.isUnplayable && ![setCard isEqual:thisCard])
                {
                    [selectedCards addObject:thisCard];
                }
            }
            
            int matchScore = (MATCH_BONUS*[setCard matchCards:selectedCards]);
            NSString * action = [[NSString alloc] init];
            
            if(matchScore > 0)
            {
                action = [NSString stringWithFormat:@"Matched: %@", setCard.contents];
                setCard.faceUp = setCard.unplayable = YES;
                
                for(Card *c in selectedCards)
                {
                    c.faceUp = c.unplayable = YES;
                    action = [action stringByAppendingFormat:@" %@", c.contents];
                }
                
                action = [action stringByAppendingFormat:@" :%d pts!", matchScore];
            }
            else
            {
                matchScore = MISMATCH_PENALTY;
                action = [NSString stringWithFormat:@"No Match For: %@", setCard.contents];
                
                for(Card *c in selectedCards)
                {
                    c.faceUp = c.unplayable = NO;
                    action = [action stringByAppendingFormat:@" %@", c.contents];
                }
            }
            
            self.score += matchScore;
            [self recordGameAction:action];
            [selectedCards removeAllObjects];
        }
        
        if(!noAction) {
                setCard.faceUp = !setCard.isFaceUp;
        }
    }
}

@end
