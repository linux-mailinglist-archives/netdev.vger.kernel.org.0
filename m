Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1158C42EED
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfFLSio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:38:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45714 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbfFLSim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:38:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cVpdj9g3nfutWCkO4qap0oOXWR198VYaPZkxAl4x/vo=; b=k86d+c3dbWABBWg7wcoV51wuIS
        SGZOXoXLdPD+loPFKb8S8cnM72DyToMAlYM2f+W7lFjnayRkjwmuz4/j6fyAVIaOQ40Fp8RaQiO4g
        QiqbwzkjpLeB4QyK6nKHQQ1FS9UI+QcNPmQjaG+FigP13RcDbYCizA+Z67Ka1wQ0hioMQVnI6uyyg
        5IMwnVtVA1tboBLMJKLATG3C4Rt9B4j3j1tobDT5iN31Jgvxw+gwtg4pY2XToUTvOIt6mMA4KWDbd
        UlUkwAYsZ9HpaEQLtAHj9cxBP4jQ30c1fAw8py/HnhzO7Hzyei5l6hvtBfes5ePFfQmcn7pLBFf/9
        VtP+QPYg==;
Received: from 201.86.169.251.dynamic.adsl.gvt.net.br ([201.86.169.251] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hb88s-0006Ya-UV; Wed, 12 Jun 2019 18:38:40 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hb88q-0002Bg-CM; Wed, 12 Jun 2019 15:38:36 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-leds@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH v1 22/31] docs: leds: convert to ReST
Date:   Wed, 12 Jun 2019 15:38:25 -0300
Message-Id: <ccad10454866a6f3130f37c3027175c0f36aee0f.1560364494.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560364493.git.mchehab+samsung@kernel.org>
References: <cover.1560364493.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the leds documentation files to ReST, add an
index for them and adjust in order to produce a nice html
output via the Sphinx build system.

At its new index.rst, let's add a :orphan: while this is not linked to
the main index.rst file, in order to avoid build warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/laptops/thinkpad-acpi.txt       |   4 +-
 Documentation/leds/index.rst                  |  25 ++
 .../leds/{leds-blinkm.txt => leds-blinkm.rst} |  64 ++---
 ...s-class-flash.txt => leds-class-flash.rst} |  49 ++--
 .../leds/{leds-class.txt => leds-class.rst}   |  15 +-
 .../leds/{leds-lm3556.txt => leds-lm3556.rst} | 100 ++++++--
 .../leds/{leds-lp3944.txt => leds-lp3944.rst} |  23 +-
 Documentation/leds/leds-lp5521.rst            | 115 +++++++++
 Documentation/leds/leds-lp5521.txt            | 101 --------
 Documentation/leds/leds-lp5523.rst            | 147 ++++++++++++
 Documentation/leds/leds-lp5523.txt            | 130 ----------
 Documentation/leds/leds-lp5562.rst            | 137 +++++++++++
 Documentation/leds/leds-lp5562.txt            | 120 ----------
 Documentation/leds/leds-lp55xx.rst            | 224 ++++++++++++++++++
 Documentation/leds/leds-lp55xx.txt            | 194 ---------------
 Documentation/leds/leds-mlxcpld.rst           | 118 +++++++++
 Documentation/leds/leds-mlxcpld.txt           | 110 ---------
 ...edtrig-oneshot.txt => ledtrig-oneshot.rst} |  11 +-
 ...ig-transient.txt => ledtrig-transient.rst} |  63 +++--
 ...edtrig-usbport.txt => ledtrig-usbport.rst} |  11 +-
 Documentation/leds/{uleds.txt => uleds.rst}   |   5 +-
 MAINTAINERS                                   |   2 +-
 drivers/leds/trigger/Kconfig                  |   2 +-
 drivers/leds/trigger/ledtrig-transient.c      |   2 +-
 net/netfilter/Kconfig                         |   2 +-
 25 files changed, 996 insertions(+), 778 deletions(-)
 create mode 100644 Documentation/leds/index.rst
 rename Documentation/leds/{leds-blinkm.txt => leds-blinkm.rst} (57%)
 rename Documentation/leds/{leds-class-flash.txt => leds-class-flash.rst} (74%)
 rename Documentation/leds/{leds-class.txt => leds-class.rst} (92%)
 rename Documentation/leds/{leds-lm3556.txt => leds-lm3556.rst} (70%)
 rename Documentation/leds/{leds-lp3944.txt => leds-lp3944.rst} (78%)
 create mode 100644 Documentation/leds/leds-lp5521.rst
 delete mode 100644 Documentation/leds/leds-lp5521.txt
 create mode 100644 Documentation/leds/leds-lp5523.rst
 delete mode 100644 Documentation/leds/leds-lp5523.txt
 create mode 100644 Documentation/leds/leds-lp5562.rst
 delete mode 100644 Documentation/leds/leds-lp5562.txt
 create mode 100644 Documentation/leds/leds-lp55xx.rst
 delete mode 100644 Documentation/leds/leds-lp55xx.txt
 create mode 100644 Documentation/leds/leds-mlxcpld.rst
 delete mode 100644 Documentation/leds/leds-mlxcpld.txt
 rename Documentation/leds/{ledtrig-oneshot.txt => ledtrig-oneshot.rst} (90%)
 rename Documentation/leds/{ledtrig-transient.txt => ledtrig-transient.rst} (81%)
 rename Documentation/leds/{ledtrig-usbport.txt => ledtrig-usbport.rst} (86%)
 rename Documentation/leds/{uleds.txt => uleds.rst} (95%)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 6cced88de6da..75ef063622d2 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -679,7 +679,7 @@ status as "unknown". The available commands are:
 sysfs notes:
 
 The ThinkLight sysfs interface is documented by the LED class
-documentation, in Documentation/leds/leds-class.txt.  The ThinkLight LED name
+documentation, in Documentation/leds/leds-class.rst.  The ThinkLight LED name
 is "tpacpi::thinklight".
 
 Due to limitations in the sysfs LED class, if the status of the ThinkLight
@@ -779,7 +779,7 @@ All of the above can be turned on and off and can be made to blink.
 sysfs notes:
 
 The ThinkPad LED sysfs interface is described in detail by the LED class
-documentation, in Documentation/leds/leds-class.txt.
+documentation, in Documentation/leds/leds-class.rst.
 
 The LEDs are named (in LED ID order, from 0 to 12):
 "tpacpi::power", "tpacpi:orange:batt", "tpacpi:green:batt",
diff --git a/Documentation/leds/index.rst b/Documentation/leds/index.rst
new file mode 100644
index 000000000000..9885f7c1b75d
--- /dev/null
+++ b/Documentation/leds/index.rst
@@ -0,0 +1,25 @@
+:orphan:
+
+====
+LEDs
+====
+
+.. toctree::
+   :maxdepth: 1
+
+   leds-class
+   leds-class-flash
+   ledtrig-oneshot
+   ledtrig-transient
+   ledtrig-usbport
+
+   uleds
+
+   leds-blinkm
+   leds-lm3556
+   leds-lp3944
+   leds-lp5521
+   leds-lp5523
+   leds-lp5562
+   leds-lp55xx
+   leds-mlxcpld
diff --git a/Documentation/leds/leds-blinkm.txt b/Documentation/leds/leds-blinkm.rst
similarity index 57%
rename from Documentation/leds/leds-blinkm.txt
rename to Documentation/leds/leds-blinkm.rst
index 9dd92f4cf4e1..c74b5bc877b1 100644
--- a/Documentation/leds/leds-blinkm.txt
+++ b/Documentation/leds/leds-blinkm.rst
@@ -1,3 +1,7 @@
+==================
+Leds BlinkM driver
+==================
+
 The leds-blinkm driver supports the devices of the BlinkM family.
 
 They are RGB-LED modules driven by a (AT)tiny microcontroller and
@@ -14,35 +18,36 @@ The interface this driver provides is 2-fold:
 a) LED class interface for use with triggers
 ############################################
 
-The registration follows the scheme:
-blinkm-<i2c-bus-nr>-<i2c-device-nr>-<color>
+The registration follows the scheme::
 
-$ ls -h /sys/class/leds/blinkm-6-*
-/sys/class/leds/blinkm-6-9-blue:
-brightness  device  max_brightness  power  subsystem  trigger  uevent
+  blinkm-<i2c-bus-nr>-<i2c-device-nr>-<color>
 
-/sys/class/leds/blinkm-6-9-green:
-brightness  device  max_brightness  power  subsystem  trigger  uevent
+  $ ls -h /sys/class/leds/blinkm-6-*
+  /sys/class/leds/blinkm-6-9-blue:
+  brightness  device  max_brightness  power  subsystem  trigger  uevent
 
-/sys/class/leds/blinkm-6-9-red:
-brightness  device  max_brightness  power  subsystem  trigger  uevent
+  /sys/class/leds/blinkm-6-9-green:
+  brightness  device  max_brightness  power  subsystem  trigger  uevent
+
+  /sys/class/leds/blinkm-6-9-red:
+  brightness  device  max_brightness  power  subsystem  trigger  uevent
 
 (same is /sys/bus/i2c/devices/6-0009/leds)
 
 We can control the colors separated into red, green and blue and
 assign triggers on each color.
 
-E.g.:
+E.g.::
 
-$ cat blinkm-6-9-blue/brightness
-05
+  $ cat blinkm-6-9-blue/brightness
+  05
 
-$ echo 200 > blinkm-6-9-blue/brightness
-$
+  $ echo 200 > blinkm-6-9-blue/brightness
+  $
 
-$ modprobe ledtrig-heartbeat
-$ echo heartbeat > blinkm-6-9-green/trigger
-$
+  $ modprobe ledtrig-heartbeat
+  $ echo heartbeat > blinkm-6-9-green/trigger
+  $
 
 
 b) Sysfs group to control rgb, fade, hsb, scripts ...
@@ -52,29 +57,28 @@ This extended interface is available as folder blinkm
 in the sysfs folder of the I2C device.
 E.g. below /sys/bus/i2c/devices/6-0009/blinkm
 
-$ ls -h /sys/bus/i2c/devices/6-0009/blinkm/
-blue  green  red  test
+  $ ls -h /sys/bus/i2c/devices/6-0009/blinkm/
+  blue  green  red  test
 
 Currently supported is just setting red, green, blue
 and a test sequence.
 
-E.g.:
+E.g.::
 
-$ cat *
-00
-00
-00
-#Write into test to start test sequence!#
+  $ cat *
+  00
+  00
+  00
+  #Write into test to start test sequence!#
 
-$ echo 1 > test
-$
+  $ echo 1 > test
+  $
 
-$ echo 255 > red
-$
+  $ echo 255 > red
+  $
 
 
 
 as of 6/2012
 
 dl9pf <at> gmx <dot> de
-
diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.rst
similarity index 74%
rename from Documentation/leds/leds-class-flash.txt
rename to Documentation/leds/leds-class-flash.rst
index 8da3c6f4b60b..6ec12c5a1a0e 100644
--- a/Documentation/leds/leds-class-flash.txt
+++ b/Documentation/leds/leds-class-flash.rst
@@ -1,9 +1,9 @@
-
+==============================
 Flash LED handling under Linux
 ==============================
 
 Some LED devices provide two modes - torch and flash. In the LED subsystem
-those modes are supported by LED class (see Documentation/leds/leds-class.txt)
+those modes are supported by LED class (see Documentation/leds/leds-class.rst)
 and LED Flash class respectively. The torch mode related features are enabled
 by default and the flash ones only if a driver declares it by setting
 LED_DEV_CAP_FLASH flag.
@@ -14,6 +14,7 @@ registered in the LED subsystem with led_classdev_flash_register function.
 
 Following sysfs attributes are exposed for controlling flash LED devices:
 (see Documentation/ABI/testing/sysfs-class-led-flash)
+
 	- flash_brightness
 	- max_flash_brightness
 	- flash_timeout
@@ -31,30 +32,46 @@ be defined in the kernel config.
 
 The driver must call the v4l2_flash_init function to get registered in the
 V4L2 subsystem. The function takes six arguments:
-- dev       : flash device, e.g. an I2C device
-- of_node   : of_node of the LED, may be NULL if the same as device's
-- fled_cdev : LED flash class device to wrap
-- iled_cdev : LED flash class device representing indicator LED associated with
-	      fled_cdev, may be NULL
-- ops : V4L2 specific ops
-	* external_strobe_set - defines the source of the flash LED strobe -
+
+- dev:
+	flash device, e.g. an I2C device
+- of_node:
+	of_node of the LED, may be NULL if the same as device's
+- fled_cdev:
+	LED flash class device to wrap
+- iled_cdev:
+	LED flash class device representing indicator LED associated with
+	fled_cdev, may be NULL
+- ops:
+	V4L2 specific ops
+
+	* external_strobe_set
+		defines the source of the flash LED strobe -
 		V4L2_CID_FLASH_STROBE control or external source, typically
 		a sensor, which makes it possible to synchronise the flash
 		strobe start with exposure start,
-	* intensity_to_led_brightness and led_brightness_to_intensity - perform
+	* intensity_to_led_brightness and led_brightness_to_intensity
+		perform
 		enum led_brightness <-> V4L2 intensity conversion in a device
 		specific manner - they can be used for devices with non-linear
 		LED current scale.
-- config : configuration for V4L2 Flash sub-device
-	* dev_name - the name of the media entity, unique in the system,
-	* flash_faults - bitmask of flash faults that the LED flash class
+- config:
+	configuration for V4L2 Flash sub-device
+
+	* dev_name
+		the name of the media entity, unique in the system,
+	* flash_faults
+		bitmask of flash faults that the LED flash class
 		device can report; corresponding LED_FAULT* bit definitions are
 		available in <linux/led-class-flash.h>,
-	* torch_intensity - constraints for the LED in TORCH mode
+	* torch_intensity
+		constraints for the LED in TORCH mode
 		in microamperes,
-	* indicator_intensity - constraints for the indicator LED
+	* indicator_intensity
+		constraints for the indicator LED
 		in microamperes,
-	* has_external_strobe - determines whether the flash strobe source
+	* has_external_strobe
+		determines whether the flash strobe source
 		can be switched to external,
 
 On remove the v4l2_flash_release function has to be called, which takes one
diff --git a/Documentation/leds/leds-class.txt b/Documentation/leds/leds-class.rst
similarity index 92%
rename from Documentation/leds/leds-class.txt
rename to Documentation/leds/leds-class.rst
index 8b39cc6b03ee..df0120a1ee3c 100644
--- a/Documentation/leds/leds-class.txt
+++ b/Documentation/leds/leds-class.rst
@@ -1,4 +1,4 @@
-
+========================
 LED handling under Linux
 ========================
 
@@ -43,7 +43,7 @@ LED Device Naming
 
 Is currently of the form:
 
-"devicename:colour:function"
+	"devicename:colour:function"
 
 There have been calls for LED properties such as colour to be exported as
 individual led class attributes. As a solution which doesn't incur as much
@@ -57,9 +57,12 @@ Brightness setting API
 
 LED subsystem core exposes following API for setting brightness:
 
-    - led_set_brightness : it is guaranteed not to sleep, passing LED_OFF stops
+    - led_set_brightness:
+		it is guaranteed not to sleep, passing LED_OFF stops
 		blinking,
-    - led_set_brightness_sync : for use cases when immediate effect is desired -
+
+    - led_set_brightness_sync:
+		for use cases when immediate effect is desired -
 		it can block the caller for the time required for accessing
 		device registers and can sleep, passing LED_OFF stops hardware
 		blinking, returns -EBUSY if software blink fallback is enabled.
@@ -70,7 +73,7 @@ LED registration API
 
 A driver wanting to register a LED classdev for use by other drivers /
 userspace needs to allocate and fill a led_classdev struct and then call
-[devm_]led_classdev_register. If the non devm version is used the driver
+`[devm_]led_classdev_register`. If the non devm version is used the driver
 must call led_classdev_unregister from its remove function before
 free-ing the led_classdev struct.
 
@@ -94,7 +97,7 @@ with brightness value LED_OFF, which should stop any software
 timers that may have been required for blinking.
 
 The blink_set() function should choose a user friendly blinking value
-if it is called with *delay_on==0 && *delay_off==0 parameters. In this
+if it is called with `*delay_on==0` && `*delay_off==0` parameters. In this
 case the driver should give back the chosen value through delay_on and
 delay_off parameters to the leds subsystem.
 
diff --git a/Documentation/leds/leds-lm3556.txt b/Documentation/leds/leds-lm3556.rst
similarity index 70%
rename from Documentation/leds/leds-lm3556.txt
rename to Documentation/leds/leds-lm3556.rst
index 62278e871b50..1ef17d7d800e 100644
--- a/Documentation/leds/leds-lm3556.txt
+++ b/Documentation/leds/leds-lm3556.rst
@@ -1,68 +1,118 @@
+========================
 Kernel driver for lm3556
 ========================
 
-*Texas Instrument:
- 1.5 A Synchronous Boost LED Flash Driver w/ High-Side Current Source
+* Texas Instrument:
+  1.5 A Synchronous Boost LED Flash Driver w/ High-Side Current Source
 * Datasheet: http://www.national.com/ds/LM/LM3556.pdf
 
 Authors:
-	Daniel Jeong
+      - Daniel Jeong
+
 	Contact:Daniel Jeong(daniel.jeong-at-ti.com, gshark.jeong-at-gmail.com)
 
 Description
 -----------
 There are 3 functions in LM3556, Flash, Torch and Indicator.
 
-FLASH MODE
+Flash Mode
+^^^^^^^^^^
+
 In Flash Mode, the LED current source(LED) provides 16 target current levels
 from 93.75 mA to 1500 mA.The Flash currents are adjusted via the CURRENT
 CONTROL REGISTER(0x09).Flash mode is activated by the ENABLE REGISTER(0x0A),
 or by pulling the STROBE pin HIGH.
+
 LM3556 Flash can be controlled through sys/class/leds/flash/brightness file
+
 * if STROBE pin is enabled, below example control brightness only, and
-ON / OFF will be controlled by STROBE pin.
+  ON / OFF will be controlled by STROBE pin.
 
 Flash Example:
-OFF     : #echo 0 > sys/class/leds/flash/brightness
-93.75 mA: #echo 1 > sys/class/leds/flash/brightness
-... .....
-1500  mA: #echo 16 > sys/class/leds/flash/brightness
 
-TORCH MODE
+OFF::
+
+	#echo 0 > sys/class/leds/flash/brightness
+
+93.75 mA::
+
+	#echo 1 > sys/class/leds/flash/brightness
+
+...
+
+1500  mA::
+
+	#echo 16 > sys/class/leds/flash/brightness
+
+Torch Mode
+^^^^^^^^^^
+
 In Torch Mode, the current source(LED) is programmed via the CURRENT CONTROL
 REGISTER(0x09).Torch Mode is activated by the ENABLE REGISTER(0x0A) or by the
 hardware TORCH input.
+
 LM3556 torch can be controlled through sys/class/leds/torch/brightness file.
 * if TORCH pin is enabled, below example control brightness only,
 and ON / OFF will be controlled by TORCH pin.
 
 Torch Example:
-OFF     : #echo 0 > sys/class/leds/torch/brightness
-46.88 mA: #echo 1 > sys/class/leds/torch/brightness
-... .....
-375 mA  : #echo 8 > sys/class/leds/torch/brightness
 
-INDICATOR MODE
+OFF::
+
+	#echo 0 > sys/class/leds/torch/brightness
+
+46.88 mA::
+
+	#echo 1 > sys/class/leds/torch/brightness
+
+...
+
+375 mA::
+
+	#echo 8 > sys/class/leds/torch/brightness
+
+Indicator Mode
+^^^^^^^^^^^^^^
+
 Indicator pattern can be set through sys/class/leds/indicator/pattern file,
 and 4 patterns are pre-defined in indicator_pattern array.
+
 According to N-lank, Pulse time and N Period values, different pattern wiill
 be generated.If you want new patterns for your own device, change
 indicator_pattern array with your own values and INDIC_PATTERN_SIZE.
+
 Please refer datasheet for more detail about N-Blank, Pulse time and N Period.
 
 Indicator pattern example:
-pattern 0: #echo 0 > sys/class/leds/indicator/pattern
-....
-pattern 3: #echo 3 > sys/class/leds/indicator/pattern
+
+pattern 0::
+
+	#echo 0 > sys/class/leds/indicator/pattern
+
+...
+
+pattern 3::
+
+	#echo 3 > sys/class/leds/indicator/pattern
 
 Indicator brightness can be controlled through
 sys/class/leds/indicator/brightness file.
 
 Example:
-OFF      : #echo 0 > sys/class/leds/indicator/brightness
-5.86 mA  : #echo 1 > sys/class/leds/indicator/brightness
-........
-46.875mA : #echo 8 > sys/class/leds/indicator/brightness
+
+OFF::
+
+	#echo 0 > sys/class/leds/indicator/brightness
+
+5.86 mA::
+
+	#echo 1 > sys/class/leds/indicator/brightness
+
+...
+
+46.875mA::
+
+	#echo 8 > sys/class/leds/indicator/brightness
 
 Notes
 -----
@@ -70,7 +120,8 @@ Driver expects it is registered using the i2c_board_info mechanism.
 To register the chip at address 0x63 on specific adapter, set the platform data
 according to include/linux/platform_data/leds-lm3556.h, set the i2c board info
 
-Example:
+Example::
+
 	static struct i2c_board_info board_i2c_ch4[] __initdata = {
 		{
 			 I2C_BOARD_INFO(LM3556_NAME, 0x63),
@@ -80,6 +131,7 @@ Example:
 
 and register it in the platform init function
 
-Example:
+Example::
+
 	board_register_i2c_bus(4, 400,
 				board_i2c_ch4, ARRAY_SIZE(board_i2c_ch4));
diff --git a/Documentation/leds/leds-lp3944.txt b/Documentation/leds/leds-lp3944.rst
similarity index 78%
rename from Documentation/leds/leds-lp3944.txt
rename to Documentation/leds/leds-lp3944.rst
index e88ac3b60c08..c2f87dc1a3a9 100644
--- a/Documentation/leds/leds-lp3944.txt
+++ b/Documentation/leds/leds-lp3944.rst
@@ -1,14 +1,20 @@
+====================
 Kernel driver lp3944
 ====================
 
   * National Semiconductor LP3944 Fun-light Chip
+
     Prefix: 'lp3944'
+
     Addresses scanned: None (see the Notes section below)
-    Datasheet: Publicly available at the National Semiconductor website
-               http://www.national.com/pf/LP/LP3944.html
+
+    Datasheet:
+
+	Publicly available at the National Semiconductor website
+	http://www.national.com/pf/LP/LP3944.html
 
 Authors:
-        Antonio Ospite <ospite@studenti.unina.it>
+	Antonio Ospite <ospite@studenti.unina.it>
 
 
 Description
@@ -19,8 +25,11 @@ is used as a led controller.
 
 The DIM modes are used to set _blink_ patterns for leds, the pattern is
 specified supplying two parameters:
-  - period: from 0s to 1.6s
-  - duty cycle: percentage of the period the led is on, from 0 to 100
+
+  - period:
+	from 0s to 1.6s
+  - duty cycle:
+	percentage of the period the led is on, from 0 to 100
 
 Setting a led in DIM0 or DIM1 mode makes it blink according to the pattern.
 See the datasheet for details.
@@ -35,7 +44,7 @@ The chip is used mainly in embedded contexts, so this driver expects it is
 registered using the i2c_board_info mechanism.
 
 To register the chip at address 0x60 on adapter 0, set the platform data
-according to include/linux/leds-lp3944.h, set the i2c board info:
+according to include/linux/leds-lp3944.h, set the i2c board info::
 
 	static struct i2c_board_info a910_i2c_board_info[] __initdata = {
 		{
@@ -44,7 +53,7 @@ according to include/linux/leds-lp3944.h, set the i2c board info:
 		},
 	};
 
-and register it in the platform init function
+and register it in the platform init function::
 
 	i2c_register_board_info(0, a910_i2c_board_info,
 			ARRAY_SIZE(a910_i2c_board_info));
diff --git a/Documentation/leds/leds-lp5521.rst b/Documentation/leds/leds-lp5521.rst
new file mode 100644
index 000000000000..0432615b083d
--- /dev/null
+++ b/Documentation/leds/leds-lp5521.rst
@@ -0,0 +1,115 @@
+========================
+Kernel driver for lp5521
+========================
+
+* National Semiconductor LP5521 led driver chip
+* Datasheet: http://www.national.com/pf/LP/LP5521.html
+
+Authors: Mathias Nyman, Yuri Zaporozhets, Samu Onkalo
+
+Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
+
+Description
+-----------
+
+LP5521 can drive up to 3 channels. Leds can be controlled directly via
+the led class control interface. Channels have generic names:
+lp5521:channelx, where x is 0 .. 2
+
+All three channels can be also controlled using the engine micro programs.
+More details of the instructions can be found from the public data sheet.
+
+LP5521 has the internal program memory for running various LED patterns.
+There are two ways to run LED patterns.
+
+1) Legacy interface - enginex_mode and enginex_load
+   Control interface for the engines:
+
+   x is 1 .. 3
+
+   enginex_mode:
+	disabled, load, run
+   enginex_load:
+	store program (visible only in engine load mode)
+
+  Example (start to blink the channel 2 led)::
+
+	cd   /sys/class/leds/lp5521:channel2/device
+	echo "load" > engine3_mode
+	echo "037f4d0003ff6000" > engine3_load
+	echo "run" > engine3_mode
+
+  To stop the engine::
+
+	echo "disabled" > engine3_mode
+
+2) Firmware interface - LP55xx common interface
+
+For the details, please refer to 'firmware' section in leds-lp55xx.txt
+
+sysfs contains a selftest entry.
+
+The test communicates with the chip and checks that
+the clock mode is automatically set to the requested one.
+
+Each channel has its own led current settings.
+
+- /sys/class/leds/lp5521:channel0/led_current - RW
+- /sys/class/leds/lp5521:channel0/max_current - RO
+
+Format: 10x mA i.e 10 means 1.0 mA
+
+example platform data::
+
+  static struct lp55xx_led_config lp5521_led_config[] = {
+	  {
+		.name = "red",
+		  .chan_nr        = 0,
+		  .led_current    = 50,
+		.max_current    = 130,
+	  }, {
+		.name = "green",
+		  .chan_nr        = 1,
+		  .led_current    = 0,
+		.max_current    = 130,
+	  }, {
+		.name = "blue",
+		  .chan_nr        = 2,
+		  .led_current    = 0,
+		.max_current    = 130,
+	  }
+  };
+
+  static int lp5521_setup(void)
+  {
+	/* setup HW resources */
+  }
+
+  static void lp5521_release(void)
+  {
+	/* Release HW resources */
+  }
+
+  static void lp5521_enable(bool state)
+  {
+	/* Control of chip enable signal */
+  }
+
+  static struct lp55xx_platform_data lp5521_platform_data = {
+	  .led_config     = lp5521_led_config,
+	  .num_channels   = ARRAY_SIZE(lp5521_led_config),
+	  .clock_mode     = LP55XX_CLOCK_EXT,
+	  .setup_resources   = lp5521_setup,
+	  .release_resources = lp5521_release,
+	  .enable            = lp5521_enable,
+  };
+
+Note:
+  chan_nr can have values between 0 and 2.
+  The name of each channel can be configurable.
+  If the name field is not defined, the default name will be set to 'xxxx:channelN'
+  (XXXX : pdata->label or i2c client name, N : channel number)
+
+
+If the current is set to 0 in the platform data, that channel is
+disabled and it is not visible in the sysfs.
diff --git a/Documentation/leds/leds-lp5521.txt b/Documentation/leds/leds-lp5521.txt
deleted file mode 100644
index d08d8c179f85..000000000000
--- a/Documentation/leds/leds-lp5521.txt
+++ /dev/null
@@ -1,101 +0,0 @@
-Kernel driver for lp5521
-========================
-
-* National Semiconductor LP5521 led driver chip
-* Datasheet: http://www.national.com/pf/LP/LP5521.html
-
-Authors: Mathias Nyman, Yuri Zaporozhets, Samu Onkalo
-Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
-
-Description
------------
-
-LP5521 can drive up to 3 channels. Leds can be controlled directly via
-the led class control interface. Channels have generic names:
-lp5521:channelx, where x is 0 .. 2
-
-All three channels can be also controlled using the engine micro programs.
-More details of the instructions can be found from the public data sheet.
-
-LP5521 has the internal program memory for running various LED patterns.
-There are two ways to run LED patterns.
-
-1) Legacy interface - enginex_mode and enginex_load
-  Control interface for the engines:
-  x is 1 .. 3
-  enginex_mode : disabled, load, run
-  enginex_load : store program (visible only in engine load mode)
-
-  Example (start to blink the channel 2 led):
-  cd   /sys/class/leds/lp5521:channel2/device
-  echo "load" > engine3_mode
-  echo "037f4d0003ff6000" > engine3_load
-  echo "run" > engine3_mode
-
-  To stop the engine:
-  echo "disabled" > engine3_mode
-
-2) Firmware interface - LP55xx common interface
-  For the details, please refer to 'firmware' section in leds-lp55xx.txt
-
-sysfs contains a selftest entry.
-The test communicates with the chip and checks that
-the clock mode is automatically set to the requested one.
-
-Each channel has its own led current settings.
-/sys/class/leds/lp5521:channel0/led_current - RW
-/sys/class/leds/lp5521:channel0/max_current - RO
-Format: 10x mA i.e 10 means 1.0 mA
-
-example platform data:
-
-Note: chan_nr can have values between 0 and 2.
-The name of each channel can be configurable.
-If the name field is not defined, the default name will be set to 'xxxx:channelN'
-(XXXX : pdata->label or i2c client name, N : channel number)
-
-static struct lp55xx_led_config lp5521_led_config[] = {
-        {
-		.name = "red",
-                .chan_nr        = 0,
-                .led_current    = 50,
-		.max_current    = 130,
-        }, {
-		.name = "green",
-                .chan_nr        = 1,
-                .led_current    = 0,
-		.max_current    = 130,
-        }, {
-		.name = "blue",
-                .chan_nr        = 2,
-                .led_current    = 0,
-		.max_current    = 130,
-        }
-};
-
-static int lp5521_setup(void)
-{
-	/* setup HW resources */
-}
-
-static void lp5521_release(void)
-{
-	/* Release HW resources */
-}
-
-static void lp5521_enable(bool state)
-{
-	/* Control of chip enable signal */
-}
-
-static struct lp55xx_platform_data lp5521_platform_data = {
-        .led_config     = lp5521_led_config,
-        .num_channels   = ARRAY_SIZE(lp5521_led_config),
-        .clock_mode     = LP55XX_CLOCK_EXT,
-        .setup_resources   = lp5521_setup,
-        .release_resources = lp5521_release,
-        .enable            = lp5521_enable,
-};
-
-If the current is set to 0 in the platform data, that channel is
-disabled and it is not visible in the sysfs.
diff --git a/Documentation/leds/leds-lp5523.rst b/Documentation/leds/leds-lp5523.rst
new file mode 100644
index 000000000000..7d7362a1dd57
--- /dev/null
+++ b/Documentation/leds/leds-lp5523.rst
@@ -0,0 +1,147 @@
+========================
+Kernel driver for lp5523
+========================
+
+* National Semiconductor LP5523 led driver chip
+* Datasheet: http://www.national.com/pf/LP/LP5523.html
+
+Authors: Mathias Nyman, Yuri Zaporozhets, Samu Onkalo
+Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
+
+Description
+-----------
+LP5523 can drive up to 9 channels. Leds can be controlled directly via
+the led class control interface.
+The name of each channel is configurable in the platform data - name and label.
+There are three options to make the channel name.
+
+a) Define the 'name' in the platform data
+
+To make specific channel name, then use 'name' platform data.
+
+- /sys/class/leds/R1               (name: 'R1')
+- /sys/class/leds/B1               (name: 'B1')
+
+b) Use the 'label' with no 'name' field
+
+For one device name with channel number, then use 'label'.
+- /sys/class/leds/RGB:channelN     (label: 'RGB', N: 0 ~ 8)
+
+c) Default
+
+If both fields are NULL, 'lp5523' is used by default.
+- /sys/class/leds/lp5523:channelN  (N: 0 ~ 8)
+
+LP5523 has the internal program memory for running various LED patterns.
+There are two ways to run LED patterns.
+
+1) Legacy interface - enginex_mode, enginex_load and enginex_leds
+
+  Control interface for the engines:
+
+  x is 1 .. 3
+
+  enginex_mode:
+	disabled, load, run
+  enginex_load:
+	microcode load
+  enginex_leds:
+	led mux control
+
+  ::
+
+	cd /sys/class/leds/lp5523:channel2/device
+	echo "load" > engine3_mode
+	echo "9d80400004ff05ff437f0000" > engine3_load
+	echo "111111111" > engine3_leds
+	echo "run" > engine3_mode
+
+  To stop the engine::
+
+	echo "disabled" > engine3_mode
+
+2) Firmware interface - LP55xx common interface
+
+For the details, please refer to 'firmware' section in leds-lp55xx.txt
+
+LP5523 has three master faders. If a channel is mapped to one of
+the master faders, its output is dimmed based on the value of the master
+fader.
+
+For example::
+
+  echo "123000123" > master_fader_leds
+
+creates the following channel-fader mappings::
+
+  channel 0,6 to master_fader1
+  channel 1,7 to master_fader2
+  channel 2,8 to master_fader3
+
+Then, to have 25% of the original output on channel 0,6::
+
+  echo 64 > master_fader1
+
+To have 0% of the original output (i.e. no output) channel 1,7::
+
+  echo 0 > master_fader2
+
+To have 100% of the original output (i.e. no dimming) on channel 2,8::
+
+  echo 255 > master_fader3
+
+To clear all master fader controls::
+
+  echo "000000000" > master_fader_leds
+
+Selftest uses always the current from the platform data.
+
+Each channel contains led current settings.
+- /sys/class/leds/lp5523:channel2/led_current - RW
+- /sys/class/leds/lp5523:channel2/max_current - RO
+
+Format: 10x mA i.e 10 means 1.0 mA
+
+Example platform data::
+
+	static struct lp55xx_led_config lp5523_led_config[] = {
+		{
+			.name		= "D1",
+			.chan_nr        = 0,
+			.led_current    = 50,
+			.max_current    = 130,
+		},
+	...
+		{
+			.chan_nr        = 8,
+			.led_current    = 50,
+			.max_current    = 130,
+		}
+	};
+
+	static int lp5523_setup(void)
+	{
+		/* Setup HW resources */
+	}
+
+	static void lp5523_release(void)
+	{
+		/* Release HW resources */
+	}
+
+	static void lp5523_enable(bool state)
+	{
+		/* Control chip enable signal */
+	}
+
+	static struct lp55xx_platform_data lp5523_platform_data = {
+		.led_config     = lp5523_led_config,
+		.num_channels   = ARRAY_SIZE(lp5523_led_config),
+		.clock_mode     = LP55XX_CLOCK_EXT,
+		.setup_resources   = lp5523_setup,
+		.release_resources = lp5523_release,
+		.enable            = lp5523_enable,
+	};
+
+Note
+  chan_nr can have values between 0 and 8.
diff --git a/Documentation/leds/leds-lp5523.txt b/Documentation/leds/leds-lp5523.txt
deleted file mode 100644
index 0961a060fc4d..000000000000
--- a/Documentation/leds/leds-lp5523.txt
+++ /dev/null
@@ -1,130 +0,0 @@
-Kernel driver for lp5523
-========================
-
-* National Semiconductor LP5523 led driver chip
-* Datasheet: http://www.national.com/pf/LP/LP5523.html
-
-Authors: Mathias Nyman, Yuri Zaporozhets, Samu Onkalo
-Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
-
-Description
------------
-LP5523 can drive up to 9 channels. Leds can be controlled directly via
-the led class control interface.
-The name of each channel is configurable in the platform data - name and label.
-There are three options to make the channel name.
-
-a) Define the 'name' in the platform data
-To make specific channel name, then use 'name' platform data.
-/sys/class/leds/R1               (name: 'R1')
-/sys/class/leds/B1               (name: 'B1')
-
-b) Use the 'label' with no 'name' field
-For one device name with channel number, then use 'label'.
-/sys/class/leds/RGB:channelN     (label: 'RGB', N: 0 ~ 8)
-
-c) Default
-If both fields are NULL, 'lp5523' is used by default.
-/sys/class/leds/lp5523:channelN  (N: 0 ~ 8)
-
-LP5523 has the internal program memory for running various LED patterns.
-There are two ways to run LED patterns.
-
-1) Legacy interface - enginex_mode, enginex_load and enginex_leds
-  Control interface for the engines:
-  x is 1 .. 3
-  enginex_mode : disabled, load, run
-  enginex_load : microcode load
-  enginex_leds : led mux control
-
-  cd /sys/class/leds/lp5523:channel2/device
-  echo "load" > engine3_mode
-  echo "9d80400004ff05ff437f0000" > engine3_load
-  echo "111111111" > engine3_leds
-  echo "run" > engine3_mode
-
-  To stop the engine:
-  echo "disabled" > engine3_mode
-
-2) Firmware interface - LP55xx common interface
-  For the details, please refer to 'firmware' section in leds-lp55xx.txt
-
-LP5523 has three master faders. If a channel is mapped to one of
-the master faders, its output is dimmed based on the value of the master
-fader.
-
-For example,
-
-  echo "123000123" > master_fader_leds
-
-creates the following channel-fader mappings:
-
-  channel 0,6 to master_fader1
-  channel 1,7 to master_fader2
-  channel 2,8 to master_fader3
-
-Then, to have 25% of the original output on channel 0,6:
-
-  echo 64 > master_fader1
-
-To have 0% of the original output (i.e. no output) channel 1,7:
-
-  echo 0 > master_fader2
-
-To have 100% of the original output (i.e. no dimming) on channel 2,8:
-
-  echo 255 > master_fader3
-
-To clear all master fader controls:
-
-  echo "000000000" > master_fader_leds
-
-Selftest uses always the current from the platform data.
-
-Each channel contains led current settings.
-/sys/class/leds/lp5523:channel2/led_current - RW
-/sys/class/leds/lp5523:channel2/max_current - RO
-Format: 10x mA i.e 10 means 1.0 mA
-
-Example platform data:
-
-Note - chan_nr can have values between 0 and 8.
-
-static struct lp55xx_led_config lp5523_led_config[] = {
-        {
-		.name		= "D1",
-                .chan_nr        = 0,
-                .led_current    = 50,
-		.max_current    = 130,
-        },
-...
-        {
-                .chan_nr        = 8,
-                .led_current    = 50,
-		.max_current    = 130,
-        }
-};
-
-static int lp5523_setup(void)
-{
-	/* Setup HW resources */
-}
-
-static void lp5523_release(void)
-{
-	/* Release HW resources */
-}
-
-static void lp5523_enable(bool state)
-{
-	/* Control chip enable signal */
-}
-
-static struct lp55xx_platform_data lp5523_platform_data = {
-        .led_config     = lp5523_led_config,
-        .num_channels   = ARRAY_SIZE(lp5523_led_config),
-        .clock_mode     = LP55XX_CLOCK_EXT,
-        .setup_resources   = lp5523_setup,
-        .release_resources = lp5523_release,
-        .enable            = lp5523_enable,
-};
diff --git a/Documentation/leds/leds-lp5562.rst b/Documentation/leds/leds-lp5562.rst
new file mode 100644
index 000000000000..79bbb2487ff6
--- /dev/null
+++ b/Documentation/leds/leds-lp5562.rst
@@ -0,0 +1,137 @@
+========================
+Kernel driver for lp5562
+========================
+
+* TI LP5562 LED Driver
+
+Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+
+Description
+===========
+
+  LP5562 can drive up to 4 channels. R/G/B and White.
+  LEDs can be controlled directly via the led class control interface.
+
+  All four channels can be also controlled using the engine micro programs.
+  LP5562 has the internal program memory for running various LED patterns.
+  For the details, please refer to 'firmware' section in leds-lp55xx.txt
+
+Device attribute
+================
+
+engine_mux
+  3 Engines are allocated in LP5562, but the number of channel is 4.
+  Therefore each channel should be mapped to the engine number.
+
+  Value: RGB or W
+
+  This attribute is used for programming LED data with the firmware interface.
+  Unlike the LP5521/LP5523/55231, LP5562 has unique feature for the engine mux,
+  so additional sysfs is required
+
+  LED Map
+
+  ===== === ===============================
+  Red   ... Engine 1 (fixed)
+  Green ... Engine 2 (fixed)
+  Blue  ... Engine 3 (fixed)
+  White ... Engine 1 or 2 or 3 (selective)
+  ===== === ===============================
+
+How to load the program data using engine_mux
+=============================================
+
+  Before loading the LP5562 program data, engine_mux should be written between
+  the engine selection and loading the firmware.
+  Engine mux has two different mode, RGB and W.
+  RGB is used for loading RGB program data, W is used for W program data.
+
+  For example, run blinking green channel pattern::
+
+    echo 2 > /sys/bus/i2c/devices/xxxx/select_engine     # 2 is for green channel
+    echo "RGB" > /sys/bus/i2c/devices/xxxx/engine_mux    # engine mux for RGB
+    echo 1 > /sys/class/firmware/lp5562/loading
+    echo "4000600040FF6000" > /sys/class/firmware/lp5562/data
+    echo 0 > /sys/class/firmware/lp5562/loading
+    echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
+
+  To run a blinking white pattern::
+
+    echo 1 or 2 or 3 > /sys/bus/i2c/devices/xxxx/select_engine
+    echo "W" > /sys/bus/i2c/devices/xxxx/engine_mux
+    echo 1 > /sys/class/firmware/lp5562/loading
+    echo "4000600040FF6000" > /sys/class/firmware/lp5562/data
+    echo 0 > /sys/class/firmware/lp5562/loading
+    echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
+
+How to load the predefined patterns
+===================================
+
+  Please refer to 'leds-lp55xx.txt"
+
+Setting Current of Each Channel
+===============================
+
+  Like LP5521 and LP5523/55231, LP5562 provides LED current settings.
+  The 'led_current' and 'max_current' are used.
+
+Example of Platform data
+========================
+
+::
+
+	static struct lp55xx_led_config lp5562_led_config[] = {
+		{
+			.name 		= "R",
+			.chan_nr	= 0,
+			.led_current	= 20,
+			.max_current	= 40,
+		},
+		{
+			.name 		= "G",
+			.chan_nr	= 1,
+			.led_current	= 20,
+			.max_current	= 40,
+		},
+		{
+			.name 		= "B",
+			.chan_nr	= 2,
+			.led_current	= 20,
+			.max_current	= 40,
+		},
+		{
+			.name 		= "W",
+			.chan_nr	= 3,
+			.led_current	= 20,
+			.max_current	= 40,
+		},
+	};
+
+	static int lp5562_setup(void)
+	{
+		/* setup HW resources */
+	}
+
+	static void lp5562_release(void)
+	{
+		/* Release HW resources */
+	}
+
+	static void lp5562_enable(bool state)
+	{
+		/* Control of chip enable signal */
+	}
+
+	static struct lp55xx_platform_data lp5562_platform_data = {
+		.led_config     = lp5562_led_config,
+		.num_channels   = ARRAY_SIZE(lp5562_led_config),
+		.setup_resources   = lp5562_setup,
+		.release_resources = lp5562_release,
+		.enable            = lp5562_enable,
+	};
+
+To configure the platform specific data, lp55xx_platform_data structure is used
+
+
+If the current is set to 0 in the platform data, that channel is
+disabled and it is not visible in the sysfs.
diff --git a/Documentation/leds/leds-lp5562.txt b/Documentation/leds/leds-lp5562.txt
deleted file mode 100644
index 5a823ff6b393..000000000000
--- a/Documentation/leds/leds-lp5562.txt
+++ /dev/null
@@ -1,120 +0,0 @@
-Kernel driver for LP5562
-========================
-
-* TI LP5562 LED Driver
-
-Author: Milo(Woogyom) Kim <milo.kim@ti.com>
-
-Description
-
-  LP5562 can drive up to 4 channels. R/G/B and White.
-  LEDs can be controlled directly via the led class control interface.
-
-  All four channels can be also controlled using the engine micro programs.
-  LP5562 has the internal program memory for running various LED patterns.
-  For the details, please refer to 'firmware' section in leds-lp55xx.txt
-
-Device attribute: engine_mux
-
-  3 Engines are allocated in LP5562, but the number of channel is 4.
-  Therefore each channel should be mapped to the engine number.
-  Value : RGB or W
-
-  This attribute is used for programming LED data with the firmware interface.
-  Unlike the LP5521/LP5523/55231, LP5562 has unique feature for the engine mux,
-  so additional sysfs is required.
-
-  LED Map
-  Red   ... Engine 1 (fixed)
-  Green ... Engine 2 (fixed)
-  Blue  ... Engine 3 (fixed)
-  White ... Engine 1 or 2 or 3 (selective)
-
-How to load the program data using engine_mux
-
-  Before loading the LP5562 program data, engine_mux should be written between
-  the engine selection and loading the firmware.
-  Engine mux has two different mode, RGB and W.
-  RGB is used for loading RGB program data, W is used for W program data.
-
-  For example, run blinking green channel pattern,
-  echo 2 > /sys/bus/i2c/devices/xxxx/select_engine     # 2 is for green channel
-  echo "RGB" > /sys/bus/i2c/devices/xxxx/engine_mux    # engine mux for RGB
-  echo 1 > /sys/class/firmware/lp5562/loading
-  echo "4000600040FF6000" > /sys/class/firmware/lp5562/data
-  echo 0 > /sys/class/firmware/lp5562/loading
-  echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
-
-  To run a blinking white pattern,
-  echo 1 or 2 or 3 > /sys/bus/i2c/devices/xxxx/select_engine
-  echo "W" > /sys/bus/i2c/devices/xxxx/engine_mux
-  echo 1 > /sys/class/firmware/lp5562/loading
-  echo "4000600040FF6000" > /sys/class/firmware/lp5562/data
-  echo 0 > /sys/class/firmware/lp5562/loading
-  echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
-
-How to load the predefined patterns
-
-  Please refer to 'leds-lp55xx.txt"
-
-Setting Current of Each Channel
-
-  Like LP5521 and LP5523/55231, LP5562 provides LED current settings.
-  The 'led_current' and 'max_current' are used.
-
-(Example of Platform data)
-
-To configure the platform specific data, lp55xx_platform_data structure is used.
-
-static struct lp55xx_led_config lp5562_led_config[] = {
-	{
-		.name 		= "R",
-		.chan_nr	= 0,
-		.led_current	= 20,
-		.max_current	= 40,
-	},
-	{
-		.name 		= "G",
-		.chan_nr	= 1,
-		.led_current	= 20,
-		.max_current	= 40,
-	},
-	{
-		.name 		= "B",
-		.chan_nr	= 2,
-		.led_current	= 20,
-		.max_current	= 40,
-	},
-	{
-		.name 		= "W",
-		.chan_nr	= 3,
-		.led_current	= 20,
-		.max_current	= 40,
-	},
-};
-
-static int lp5562_setup(void)
-{
-	/* setup HW resources */
-}
-
-static void lp5562_release(void)
-{
-	/* Release HW resources */
-}
-
-static void lp5562_enable(bool state)
-{
-	/* Control of chip enable signal */
-}
-
-static struct lp55xx_platform_data lp5562_platform_data = {
-        .led_config     = lp5562_led_config,
-        .num_channels   = ARRAY_SIZE(lp5562_led_config),
-        .setup_resources   = lp5562_setup,
-        .release_resources = lp5562_release,
-        .enable            = lp5562_enable,
-};
-
-If the current is set to 0 in the platform data, that channel is
-disabled and it is not visible in the sysfs.
diff --git a/Documentation/leds/leds-lp55xx.rst b/Documentation/leds/leds-lp55xx.rst
new file mode 100644
index 000000000000..632e41cec0b5
--- /dev/null
+++ b/Documentation/leds/leds-lp55xx.rst
@@ -0,0 +1,224 @@
+=================================================
+LP5521/LP5523/LP55231/LP5562/LP8501 Common Driver
+=================================================
+
+Authors: Milo(Woogyom) Kim <milo.kim@ti.com>
+
+Description
+-----------
+LP5521, LP5523/55231, LP5562 and LP8501 have common features as below.
+
+  Register access via the I2C
+  Device initialization/deinitialization
+  Create LED class devices for multiple output channels
+  Device attributes for user-space interface
+  Program memory for running LED patterns
+
+The LP55xx common driver provides these features using exported functions.
+
+  lp55xx_init_device() / lp55xx_deinit_device()
+  lp55xx_register_leds() / lp55xx_unregister_leds()
+  lp55xx_regsister_sysfs() / lp55xx_unregister_sysfs()
+
+( Driver Structure Data )
+
+In lp55xx common driver, two different data structure is used.
+
+* lp55xx_led
+    control multi output LED channels such as led current, channel index.
+* lp55xx_chip
+    general chip control such like the I2C and platform data.
+
+For example, LP5521 has maximum 3 LED channels.
+LP5523/55231 has 9 output channels::
+
+  lp55xx_chip for LP5521 ... lp55xx_led #1
+			     lp55xx_led #2
+			     lp55xx_led #3
+
+  lp55xx_chip for LP5523 ... lp55xx_led #1
+			     lp55xx_led #2
+				   .
+				   .
+			     lp55xx_led #9
+
+( Chip Dependent Code )
+
+To support device specific configurations, special structure
+'lpxx_device_config' is used.
+
+  - Maximum number of channels
+  - Reset command, chip enable command
+  - Chip specific initialization
+  - Brightness control register access
+  - Setting LED output current
+  - Program memory address access for running patterns
+  - Additional device specific attributes
+
+( Firmware Interface )
+
+LP55xx family devices have the internal program memory for running
+various LED patterns.
+
+This pattern data is saved as a file in the user-land or
+hex byte string is written into the memory through the I2C.
+
+LP55xx common driver supports the firmware interface.
+
+LP55xx chips have three program engines.
+
+To load and run the pattern, the programming sequence is following.
+
+  (1) Select an engine number (1/2/3)
+  (2) Mode change to load
+  (3) Write pattern data into selected area
+  (4) Mode change to run
+
+The LP55xx common driver provides simple interfaces as below.
+
+select_engine:
+	Select which engine is used for running program
+run_engine:
+	Start program which is loaded via the firmware interface
+firmware:
+	Load program data
+
+In case of LP5523, one more command is required, 'enginex_leds'.
+It is used for selecting LED output(s) at each engine number.
+In more details, please refer to 'leds-lp5523.txt'.
+
+For example, run blinking pattern in engine #1 of LP5521::
+
+	echo 1 > /sys/bus/i2c/devices/xxxx/select_engine
+	echo 1 > /sys/class/firmware/lp5521/loading
+	echo "4000600040FF6000" > /sys/class/firmware/lp5521/data
+	echo 0 > /sys/class/firmware/lp5521/loading
+	echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
+
+For example, run blinking pattern in engine #3 of LP55231
+
+Two LEDs are configured as pattern output channels::
+
+	echo 3 > /sys/bus/i2c/devices/xxxx/select_engine
+	echo 1 > /sys/class/firmware/lp55231/loading
+	echo "9d0740ff7e0040007e00a0010000" > /sys/class/firmware/lp55231/data
+	echo 0 > /sys/class/firmware/lp55231/loading
+	echo "000001100" > /sys/bus/i2c/devices/xxxx/engine3_leds
+	echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
+
+To start blinking patterns in engine #2 and #3 simultaneously::
+
+	for idx in 2 3
+	do
+	echo $idx > /sys/class/leds/red/device/select_engine
+	sleep 0.1
+	echo 1 > /sys/class/firmware/lp5521/loading
+	echo "4000600040FF6000" > /sys/class/firmware/lp5521/data
+	echo 0 > /sys/class/firmware/lp5521/loading
+	done
+	echo 1 > /sys/class/leds/red/device/run_engine
+
+Here is another example for LP5523.
+
+Full LED strings are selected by 'engine2_leds'::
+
+	echo 2 > /sys/bus/i2c/devices/xxxx/select_engine
+	echo 1 > /sys/class/firmware/lp5523/loading
+	echo "9d80400004ff05ff437f0000" > /sys/class/firmware/lp5523/data
+	echo 0 > /sys/class/firmware/lp5523/loading
+	echo "111111111" > /sys/bus/i2c/devices/xxxx/engine2_leds
+	echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
+
+As soon as 'loading' is set to 0, registered callback is called.
+Inside the callback, the selected engine is loaded and memory is updated.
+To run programmed pattern, 'run_engine' attribute should be enabled.
+
+The pattern sequence of LP8501 is similar to LP5523.
+
+However pattern data is specific.
+
+Ex 1) Engine 1 is used::
+
+	echo 1 > /sys/bus/i2c/devices/xxxx/select_engine
+	echo 1 > /sys/class/firmware/lp8501/loading
+	echo "9d0140ff7e0040007e00a001c000" > /sys/class/firmware/lp8501/data
+	echo 0 > /sys/class/firmware/lp8501/loading
+	echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
+
+Ex 2) Engine 2 and 3 are used at the same time::
+
+	echo 2 > /sys/bus/i2c/devices/xxxx/select_engine
+	sleep 1
+	echo 1 > /sys/class/firmware/lp8501/loading
+	echo "9d0140ff7e0040007e00a001c000" > /sys/class/firmware/lp8501/data
+	echo 0 > /sys/class/firmware/lp8501/loading
+	sleep 1
+	echo 3 > /sys/bus/i2c/devices/xxxx/select_engine
+	sleep 1
+	echo 1 > /sys/class/firmware/lp8501/loading
+	echo "9d0340ff7e0040007e00a001c000" > /sys/class/firmware/lp8501/data
+	echo 0 > /sys/class/firmware/lp8501/loading
+	sleep 1
+	echo 1 > /sys/class/leds/d1/device/run_engine
+
+( 'run_engine' and 'firmware_cb' )
+
+The sequence of running the program data is common.
+
+But each device has own specific register addresses for commands.
+
+To support this, 'run_engine' and 'firmware_cb' are configurable in each driver.
+
+run_engine:
+	Control the selected engine
+firmware_cb:
+	The callback function after loading the firmware is done.
+
+	Chip specific commands for loading and updating program memory.
+
+( Predefined pattern data )
+
+Without the firmware interface, LP55xx driver provides another method for
+loading a LED pattern. That is 'predefined' pattern.
+
+A predefined pattern is defined in the platform data and load it(or them)
+via the sysfs if needed.
+
+To use the predefined pattern concept, 'patterns' and 'num_patterns' should be
+configured.
+
+Example of predefined pattern data::
+
+  /* mode_1: blinking data */
+  static const u8 mode_1[] = {
+		0x40, 0x00, 0x60, 0x00, 0x40, 0xFF, 0x60, 0x00,
+		};
+
+  /* mode_2: always on */
+  static const u8 mode_2[] = { 0x40, 0xFF, };
+
+  struct lp55xx_predef_pattern board_led_patterns[] = {
+	{
+		.r = mode_1,
+		.size_r = ARRAY_SIZE(mode_1),
+	},
+	{
+		.b = mode_2,
+		.size_b = ARRAY_SIZE(mode_2),
+	},
+  }
+
+  struct lp55xx_platform_data lp5562_pdata = {
+  ...
+	.patterns      = board_led_patterns,
+	.num_patterns  = ARRAY_SIZE(board_led_patterns),
+  };
+
+Then, mode_1 and mode_2 can be run via through the sysfs::
+
+  echo 1 > /sys/bus/i2c/devices/xxxx/led_pattern    # red blinking LED pattern
+  echo 2 > /sys/bus/i2c/devices/xxxx/led_pattern    # blue LED always on
+
+To stop running pattern::
+
+  echo 0 > /sys/bus/i2c/devices/xxxx/led_pattern
diff --git a/Documentation/leds/leds-lp55xx.txt b/Documentation/leds/leds-lp55xx.txt
deleted file mode 100644
index e23fa91ea722..000000000000
--- a/Documentation/leds/leds-lp55xx.txt
+++ /dev/null
@@ -1,194 +0,0 @@
-LP5521/LP5523/LP55231/LP5562/LP8501 Common Driver
-=================================================
-
-Authors: Milo(Woogyom) Kim <milo.kim@ti.com>
-
-Description
------------
-LP5521, LP5523/55231, LP5562 and LP8501 have common features as below.
-
-  Register access via the I2C
-  Device initialization/deinitialization
-  Create LED class devices for multiple output channels
-  Device attributes for user-space interface
-  Program memory for running LED patterns
-
-The LP55xx common driver provides these features using exported functions.
-  lp55xx_init_device() / lp55xx_deinit_device()
-  lp55xx_register_leds() / lp55xx_unregister_leds()
-  lp55xx_regsister_sysfs() / lp55xx_unregister_sysfs()
-
-( Driver Structure Data )
-
-In lp55xx common driver, two different data structure is used.
-
-o lp55xx_led
-  control multi output LED channels such as led current, channel index.
-o lp55xx_chip
-  general chip control such like the I2C and platform data.
-
-For example, LP5521 has maximum 3 LED channels.
-LP5523/55231 has 9 output channels.
-
-lp55xx_chip for LP5521 ... lp55xx_led #1
-                           lp55xx_led #2
-                           lp55xx_led #3
-
-lp55xx_chip for LP5523 ... lp55xx_led #1
-                           lp55xx_led #2
-                                 .
-                                 .
-                           lp55xx_led #9
-
-( Chip Dependent Code )
-
-To support device specific configurations, special structure
-'lpxx_device_config' is used.
-
-  Maximum number of channels
-  Reset command, chip enable command
-  Chip specific initialization
-  Brightness control register access
-  Setting LED output current
-  Program memory address access for running patterns
-  Additional device specific attributes
-
-( Firmware Interface )
-
-LP55xx family devices have the internal program memory for running
-various LED patterns.
-This pattern data is saved as a file in the user-land or
-hex byte string is written into the memory through the I2C.
-LP55xx common driver supports the firmware interface.
-
-LP55xx chips have three program engines.
-To load and run the pattern, the programming sequence is following.
-  (1) Select an engine number (1/2/3)
-  (2) Mode change to load
-  (3) Write pattern data into selected area
-  (4) Mode change to run
-
-The LP55xx common driver provides simple interfaces as below.
-select_engine : Select which engine is used for running program
-run_engine    : Start program which is loaded via the firmware interface
-firmware      : Load program data
-
-In case of LP5523, one more command is required, 'enginex_leds'.
-It is used for selecting LED output(s) at each engine number.
-In more details, please refer to 'leds-lp5523.txt'.
-
-For example, run blinking pattern in engine #1 of LP5521
-echo 1 > /sys/bus/i2c/devices/xxxx/select_engine
-echo 1 > /sys/class/firmware/lp5521/loading
-echo "4000600040FF6000" > /sys/class/firmware/lp5521/data
-echo 0 > /sys/class/firmware/lp5521/loading
-echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
-
-For example, run blinking pattern in engine #3 of LP55231
-Two LEDs are configured as pattern output channels.
-echo 3 > /sys/bus/i2c/devices/xxxx/select_engine
-echo 1 > /sys/class/firmware/lp55231/loading
-echo "9d0740ff7e0040007e00a0010000" > /sys/class/firmware/lp55231/data
-echo 0 > /sys/class/firmware/lp55231/loading
-echo "000001100" > /sys/bus/i2c/devices/xxxx/engine3_leds
-echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
-
-To start blinking patterns in engine #2 and #3 simultaneously,
-for idx in 2 3
-do
-  echo $idx > /sys/class/leds/red/device/select_engine
-  sleep 0.1
-  echo 1 > /sys/class/firmware/lp5521/loading
-  echo "4000600040FF6000" > /sys/class/firmware/lp5521/data
-  echo 0 > /sys/class/firmware/lp5521/loading
-done
-echo 1 > /sys/class/leds/red/device/run_engine
-
-Here is another example for LP5523.
-Full LED strings are selected by 'engine2_leds'.
-echo 2 > /sys/bus/i2c/devices/xxxx/select_engine
-echo 1 > /sys/class/firmware/lp5523/loading
-echo "9d80400004ff05ff437f0000" > /sys/class/firmware/lp5523/data
-echo 0 > /sys/class/firmware/lp5523/loading
-echo "111111111" > /sys/bus/i2c/devices/xxxx/engine2_leds
-echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
-
-As soon as 'loading' is set to 0, registered callback is called.
-Inside the callback, the selected engine is loaded and memory is updated.
-To run programmed pattern, 'run_engine' attribute should be enabled.
-
-The pattern sequence of LP8501 is similar to LP5523.
-However pattern data is specific.
-Ex 1) Engine 1 is used
-echo 1 > /sys/bus/i2c/devices/xxxx/select_engine
-echo 1 > /sys/class/firmware/lp8501/loading
-echo "9d0140ff7e0040007e00a001c000" > /sys/class/firmware/lp8501/data
-echo 0 > /sys/class/firmware/lp8501/loading
-echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
-
-Ex 2) Engine 2 and 3 are used at the same time
-echo 2 > /sys/bus/i2c/devices/xxxx/select_engine
-sleep 1
-echo 1 > /sys/class/firmware/lp8501/loading
-echo "9d0140ff7e0040007e00a001c000" > /sys/class/firmware/lp8501/data
-echo 0 > /sys/class/firmware/lp8501/loading
-sleep 1
-echo 3 > /sys/bus/i2c/devices/xxxx/select_engine
-sleep 1
-echo 1 > /sys/class/firmware/lp8501/loading
-echo "9d0340ff7e0040007e00a001c000" > /sys/class/firmware/lp8501/data
-echo 0 > /sys/class/firmware/lp8501/loading
-sleep 1
-echo 1 > /sys/class/leds/d1/device/run_engine
-
-( 'run_engine' and 'firmware_cb' )
-The sequence of running the program data is common.
-But each device has own specific register addresses for commands.
-To support this, 'run_engine' and 'firmware_cb' are configurable in each driver.
-run_engine  : Control the selected engine
-firmware_cb : The callback function after loading the firmware is done.
-              Chip specific commands for loading and updating program memory.
-
-( Predefined pattern data )
-
-Without the firmware interface, LP55xx driver provides another method for
-loading a LED pattern. That is 'predefined' pattern.
-A predefined pattern is defined in the platform data and load it(or them)
-via the sysfs if needed.
-To use the predefined pattern concept, 'patterns' and 'num_patterns' should be
-configured.
-
-  Example of predefined pattern data:
-
-  /* mode_1: blinking data */
-  static const u8 mode_1[] = {
-		0x40, 0x00, 0x60, 0x00, 0x40, 0xFF, 0x60, 0x00,
-		};
-
-  /* mode_2: always on */
-  static const u8 mode_2[] = { 0x40, 0xFF, };
-
-  struct lp55xx_predef_pattern board_led_patterns[] = {
-	{
-		.r = mode_1,
-		.size_r = ARRAY_SIZE(mode_1),
-	},
-	{
-		.b = mode_2,
-		.size_b = ARRAY_SIZE(mode_2),
-	},
-  }
-
-  struct lp55xx_platform_data lp5562_pdata = {
-  ...
-	.patterns      = board_led_patterns,
-	.num_patterns  = ARRAY_SIZE(board_led_patterns),
-  };
-
-Then, mode_1 and mode_2 can be run via through the sysfs.
-
-  echo 1 > /sys/bus/i2c/devices/xxxx/led_pattern    # red blinking LED pattern
-  echo 2 > /sys/bus/i2c/devices/xxxx/led_pattern    # blue LED always on
-
-To stop running pattern,
-  echo 0 > /sys/bus/i2c/devices/xxxx/led_pattern
diff --git a/Documentation/leds/leds-mlxcpld.rst b/Documentation/leds/leds-mlxcpld.rst
new file mode 100644
index 000000000000..528582429e0b
--- /dev/null
+++ b/Documentation/leds/leds-mlxcpld.rst
@@ -0,0 +1,118 @@
+=======================================
+Kernel driver for Mellanox systems LEDs
+=======================================
+
+Provide system LED support for the nex Mellanox systems:
+"msx6710", "msx6720", "msb7700", "msn2700", "msx1410",
+"msn2410", "msb7800", "msn2740", "msn2100".
+
+Description
+-----------
+Driver provides the following LEDs for the systems "msx6710", "msx6720",
+"msb7700", "msn2700", "msx1410", "msn2410", "msb7800", "msn2740":
+
+  - mlxcpld:fan1:green
+  - mlxcpld:fan1:red
+  - mlxcpld:fan2:green
+  - mlxcpld:fan2:red
+  - mlxcpld:fan3:green
+  - mlxcpld:fan3:red
+  - mlxcpld:fan4:green
+  - mlxcpld:fan4:red
+  - mlxcpld:psu:green
+  - mlxcpld:psu:red
+  - mlxcpld:status:green
+  - mlxcpld:status:red
+
+ "status"
+  - CPLD reg offset: 0x20
+  - Bits [3:0]
+
+ "psu"
+  - CPLD reg offset: 0x20
+  - Bits [7:4]
+
+ "fan1"
+  - CPLD reg offset: 0x21
+  - Bits [3:0]
+
+ "fan2"
+  - CPLD reg offset: 0x21
+  - Bits [7:4]
+
+ "fan3"
+  - CPLD reg offset: 0x22
+  - Bits [3:0]
+
+ "fan4"
+  - CPLD reg offset: 0x22
+  - Bits [7:4]
+
+ Color mask for all the above LEDs:
+
+  [bit3,bit2,bit1,bit0] or
+  [bit7,bit6,bit5,bit4]:
+
+	- [0,0,0,0] = LED OFF
+	- [0,1,0,1] = Red static ON
+	- [1,1,0,1] = Green static ON
+	- [0,1,1,0] = Red blink 3Hz
+	- [1,1,1,0] = Green blink 3Hz
+	- [0,1,1,1] = Red blink 6Hz
+	- [1,1,1,1] = Green blink 6Hz
+
+Driver provides the following LEDs for the system "msn2100":
+
+  - mlxcpld:fan:green
+  - mlxcpld:fan:red
+  - mlxcpld:psu1:green
+  - mlxcpld:psu1:red
+  - mlxcpld:psu2:green
+  - mlxcpld:psu2:red
+  - mlxcpld:status:green
+  - mlxcpld:status:red
+  - mlxcpld:uid:blue
+
+ "status"
+  - CPLD reg offset: 0x20
+  - Bits [3:0]
+
+ "fan"
+  - CPLD reg offset: 0x21
+  - Bits [3:0]
+
+ "psu1"
+  - CPLD reg offset: 0x23
+  - Bits [3:0]
+
+ "psu2"
+  - CPLD reg offset: 0x23
+  - Bits [7:4]
+
+ "uid"
+  - CPLD reg offset: 0x24
+  - Bits [3:0]
+
+ Color mask for all the above LEDs, excepted uid:
+
+  [bit3,bit2,bit1,bit0] or
+  [bit7,bit6,bit5,bit4]:
+
+	- [0,0,0,0] = LED OFF
+	- [0,1,0,1] = Red static ON
+	- [1,1,0,1] = Green static ON
+	- [0,1,1,0] = Red blink 3Hz
+	- [1,1,1,0] = Green blink 3Hz
+	- [0,1,1,1] = Red blink 6Hz
+	- [1,1,1,1] = Green blink 6Hz
+
+ Color mask for uid LED:
+  [bit3,bit2,bit1,bit0]:
+
+	- [0,0,0,0] = LED OFF
+	- [1,1,0,1] = Blue static ON
+	- [1,1,1,0] = Blue blink 3Hz
+	- [1,1,1,1] = Blue blink 6Hz
+
+Driver supports HW blinking at 3Hz and 6Hz frequency (50% duty cycle).
+For 3Hz duty cylce is about 167 msec, for 6Hz is about 83 msec.
diff --git a/Documentation/leds/leds-mlxcpld.txt b/Documentation/leds/leds-mlxcpld.txt
deleted file mode 100644
index a0e8fd457117..000000000000
--- a/Documentation/leds/leds-mlxcpld.txt
+++ /dev/null
@@ -1,110 +0,0 @@
-Kernel driver for Mellanox systems LEDs
-=======================================
-
-Provide system LED support for the nex Mellanox systems:
-"msx6710", "msx6720", "msb7700", "msn2700", "msx1410",
-"msn2410", "msb7800", "msn2740", "msn2100".
-
-Description
------------
-Driver provides the following LEDs for the systems "msx6710", "msx6720",
-"msb7700", "msn2700", "msx1410", "msn2410", "msb7800", "msn2740":
-  mlxcpld:fan1:green
-  mlxcpld:fan1:red
-  mlxcpld:fan2:green
-  mlxcpld:fan2:red
-  mlxcpld:fan3:green
-  mlxcpld:fan3:red
-  mlxcpld:fan4:green
-  mlxcpld:fan4:red
-  mlxcpld:psu:green
-  mlxcpld:psu:red
-  mlxcpld:status:green
-  mlxcpld:status:red
-
- "status"
-  CPLD reg offset: 0x20
-  Bits [3:0]
-
- "psu"
-  CPLD reg offset: 0x20
-  Bits [7:4]
-
- "fan1"
-  CPLD reg offset: 0x21
-  Bits [3:0]
-
- "fan2"
-  CPLD reg offset: 0x21
-  Bits [7:4]
-
- "fan3"
-  CPLD reg offset: 0x22
-  Bits [3:0]
-
- "fan4"
-  CPLD reg offset: 0x22
-  Bits [7:4]
-
- Color mask for all the above LEDs:
-  [bit3,bit2,bit1,bit0] or
-  [bit7,bit6,bit5,bit4]:
-	[0,0,0,0] = LED OFF
-	[0,1,0,1] = Red static ON
-	[1,1,0,1] = Green static ON
-	[0,1,1,0] = Red blink 3Hz
-	[1,1,1,0] = Green blink 3Hz
-	[0,1,1,1] = Red blink 6Hz
-	[1,1,1,1] = Green blink 6Hz
-
-Driver provides the following LEDs for the system "msn2100":
-  mlxcpld:fan:green
-  mlxcpld:fan:red
-  mlxcpld:psu1:green
-  mlxcpld:psu1:red
-  mlxcpld:psu2:green
-  mlxcpld:psu2:red
-  mlxcpld:status:green
-  mlxcpld:status:red
-  mlxcpld:uid:blue
-
- "status"
-  CPLD reg offset: 0x20
-  Bits [3:0]
-
- "fan"
-  CPLD reg offset: 0x21
-  Bits [3:0]
-
- "psu1"
-  CPLD reg offset: 0x23
-  Bits [3:0]
-
- "psu2"
-  CPLD reg offset: 0x23
-  Bits [7:4]
-
- "uid"
-  CPLD reg offset: 0x24
-  Bits [3:0]
-
- Color mask for all the above LEDs, excepted uid:
-  [bit3,bit2,bit1,bit0] or
-  [bit7,bit6,bit5,bit4]:
-	[0,0,0,0] = LED OFF
-	[0,1,0,1] = Red static ON
-	[1,1,0,1] = Green static ON
-	[0,1,1,0] = Red blink 3Hz
-	[1,1,1,0] = Green blink 3Hz
-	[0,1,1,1] = Red blink 6Hz
-	[1,1,1,1] = Green blink 6Hz
-
- Color mask for uid LED:
-  [bit3,bit2,bit1,bit0]:
-	[0,0,0,0] = LED OFF
-	[1,1,0,1] = Blue static ON
-	[1,1,1,0] = Blue blink 3Hz
-	[1,1,1,1] = Blue blink 6Hz
-
-Driver supports HW blinking at 3Hz and 6Hz frequency (50% duty cycle).
-For 3Hz duty cylce is about 167 msec, for 6Hz is about 83 msec.
diff --git a/Documentation/leds/ledtrig-oneshot.txt b/Documentation/leds/ledtrig-oneshot.rst
similarity index 90%
rename from Documentation/leds/ledtrig-oneshot.txt
rename to Documentation/leds/ledtrig-oneshot.rst
index fe57474a12e2..69fa3ea1d554 100644
--- a/Documentation/leds/ledtrig-oneshot.txt
+++ b/Documentation/leds/ledtrig-oneshot.rst
@@ -1,3 +1,4 @@
+====================
 One-shot LED Trigger
 ====================
 
@@ -17,27 +18,27 @@ additional "invert" property specifies if the LED has to stay off (normal) or
 on (inverted) when not rearmed.
 
 The trigger can be activated from user space on led class devices as shown
-below:
+below::
 
   echo oneshot > trigger
 
 This adds sysfs attributes to the LED that are documented in:
 Documentation/ABI/testing/sysfs-class-led-trigger-oneshot
 
-Example use-case: network devices, initialization:
+Example use-case: network devices, initialization::
 
   echo oneshot > trigger # set trigger for this led
   echo 33 > delay_on     # blink at 1 / (33 + 33) Hz on continuous traffic
   echo 33 > delay_off
 
-interface goes up:
+interface goes up::
 
   echo 1 > invert # set led as normally-on, turn the led on
 
-packet received/transmitted:
+packet received/transmitted::
 
   echo 1 > shot # led starts blinking, ignored if already blinking
 
-interface goes down
+interface goes down::
 
   echo 0 > invert # set led as normally-off, turn the led off
diff --git a/Documentation/leds/ledtrig-transient.txt b/Documentation/leds/ledtrig-transient.rst
similarity index 81%
rename from Documentation/leds/ledtrig-transient.txt
rename to Documentation/leds/ledtrig-transient.rst
index 3bd38b487df1..d921dc830cd0 100644
--- a/Documentation/leds/ledtrig-transient.txt
+++ b/Documentation/leds/ledtrig-transient.rst
@@ -1,3 +1,4 @@
+=====================
 LED Transient Trigger
 =====================
 
@@ -62,12 +63,13 @@ non-transient state. When driver gets suspended, irrespective of the transient
 state, the LED state changes to LED_OFF.
 
 Transient trigger can be enabled and disabled from user space on led class
-devices, that support this trigger as shown below:
+devices, that support this trigger as shown below::
 
-echo transient > trigger
-echo none > trigger
+	echo transient > trigger
+	echo none > trigger
 
-NOTE: Add a new property trigger state to control the state.
+NOTE:
+	Add a new property trigger state to control the state.
 
 This trigger exports three properties, activate, state, and duration. When
 transient trigger is activated these properties are set to default values.
@@ -79,7 +81,8 @@ transient trigger is activated these properties are set to default values.
 - state allows user to specify a transient state to be held for the specified
   duration.
 
-	activate - one shot timer activate mechanism.
+	activate
+	      - one shot timer activate mechanism.
 		1 when activated, 0 when deactivated.
 		default value is zero when transient trigger is enabled,
 		to allow duration to be set.
@@ -89,12 +92,14 @@ transient trigger is activated these properties are set to default values.
 		deactivated state indicates that there is no active timer
 		running.
 
-	duration - one shot timer value. When activate is set, duration value
+	duration
+	      - one shot timer value. When activate is set, duration value
 		is used to start a timer that runs once. This value doesn't
 		get changed by the trigger unless user does a set via
 		echo new_value > duration
 
-	state - transient state to be held. It has two values 0 or 1. 0 maps
+	state
+	      - transient state to be held. It has two values 0 or 1. 0 maps
 		to LED_OFF and 1 maps to LED_FULL. The specified state is
 		held for the duration of the one shot timer and then the
 		state gets changed to the non-transient state which is the
@@ -114,39 +119,49 @@ When timer expires activate goes back to deactivated state, duration is left
 at the set value to be used when activate is set at a future time. This will
 allow user app to set the time once and activate it to run it once for the
 specified value as needed. When timer expires, state is restored to the
-non-transient state which is the inverse of the transient state.
+non-transient state which is the inverse of the transient state:
 
-	echo 1 > activate - starts timer = duration when duration is not 0.
-	echo 0 > activate - cancels currently running timer.
-	echo n > duration - stores timer value to be used upon next
-                            activate. Currently active timer if
-                            any, continues to run for the specified time.
-	echo 0 > duration - stores timer value to be used upon next
-                            activate. Currently active timer if any,
-                            continues to run for the specified time.
-	echo 1 > state    - stores desired transient state LED_FULL to be
+	=================   ===============================================
+	echo 1 > activate   starts timer = duration when duration is not 0.
+	echo 0 > activate   cancels currently running timer.
+	echo n > duration   stores timer value to be used upon next
+			    activate. Currently active timer if
+			    any, continues to run for the specified time.
+	echo 0 > duration   stores timer value to be used upon next
+			    activate. Currently active timer if any,
+			    continues to run for the specified time.
+	echo 1 > state      stores desired transient state LED_FULL to be
 			    held for the specified duration.
-	echo 0 > state    - stores desired transient state LED_OFF to be
+	echo 0 > state      stores desired transient state LED_OFF to be
 			    held for the specified duration.
+	=================   ===============================================
+
+What is not supported
+=====================
 
-What is not supported:
-======================
 - Timer activation is one shot and extending and/or shortening the timer
   is not supported.
 
-Example use-case 1:
+Examples
+========
+
+use-case 1::
+
 	echo transient > trigger
 	echo n > duration
 	echo 1 > state
-repeat the following step as needed:
+
+repeat the following step as needed::
+
 	echo 1 > activate - start timer = duration to run once
 	echo 1 > activate - start timer = duration to run once
 	echo none > trigger
 
 This trigger is intended to be used for for the following example use cases:
+
  - Control of vibrate (phones, tablets etc.) hardware by user space app.
  - Use of LED by user space app as activity indicator.
  - Use of LED by user space app as a kind of watchdog indicator -- as
-       long as the app is alive, it can keep the LED illuminated, if it dies
-       the LED will be extinguished automatically.
+   long as the app is alive, it can keep the LED illuminated, if it dies
+   the LED will be extinguished automatically.
  - Use by any user space app that needs a transient GPIO output.
diff --git a/Documentation/leds/ledtrig-usbport.txt b/Documentation/leds/ledtrig-usbport.rst
similarity index 86%
rename from Documentation/leds/ledtrig-usbport.txt
rename to Documentation/leds/ledtrig-usbport.rst
index 69f54bfb4789..37c2505bfd57 100644
--- a/Documentation/leds/ledtrig-usbport.txt
+++ b/Documentation/leds/ledtrig-usbport.rst
@@ -1,3 +1,4 @@
+====================
 USB port LED trigger
 ====================
 
@@ -10,14 +11,18 @@ listed as separated entries in a "ports" subdirectory. Selecting is handled by
 echoing "1" to a chosen port.
 
 Please note that this trigger allows selecting multiple USB ports for a single
-LED. This can be useful in two cases:
+LED.
+
+This can be useful in two cases:
 
 1) Device with single USB LED and few physical ports
+====================================================
 
 In such a case LED will be turned on as long as there is at least one connected
 USB device.
 
 2) Device with a physical port handled by few controllers
+=========================================================
 
 Some devices may have one controller per PHY standard. E.g. USB 3.0 physical
 port may be handled by ohci-platform, ehci-platform and xhci-hcd. If there is
@@ -25,14 +30,14 @@ only one LED user will most likely want to assign ports from all 3 hubs.
 
 
 This trigger can be activated from user space on led class devices as shown
-below:
+below::
 
   echo usbport > trigger
 
 This adds sysfs attributes to the LED that are documented in:
 Documentation/ABI/testing/sysfs-class-led-trigger-usbport
 
-Example use-case:
+Example use-case::
 
   echo usbport > trigger
   echo 1 > ports/usb1-port1
diff --git a/Documentation/leds/uleds.txt b/Documentation/leds/uleds.rst
similarity index 95%
rename from Documentation/leds/uleds.txt
rename to Documentation/leds/uleds.rst
index 13e375a580f9..83221098009c 100644
--- a/Documentation/leds/uleds.txt
+++ b/Documentation/leds/uleds.rst
@@ -1,3 +1,4 @@
+==============
 Userspace LEDs
 ==============
 
@@ -10,12 +11,12 @@ Usage
 
 When the driver is loaded, a character device is created at /dev/uleds. To
 create a new LED class device, open /dev/uleds and write a uleds_user_dev
-structure to it (found in kernel public header file linux/uleds.h).
+structure to it (found in kernel public header file linux/uleds.h)::
 
     #define LED_MAX_NAME_SIZE 64
 
     struct uleds_user_dev {
-        char name[LED_MAX_NAME_SIZE];
+	char name[LED_MAX_NAME_SIZE];
     };
 
 A new LED class device will be created with the name given. The name can be
diff --git a/MAINTAINERS b/MAINTAINERS
index f8f2394f9e84..73000e7d7f19 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10172,7 +10172,7 @@ L:	linux-leds@vger.kernel.org
 S:	Supported
 F:	drivers/leds/leds-mlxcpld.c
 F:	drivers/leds/leds-mlxreg.c
-F:	Documentation/leds/leds-mlxcpld.txt
+F:	Documentation/leds/leds-mlxcpld.rst
 
 MELLANOX PLATFORM DRIVER
 M:	Vadim Pasternak <vadimp@mellanox.com>
diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index 7fa9d174a40c..ce9429ca6dde 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -15,7 +15,7 @@ config LEDS_TRIGGER_TIMER
 	  This allows LEDs to be controlled by a programmable timer
 	  via sysfs. Some LED hardware can be programmed to start
 	  blinking the LED without any further software interaction.
-	  For more details read Documentation/leds/leds-class.txt.
+	  For more details read Documentation/leds/leds-class.rst.
 
 	  If unsure, say Y.
 
diff --git a/drivers/leds/trigger/ledtrig-transient.c b/drivers/leds/trigger/ledtrig-transient.c
index a80bb82aacc2..80635183fac8 100644
--- a/drivers/leds/trigger/ledtrig-transient.c
+++ b/drivers/leds/trigger/ledtrig-transient.c
@@ -3,7 +3,7 @@
 // LED Kernel Transient Trigger
 //
 // Transient trigger allows one shot timer activation. Please refer to
-// Documentation/leds/ledtrig-transient.txt for details
+// Documentation/leds/ledtrig-transient.rst for details
 // Copyright (C) 2012 Shuah Khan <shuahkhan@gmail.com>
 //
 // Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index dd2af7be3eea..1837734ce85b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -906,7 +906,7 @@ config NETFILTER_XT_TARGET_LED
 	    echo netfilter-ssh > /sys/class/leds/<ledname>/trigger
 
 	  For more information on the LEDs available on your system, see
-	  Documentation/leds/leds-class.txt
+	  Documentation/leds/leds-class.rst
 
 config NETFILTER_XT_TARGET_LOG
 	tristate "LOG target support"
-- 
2.21.0

