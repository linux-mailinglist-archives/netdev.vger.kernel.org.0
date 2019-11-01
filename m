Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 165DFEC36B
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfKANCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:02:37 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36348 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfKANCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 09:02:37 -0400
Received: by mail-lj1-f194.google.com with SMTP id x9so5365247lji.3
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 06:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a4QFBGtv8Ambs2lPqLYyKhszNYgCXJYa4r0rQuatVxU=;
        b=P59WIHG4DsDRxEwbGNLTqhMTnFGqBqez++WKoCxBwO41FU4DIuFxzw89udcJbdi2pJ
         mqqXl4WkB99loqOWQZ1C/cB1Jgc443vzfVLjAA1g0zXgC70d0IRvw/f+qlXYewA5iRVX
         fw9g2XgdXnYu2BXYuOFyvRhgFwDX+gJWk7bXfRsGE/3KjafDQllJFjcfNEnNfE9dTXVo
         dJ07UTn46DePn4nWT1PUl00C8MbfaZBEtJmS4/A7XWYweZjnRt7X2/q71lEyULdDNZ4Y
         2OLdLQOMhcMeEx4+H3KnqKTcUb+q17IhZFjQGepd1HyKoKxpKse3DDfebYBZNNJxFA3b
         /cOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a4QFBGtv8Ambs2lPqLYyKhszNYgCXJYa4r0rQuatVxU=;
        b=d3+rOZhj2FjcKzlIw4c+O41UenjtTjhcpBt2SaujVwuNsHqlzIyDHZU84t9KvDXpbC
         uBwz5AF8D/n7TrFrZ94oHUMxcsQN6tvg9tCY934oNqN4KUE4vVAqx/12n0zj/H1fHhO1
         GOxgLeGM49v/J13xfIdo1+rdOzquRLfe5/EhPQEFQe+RHvonkiGRfvF9v4RTgIVJkVCU
         AUrHPEp4myhESwyqVuhJNdDy/JUa/mBrFvhq3AFfqUiyTDaZVyTtqga2kMLJ99aQnuvr
         E0uP/Wc4f+9yrsD/tahZp6Sn1+374LbfqmBZo/fm8O4UtR2omonma7jsYIwGbRaFh6HK
         bIfg==
X-Gm-Message-State: APjAAAUd6yDo+Pi9zszE/zoEzvedQX4ytgZWrHj0xqE3XSZAoPbKMGj/
        mRZwv9D9BKvQuW/+ZOFPjQTo8/eEKFzrXw==
X-Google-Smtp-Source: APXvYqycVX/g1nunIVpjox4XDWyxochtMsk5XFaGwIXUphjYFVRh9SfeHukIPoNhq2SI1FYpfvM7bg==
X-Received: by 2002:a05:651c:10c:: with SMTP id a12mr8190025ljb.93.1572613353735;
        Fri, 01 Nov 2019 06:02:33 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id c3sm2516749lfi.32.2019.11.01.06.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 06:02:32 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 02/10 v2] wan: ixp4xx_hss: prepare compile testing
Date:   Fri,  1 Nov 2019 14:02:16 +0100
Message-Id: <20191101130224.7964-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101130224.7964-1-linus.walleij@linaro.org>
References: <20191101130224.7964-1-linus.walleij@linaro.org>
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

