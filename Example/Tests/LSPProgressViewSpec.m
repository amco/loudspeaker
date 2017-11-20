//
//  LSPProgressViewSpec.m
//  Tests
//
//  Created by Adam Yanalunas on 11/20/17.
//  Copyright © 2017 Adam Yanalunas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <loudspeaker/loudspeaker.h>
#import <OCMock/OCMock.h>


SpecBegin(LSPProgressView)


describe(@"initForAutoLayout", ^{
    __block LSPProgressView *view;
    __block OCMockObject *viewMock;
    
    beforeEach(^{
        view = [LSPProgressView.alloc initForAutoLayout];
        viewMock = OCMPartialMock(view);
    });
    
    afterEach(^{
        [viewMock stopMocking];
    });
    
    it(@"sets view to disable autoresize mask", ^{
        expect(view.translatesAutoresizingMaskIntoConstraints).to.beFalsy();
    });
    
    it(@"sets up the view", ^{
        [[viewMock expect] setup];
    });
});

describe(@"newAutoLayoutView", ^{
    __block LSPProgressView *view;
    __block OCMockObject *viewMock;
    
    beforeEach(^{
        view = LSPProgressView.newAutoLayoutView;
        viewMock = OCMPartialMock(view);
    });
    
    afterEach(^{
        [viewMock stopMocking];
    });
    
    it(@"sets view to disable autoresize mask", ^{
        expect(view.translatesAutoresizingMaskIntoConstraints).to.beFalsy();
    });
    
    it(@"sets up the view", ^{
        [[viewMock expect] setup];
    });
});

describe(@"setup", ^{
    __block LSPProgressView *view;
    
    beforeEach(^{
        view = LSPProgressView.newAutoLayoutView;
        [view setup];
    });
    
    it(@"sets up subviews", ^{
        expect(view.progressBackground.superview).to.beIdenticalTo(view);
        expect(view.progressBar.superview).to.beIdenticalTo(view);
    });
    
    it(@"provides default background colors", ^{
        UIColor *backgroundColor = [UIColor colorWithWhite:207/255. alpha:1];
        UIColor *foregroundColor = [UIColor colorWithRed:88/255. green:199/255. blue:226/255. alpha:1];
        
        expect(view.progressBackground.backgroundColor).to.equal(backgroundColor);
        expect(view.progressBar.backgroundColor).to.equal(foregroundColor);
    });
});

describe(@"setProgress:", ^{
    __block LSPProgressView *view;
    
    beforeEach(^{
        UIView *parent = [UIView.alloc initWithFrame:CGRectMake(0, 0, 400, 50)];
        view = LSPProgressView.newAutoLayoutView;
        [parent addSubview:view];
        
        NSDictionary *viewBindings = NSDictionaryOfVariableBindings(view);
        [parent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:viewBindings]];
        [parent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:viewBindings]];
        
        [view layoutIfNeeded];
        
        [view setProgress:.5];
    });
    
    it(@"moves the progress bar to the new progress amount", ^{
        CGFloat width = CGRectGetWidth(view.progressBar.frame);
        expect(width).to.equal(200);
    });
    
    it(@"updates the progress bar's accessiblity label", ^{
        expect(view.progressBar.accessibilityLabel).to.equal(@"50%");
    });
});

describe(@"progressBar", ^{
    __block LSPProgressView *view;
    
    beforeEach(^{
        view = LSPProgressView.newAutoLayoutView;
    });
    
    it(@"is configured to tell iOS its accessibility information updates frequently", ^{
        BOOL hasTraits = (view.progressBar.accessibilityTraits & UIAccessibilityTraitUpdatesFrequently) != 0;
        expect(hasTraits).to.beTruthy();
    });
});


SpecEnd

//@interface LSPProgressViewSpecHelper : NSObject
//
//- (void)assertSetup;
//
//@end
//
//@implementation LSPProgressViewSpecHelper
//
//- (void)assertSetup
//{
//    __block LSPProgressView *view;
//    __block OCMockObject *viewMock;
//
//    beforeEach(^{
//        view = [LSPProgressView.alloc initForAutoLayout];
//        viewMock = OCMPartialMock(view);
//    });
//
//    afterEach(^{
//        [viewMock stopMocking];
//    });
//
//    it(@"sets view to disable autoresize mask", ^{
//        expect(view.translatesAutoresizingMaskIntoConstraints).to.beFalsy();
//    });
//
//    it(@"sets up the view", ^{
//
//    });
//}
//
//@end

