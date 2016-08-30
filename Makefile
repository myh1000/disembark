ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = disembark
disembark_FILES = Tweak.xm
disembark_FRAMEWORKS = UIKit CoreTelephony

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
