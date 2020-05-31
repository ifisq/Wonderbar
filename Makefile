TARGET = iphone:13.2

INSTALL_TARGET_PROCESSES = SpringBoard
Test_CFLAGS+=“-DTHEOS_LEAN_AND_MEAN

include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e

TWEAK_NAME = wonderbar

wonderbar_FILES = Tweak.x
wonderbar_FRAMEWORKS = UIKit
wonderbar_PRIVATE_FRAMEWORKS = Preferences UIKitCore
wonderbar_EXTRA_FRAMEWORKS += Cephei
wonderbar_LIBRARIES = colorpicker
wonderbar_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += wonderbarprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
