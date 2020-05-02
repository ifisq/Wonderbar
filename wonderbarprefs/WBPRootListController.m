#include "WBPRootListController.h"
#import <Preferences/PSEditableTableCell.h>

@implementation WBPRootListController

// Initialize Preferences with Cephei
- (void)viewDidLoad {
	[super viewDidLoad];

	HBAppearanceSettings *appearance = [[HBAppearanceSettings alloc] init];
	appearance.tintColor = [UIColor colorWithRed:.678 green:.847 blue:.902 alpha:1];
	self.hb_appearanceSettings = appearance;
	self.title = @"Wonderbar";
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

// This is used to remove the keyboard when the user clicks on 'Save' in preferences.
- (void)applySettings {
	[self.view endEditing:YES];
}

// When the user selects the respring option, this method is called to respring the device & return to the tweak preferences screen.
- (void)respring {
	[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Wonderbar"]];
}

@end
