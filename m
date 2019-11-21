Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFE681056CE
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 17:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfKUQSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 11:18:13 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:53351 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfKUQSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 11:18:13 -0500
Received: from orion.localdomain ([95.115.120.75]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MY60L-1iM0v62R4f-00YSvf; Thu, 21 Nov 2019 17:18:01 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     jikos@kernel.org, benjamin.tissoires@redhat.com,
        dmitry.torokhov@gmail.com, Jes.Sorensen@gmail.com,
        kvalo@codeaurora.org, johan@kernel.org,
        linux-input@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] drivers: usb: consolidate USB vendor IDs in one include file
Date:   Thu, 21 Nov 2019 17:17:42 +0100
Message-Id: <20191121161742.31435-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:m09Mu4opge9FH7x1/cOt9HjdwnEbIR+SFkI2Fyra51rBxLSO70b
 k+IgC1ek13z1XMuhR4XpRYBp7Su+15oGqe6ZD4yo8bszSP4MJ9ukiM2XEDqvZ4zwl0fQr17
 oKDgNxprYt5YEzr8StWcryFD7zwxnYHCWMtRvb0Jt1nIss+pZrkfQ5gFiTuBfaPt0TwUTZv
 +qiaf8OmgcZjF3ONtkYIA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qxvFVnioYPQ=:Sx9gB/1+V8KUZvcurQf9yX
 lbUzaAEhRwI665kTaQzKgkFN0vcwG2bD0CaSpENJ58+o80RC7ArfljGUzNgs9tPBcCGjUtUw3
 eXD0TmM4mhfgbaPDJYXbUJULzwzmiGsjNAyOPz//jStIPewAXkbJaeU0vpTNkjQIEB4rLBk0a
 4HIrA5gTQ1/NcyFZ6HBVI6j8O9iE2XK/fjgs6JhmcMjxTAWcRcckR7JSsmjJzwYiHzSVIWd44
 i04+6xpXC2DSEVqfbzmOucbKBFKb+5QspgAv9IwwwX6chF01+ko3/efbOAhN077NAABrZ2DeT
 N7lY6G9LkgCn/bJOdycoiE1vO6f0nEQLLN8+kxfhtlq/wqRN14S35Q5Hx0F0C6cv4SLSybPpX
 tVjo+5FWtZGPnBtEd7a1lDvIKufPuh51BfmrMLPgr32Xbaqshf5f/1qWiAz/6DvxS4x6NUCaN
 IBz2UuBO0iecZZ3WqsKi8G4OioF7V5JSIUBvXdUV5E/zHbxykphGLqpPq0YCdEdApBJHfiBPc
 hSnbD4XIs5aN9QOWHswBKxw4m7wuUST9F2IYOzrXvwe5H3WcggXd/Q/NsQiyp7x7peeN6D20h
 ufOgbte1HDSThNrtKvxGw8qsaljRszfY0mYBtoLha6NQCRboOXIftuvALeciPXMt226L+EDBV
 1V47u0Aqlg1UjLy9kafiweM7ntN7k07lUXAt+rkb9rdpf2mOMxkOjggLiz0avOT9fEmDygHze
 KBrpv6POjoBmowDsftNZsqv9LBJirmCykayEoJNsfv05c6YYHvYe8f48WWbEqURrFnmNN1R5W
 YurtzSsCAcvU8nw/U+OqRmgaVf7MuXICMF20NC8AJIR8gN3gUXzxmA6yS+Jg9C3+g4OMGDIh1
 RYhJk4Sn8DnL0jc153Fg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of redefining usb vendor IDs in several places, consolidate
into one include file: include/linux/usb/usb_ids.h

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 drivers/hid/hid-ids.h                              | 15 ++------------
 drivers/hid/wacom.h                                |  4 +---
 drivers/input/joydev.c                             |  5 +----
 drivers/input/mouse/bcm5974.c                      |  3 +--
 drivers/input/mouse/synaptics_usb.c                |  2 +-
 drivers/input/tablet/aiptek.c                      |  3 +--
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  2 +-
 drivers/usb/serial/io_usbvend.h                    |  1 -
 include/linux/usb/usb_ids.h                        | 24 ++++++++++++++++++++++
 9 files changed, 32 insertions(+), 27 deletions(-)
 create mode 100644 include/linux/usb/usb_ids.h

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 447e8db21174..7520800da1e4 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -14,6 +14,8 @@
 #ifndef HID_IDS_H_FILE
 #define HID_IDS_H_FILE
 
+#include <linux/usb/usb_ids.h>
+
 #define USB_VENDOR_ID_258A		0x258a
 #define USB_DEVICE_ID_258A_6A88		0x6a88
 
@@ -46,7 +48,6 @@
 #define USB_VENDOR_ID_AFATECH		0x15a4
 #define USB_DEVICE_ID_AFATECH_AF9016	0x9016
 
-#define USB_VENDOR_ID_AIPTEK		0x08ca
 #define USB_DEVICE_ID_AIPTEK_01		0x0001
 #define USB_DEVICE_ID_AIPTEK_10		0x0010
 #define USB_DEVICE_ID_AIPTEK_20		0x0020
@@ -89,7 +90,6 @@
 #define USB_VENDOR_ID_ANTON		0x1130
 #define USB_DEVICE_ID_ANTON_TOUCH_PAD	0x3101
 
-#define USB_VENDOR_ID_APPLE		0x05ac
 #define BT_VENDOR_ID_APPLE		0x004c
 #define USB_DEVICE_ID_APPLE_MIGHTYMOUSE	0x0304
 #define USB_DEVICE_ID_APPLE_MAGICMOUSE	0x030d
@@ -658,7 +658,6 @@
 #define USB_VENDOR_ID_KEYTOUCH		0x0926
 #define USB_DEVICE_ID_KEYTOUCH_IEC	0x3333
 
-#define USB_VENDOR_ID_KYE		0x0458
 #define USB_DEVICE_ID_KYE_ERGO_525V	0x0087
 #define USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE	0x0138
 #define USB_DEVICE_ID_GENIUS_MANTICORE	0x0153
@@ -715,7 +714,6 @@
 #define USB_DEVICE_ID_LD_HYBRID		0x2090
 #define USB_DEVICE_ID_LD_HEATCONTROL	0x20A0
 
-#define USB_VENDOR_ID_LENOVO		0x17ef
 #define USB_DEVICE_ID_LENOVO_TPKBD	0x6009
 #define USB_DEVICE_ID_LENOVO_CUSBKBD	0x6047
 #define USB_DEVICE_ID_LENOVO_CBTKBD	0x6048
@@ -963,7 +961,6 @@
 #define USB_VENDOR_ID_RAZER            0x1532
 #define USB_DEVICE_ID_RAZER_BLADE_14   0x011D
 
-#define USB_VENDOR_ID_REALTEK		0x0bda
 #define USB_DEVICE_ID_REALTEK_READER	0x0152
 
 #define USB_VENDOR_ID_RETROUSB		0xf000
@@ -1029,8 +1026,6 @@
 #define USB_DEVICE_ID_SMK_NSG_MR5U_REMOTE       0x0368
 #define USB_DEVICE_ID_SMK_NSG_MR7U_REMOTE       0x0369
 
-
-#define USB_VENDOR_ID_SONY			0x054c
 #define USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE	0x024b
 #define USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE	0x0374
 #define USB_DEVICE_ID_SONY_PS3_BDREMOTE		0x0306
@@ -1082,7 +1077,6 @@
 #define USB_DEVICE_ID_SYMBOL_SCANNER_2	0x1300
 #define USB_DEVICE_ID_SYMBOL_SCANNER_3	0x1200
 
-#define USB_VENDOR_ID_SYNAPTICS		0x06cb
 #define USB_DEVICE_ID_SYNAPTICS_TP	0x0001
 #define USB_DEVICE_ID_SYNAPTICS_INT_TP	0x0002
 #define USB_DEVICE_ID_SYNAPTICS_CPAD	0x0003
@@ -1105,12 +1099,8 @@
 #define USB_VENDOR_ID_THINGM		0x27b8
 #define USB_DEVICE_ID_BLINK1		0x01ed
 
-#define USB_VENDOR_ID_THQ		0x20d6
-#define USB_DEVICE_ID_THQ_PS3_UDRAW	0xcb17
-
 #define USB_VENDOR_ID_THRUSTMASTER	0x044f
 
-#define USB_VENDOR_ID_TIVO		0x150a
 #define USB_DEVICE_ID_TIVO_SLIDE_BT	0x1200
 #define USB_DEVICE_ID_TIVO_SLIDE	0x1201
 #define USB_DEVICE_ID_TIVO_SLIDE_PRO	0x1203
@@ -1180,7 +1170,6 @@
 #define USB_VENDOR_ID_VTL		0x0306
 #define USB_DEVICE_ID_VTL_MULTITOUCH_FF3F	0xff3f
 
-#define USB_VENDOR_ID_WACOM		0x056a
 #define USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH	0x81
 #define USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH   0x00BD
 
diff --git a/drivers/hid/wacom.h b/drivers/hid/wacom.h
index 203d27d198b8..86d08f70184f 100644
--- a/drivers/hid/wacom.h
+++ b/drivers/hid/wacom.h
@@ -90,6 +90,7 @@
 #include <linux/kfifo.h>
 #include <linux/leds.h>
 #include <linux/usb/input.h>
+#include <linux/usb/usb_ids.h>
 #include <linux/power_supply.h>
 #include <asm/unaligned.h>
 
@@ -100,9 +101,6 @@
 #define DRIVER_AUTHOR "Vojtech Pavlik <vojtech@ucw.cz>"
 #define DRIVER_DESC "USB Wacom tablet driver"
 
-#define USB_VENDOR_ID_WACOM	0x056a
-#define USB_VENDOR_ID_LENOVO	0x17ef
-
 enum wacom_worker {
 	WACOM_WORKER_WIRELESS,
 	WACOM_WORKER_BATTERY,
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index a2b5fbba2d3b..49a93f445b3b 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/cdev.h>
+#include <linux/usb/usb_ids.h>
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Joystick device interfaces");
@@ -747,15 +748,11 @@ static void joydev_cleanup(struct joydev *joydev)
  * These codes are copied from from hid-ids.h, unfortunately there is no common
  * usb_ids/bt_ids.h header.
  */
-#define USB_VENDOR_ID_SONY			0x054c
 #define USB_DEVICE_ID_SONY_PS3_CONTROLLER		0x0268
 #define USB_DEVICE_ID_SONY_PS4_CONTROLLER		0x05c4
 #define USB_DEVICE_ID_SONY_PS4_CONTROLLER_2		0x09cc
 #define USB_DEVICE_ID_SONY_PS4_CONTROLLER_DONGLE	0x0ba0
 
-#define USB_VENDOR_ID_THQ			0x20d6
-#define USB_DEVICE_ID_THQ_PS3_UDRAW			0xcb17
-
 #define ACCEL_DEV(vnd, prd)						\
 	{								\
 		.flags = INPUT_DEVICE_ID_MATCH_VENDOR |			\
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 59a14505b9cd..e00c5133ad05 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -24,12 +24,11 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/usb/input.h>
+#include <linux/usb/usb_ids.h>
 #include <linux/hid.h>
 #include <linux/mutex.h>
 #include <linux/input/mt.h>
 
-#define USB_VENDOR_ID_APPLE		0x05ac
-
 /* MacbookAir, aka wellspring */
 #define USB_DEVICE_ID_APPLE_WELLSPRING_ANSI	0x0223
 #define USB_DEVICE_ID_APPLE_WELLSPRING_ISO	0x0224
diff --git a/drivers/input/mouse/synaptics_usb.c b/drivers/input/mouse/synaptics_usb.c
index b5ff27e32a0c..010f13d803b4 100644
--- a/drivers/input/mouse/synaptics_usb.c
+++ b/drivers/input/mouse/synaptics_usb.c
@@ -39,10 +39,10 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/usb.h>
+#include <linux/usb/usb_ids.h>
 #include <linux/input.h>
 #include <linux/usb/input.h>
 
-#define USB_VENDOR_ID_SYNAPTICS	0x06cb
 #define USB_DEVICE_ID_SYNAPTICS_TP	0x0001	/* Synaptics USB TouchPad */
 #define USB_DEVICE_ID_SYNAPTICS_INT_TP	0x0002	/* Integrated USB TouchPad */
 #define USB_DEVICE_ID_SYNAPTICS_CPAD	0x0003	/* Synaptics cPad */
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 2ca586fb914f..c1cde51a6929 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -62,6 +62,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/usb/input.h>
+#include <linux/usb/usb_ids.h>
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -162,8 +163,6 @@
  * (Step 9 can be omitted, but you'll then have no function keys.)
  */
 
-#define USB_VENDOR_ID_AIPTEK				0x08ca
-#define USB_VENDOR_ID_KYE				0x0458
 #define USB_REQ_GET_REPORT				0x01
 #define USB_REQ_SET_REPORT				0x09
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index c6c41fb962ff..44ffbab12b7e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/usb.h>
+#include <linux/usb/usb_ids.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -64,7 +65,6 @@ MODULE_PARM_DESC(dma_agg_timeout, "Set DMA aggregation timeout (range 1-127)");
 module_param_named(dma_agg_pages, rtl8xxxu_dma_agg_pages, int, 0600);
 MODULE_PARM_DESC(dma_agg_pages, "Set DMA aggregation pages (range 1-127, 0 to disable)");
 
-#define USB_VENDOR_ID_REALTEK		0x0bda
 #define RTL8XXXU_RX_URBS		32
 #define RTL8XXXU_RX_URB_PENDING_WATER	8
 #define RTL8XXXU_TX_URBS		64
diff --git a/drivers/usb/serial/io_usbvend.h b/drivers/usb/serial/io_usbvend.h
index c38e87ac5ea9..b94c69207bc3 100644
--- a/drivers/usb/serial/io_usbvend.h
+++ b/drivers/usb/serial/io_usbvend.h
@@ -26,7 +26,6 @@
 //
 
 #define	USB_VENDOR_ID_ION	0x1608		// Our VID
-#define	USB_VENDOR_ID_TI	0x0451		// TI VID
 #define USB_VENDOR_ID_AXIOHM	0x05D9		/* Axiohm VID */
 
 //
diff --git a/include/linux/usb/usb_ids.h b/include/linux/usb/usb_ids.h
new file mode 100644
index 000000000000..d72c1bfa8621
--- /dev/null
+++ b/include/linux/usb/usb_ids.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *	USB Vendor and Device IDs
+ *
+ */
+#ifndef _LINUX_USB_IDS_H
+#define _LINUX_USB_IDS_H
+
+#define USB_VENDOR_ID_AIPTEK		0x08ca
+#define USB_VENDOR_ID_APPLE		0x05ac
+#define USB_VENDOR_ID_KYE		0x0458
+#define USB_VENDOR_ID_LENOVO		0x17ef
+#define USB_VENDOR_ID_REALTEK		0x0bda
+#define USB_VENDOR_ID_SONY		0x054c
+#define USB_VENDOR_ID_SYNAPTICS		0x06cb
+
+#define USB_VENDOR_ID_THQ		0x20d6
+#define USB_DEVICE_ID_THQ_PS3_UDRAW	0xcb17
+
+#define USB_VENDOR_ID_TI		0x0451
+#define USB_VENDOR_ID_TIVO		0x150a
+#define USB_VENDOR_ID_WACOM		0x056a
+
+#endif /* _LINUX_USB_IDS_H */
-- 
2.11.0

