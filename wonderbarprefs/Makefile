ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2:13.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = wonderbarprefs

wonderbarprefs_FILES = WBPRootListController.m
wonderbarprefs_INSTALL_PATH = /Library/PreferenceBundles
wonderbarprefs_FRAMEWORKS = UIKit
wonderbarprefs_PRIVATE_FRAMEWORKS = Preferences
wonderbarprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
wonderbarprefs_LIBRARIES = colorpicker
wonderbarprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/wonderbarprefs.plist$(ECHO_END)