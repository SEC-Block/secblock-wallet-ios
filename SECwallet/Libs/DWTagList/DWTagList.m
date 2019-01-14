//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS Size(12.0f)
#define LABEL_MARGIN_DEFAULT Size(8.0f)
#define BOTTOM_MARGIN_DEFAULT Size(8.0f)
#define FONT_SIZE_DEFAULT Size(9)
#define HORIZONTAL_PADDING_DEFAULT Size(8.0f)
#define VERTICAL_PADDING_DEFAULT Size(5.0f)
#define TEXT_SHADOW_COLOR [UIColor clearColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor]
#define BORDER_WIDTH 0.0f
#define DEFAULT_AUTOMATIC_RESIZE NO
#define DEFAULT_SHOW_TAG_MENU NO

@interface DWTagList () <DWTagViewDelegate>
{
    NSArray *selectTextArray;
}

@end

@implementation DWTagList

@synthesize view, textArray, automaticResize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:view];
        [self setClipsToBounds:YES];
        self.automaticResize = DEFAULT_AUTOMATIC_RESIZE;
        self.highlightedBackgroundColor = COLOR(3, 117, 226, 1);
        self.font = [UIFont systemFontOfSize:FONT_SIZE_DEFAULT];
        self.labelMargin = LABEL_MARGIN_DEFAULT;
        self.bottomMargin = BOTTOM_MARGIN_DEFAULT;
        self.horizontalPadding = HORIZONTAL_PADDING_DEFAULT;
        self.verticalPadding = VERTICAL_PADDING_DEFAULT;
        self.cornerRadius = CORNER_RADIUS;
        self.borderColor = BORDER_COLOR;
        self.borderWidth = BORDER_WIDTH;
        self.textColor = [UIColor whiteColor];
        self.textShadowColor = TEXT_SHADOW_COLOR;
        self.textShadowOffset = TEXT_SHADOW_OFFSET;
        self.showTagMenu = DEFAULT_SHOW_TAG_MENU;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:view];
        [self setClipsToBounds:YES];
        self.highlightedBackgroundColor = COLOR(3, 117, 226, 1);
        self.font = [UIFont systemFontOfSize:FONT_SIZE_DEFAULT];
        self.labelMargin = LABEL_MARGIN_DEFAULT;
        self.bottomMargin = BOTTOM_MARGIN_DEFAULT;
        self.horizontalPadding = HORIZONTAL_PADDING_DEFAULT;
        self.verticalPadding = VERTICAL_PADDING_DEFAULT;
        self.cornerRadius = CORNER_RADIUS;
        self.borderColor = BORDER_COLOR;
        self.borderWidth = BORDER_WIDTH;
        self.textColor = [UIColor whiteColor];
        self.textShadowColor = TEXT_SHADOW_COLOR;
        self.textShadowOffset = TEXT_SHADOW_OFFSET;
        self.showTagMenu = DEFAULT_SHOW_TAG_MENU;
    }
    return self;
}

- (void)setTags:(NSArray *)array andSelectTags:(NSArray *)selectArray
{
    textArray = [[NSArray alloc] initWithArray:array];
    selectTextArray = [[NSArray alloc] initWithArray:selectArray];
    sizeFit = CGSizeZero;
    if (automaticResize) {
        [self display];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeFit.width, sizeFit.height);
    }else {
        [self display];
    }
}

- (void)setTagBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    [self display];
}

- (void)setTagHighlightColor:(UIColor *)color
{
    self.highlightedBackgroundColor = color;
    [self display];
}

- (void)setViewOnly:(BOOL)viewOnly
{
    if (_viewOnly != viewOnly) {
        _viewOnly = viewOnly;
        [self display];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)display
{
    NSMutableArray *tagViews = [NSMutableArray array];
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[DWTagView class]]) {
            DWTagView *tagView = (DWTagView*)subview;
            for (UIGestureRecognizer *gesture in [subview gestureRecognizers]) {
                [subview removeGestureRecognizer:gesture];
            }
            
            [tagView.button removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
            [tagViews addObject:subview];
        }
        [subview removeFromSuperview];
    }
    
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    
    NSInteger tag = 0;
    for (id text in textArray) {
        DWTagView *tagView;
        if (tagViews.count > 0) {
            tagView = [tagViews lastObject];
            [tagViews removeLastObject];
        }
        else {
            tagView = [[DWTagView alloc] init];
        }
        
        [tagView updateWithString:text
                             font:self.font
               constrainedToWidth:self.frame.size.width - (self.horizontalPadding * 2)
                          padding:CGSizeMake(self.horizontalPadding, self.verticalPadding)
                     minimumWidth:self.minimumWidth
                      selectArray:selectTextArray
                           textArray:textArray
         ];

        if (gotPreviousFrame) {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + tagView.frame.size.width + self.labelMargin > self.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + tagView.frame.size.height + self.bottomMargin);
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + self.labelMargin, previousFrame.origin.y);
            }
            newRect.size = tagView.frame.size;
            [tagView setFrame:newRect];
        }
        
        previousFrame = tagView.frame;
        gotPreviousFrame = YES;
        
        //默认状态
        [tagView setBackgroundColor:lblBackgroundColor];
        [tagView setCornerRadius:_cornerRadius];
        [tagView setBorderColor:_borderColor.CGColor];
        [tagView setBorderWidth:_borderWidth];
        [tagView setTextColor:_textColor];
        
        //选中状态
        if (![textArray isEqualToArray:selectTextArray]) {
            for (NSString *selectStr in selectTextArray) {
                if ([selectStr isEqualToString:text]) {
                    [tagView setBackgroundColor:COLOR(56, 142, 218, 1)];
                    [tagView setCornerRadius:Size(12)];
                    [tagView setBorderWidth:Size(0)];
                    [tagView setBorderColor:COLOR(56, 142, 218, 1).CGColor];
                    [tagView setTextColor:WHITE_COLOR];
                }
            }
        }
        
        [tagView setTextShadowColor:self.textShadowColor];
        [tagView setTextShadowOffset:self.textShadowOffset];
        [tagView setTag:tag];
        [tagView setDelegate:self];
        tag++;
        
        [self addSubview:tagView];
        
        if (!_viewOnly) {
            [tagView.button addTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
            [tagView.button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [tagView.button addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
            [tagView.button addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
        }
    }
    
    sizeFit = CGSizeMake(self.frame.size.width, previousFrame.origin.y + previousFrame.size.height + self.bottomMargin + 1.0f);
    self.contentSize = sizeFit;
}

- (CGSize)fittedSize
{
    return sizeFit;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    [self setContentOffset: CGPointMake(0.0, self.contentSize.height - self.bounds.size.height + self.contentInset.bottom) animated: animated];
}

- (void)touchDownInside:(id)sender
{
    UIButton *button = (UIButton*)sender;
    DWTagView *tagView = (DWTagView *)[button superview];
    //选中状态
    if ([selectTextArray containsObject:tagView.label.text]) {
        [tagView setBackgroundColor:COLOR(56, 142, 218, 1)];
    }else{
        [tagView setBackgroundColor:self.highlightedBackgroundColor];
    }
}

- (void)touchUpInside:(id)sender
{
    UIButton *button = (UIButton*)sender;
    DWTagView *tagView = (DWTagView *)[button superview];
    //选中状态
    if ([selectTextArray containsObject:tagView.label.text]) {
        [tagView setBackgroundColor:COLOR(56, 142, 218, 1)];
    }else{
        [tagView setBackgroundColor:[self getBackgroundColor]];
    }

    if ([self.tagDelegate respondsToSelector:@selector(selectedDWTagList:tag:tagIndex:)]) {
        [self.tagDelegate selectedDWTagList:self tag:tagView.label.text tagIndex:tagView.tag];
    }
    
    if ([self.tagDelegate respondsToSelector:@selector(selectedTag:)]) {
        [self.tagDelegate selectedTag:tagView.label.text];
    }
    
    if (self.showTagMenu) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setTargetRect:tagView.frame inView:self];
        [menuController setMenuVisible:YES animated:YES];
        [tagView becomeFirstResponder];
    }
}

- (void)touchDragExit:(id)sender
{
    UIButton *button = (UIButton*)sender;
    DWTagView *tagView = (DWTagView *)[button superview];
    //选中状态
    if ([selectTextArray containsObject:tagView.label.text]) {
        [tagView setBackgroundColor:BACKGROUND_DARK_COLOR];
    }else{
        [tagView setBackgroundColor:[self getBackgroundColor]];
    }
}

- (void)touchDragInside:(id)sender
{
    UIButton *button = (UIButton*)sender;
    DWTagView *tagView = (DWTagView *)[button superview];
    //选中状态
    if ([selectTextArray containsObject:tagView.label.text]) {
        [tagView setBackgroundColor:BACKGROUND_DARK_COLOR];
    }else{
        [tagView setBackgroundColor:[self getBackgroundColor]];
    }
}

- (UIColor *)getBackgroundColor
{
    if (!lblBackgroundColor) {
        return COLOR(56, 142, 218, 1);
    } else {
        return lblBackgroundColor;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self display];
}

- (void)setBorderColor:(UIColor*)borderColor
{
    _borderColor = borderColor;
    [self display];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self display];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self display];
}

- (void)setTextShadowColor:(UIColor *)textShadowColor
{
    _textShadowColor = textShadowColor;
    [self display];
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset
{
    _textShadowOffset = textShadowOffset;
    [self display];
}

- (void)dealloc
{
    view = nil;
    textArray = nil;
    lblBackgroundColor = nil;
}

#pragma mark - DWTagViewDelegate
- (void)tagViewWantsToBeDeleted:(DWTagView *)tagView {
    NSMutableArray *mTextArray = [self.textArray mutableCopy];
    [mTextArray removeObject:tagView.label.text];
    [self setTags:mTextArray andSelectTags:@[]];
    
    if ([self.tagDelegate respondsToSelector:@selector(tagListTagsChanged:)]) {
        [self.tagDelegate tagListTagsChanged:self];
    }
}

@end


@implementation DWTagView

- (id)init
{
    self = [super init];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_label setTextColor:TEXT_GREEN_COLOR];
        [_label setShadowColor:TEXT_SHADOW_COLOR];
        [_label setShadowOffset:TEXT_SHADOW_OFFSET];
        [_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_label];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_button setFrame:self.frame];
        [self addSubview:_button];
    }
    return self;
}

- (void)updateWithString:(id)text font:(UIFont*)font constrainedToWidth:(CGFloat)maxWidth padding:(CGSize)padding minimumWidth:(CGFloat)minimumWidth selectArray:(NSArray *)selectArray textArray:(NSArray *)textArray
{
    CGSize textSize = CGSizeZero;
    BOOL isTextAttributedString = [text isKindOfClass:[NSAttributedString class]];
    
    if (isTextAttributedString) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text];
        [attributedString addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, ((NSAttributedString *)text).string.length)];
		NSString *str2 = attributedString.string;
		if (str2.length > 10) {
			str2 = [str2 substringToIndex:10];
		}
		textSize = [str2 sizeWithFont:font forWidth:maxWidth lineBreakMode:NSLineBreakByTruncatingTail];
		_label.attributedText = [attributedString copy];
    } else {
		NSString *str = text;
		if (str.length > 10) {
			str = [str substringToIndex:10];
		}
		textSize = [str sizeWithFont:font forWidth:maxWidth lineBreakMode:NSLineBreakByTruncatingTail];
		_label.text = text;
    }
    
    textSize.width = MAX(textSize.width+Size(15), minimumWidth+Size(15));
    textSize.height += padding.height*2 +Size(3);
    
    self.frame = CGRectMake(0, 0, textSize.width+padding.width*2, textSize.height);
    _label.frame = CGRectMake(padding.width, 0, MIN(textSize.width, self.frame.size.width), textSize.height);
	_label.font = font;
    [_button setAccessibilityLabel:self.label.text];
    
    if ([textArray isEqualToArray:selectArray]) {
        [_label setTextAlignment:NSTextAlignmentLeft];
        [_button setImage:[UIImage imageNamed:@"closeGray"] forState:UIControlStateNormal];
        [_button setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width-Size(20), 0, 0)];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }else{
        if ([selectArray containsObject:self.label.text]) {
            [_label setTextAlignment:NSTextAlignmentLeft];
            [_button setImage:[UIImage imageNamed:@"checkBlue"] forState:UIControlStateNormal];
            [_button setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width-Size(20), 0, 0)];
            _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }else{
            [_label setTextAlignment:NSTextAlignmentCenter];
            [_button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    [self.layer setCornerRadius:cornerRadius];
}

- (void)setBorderColor:(CGColorRef)borderColor
{
    [self.layer setBorderColor:borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    [self.layer setBorderWidth:borderWidth];
}

- (void)setLabelText:(NSString*)text
{
    [_label setText:text];
}

- (void)setTextColor:(UIColor *)textColor
{
    [_label setTextColor:textColor];
}

- (void)setTextShadowColor:(UIColor*)textShadowColor
{
    [_label setShadowColor:textShadowColor];
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset
{
    [_label setShadowOffset:textShadowOffset];
}

- (void)dealloc
{
    _label = nil;
    _button = nil;
}

#pragma mark - UIMenuController support

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:)) || (action == @selector(delete:));
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.label.text];
}

- (void)delete:(id)sender
{
    [self.delegate tagViewWantsToBeDeleted:self];
}

@end
