ARCHS = armv7 arm64 arm64e
export TARGET = iphone:clang:11.2:7.0
include $(THEOS)/makefiles/common.mk

DEBUG=0 

TWEAK_NAME = ExactTime ExactTimeMail ExactTimePhone ExactTimeMessages
ExactTime_FILES = ExactTime.xm

ExactTimeMail_FILES = ExactTimeMail.x

ExactTimePhone_FILES = ExactTimePhone.x

ExactTimeMessages_FILES = ExactTimeMessages.xm


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += exacttimeprefs
include $(THEOS)/makefiles/aggregate.mk
