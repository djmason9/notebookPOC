//
//  Etext2CustomEditUIButton.m
//  NotebookPOC
//
//  Created by Mason, Darren J on 10/28/15.
//  Copyright (c) 2015 Mason, Darren J. All rights reserved.
//

#import "Etext2CustomEditUIButton.h"
#import "Etext2NoteBookTableViewCell.h"

@implementation Etext2CustomEditUIButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        _userInfo = [NSMutableDictionary new];
        _userInfo[BUTTON_SELECTED]= @(NO); //default
        
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
#pragma mark - actions
- (void)buttonAction:(id)sender {
    
    Etext2NoteBookTableViewCell *cell = (Etext2NoteBookTableViewCell*)self.superview.superview.superview.superview.superview;
    
    //toggle button on or off to enable or disable style
    BOOL on = [_userInfo[BUTTON_SELECTED] boolValue];
    
    if(!on){ //set on
        [self setUpButtonSelectedStyle];
    }else{ //set off
        [self setUpButtonUnSelectedStyle];
    }
    

    [cell buttonAction:self];
}

#pragma mark - buttonStates

/**
 *  Sets the background for an OFF state of a button
 *
 *  @param currentButton
 */
-(void)setUpButtonUnSelectedStyle{
    
    _userInfo[BUTTON_SELECTED] = @(NO);
    
    // Create the colors
    UIColor *topColor = [UIColor colorWithRed:0.992 green:0.992 blue:0.992 alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:0.882 green:0.882 blue:0.882 alpha:1];
    
    [self doGradientWithTopcolor:topColor andBottomColor:bottomColor];
}

/**
 *  Sets the background of an ON State of a button
 *
 *  @param currentButton
 */
-(void)setUpButtonSelectedStyle{
    
    _userInfo[BUTTON_SELECTED] = @(YES);
    
    // Create the colors
    UIColor *bottomColor = [UIColor colorWithRed:0.992 green:0.992 blue:0.992 alpha:1];
    UIColor *topColor = [UIColor colorWithRed:0.882 green:0.882 blue:0.882 alpha:1];
    
    [self doGradientWithTopcolor:topColor andBottomColor:bottomColor];
}

-(void)doGradientWithTopcolor:(UIColor*)topColor andBottomColor:(UIColor*)bottomColor {
    
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.bounds;
    
    //Add gradient to view
    [self.layer replaceSublayer:self.layer.sublayers[0] with:theViewGradient];
    
}


@end
