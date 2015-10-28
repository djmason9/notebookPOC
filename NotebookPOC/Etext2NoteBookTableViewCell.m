//
//  Etext2NoteBookTableViewCell.m
//  NotebookPOC
//
//  Created by Mason, Darren J on 10/23/15.
//  Copyright (c) 2015 Mason, Darren J. All rights reserved.
//

#import "Etext2NoteBookTableViewCell.h"
#import "Etext2WebClient.h"
#import "AFNetworking.h"
#import "Etext2Utility.h"
#import "Etext2NoteBookTableViewCell.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "Etext2CustomEditUIButton.h"



#define DISABLED_COLOR [UIColor colorWithRed:0.686 green:0.686 blue:0.686 alpha:1]
#define STANDARD_BUTTON_FONT [UIFont fontWithName:kFontAwesomeFamilyName size:14]

enum EditType{
    Bold,
    Italic,
    BoldOblique,
    Underline
};

@implementation Etext2NoteBookTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self hydrateCell];
    
    
}


#pragma mark - Actions
- (IBAction)buttonAction:(id)sender {
    
    Etext2CustomEditUIButton *selectedButton = (Etext2CustomEditUIButton*)sender;
    
    UIView *parentView = selectedButton.superview.superview;
    UITextView *textView = (UITextView*)[parentView viewWithTag:TEXT_BOX];
    UITextRange *selectedRange = [textView selectedTextRange];
    
    NSString *selectedText = [textView textInRange:selectedRange];
    NSAttributedString *allText = textView.attributedText;
    
    NSRange textRange = [[allText string] rangeOfString:selectedText];
    
    if (textRange.length <= 0) { //if nothing is selected do nothing
        return;
    }
    
    //toggle button on or off to enable or disable style
    
    BOOL isOn = [selectedButton.userInfo[BUTTON_SELECTED] boolValue];
    
    if(!isOn){ //on
        selectedButton.userInfo[BUTTON_SELECTED] = @(YES);
        [Etext2Utility setUpButtonSelectedStyle:selectedButton];
        isOn = YES;
        
    }else{ //off
        selectedButton.userInfo[BUTTON_SELECTED] = @(NO);
        [Etext2Utility setUpButtonUnSelectedStyle:selectedButton];
        isOn = NO;
    }

    

    switch (selectedButton.tag) {
        case BOLD:
        {
            NSLog(@"BOLD ACTION SENT! %@",selectedText);
            [self doStringAttribution:textRange fromAllText:allText formatType:Bold  pressedButton:selectedButton withHandler:^(NSMutableAttributedString * formattedText) {
                textView.attributedText = formattedText;
            }];
            break;
        }
        case ITALIC:
        {
            NSLog(@"ITALIC ACTION SENT! %@",selectedText);
            [self doStringAttribution:textRange fromAllText:allText formatType:Italic pressedButton:selectedButton  withHandler:^(NSMutableAttributedString * formattedText) {
                textView.attributedText = formattedText;
            }];;
            break;
        }
        case UNDERLINE:
        {
            NSLog(@"UNDERLINE ACTION SENT! %@",selectedText);
            [self doStringAttribution:textRange fromAllText:allText formatType:Underline pressedButton:selectedButton  withHandler:^(NSMutableAttributedString * formattedText) {
                textView.attributedText = formattedText;
            }];
            break;
        }
        case BULLET:
        {
            NSLog(@"BULLET ACTION SENT! %@",selectedText);

            break;
        }
        case NUMBER_BULLET:
        {
            NSLog(@"NUMBER BULLET ACTION SENT! %@",selectedText);

            break;
        }
        case UNDO:
        {
            NSLog(@"UNDO ACTION SENT! %@",selectedText);

            break;
        }
        case REDO:
        {
            NSLog(@"REDO ACTION SENT! %@",selectedText);

            break;
        }

    }

}

- (IBAction)doneEditingNote:(id)sender {
    
    [self.cellDelegate doDoneEditing:self];
}

#pragma mark - Private Methods

-(void)hydrateCell{
    ((UIView*)[self viewWithTag:EDIT_BOX]).hidden = YES;
    
    UIView *editBox =((UIView*)[self viewWithTag:EDIT_BOX_INNER]);
    editBox.layer.borderColor = [UIColor colorWithRed:0.682 green:0.682 blue:0.682 alpha:1].CGColor; /*#aeaeae*/
    editBox.layer.borderWidth = 1.0;
    
    UIView *buttonBase = ((UIView*)[self viewWithTag:BUTTON_BASE]);
    [self setViewGradient:buttonBase];
    
    UIButton *done = ((UIButton*)[self viewWithTag:DONE]);
    done.layer.backgroundColor = [UIColor blackColor].CGColor;
    
    UIButton *bold = ((UIButton*)[self viewWithTag:BOLD]);
    bold.titleLabel.font = STANDARD_BUTTON_FONT;
    [bold setTitle:[NSString fontAwesomeIconStringForEnum:FABold] forState:UIControlStateNormal];
    
    [self setUpButtonStyle:bold];
    
    UIButton *italic = ((UIButton*)[self viewWithTag:ITALIC]);
    italic.titleLabel.font = STANDARD_BUTTON_FONT;
    [italic setTitle:[NSString fontAwesomeIconStringForEnum:FAItalic] forState:UIControlStateNormal];
    
    [self setUpButtonStyle:italic];
    
    UIButton *underline = ((UIButton*)[self viewWithTag:UNDERLINE]);
    underline.titleLabel.font = STANDARD_BUTTON_FONT;
    [underline setTitle:[NSString fontAwesomeIconStringForEnum:FAUnderline] forState:UIControlStateNormal];
    
    [self setUpButtonStyle:underline];
    
    UIButton *bullet = ((UIButton*)[self viewWithTag:BULLET]);
    bullet.titleLabel.font = STANDARD_BUTTON_FONT;
    [bullet setTitle:[NSString fontAwesomeIconStringForEnum:FAList] forState:UIControlStateNormal];
    
    [self setUpButtonStyle:bullet];
    
    UIButton *orderedList = ((UIButton*)[self viewWithTag:NUMBER_BULLET]);
    orderedList.titleLabel.font = STANDARD_BUTTON_FONT;
    [orderedList setTitle:[NSString fontAwesomeIconStringForEnum:FAListOl] forState:UIControlStateNormal];
    
    [self setUpButtonStyle:orderedList];
    
    //disabled
    UIButton *undo = ((UIButton*)[self viewWithTag:UNDO]);
    undo.titleLabel.font = STANDARD_BUTTON_FONT;
    [undo setTitle:[NSString fontAwesomeIconStringForEnum:FAReply] forState:UIControlStateNormal];
    [undo setTitleColor:DISABLED_COLOR forState:UIControlStateNormal /*#afafaf*/];
    
    [self setUpButtonStyle:undo];
    
    UIButton *redo = ((UIButton*)[self viewWithTag:REDO]);
    redo.titleLabel.font = STANDARD_BUTTON_FONT;
    [redo setTitle:[NSString fontAwesomeIconStringForEnum:FAShare] forState:UIControlStateNormal];
    [redo setTitleColor:DISABLED_COLOR forState:UIControlStateNormal /*#afafaf*/];
    
    [self setUpButtonStyle:redo];
}

-(void)setUpButtonStyle:(UIButton*)currentButton{
    
    currentButton.layer.borderWidth = 0.5;
    currentButton.layer.cornerRadius = 4;
    currentButton.layer.borderColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1].CGColor;//[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1].CGColor;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:currentButton.bounds];
    currentButton.backgroundColor = [UIColor whiteColor];
    
    currentButton.layer.shadowColor = [UIColor colorWithRed:0.624 green:0.624 blue:0.624 alpha:1].CGColor;
    currentButton.layer.shadowOffset = CGSizeMake(0,1.5);
    currentButton.layer.shadowRadius = 0.8;
    currentButton.layer.shadowOpacity = 0.6f;
    currentButton.layer.shadowPath = shadowPath.CGPath;
    
    [self setViewGradient:currentButton];
    
}
/**
 *  sets the inital background gradients for UIView
 *
 *  @param currentView
 */
-(void)setViewGradient:(UIView*)currentView{
    
    // Create the colors
    UIColor *topColor = [UIColor colorWithRed:0.992 green:0.992 blue:0.992 alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:0.882 green:0.882 blue:0.882 alpha:1];
    
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = currentView.bounds;
    
    //Add gradient to view
    [currentView.layer insertSublayer:theViewGradient atIndex:0];
    
}



-(void)doStringAttribution:(NSRange)selectedRange fromAllText:(NSAttributedString*)allString formatType:(NSInteger)type pressedButton:(Etext2CustomEditUIButton*)pushedButton withHandler:(void (^)(NSMutableAttributedString*))handler{

    
    [allString enumerateAttributesInRange:selectedRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        //font types
        UIFont *attributeBoldFont = [UIFont fontWithName:APPLICATION_BOLD_FONT size:14];
        UIFont *attributeNormalFont = [UIFont fontWithName:APPLICATION_STANDARD_FONT size:14];
        UIFont *attributeObliqueFont = [UIFont fontWithName:APPLICATION_STANDARD_ITALIC_FONT size:14];
        UIFont *attributeBoldObliqueFont = [UIFont fontWithName:APPLICATION_BOLD_ITALIC_FONT size:14];
        
        NSMutableArray *attributeTypes = [NSMutableArray new];
        
        //is the button on or off
        
 
        [attributeTypes addObject:@(type)]; //coming type
        
        for (id attributeType in attrs) {
            //check for any underlines
            if([attributeType isEqualToString:@"NSUnderline"]){
                    [attributeTypes addObject:@(Underline)];
            }
            //check for existing formatting.
            if([attributeType isEqualToString:@"NSFont"]){
                
                if ([((UIFont*)attrs[attributeType]).fontName rangeOfString:@"HeavyOblique"].location != NSNotFound) {
                        [attributeTypes addObject:@(BoldOblique)];
                }else if ([((UIFont*)attrs[attributeType]).fontName rangeOfString:@"Oblique"].location != NSNotFound) {
                        [attributeTypes addObject:@(Italic)];
                }else if ([((UIFont*)attrs[attributeType]).fontName rangeOfString:@"Heavy"].location != NSNotFound) {
                        [attributeTypes addObject:@(Bold)];
                }
            }
        }

        NSMutableAttributedString *formattedString = [allString mutableCopy];
        
        NSString* substringForMatch = [[allString string] substringWithRange:selectedRange];
        NSMutableAttributedString *formattedSubString = [[NSMutableAttributedString alloc] initWithString:substringForMatch];
        
        
        if(([attributeTypes containsObject:@(Bold)] || [attributeTypes containsObject:@(BoldOblique)]) && [((Etext2CustomEditUIButton*)[pushedButton.superview viewWithTag:BOLD]).userInfo[BUTTON_SELECTED] boolValue]){//if bold
                [formattedSubString addAttribute:NSFontAttributeName value:attributeBoldFont range:NSMakeRange(0,substringForMatch.length)];
        }
        
        if([attributeTypes containsObject:@(Italic)] && [((Etext2CustomEditUIButton*)[pushedButton.superview viewWithTag:ITALIC]).userInfo[BUTTON_SELECTED] boolValue]){ //oblique
            [formattedSubString addAttribute:NSFontAttributeName value:attributeObliqueFont range:NSMakeRange(0,substringForMatch.length)];
        }
        
        if(([attributeTypes containsObject:@(BoldOblique)] &&
           ([attributeTypes containsObject:@(Italic)] && [attributeTypes containsObject:@(Bold)])) ||
           ([((Etext2CustomEditUIButton*)[pushedButton.superview viewWithTag:BOLD]).userInfo[BUTTON_SELECTED] boolValue] &&
           [((Etext2CustomEditUIButton*)[pushedButton.superview viewWithTag:ITALIC]).userInfo[BUTTON_SELECTED] boolValue])){ //bold oblique
            [formattedSubString addAttribute:NSFontAttributeName value:attributeBoldObliqueFont range:NSMakeRange(0,substringForMatch.length)];
        }
        
        if([attributeTypes containsObject:@(Underline)] && [((Etext2CustomEditUIButton*)[pushedButton.superview viewWithTag:UNDERLINE]).userInfo[BUTTON_SELECTED] boolValue]){//underline
            [formattedSubString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0,substringForMatch.length)];
        }
        
        [formattedString replaceCharactersInRange:selectedRange withAttributedString:formattedSubString];
        
        handler(formattedString);
        
    }];

}


@end
