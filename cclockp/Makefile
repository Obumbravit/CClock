include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = cclockp
cclockp_FILES = CkPRootListController.m CCColorfulHeaderCell.m
cclockp_FRAMEWORKS = UIKit
cclockp_PRIVATE_FRAMEWORKS = Preferences
cclockp_INSTALL_PATH = /Library/PreferenceBundles
cclockp_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/cclockp.plist$(ECHO_END)
