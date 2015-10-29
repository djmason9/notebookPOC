//
//  Etext2CustomEditUIButton.h
//  NotebookPOC
//
//  Created by Mason, Darren J on 10/28/15.
//  Copyright (c) 2015 Mason, Darren J. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BUTTON_SELECTED @"isSelected"
//buttons
#define BOLD 1
#define ITALIC 2
#define UNDERLINE 3
#define BULLET 4
#define NUMBER_BULLET 5
#define UNDO 6
#define REDO 7

#define DONE 11
#define EDIT_BOX 10
#define EDIT_BOX_INNER 200
#define WORD_COUNT 12
#define NOTE_TEXT 100
#define NOTE_PROMPT 101
#define BUTTON_BASE 99
#define TEXT_BOX 89
#define DATE 300

@interface Etext2CustomEditUIButton : UIButton

@property (nonatomic,strong) NSMutableDictionary *userInfo;

-(void)setUpButtonUnSelectedStyle;
-(void)setUpButtonSelectedStyle;

@end
