//
//  SetCard.m
//  Matchismo
//
//  Created by Mario Russo on 2/13/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (NSString *)contents
{
    return [NSString stringWithFormat: @"%@ %@ : %d x %@", self.fillPattern, self.color, self.rank, self.shape];
}

+ (NSArray *)validRanks
{
    return @[@1, @2, @3];
}

+ (NSArray *)validColors
{
    return @[@"Red", @"Blue", @"Purple"];
}

+ (NSArray *)validFillPatterns
{
    return @[@"Empty", @"Partial", @"Solid"];
}

+ (NSArray *)validShapes
{
    return @[@"Circle", @"Square", @"Triangle"];
}

+ (NSUInteger)maxRank { return [self validRanks].count; }

- (int)matchCards:(NSArray *)cardsToCompare
{
    int score = 0;
    if( [cardsToCompare count] == 2)
    {
        SetCard *cardComp1 = cardsToCompare[0];
        SetCard *cardComp2 = cardsToCompare[1];
     
        if(cardComp1 && cardComp2)
        {
            Boolean ranksAreEqual = (self.rank == cardComp1.rank == cardComp2.rank);
            Boolean ranksAreNotEqual = (self.rank != cardComp1.rank != cardComp2.rank);
            
            Boolean shapesAreEqual = [self isString1:[self shape] EqualToString2:[cardComp1 shape] EqualToString3:[cardComp2 shape]];
            Boolean shapesAreNotEqual = [self isString1:[self shape] NotEqualToString2:[cardComp1 shape] NotEqualToString3:[cardComp2 shape]];
            
            Boolean colorsAreEqual = [self isString1:[self color] EqualToString2:[cardComp1 color] EqualToString3:[cardComp2 color]];
            Boolean colorsAreNotEqual = [self isString1:[self color] NotEqualToString2:[cardComp1 color] NotEqualToString3:[cardComp2 color]];
            
            Boolean fillPatternsAreEqual = [self isString1:[self fillPattern] EqualToString2:[cardComp1 fillPattern] EqualToString3:[cardComp2 fillPattern]];
            Boolean fillPatternsAreNotEqual = [self isString1:[self fillPattern] NotEqualToString2:[cardComp1 fillPattern] NotEqualToString3:[cardComp2 fillPattern]];
            
            if(ranksAreEqual || ranksAreNotEqual)
            {
               if(shapesAreEqual || shapesAreNotEqual)
               {
                   if(colorsAreEqual || colorsAreNotEqual)
                   {
                       if(fillPatternsAreEqual || fillPatternsAreNotEqual)
                       {
                           score = 1;
                       }
                   }
               }
           }
        }
    }
    
    return score;
}

- (Boolean)isString1:(NSString *)str1 EqualToString2:(NSString *)str2 EqualToString3:(NSString *)str3
{
    return ([str1 isEqualToString:str2] && [str2 isEqualToString:str3]);
}

- (Boolean)isString1:(NSString *)str1 NotEqualToString2:(NSString *)str2 NotEqualToString3:(NSString *)str3
{
    return (![str1 isEqualToString:str2] && ![str2 isEqualToString:str3]);
}

@end
