TARGET := iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk
TWEAK_NAME = AdSpeedUp

AdSpeedUp_FILES = Tweak.xm
AdSpeedUp_CFLAGS = -fobjc-arc
AdSpeedUp_FRAMEWORKS = UIKit Foundation AVFoundation WebKit

include $(THEOS)/makefiles/tweak.mk
