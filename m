Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3515E20DF0E
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbgF2Ubx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:31:53 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:60912 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732478AbgF2Ubv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 16:31:51 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 29768BC140;
        Mon, 29 Jun 2020 20:31:33 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     corbet@lwn.net, aaro.koskinen@iki.fi, tony@atomide.com,
        linux@armlinux.org.uk, daniel@zonque.org, haojian.zhuang@gmail.com,
        robert.jarzmik@free.fr, kgene@kernel.org, krzk@kernel.org,
        dmitry.torokhov@gmail.com, lee.jones@linaro.org,
        wsa+renesas@sang-engineering.com, ulf.hansson@linaro.org,
        davem@davemloft.net, kuba@kernel.org, b.zolnierkie@samsung.com,
        j.neuschaefer@gmx.net, mchehab+samsung@kernel.org,
        gustavo@embeddedor.com, gregkh@linuxfoundation.org,
        yanaijie@huawei.com, daniel.vetter@ffwll.ch,
        rafael.j.wysocki@intel.com, Julia.Lawall@inria.fr,
        linus.walleij@linaro.org, viresh.kumar@linaro.org, arnd@arndb.de,
        jani.nikula@intel.com, yuehaibing@huawei.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] Remove handhelds.org links and email addresses
Date:   Mon, 29 Jun 2020 22:31:21 +0200
Message-Id: <20200629203121.7892-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++
X-Spam-Level: **
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
https://lore.kernel.org/linux-doc/20200626110706.7b5d4a38@lwn.net/

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 @Jon I thought about what I said and *no*, unfortunately I *can't* automate
 the detection of such as easy as the HTTPSifying. As you maybe see below
 cleaning up is even "harder".

 We have only 17 files and one domain here. Shall I split it up per subsystem
 or can we let it as is?

 Documentation/arm/sa1100/assabet.rst           |  2 --
 Documentation/arm/samsung-s3c24xx/h1940.rst    | 10 ----------
 Documentation/arm/samsung-s3c24xx/overview.rst |  3 +--
 Documentation/arm/samsung-s3c24xx/smdk2440.rst |  4 ----
 arch/arm/mach-omap1/Kconfig                    |  4 +---
 arch/arm/mach-pxa/h5000.c                      |  2 +-
 arch/arm/mach-s3c24xx/mach-h1940.c             |  2 --
 arch/arm/mach-s3c24xx/mach-n30.c               |  3 ---
 arch/arm/mach-s3c24xx/mach-rx3715.c            |  2 --
 drivers/input/keyboard/gpio_keys.c             |  2 +-
 drivers/input/keyboard/jornada720_kbd.c        |  2 +-
 drivers/input/touchscreen/jornada720_ts.c      |  2 +-
 drivers/mfd/asic3.c                            |  2 +-
 drivers/mmc/host/renesas_sdhi_core.c           |  2 +-
 drivers/net/ethernet/dec/tulip/de4x5.c         |  1 -
 drivers/video/fbdev/sa1100fb.c                 |  2 +-
 include/linux/apm-emulation.h                  |  2 --
 17 files changed, 9 insertions(+), 38 deletions(-)

diff --git a/Documentation/arm/sa1100/assabet.rst b/Documentation/arm/sa1100/assabet.rst
index a761e128fb08..c9e75ae3f077 100644
--- a/Documentation/arm/sa1100/assabet.rst
+++ b/Documentation/arm/sa1100/assabet.rst
@@ -32,7 +32,6 @@ BLOB (http://www.lartmaker.nl/lartware/blob/)
    patches were merged into BLOB to add support for Assabet.
 
 Compaq's Bootldr + John Dorsey's patch for Assabet support
-(http://www.handhelds.org/Compaq/bootldr.html)
 (http://www.wearablegroup.org/software/bootldr/)
 
    Bootldr is the bootloader developed by Compaq for the iPAQ Pocket PC.
@@ -54,7 +53,6 @@ precompiled RedBoot binary is available from the following location:
 
 - ftp://ftp.netwinder.org/users/n/nico/
 - ftp://ftp.arm.linux.org.uk/pub/linux/arm/people/nico/
-- ftp://ftp.handhelds.org/pub/linux/arm/sa-1100-patches/
 
 Look for redboot-assabet*.tgz.  Some installation infos are provided in
 redboot-assabet*.txt.
diff --git a/Documentation/arm/samsung-s3c24xx/h1940.rst b/Documentation/arm/samsung-s3c24xx/h1940.rst
index 62a562c178e3..e7ce61ada9ee 100644
--- a/Documentation/arm/samsung-s3c24xx/h1940.rst
+++ b/Documentation/arm/samsung-s3c24xx/h1940.rst
@@ -2,8 +2,6 @@
 HP IPAQ H1940
 =============
 
-http://www.handhelds.org/projects/h1940.html
-
 Introduction
 ------------
 
@@ -16,14 +14,6 @@ Support
 
   A variety of information is available
 
-  handhelds.org project page:
-
-    http://www.handhelds.org/projects/h1940.html
-
-  handhelds.org wiki page:
-
-    http://handhelds.org/moin/moin.cgi/HpIpaqH1940
-
   Herbert Pötzl pages:
 
     http://vserver.13thfloor.at/H1940/
diff --git a/Documentation/arm/samsung-s3c24xx/overview.rst b/Documentation/arm/samsung-s3c24xx/overview.rst
index e9a1dc7276b5..ed17c2a86edf 100644
--- a/Documentation/arm/samsung-s3c24xx/overview.rst
+++ b/Documentation/arm/samsung-s3c24xx/overview.rst
@@ -113,8 +113,7 @@ Machines
 
   Acer N30
 
-    A S3C2410 based PDA from Acer.  There is a Wiki page at
-    http://handhelds.org/moin/moin.cgi/AcerN30Documentation .
+    A S3C2410 based PDA from Acer.
 
   AML M5900
 
diff --git a/Documentation/arm/samsung-s3c24xx/smdk2440.rst b/Documentation/arm/samsung-s3c24xx/smdk2440.rst
index 524fd0b4afaf..c2681815e585 100644
--- a/Documentation/arm/samsung-s3c24xx/smdk2440.rst
+++ b/Documentation/arm/samsung-s3c24xx/smdk2440.rst
@@ -25,10 +25,6 @@ Support
   Ben Dooks' SMDK2440 site at http://www.fluff.org/ben/smdk2440/ which
   includes linux based USB download tools.
 
-  Some of the h1940 patches that can be found from the H1940 project
-  site at http://www.handhelds.org/projects/h1940.html can also be
-  applied to this board.
-
 
 Peripherals
 -----------
diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 948da556162e..8631a2f4e746 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -145,9 +145,7 @@ config MACH_SX1
 	help
 	  Support for the Siemens SX1 phone. To boot the kernel,
 	  you'll need a SX1 compatible bootloader; check out
-	  http://forum.oslik.ru and
-	  http://www.handhelds.org/moin/moin.cgi/SiemensSX1
-	  for more information.
+	  http://forum.oslik.ru for more information.
 	  Say Y here if you have such a phone, say NO otherwise.
 
 config MACH_NOKIA770
diff --git a/arch/arm/mach-pxa/h5000.c b/arch/arm/mach-pxa/h5000.c
index ece1e71c90a9..679aa780b004 100644
--- a/arch/arm/mach-pxa/h5000.c
+++ b/arch/arm/mach-pxa/h5000.c
@@ -4,7 +4,7 @@
  *
  * Copyright 2000-2003  Hewlett-Packard Company.
  * Copyright 2002       Jamey Hicks <jamey.hicks@hp.com>
- * Copyright 2004-2005  Phil Blundell <pb@handhelds.org>
+ * Copyright 2004-2005  Phil Blundell
  * Copyright 2007-2008  Anton Vorontsov <cbouatmailru@gmail.com>
  *
  * COMPAQ COMPUTER CORPORATION MAKES NO WARRANTIES, EXPRESSED OR IMPLIED,
diff --git a/arch/arm/mach-s3c24xx/mach-h1940.c b/arch/arm/mach-s3c24xx/mach-h1940.c
index e1c372e5447b..da8debc28282 100644
--- a/arch/arm/mach-s3c24xx/mach-h1940.c
+++ b/arch/arm/mach-s3c24xx/mach-h1940.c
@@ -2,8 +2,6 @@
 //
 // Copyright (c) 2003-2005 Simtec Electronics
 //   Ben Dooks <ben@simtec.co.uk>
-//
-// http://www.handhelds.org/projects/h1940.html
 
 #include <linux/kernel.h>
 #include <linux/types.h>
diff --git a/arch/arm/mach-s3c24xx/mach-n30.c b/arch/arm/mach-s3c24xx/mach-n30.c
index d856f23939af..210cadfd8168 100644
--- a/arch/arm/mach-s3c24xx/mach-n30.c
+++ b/arch/arm/mach-s3c24xx/mach-n30.c
@@ -7,9 +7,6 @@
 //	Ben Dooks <ben@simtec.co.uk>
 //
 // Copyright (c) 2005-2008 Christer Weinigel <christer@weinigel.se>
-//
-// There is a wiki with more information about the n30 port at
-// http://handhelds.org/moin/moin.cgi/AcerN30Documentation .
 
 #include <linux/kernel.h>
 #include <linux/types.h>
diff --git a/arch/arm/mach-s3c24xx/mach-rx3715.c b/arch/arm/mach-s3c24xx/mach-rx3715.c
index 529c6faf862f..669b96ec79a7 100644
--- a/arch/arm/mach-s3c24xx/mach-rx3715.c
+++ b/arch/arm/mach-s3c24xx/mach-rx3715.c
@@ -2,8 +2,6 @@
 //
 // Copyright (c) 2003-2004 Simtec Electronics
 //	Ben Dooks <ben@simtec.co.uk>
-//
-// http://www.handhelds.org/projects/rx3715.html
 
 #include <linux/kernel.h>
 #include <linux/types.h>
diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 53c9ff338dea..f455f6efdd26 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -1032,6 +1032,6 @@ late_initcall(gpio_keys_init);
 module_exit(gpio_keys_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Phil Blundell <pb@handhelds.org>");
+MODULE_AUTHOR("Phil Blundell");
 MODULE_DESCRIPTION("Keyboard driver for GPIOs");
 MODULE_ALIAS("platform:gpio-keys");
diff --git a/drivers/input/keyboard/jornada720_kbd.c b/drivers/input/keyboard/jornada720_kbd.c
index cd9af5221c3d..6c1ca741a405 100644
--- a/drivers/input/keyboard/jornada720_kbd.c
+++ b/drivers/input/keyboard/jornada720_kbd.c
@@ -9,7 +9,7 @@
  *    Copyright (C) 2006 jornada 720 kbd driver by
 		Filip Zyzniewsk <Filip.Zyzniewski@tefnet.plX
  *     based on (C) 2004 jornada 720 kbd driver by
-		Alex Lange <chicken@handhelds.org>
+		Alex Lange
  */
 #include <linux/device.h>
 #include <linux/errno.h>
diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index 974521102178..be17592b431c 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2007 Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
  *
  *  Copyright (C) 2006 Filip Zyzniewski <filip.zyzniewski@tefnet.pl>
- *  based on HP Jornada 56x touchscreen driver by Alex Lange <chicken@handhelds.org>
+ *  based on HP Jornada 56x touchscreen driver by Alex Lange
  *
  * HP Jornada 710/720/729 Touchscreen Driver
  */
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index a6bd2134cea2..e9fdc402eddd 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -8,7 +8,7 @@
  * Copyright 2004-2005 Phil Blundell
  * Copyright 2007-2008 OpenedHand Ltd.
  *
- * Authors: Phil Blundell <pb@handhelds.org>,
+ * Authors: Phil Blundell,
  *	    Samuel Ortiz <sameo@openedhand.com>
  */
 
diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 15e21894bd44..1fc640fa4784 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -13,7 +13,7 @@
  * Copyright 2004-2005 Phil Blundell
  * Copyright 2007-2008 OpenedHand Ltd.
  *
- * Authors: Phil Blundell <pb@handhelds.org>,
+ * Authors: Phil Blundell,
  *	    Samuel Ortiz <sameo@openedhand.com>
  *
  */
diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 0ccd9994ad45..3f0e5cdb538f 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -435,7 +435,6 @@
                            case a PCI bridge (DEC chip 21152). The value of
                            'pb' is now only initialized if a de4x5 chip is
                            present.
-                           <france@handhelds.org>
       0.547  08-Nov-01    Use library crc32 functions by <Matt_Domsch@dell.com>
       0.548  30-Aug-03    Big 2.6 cleanup. Ported to PCI/EISA probing and
                            generic DMA APIs. Fixed DE425 support on Alpha.
diff --git a/drivers/video/fbdev/sa1100fb.c b/drivers/video/fbdev/sa1100fb.c
index 3e6e13f7a831..0d273b02cba0 100644
--- a/drivers/video/fbdev/sa1100fb.c
+++ b/drivers/video/fbdev/sa1100fb.c
@@ -144,7 +144,7 @@
  *	  manufactured by Prime View, model no V16C6448AB
  *
  * 2001/07/23: <rmk@arm.linux.org.uk>
- *	- Hand merge version from handhelds.org CVS tree.  See patch
+ *	- Hand merge version from CVS tree.  See patch
  *	  notes for 595/1 for more information.
  *	- Drop 12bpp (it's 16bpp with different colour register mappings).
  *	- This hardware can not do direct colour.  Therefore we don't
diff --git a/include/linux/apm-emulation.h b/include/linux/apm-emulation.h
index 94c036957948..b5d63358c61b 100644
--- a/include/linux/apm-emulation.h
+++ b/include/linux/apm-emulation.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /* -*- linux-c -*-
- *
- * (C) 2003 zecke@handhelds.org
  *
  * based on arch/arm/kernel/apm.c
  * factor out the information needed by architectures to provide
-- 
2.27.0

