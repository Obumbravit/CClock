export THEOS = /opt/theos
export TARGET = iphone:clang:11.2:11.0
export ARCHS = arm64 arm64e
THEOS_DEVICE_IP = 10.0.0.26

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CClock
CClock_BUNDLE_EXTENSION = bundle
CClock_CFLAGS = -fobjc-arc
CClock_FILES = CClock.m CClockViewController.xm
CClock_EXTRA_FRAMEWORKS = CydiaSubstrate
CClock_PRIVATE_FRAMEWORKS = ControlCenterUIKit
CClock_INSTALL_PATH = /Library/ControlCenter/Bundles/

include $(THEOS_MAKE_PATH)/bundle.mk
SUBPROJECTS += cclockp
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
