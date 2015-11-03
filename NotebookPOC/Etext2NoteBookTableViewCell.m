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
#import "Etext2CustomEditUIButton.h"
#import "Etext2CustomUITextView.h"





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
- (void)buttonAction:(Etext2CustomEditUIButton*)selectedButton {

    
    
    UIView *parentView = selectedButton.superview.superview;
    Etext2CustomUITextView *textView = (Etext2CustomUITextView*)[parentView viewWithTag:TEXT_BOX];
//    UITextRange *selectedRange = [textView selectedTextRange];
    
//    NSString *selectedText = [textView textInRange:selectedRange];
    NSAttributedString *allText = textView.attributedText;
    
    NSRange textRange = textView.selectedRange;
   
    
    switch (selectedButton.tag) {
//        case BULLET:
//        {
//            NSLog(@"BULLET ACTION SENT! %@",selectedText);
//
//            break;
//        }
//        case NUMBER_BULLET:
//        {
//            NSLog(@"NUMBER BULLET ACTION SENT! %@",selectedText);
//
//            break;
//        }
        case UNDO:
        {
            NSLog(@"UNDO ACTION SENT!");
            [self.cellDelegate doUndo:self];
            break;
        }
        case REDO:
        {
            NSLog(@"REDO ACTION SENT!");
            [self.cellDelegate doRedo:self];
            break;
        }
        default:{ //all font attribute changes B,I,U
            [self doStringAttribution:textRange fromAllText:allText withHandler:^(NSMutableAttributedString * formattedText) {
                [self.cellDelegate attributeButtonPressed];
                textView.attributedText = formattedText;
                [self.cellDelegate resetSelectedText:self];
            }];
        
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

    // BUTTONS
    UIButton *done = ((UIButton*)[self viewWithTag:DONE]);
    done.layer.backgroundColor = [UIColor blackColor].CGColor;

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
    
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)TOP_COLOR.CGColor, (id)BOTTOM_COLOR.CGColor, nil];
    theViewGradient.frame = currentView.bounds;
    
    //Add gradient to view
    [currentView.layer insertSublayer:theViewGradient atIndex:0];
    
}

-(void)doStringAttribution:(NSRange)selectedRange fromAllText:(NSAttributedString*)allString withHandler:(void (^)(NSMutableAttributedString*))handler{

    //are the other buttons on or off
    BOOL boldOn = [((Etext2CustomEditUIButton*)[self viewWithTag:BOLD]).userInfo[BUTTON_SELECTED] boolValue];
    BOOL italicOn =[((Etext2CustomEditUIButton*)[self viewWithTag:ITALIC]).userInfo[BUTTON_SELECTED] boolValue];
    BOOL underlineOn =[((Etext2CustomEditUIButton*)[self viewWithTag:UNDERLINE]).userInfo[BUTTON_SELECTED] boolValue];
    
    BOOL bulletOn = [((Etext2CustomEditUIButton*)[self viewWithTag:BULLET]).userInfo[BUTTON_SELECTED] boolValue];
    BOOL orderedBulletOn = [((Etext2CustomEditUIButton*)[self viewWithTag:NUMBER_BULLET]).userInfo[BUTTON_SELECTED] boolValue];
    
    if(selectedRange.length>0) {
        [allString enumerateAttributesInRange:selectedRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            
            //font types
            UIFont *attributeBoldFont = [UIFont fontWithName:APPLICATION_BOLD_FONT size:STANDARD_FONT_SIZE];
            UIFont *attributeNormalFont = [UIFont fontWithName:APPLICATION_STANDARD_FONT size:STANDARD_FONT_SIZE];
            UIFont *attributeObliqueFont = [UIFont fontWithName:APPLICATION_STANDARD_ITALIC_FONT size:STANDARD_FONT_SIZE];
            UIFont *attributeBoldObliqueFont = [UIFont fontWithName:APPLICATION_BOLD_ITALIC_FONT size:STANDARD_FONT_SIZE];
            
            NSMutableArray *attributeTypes = [NSMutableArray new];
            
            for (id attributeType in attrs) {
                //check for any underlines
                if(underlineOn){
                        [attributeTypes addObject:@(Underline)];
                }
                //check for existing formatting.
                if([attributeType isEqualToString:@"NSFont"]){
                    
                    if(italicOn) {
                        [attributeTypes addObject:@(Italic)];
                    }else if (boldOn) {
                        [attributeTypes addObject:@(Bold)];
                    }
                    
                    if (italicOn && boldOn) {
                        [attributeTypes addObject:@(BoldOblique)];
                    }
                }
            }
        

            NSMutableAttributedString *formattedString = [allString mutableCopy];

            
            NSString* substringForMatch = [[allString string] substringWithRange:selectedRange];
            NSMutableAttributedString *formattedSubString = [[NSMutableAttributedString alloc] initWithString:substringForMatch];
            
            //remove \u25E6 from string
            if([substringForMatch rangeOfString:@"\u25E6"].location != NSNotFound){
                substringForMatch = [substringForMatch stringByReplacingOccurrencesOfString:@"\u25E6\t" withString:@""];
                formattedSubString = [[NSMutableAttributedString alloc] initWithString:substringForMatch];
                
            }else if([substringForMatch rangeOfString:@".\t"].location != NSNotFound){ //removes numbers and tabs

                while ((range = [[formattedSubString mutableString] rangeOfString:@"[0-9]+.+\t" options:NSRegularExpressionSearch]).location != NSNotFound)
                {
                    [[formattedSubString mutableString] replaceCharactersInRange:range withString:@""];
                }
                
            }
         
            if(bulletOn || orderedBulletOn){
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setParagraphSpacing:3];
                paragraphStyle.headIndent = STANDARD_FONT_SIZE *2;
                paragraphStyle.firstLineHeadIndent = STANDARD_FONT_SIZE;
            
                
                NSTextTab *listTab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentNatural
                                                                     location:STANDARD_FONT_SIZE * 2
                                                                      options:nil];
                paragraphStyle.tabStops = @[listTab];
                
                if (bulletOn){
                    BOOL breaksFound = NO;
                    //if the string has \n in it use those to add bullets to first pos \u25E6\t and \n\u25E6\t
                    while ((range = [[formattedSubString mutableString] rangeOfString:@"\n" options:NSRegularExpressionSearch]).location != NSNotFound)
                    {
                        breaksFound= YES;
                        [[formattedSubString mutableString] replaceCharactersInRange:range withString:@"\u25E6"];
                    }
                    
                    //add a bullet at first pos if the \n were in the string
                    if(breaksFound){
                        
                        substringForMatch = [NSString stringWithFormat:@"\u25E6%@",[formattedSubString string]];
                        formattedSubString = [[NSMutableAttributedString alloc] initWithString:substringForMatch];
                        //now fix all the spacing issues with the tabs
                        NSString *holdingString=@"";
                        NSInteger count =0;
                        for(NSString *str  in [[formattedSubString string] componentsSeparatedByString:@"\u25E6"]){
                           
                            if(![str isEqualToString:@""] && count >0){ //no blanks and not the first
                                holdingString = [holdingString stringByAppendingString:[NSString stringWithFormat:@"\n\u25E6\t%@",str]];
                                
                            }else if(![str isEqualToString:@""] && count == 0){ //first line dont want a return
                                holdingString = [holdingString stringByAppendingString:[NSString stringWithFormat:@"\u25E6\t%@",str]];
                                count++;
                            }
                        }
                        
                        formattedSubString = [[NSMutableAttributedString alloc] initWithString:holdingString];
                        
                    }
                    //only do this if its a clean string no \n or\t or \u25E6 in the string
                    else if([substringForMatch rangeOfString:@"\n"].location == NSNotFound){ //no returns found
                        substringForMatch = [NSString stringWithFormat:@"\u25E6\t%@",substringForMatch];
                        formattedSubString = [[NSMutableAttributedString alloc] initWithString:substringForMatch];
                    }
                
                }
                else{
                    substringForMatch = [NSString stringWithFormat:@"1.\t%@",substringForMatch];
                }
                
//                formattedSubString = [[NSMutableAttributedString alloc] initWithString:substringForMatch];
                
                [formattedSubString addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0,substringForMatch.length)];
            }
            
            [formattedSubString addAttribute:NSFontAttributeName value:attributeNormalFont range:NSMakeRange(0,formattedSubString.length)];
            
            if([attributeTypes containsObject:@(Bold)]){//if bold
                    [formattedSubString addAttribute:NSFontAttributeName value:attributeBoldFont range:NSMakeRange(0,substringForMatch.length)];
            }
            
            if([attributeTypes containsObject:@(Italic)]){ //oblique
                [formattedSubString addAttribute:NSFontAttributeName value:attributeObliqueFont range:NSMakeRange(0,substringForMatch.length)];
            }
            
            if([attributeTypes containsObject:@(BoldOblique)] || ([attributeTypes containsObject:@(Bold)] && [attributeTypes containsObject:@(Italic)])){ //bold oblique
                [formattedSubString addAttribute:NSFontAttributeName value:attributeBoldObliqueFont range:NSMakeRange(0,substringForMatch.length)];
            }
            
            if([attributeTypes containsObject:@(Underline)]){//underline
                [formattedSubString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0,substringForMatch.length)];
            }
            
            
            
            [formattedString replaceCharactersInRange:selectedRange withAttributedString:formattedSubString];
            
            handler(formattedString);
            
        }];
        
    }else{
        
        //we are typing
        NSString *fontName;
        UIFont *newFont = [UIFont fontWithName:fontName size:STANDARD_FONT_SIZE];
        Etext2CustomUITextView *textView = (Etext2CustomUITextView*)[self viewWithTag:TEXT_BOX];
        
        
        if(boldOn)
            fontName= APPLICATION_BOLD_FONT;
        if(italicOn)
            fontName = APPLICATION_STANDARD_ITALIC_FONT;
        if(boldOn && italicOn)
            fontName = APPLICATION_BOLD_ITALIC_FONT;
        
        if(bulletOn){
            NSLog(@"%@",allString);

        }
       
        [textView applyAttributeToTypingAttribute:newFont forKey:NSFontAttributeName];
        
        
        if(underlineOn)
            [textView applyAttributeToTypingAttribute:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
        
    }

}

@end
