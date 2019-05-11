ARCHS = armv7 arm64 arm64e
export TARGET = iphone:clang:11.2:7.0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ExactTime
ExactTime_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += exacttimeprefs
include $(THEOS)/makefiles/aggregate.mk
