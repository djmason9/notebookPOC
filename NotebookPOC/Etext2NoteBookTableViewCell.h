//
//  Etext2NoteBookTableViewCell.h
//  NotebookPOC
//
//  Created by Mason, Darren J on 10/23/15.
//  Copyright (c) 2015 Mason, Darren J. All rights reserved.
//

#import <UIKit/UIKit.h>
//delete all these fonts
#define APPLICATION_STANDARD_FONT @"Avenir-Roman"
#define APPLICATION_BOLD_FONT @"Avenir-Heavy"
#define APPLICATION_STANDARD_ITALIC_FONT @"Avenir-Oblique"
#define APPLICATION_BOLD_ITALIC_FONT @"Avenir-HeavyOblique"

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

@protocol Etext2NoteBookCellDelegate <NSObject>

@required
- (void)doDoneEditing:(UITableViewCell *)cell;

@end

@interface Etext2NoteBookTableViewCell : UITableViewCell
    @property(nonatomic,weak) id <Etext2NoteBookCellDelegate> cellDelegate;
    @property(nonatomic,weak) NSString *selectedText;

@end
