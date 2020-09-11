Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC78266534
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgIKQz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbgIKPFb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 11:05:31 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71F9D222B9;
        Fri, 11 Sep 2020 14:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599834838;
        bh=p6R2ZHw5cWO8+UxCFv3CDcDXbeixyPGmxEmclz93WA4=;
        h=From:To:Subject:Date:From;
        b=I3tY2ky+hfQbfbyI967PcwUAmFKbSmAZZ1muhVWqDdahxCi/e7Sn3d817K6qSSdbB
         XLmjr5hb2qlBvpbG29VNR1EFRTzNto8894L2QbcQaQAEyqkFVkJK2T2kgyu9qujjyJ
         aMM7iK3GzwdS28Qq4i1xMKf/ai8qS0nRitsSxqs8=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>, Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/3] Documentation: Update paths of Samsung S3C machine files
Date:   Fri, 11 Sep 2020 16:33:41 +0200
Message-Id: <20200911143343.498-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation references Samsung S3C24xx and S3C64xx machine files in
multiple places but the files were traveling around the kernel multiple
times.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  2 +-
 Documentation/arm/samsung-s3c24xx/gpio.rst    |  4 ++--
 .../arm/samsung-s3c24xx/overview.rst          | 22 ++++++-------------
 .../arm/samsung-s3c24xx/usb-host.rst          |  6 ++---
 Documentation/arm/samsung/gpio.rst            |  3 +--
 .../ethernet/davicom/dm9000.rst               |  2 +-
 6 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 5debfe238027..6ac5d6dc106c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2943,7 +2943,7 @@
 	mtdset=		[ARM]
 			ARM/S3C2412 JIVE boot control
 
-			See arch/arm/mach-s3c2412/mach-jive.c
+			See arch/arm/mach-s3c/mach-jive.c
 
 	mtouchusb.raw_coordinates=
 			[HW] Make the MicroTouch USB driver use raw coordinates
diff --git a/Documentation/arm/samsung-s3c24xx/gpio.rst b/Documentation/arm/samsung-s3c24xx/gpio.rst
index f7c3d7d011a2..f4a8c800a457 100644
--- a/Documentation/arm/samsung-s3c24xx/gpio.rst
+++ b/Documentation/arm/samsung-s3c24xx/gpio.rst
@@ -29,7 +29,7 @@ GPIOLIB
 
   The following functions now either have a `s3c_` specific variant
   or are merged into gpiolib. See the definitions in
-  arch/arm/plat-samsung/include/plat/gpio-cfg.h:
+  arch/arm/mach-s3c/gpio-cfg.h:
 
   - s3c2410_gpio_setpin()	gpio_set_value() or gpio_direction_output()
   - s3c2410_gpio_getpin()	gpio_get_value() or gpio_direction_input()
@@ -86,7 +86,7 @@ between the calls.
 Headers
 -------
 
-  See arch/arm/mach-s3c24xx/include/mach/regs-gpio.h for the list
+  See arch/arm/mach-s3c/regs-gpio-s3c24xx.h for the list
   of GPIO pins, and the configuration values for them. This
   is included by using #include <mach/regs-gpio.h>
 
diff --git a/Documentation/arm/samsung-s3c24xx/overview.rst b/Documentation/arm/samsung-s3c24xx/overview.rst
index e9a1dc7276b5..14535e5cffb7 100644
--- a/Documentation/arm/samsung-s3c24xx/overview.rst
+++ b/Documentation/arm/samsung-s3c24xx/overview.rst
@@ -18,7 +18,7 @@ Introduction
   versions.
 
   The S3C2416 and S3C2450 devices are very similar and S3C2450 support is
-  included under the arch/arm/mach-s3c2416 directory. Note, while core
+  included under the arch/arm/mach-s3c directory. Note, while core
   support for these SoCs is in, work on some of the extra peripherals
   and extra interrupts is still ongoing.
 
@@ -37,19 +37,11 @@ Configuration
 Layout
 ------
 
-  The core support files are located in the platform code contained in
-  arch/arm/plat-s3c24xx with headers in include/asm-arm/plat-s3c24xx.
-  This directory should be kept to items shared between the platform
-  code (arch/arm/plat-s3c24xx) and the arch/arm/mach-s3c24* code.
+  The core support files, register, kernel and paltform data are located in the
+  platform code contained in arch/arm/mach-s3c with headers in
+  arch/arm/mach-s3c/include
 
-  Each cpu has a directory with the support files for it, and the
-  machines that carry the device. For example S3C2410 is contained
-  in arch/arm/mach-s3c2410 and S3C2440 in arch/arm/mach-s3c2440
-
-  Register, kernel and platform data definitions are held in the
-  arch/arm/mach-s3c2410 directory./include/mach
-
-arch/arm/plat-s3c24xx:
+arch/arm/mach-s3c:
 
   Files in here are either common to all the s3c24xx family,
   or are common to only some of them with names to indicate this
@@ -134,7 +126,7 @@ Adding New Machines
   should keep this in mind before altering items outside of their own
   machine files.
 
-  Machine definitions should be kept in linux/arch/arm/mach-s3c2410,
+  Machine definitions should be kept in arch/arm/mach-s3c,
   and there are a number of examples that can be looked at.
 
   Read the kernel patch submission policies as well as the
@@ -293,7 +285,7 @@ Platform Data
 	}
 
 	Note, since the code is marked as __init, it should not be
-	exported outside arch/arm/mach-s3c2410/, or exported to
+	exported outside arch/arm/mach-s3c/, or exported to
 	modules via EXPORT_SYMBOL() and related functions.
 
 
diff --git a/Documentation/arm/samsung-s3c24xx/usb-host.rst b/Documentation/arm/samsung-s3c24xx/usb-host.rst
index c84268bd1884..7aaffac89e04 100644
--- a/Documentation/arm/samsung-s3c24xx/usb-host.rst
+++ b/Documentation/arm/samsung-s3c24xx/usb-host.rst
@@ -36,7 +36,7 @@ Board Support
 -------------
 
   The driver attaches to a platform device, which will need to be
-  added by the board specific support file in linux/arch/arm/mach-s3c2410,
+  added by the board specific support file in arch/arm/mach-s3c,
   such as mach-bast.c or mach-smdk2410.c
 
   The platform device's platform_data field is only needed if the
@@ -51,9 +51,9 @@ Board Support
 Platform Data
 -------------
 
-  See arch/arm/mach-s3c2410/include/mach/usb-control.h for the
+  See include/linux/platform_data/usb-ohci-s3c2410.h for the
   descriptions of the platform device data. An implementation
-  can be found in linux/arch/arm/mach-s3c2410/usb-simtec.c .
+  can be found in arch/arm/mach-s3c/simtec-usb.c .
 
   The `struct s3c2410_hcd_info` contains a pair of functions
   that get called to enable over-current detection, and to
diff --git a/Documentation/arm/samsung/gpio.rst b/Documentation/arm/samsung/gpio.rst
index 5f7cadd7159e..f6e27b07c993 100644
--- a/Documentation/arm/samsung/gpio.rst
+++ b/Documentation/arm/samsung/gpio.rst
@@ -37,5 +37,4 @@ implementation to configure pins as necessary.
 The s3c_gpio_cfgpin() and s3c_gpio_setpull() provide the means for a
 driver or machine to change gpio configuration.
 
-See arch/arm/plat-samsung/include/plat/gpio-cfg.h for more information
-on these functions.
+See arch/arm/mach-s3c/gpio-cfg.h for more information on these functions.
diff --git a/Documentation/networking/device_drivers/ethernet/davicom/dm9000.rst b/Documentation/networking/device_drivers/ethernet/davicom/dm9000.rst
index d5458da01083..14eb0a4d4e4e 100644
--- a/Documentation/networking/device_drivers/ethernet/davicom/dm9000.rst
+++ b/Documentation/networking/device_drivers/ethernet/davicom/dm9000.rst
@@ -34,7 +34,7 @@ These resources should be specified in that order, as the ordering of the
 two address regions is important (the driver expects these to be address
 and then data).
 
-An example from arch/arm/mach-s3c2410/mach-bast.c is::
+An example from arch/arm/mach-s3c/mach-bast.c is::
 
   static struct resource bast_dm9k_resource[] = {
 	[0] = {
-- 
2.17.1

