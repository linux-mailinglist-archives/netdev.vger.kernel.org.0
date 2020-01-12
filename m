Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48E213861F
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 13:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732788AbgALMFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 07:05:03 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38915 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732774AbgALMFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 07:05:03 -0500
Received: by mail-lf1-f65.google.com with SMTP id y1so4828242lfb.6
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 04:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rAIBtvYZp1sEKS/inq+wh3LGS3QFDoK0qm7zsUmVxVo=;
        b=VpV1n6PvY+EB/sCedBcD5Kowbz1ERi5LBSqkoa9jmo0nymV1tdvE+LrVOK20AuFDqH
         TASfJwIaKGmXXskLMTs2K9fmx6SiVLlBli+cqmoNmCH+ljRzzTsrAPMpJpHHbVtbF2rT
         CSTibjgvxtjizPw7eyPPL0bG0Yr6FCFkqactIwdhNCwDQ8oGNO+JYWVDT2QROpbjh9C6
         V9OE+W2/4O1tLiUu4jkQGvngYlhqCNbGE1kfxGCZH61WeSPfo06f4P/e16egDpBy928X
         j+PiR958NJHBY/F0O+tQQQVs4tp6jXlVHLPExFp4PdPIA2KJe9ARMXT/jAvdseeXyDxo
         zGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rAIBtvYZp1sEKS/inq+wh3LGS3QFDoK0qm7zsUmVxVo=;
        b=KW5gQQe4IS9GssvhqS3Gsg17JOGVEuLxxgubAGzhmdNpmzqrD6UuFwW6orW1QVSDQ9
         Mh6yfyFadEl6M+ClxWZtY2cYeQwVb6SwIweUB4RwmPg40vyN8lSEWrzfJCW3+f86Clsn
         kV5VPDO1+BaorJL0b4HPA8Rcdky2JVjyaohAdgTk7adtPp4BJCxaFiJSwsExwo7z6YzH
         i3GOjULBB8P+rrn6ASROMZafma0g73tNfzDfuEn6gilWLWjsatJqg6sO74goBYRnvBIE
         W7XgfPh0MAoQyA3zmwlI/gkUM1i0Psa2q+PQG3XOABx16QVmk8TkVrHsPZ4hOMxtmDpS
         zWFQ==
X-Gm-Message-State: APjAAAXU18uuxIUAmd/0m5L051XA7S3uAnDr1Mrp0ih7Sz+jwsp92jyf
        lEW4IyMviXY18Sqf/AxQe0HnvwO1LTVJ0w==
X-Google-Smtp-Source: APXvYqwxwDzceK4P/o+8MjJob/HcGBDvH6c5ZBbdOluxwXWovNgU2pPqBZYrRIaUJslJIMW7+EhKaw==
X-Received: by 2002:ac2:4a89:: with SMTP id l9mr7386813lfp.121.1578830699554;
        Sun, 12 Jan 2020 04:04:59 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id z7sm4660347lfa.81.2020.01.12.04.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 04:04:58 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 2/9 v5] wan: ixp4xx_hss: prepare compile testing
Date:   Sun, 12 Jan 2020 13:04:43 +0100
Message-Id: <20200112120450.11874-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200112120450.11874-1-linus.walleij@linaro.org>
References: <20200112120450.11874-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The ixp4xx_hss driver needs the platform data definition and the
system clock rate to be compiled. Move both into a new platform_data
header file.

This is a prerequisite for compile testing, but turning on compile
testing requires further patches to isolate the SoC headers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:
- Renase onto the net-next tree
ChangeLog v3->v4:
- Drop a stable tag and rebubmit.
ChangeLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Drop the change actually enabling compile testing in Kconfig
  but keep the rest around so we are prepared. (Need the SoC
  include changes to actually enable it.)
- Rename to "prepare"
---
 arch/arm/mach-ixp4xx/goramo_mlr.c            |  4 +++
 arch/arm/mach-ixp4xx/include/mach/platform.h |  9 -----
 drivers/net/wan/Kconfig                      |  3 +-
 drivers/net/wan/ixp4xx_hss.c                 | 35 +++++++++++---------
 include/linux/platform_data/wan_ixp4xx_hss.h | 17 ++++++++++
 5 files changed, 43 insertions(+), 25 deletions(-)
 create mode 100644 include/linux/platform_data/wan_ixp4xx_hss.h

diff --git a/arch/arm/mach-ixp4xx/goramo_mlr.c b/arch/arm/mach-ixp4xx/goramo_mlr.c
index a0e0b6b7dc5c..93b7afeee142 100644
--- a/arch/arm/mach-ixp4xx/goramo_mlr.c
+++ b/arch/arm/mach-ixp4xx/goramo_mlr.c
@@ -11,6 +11,7 @@
 #include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/platform_data/wan_ixp4xx_hss.h>
 #include <linux/serial_8250.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -405,6 +406,9 @@ static void __init gmlr_init(void)
 	if (hw_bits & CFG_HW_HAS_HSS1)
 		device_tab[devices++] = &device_hss_tab[1]; /* max index 5 */
 
+	hss_plat[0].timer_freq = ixp4xx_timer_freq;
+	hss_plat[1].timer_freq = ixp4xx_timer_freq;
+
 	gpio_request(GPIO_SCL, "SCL/clock");
 	gpio_request(GPIO_SDA, "SDA/data");
 	gpio_request(GPIO_STR, "strobe");
diff --git a/arch/arm/mach-ixp4xx/include/mach/platform.h b/arch/arm/mach-ixp4xx/include/mach/platform.h
index 342acbe20f7c..04ef8025accc 100644
--- a/arch/arm/mach-ixp4xx/include/mach/platform.h
+++ b/arch/arm/mach-ixp4xx/include/mach/platform.h
@@ -104,15 +104,6 @@ struct eth_plat_info {
 	u8 hwaddr[6];
 };
 
-/* Information about built-in HSS (synchronous serial) interfaces */
-struct hss_plat_info {
-	int (*set_clock)(int port, unsigned int clock_type);
-	int (*open)(int port, void *pdev,
-		    void (*set_carrier_cb)(void *pdev, int carrier));
-	void (*close)(int port, void *pdev);
-	u8 txreadyq;
-};
-
 /*
  * Frequency of clock used for primary clocksource
  */
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index dd1a147f2971..4530840e15ef 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -315,7 +315,8 @@ config DSCC4_PCI_RST
 
 config IXP4XX_HSS
 	tristate "Intel IXP4xx HSS (synchronous serial port) support"
-	depends on HDLC && ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR
+	depends on HDLC && IXP4XX_NPE && IXP4XX_QMGR
+	depends on ARCH_IXP4XX
 	help
 	  Say Y here if you want to use built-in HSS ports
 	  on IXP4xx processor.
diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index e7619cec978a..7c5cf77e9ef1 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/wan_ixp4xx_hss.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/soc/ixp4xx/npe.h>
@@ -1182,14 +1183,14 @@ static int hss_hdlc_attach(struct net_device *dev, unsigned short encoding,
 	}
 }
 
-static u32 check_clock(u32 rate, u32 a, u32 b, u32 c,
+static u32 check_clock(u32 timer_freq, u32 rate, u32 a, u32 b, u32 c,
 		       u32 *best, u32 *best_diff, u32 *reg)
 {
 	/* a is 10-bit, b is 10-bit, c is 12-bit */
 	u64 new_rate;
 	u32 new_diff;
 
-	new_rate = ixp4xx_timer_freq * (u64)(c + 1);
+	new_rate = timer_freq * (u64)(c + 1);
 	do_div(new_rate, a * (c + 1) + b + 1);
 	new_diff = abs((u32)new_rate - rate);
 
@@ -1201,40 +1202,43 @@ static u32 check_clock(u32 rate, u32 a, u32 b, u32 c,
 	return new_diff;
 }
 
-static void find_best_clock(u32 rate, u32 *best, u32 *reg)
+static void find_best_clock(u32 timer_freq, u32 rate, u32 *best, u32 *reg)
 {
 	u32 a, b, diff = 0xFFFFFFFF;
 
-	a = ixp4xx_timer_freq / rate;
+	a = timer_freq / rate;
 
 	if (a > 0x3FF) { /* 10-bit value - we can go as slow as ca. 65 kb/s */
-		check_clock(rate, 0x3FF, 1, 1, best, &diff, reg);
+		check_clock(timer_freq, rate, 0x3FF, 1, 1, best, &diff, reg);
 		return;
 	}
 	if (a == 0) { /* > 66.666 MHz */
 		a = 1; /* minimum divider is 1 (a = 0, b = 1, c = 1) */
-		rate = ixp4xx_timer_freq;
+		rate = timer_freq;
 	}
 
-	if (rate * a == ixp4xx_timer_freq) { /* don't divide by 0 later */
-		check_clock(rate, a - 1, 1, 1, best, &diff, reg);
+	if (rate * a == timer_freq) { /* don't divide by 0 later */
+		check_clock(timer_freq, rate, a - 1, 1, 1, best, &diff, reg);
 		return;
 	}
 
 	for (b = 0; b < 0x400; b++) {
 		u64 c = (b + 1) * (u64)rate;
-		do_div(c, ixp4xx_timer_freq - rate * a);
+		do_div(c, timer_freq - rate * a);
 		c--;
 		if (c >= 0xFFF) { /* 12-bit - no need to check more 'b's */
 			if (b == 0 && /* also try a bit higher rate */
-			    !check_clock(rate, a - 1, 1, 1, best, &diff, reg))
+			    !check_clock(timer_freq, rate, a - 1, 1, 1, best,
+					 &diff, reg))
 				return;
-			check_clock(rate, a, b, 0xFFF, best, &diff, reg);
+			check_clock(timer_freq, rate, a, b, 0xFFF, best,
+				    &diff, reg);
 			return;
 		}
-		if (!check_clock(rate, a, b, c, best, &diff, reg))
+		if (!check_clock(timer_freq, rate, a, b, c, best, &diff, reg))
 			return;
-		if (!check_clock(rate, a, b, c + 1, best, &diff, reg))
+		if (!check_clock(timer_freq, rate, a, b, c + 1, best, &diff,
+				 reg))
 			return;
 	}
 }
@@ -1285,8 +1289,9 @@ static int hss_hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 		port->clock_type = clk; /* Update settings */
 		if (clk == CLOCK_INT)
-			find_best_clock(new_line.clock_rate, &port->clock_rate,
-					&port->clock_reg);
+			find_best_clock(port->plat->timer_freq,
+					new_line.clock_rate,
+					&port->clock_rate, &port->clock_reg);
 		else {
 			port->clock_rate = 0;
 			port->clock_reg = CLK42X_SPEED_2048KHZ;
diff --git a/include/linux/platform_data/wan_ixp4xx_hss.h b/include/linux/platform_data/wan_ixp4xx_hss.h
new file mode 100644
index 000000000000..d525a0feb9e1
--- /dev/null
+++ b/include/linux/platform_data/wan_ixp4xx_hss.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __PLATFORM_DATA_WAN_IXP4XX_HSS_H
+#define __PLATFORM_DATA_WAN_IXP4XX_HSS_H
+
+#include <linux/types.h>
+
+/* Information about built-in HSS (synchronous serial) interfaces */
+struct hss_plat_info {
+	int (*set_clock)(int port, unsigned int clock_type);
+	int (*open)(int port, void *pdev,
+		    void (*set_carrier_cb)(void *pdev, int carrier));
+	void (*close)(int port, void *pdev);
+	u8 txreadyq;
+	u32 timer_freq;
+};
+
+#endif
-- 
2.21.0

