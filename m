Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5349C7CDBD
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfGaUEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:04:34 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:51389 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfGaUEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 16:04:31 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MG90u-1i9MpD1XiO-00GdEL; Wed, 31 Jul 2019 22:03:55 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] ARM: lpc32xx: allow multiplatform build
Date:   Wed, 31 Jul 2019 21:56:53 +0200
Message-Id: <20190731195713.3150463-12-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190731195713.3150463-1-arnd@arndb.de>
References: <20190731195713.3150463-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:gID4RNpoX8Zy0tyRqB2A6yiPGJfcnxOOAaqeCpDCy5//AbU5fC+
 Aq2RaOrGEVpMj/GW50xVSsjfcw1hj8Jqyy4sqmlL5C6GhIiSItYASN6wS4s0tJsnDSxDQGU
 4cCKMnrp63iGJZf5+t0aWd3WlnBJDiiqakf3ozIiK3SnkTBYlqu6XZBcE3yOVYjdk8f1wxt
 jiefSp6XmrWvYU+WhrFqw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eM8z4Th1230=:8gdVoiZjbL4WjyeaVcDmZr
 cpT0mCOoqZv4Cg0/dVlx28ZgDrevnB1uhSfamTVZMiViwm8GrOEJOg+bFuHgn0vUrAk64Eqzz
 dVnc+ygDk1KuMm0rOh3zEW2GPfr6AOumDW4SvzirTizwdiFGhBBf7jlqUYHzUVWsghQXkzC/6
 X7rra8A4a09pZwHwUgQlDzt0cCEklYGimCBI4EsB9yaE0KENJj6skQJ5A2DCvdgcsb91AUkaf
 YP6QPfGJVColH35OSiBK+ZJXoNrj4ZvouhJc6jwgVvT5I47YZMoKIasuvvx6PmMa0D6DwxK17
 3EsEOsRjZ3J+1pibA4uOuRZc7BKfB1zT75NkQSZF8qF7Ds7mY17jzHB0Ip4fk2ozwRBi4gIMB
 9wCwQ7CvKSk/fe6RwLXPEw0QyWUCAE8FRGGmyzDKLWvG1qdoGTaMrxi2LNNrEhnNm0sIcU2Sr
 4XP4mPbBJSpLb9J64YnV6PGs2fSYsA2aemNk7Wir4NJng1/wG/yqnA8G5sznbsj3sxiVnV1I1
 rgq0vyKXldZvGlemusABzGEHSy3Mmd/E/e2+/BoKCioKYR1/lbn1nUDc6+h1BMBxGi8UkK/xm
 oQKxXdz/IguWloG6WLtpRPhsKUYhMexLuxanjICeC0MeBV1UYH0iJqH1NqfIwRxiCYVGbEzJL
 yEv38bGmbbOzDxt69iUvf+vr58AmBAm2WH67COjQgbWNFuTIn1dy9+05xd/GlTOFNMrlhMFmP
 rmRjILq3mssWIPxPDOxj/xJzsX0Dnu+IBGzyww==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All preparation work is done, so the platform can finally
be moved into ARCH_MULTIPLATFORM. This requires a small
change to the defconfig file to enable the platform.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig                              | 17 +------
 arch/arm/configs/lpc32xx_defconfig            |  1 +
 arch/arm/mach-lpc32xx/Kconfig                 | 11 +++++
 .../mach-lpc32xx/include/mach/uncompress.h    | 48 -------------------
 4 files changed, 14 insertions(+), 63 deletions(-)
 create mode 100644 arch/arm/mach-lpc32xx/Kconfig
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/uncompress.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 33b00579beff..65808e17cb3b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -478,21 +478,6 @@ config ARCH_W90X900
 	  <http://www.nuvoton.com/hq/enu/ProductAndSales/ProductLines/
 		ConsumerElectronicsIC/ARMMicrocontroller/ARMMicrocontroller>
 
-config ARCH_LPC32XX
-	bool "NXP LPC32XX"
-	select ARM_AMBA
-	select CLKDEV_LOOKUP
-	select CLKSRC_LPC32XX
-	select COMMON_CLK
-	select CPU_ARM926T
-	select GENERIC_CLOCKEVENTS
-	select GENERIC_IRQ_MULTI_HANDLER
-	select GPIOLIB
-	select SPARSE_IRQ
-	select USE_OF
-	help
-	  Support for the NXP LPC32XX family of processors
-
 config ARCH_PXA
 	bool "PXA2xx/PXA3xx-based"
 	depends on MMU
@@ -746,6 +731,8 @@ source "arch/arm/mach-keystone/Kconfig"
 
 source "arch/arm/mach-ks8695/Kconfig"
 
+source "arch/arm/mach-lpc32xx/Kconfig"
+
 source "arch/arm/mach-mediatek/Kconfig"
 
 source "arch/arm/mach-meson/Kconfig"
diff --git a/arch/arm/configs/lpc32xx_defconfig b/arch/arm/configs/lpc32xx_defconfig
index 0cdc6c7974b3..2d75bd8dbaf0 100644
--- a/arch/arm/configs/lpc32xx_defconfig
+++ b/arch/arm/configs/lpc32xx_defconfig
@@ -12,6 +12,7 @@ CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
+# CONFIG_ARCH_MULTI_V7 is not set
 CONFIG_ARCH_LPC32XX=y
 CONFIG_AEABI=y
 CONFIG_ZBOOT_ROM_TEXT=0x0
diff --git a/arch/arm/mach-lpc32xx/Kconfig b/arch/arm/mach-lpc32xx/Kconfig
new file mode 100644
index 000000000000..ec87c65f4536
--- /dev/null
+++ b/arch/arm/mach-lpc32xx/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config ARCH_LPC32XX
+	bool "NXP LPC32XX"
+	depends on ARCH_MULTI_V5
+	select ARM_AMBA
+	select CLKSRC_LPC32XX
+	select CPU_ARM926T
+	select GPIOLIB
+	help
+	  Support for the NXP LPC32XX family of processors
diff --git a/arch/arm/mach-lpc32xx/include/mach/uncompress.h b/arch/arm/mach-lpc32xx/include/mach/uncompress.h
deleted file mode 100644
index 74b7aa0da0e4..000000000000
--- a/arch/arm/mach-lpc32xx/include/mach/uncompress.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * arch/arm/mach-lpc32xx/include/mach/uncompress.h
- *
- * Author: Kevin Wells <kevin.wells@nxp.com>
- *
- * Copyright (C) 2010 NXP Semiconductors
- */
-
-#ifndef __ASM_ARM_ARCH_UNCOMPRESS_H
-#define __ASM_ARM_ARCH_UNCOMPRESS_H
-
-#include <linux/io.h>
-
-/*
- * Uncompress output is hardcoded to standard UART 5
- */
-
-#define UART_FIFO_CTL_TX_RESET	(1 << 2)
-#define UART_STATUS_TX_MT	(1 << 6)
-#define LPC32XX_UART5_BASE	0x40090000
-
-#define _UARTREG(x)		(void __iomem *)(LPC32XX_UART5_BASE + (x))
-
-#define LPC32XX_UART_DLLFIFO_O	0x00
-#define LPC32XX_UART_IIRFCR_O	0x08
-#define LPC32XX_UART_LSR_O	0x14
-
-static inline void putc(int ch)
-{
-	/* Wait for transmit FIFO to empty */
-	while ((__raw_readl(_UARTREG(LPC32XX_UART_LSR_O)) &
-		UART_STATUS_TX_MT) == 0)
-		;
-
-	__raw_writel((u32) ch, _UARTREG(LPC32XX_UART_DLLFIFO_O));
-}
-
-static inline void flush(void)
-{
-	__raw_writel(__raw_readl(_UARTREG(LPC32XX_UART_IIRFCR_O)) |
-		UART_FIFO_CTL_TX_RESET, _UARTREG(LPC32XX_UART_IIRFCR_O));
-}
-
-/* NULL functions; we don't presently need them */
-#define arch_decomp_setup()
-
-#endif
-- 
2.20.0

