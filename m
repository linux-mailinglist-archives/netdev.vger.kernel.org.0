Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BD8668D9F
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240835AbjAMG1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236952AbjAMGYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:24:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B766A0F5;
        Thu, 12 Jan 2023 22:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mxBIoTcWoM961bskFu4vgLYA4iK6lfkfHo46ovOHhdY=; b=epactF3LWIS1c8xybu121AnX4l
        mxQDeqmEC9J8cgMc2SIYAO9NzF3h0YlU8xbCTYRLLK24zqc8kEMH0PpbDIl1CALQ06M6j2t+DvW/2
        52IjFzvuXiBDn229AAQmQ76IVBLDEALsaXsG/rhqbYhzaI4Hb2k5FYwBW/QtpL+GpgBj1CYNBCjoU
        Wow0ecEypZirO8g6qBKEcpON8H7jgnTwizxUEhR74JGhqggyXfr0uC5oDRw7YO7Ldj7yKS+YzcUmZ
        aD+BC5AU+OusXU3+GAHmRsZapXMUIGr4gkeRILIjbZ4eJzhz4I3ZIHuh91N7YMYtmI2wXUBJeRcBz
        reMo6ZfA==;
Received: from [2001:4bb8:181:656b:9509:7d20:8d39:f895] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGDTy-000lWK-J8; Fri, 13 Jan 2023 06:24:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: [PATCH 06/22] watchdog: remove the shwdt driver
Date:   Fri, 13 Jan 2023 07:23:23 +0100
Message-Id: <20230113062339.1909087-7-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230113062339.1909087-1-hch@lst.de>
References: <20230113062339.1909087-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that arch/sh is removed this driver is dead code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .../watchdog/watchdog-parameters.rst          |  12 -
 drivers/watchdog/Kconfig                      |  20 -
 drivers/watchdog/Makefile                     |   3 -
 drivers/watchdog/shwdt.c                      | 344 ------------------
 4 files changed, 379 deletions(-)
 delete mode 100644 drivers/watchdog/shwdt.c

diff --git a/Documentation/watchdog/watchdog-parameters.rst b/Documentation/watchdog/watchdog-parameters.rst
index 29153eed668900..553ac2f8ae23f7 100644
--- a/Documentation/watchdog/watchdog-parameters.rst
+++ b/Documentation/watchdog/watchdog-parameters.rst
@@ -579,18 +579,6 @@ scx200_wdt:
 
 -------------------------------------------------
 
-shwdt:
-    clock_division_ratio:
-	Clock division ratio. Valid ranges are from 0x5 (1.31ms)
-	to 0x7 (5.25ms). (default=7)
-    heartbeat:
-	Watchdog heartbeat in seconds. (1 <= heartbeat <= 3600, default=30
-    nowayout:
-	Watchdog cannot be stopped once started
-	(default=kernel config parameter)
-
--------------------------------------------------
-
 smsc37b787_wdt:
     timeout:
 	range is 1-255 units, default is 60
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 0bc40b763b0652..7db0a5e636cf65 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -2015,26 +2015,6 @@ config DIAG288_WATCHDOG
 	  To compile this driver as a module, choose M here. The module
 	  will be called diag288_wdt.
 
-# SUPERH (sh + sh64) Architecture
-
-config SH_WDT
-	tristate "SuperH Watchdog"
-	depends on SUPERH && (CPU_SH3 || CPU_SH4 || COMPILE_TEST)
-	select WATCHDOG_CORE
-	help
-	  This driver adds watchdog support for the integrated watchdog in the
-	  SuperH processors. If you have one of these processors and wish
-	  to have watchdog support enabled, say Y, otherwise say N.
-
-	  As a side note, saying Y here will automatically boost HZ to 1000
-	  so that the timer has a chance to clear the overflow counter. On
-	  slower systems (such as the SH-2 and SH-3) this will likely yield
-	  some performance issues. As such, the WDT should be avoided here
-	  unless it is absolutely necessary.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called shwdt.
-
 # SPARC Architecture
 
 # SPARC64 Architecture
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 9cbf6580f16c9f..a852ab4d7176ac 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -195,9 +195,6 @@ obj-$(CONFIG_WATCHDOG_RTAS) += wdrtas.o
 # S390 Architecture
 obj-$(CONFIG_DIAG288_WATCHDOG) += diag288_wdt.o
 
-# SUPERH (sh + sh64) Architecture
-obj-$(CONFIG_SH_WDT) += shwdt.o
-
 # SPARC Architecture
 
 # SPARC64 Architecture
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
deleted file mode 100644
index f55533e0e0454e..00000000000000
--- a/drivers/watchdog/shwdt.c
+++ /dev/null
@@ -1,344 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * drivers/watchdog/shwdt.c
- *
- * Watchdog driver for integrated watchdog in the SuperH processors.
- *
- * Copyright (C) 2001 - 2012  Paul Mundt <lethal@linux-sh.org>
- *
- * 14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
- *     Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
- *
- * 19-Apr-2002 Rob Radez <rob@osinvestor.com>
- *     Added expect close support, made emulated timeout runtime changeable
- *     general cleanups, add some ioctls
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/platform_device.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/spinlock.h>
-#include <linux/watchdog.h>
-#include <linux/pm_runtime.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
-#include <linux/io.h>
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <asm/watchdog.h>
-
-#define DRV_NAME "sh-wdt"
-
-/*
- * Default clock division ratio is 5.25 msecs. For an additional table of
- * values, consult the asm-sh/watchdog.h. Overload this at module load
- * time.
- *
- * In order for this to work reliably we need to have HZ set to 1000 or
- * something quite higher than 100 (or we need a proper high-res timer
- * implementation that will deal with this properly), otherwise the 10ms
- * resolution of a jiffy is enough to trigger the overflow. For things like
- * the SH-4 and SH-5, this isn't necessarily that big of a problem, though
- * for the SH-2 and SH-3, this isn't recommended unless the WDT is absolutely
- * necssary.
- *
- * As a result of this timing problem, the only modes that are particularly
- * feasible are the 4096 and the 2048 divisors, which yield 5.25 and 2.62ms
- * overflow periods respectively.
- *
- * Also, since we can't really expect userspace to be responsive enough
- * before the overflow happens, we maintain two separate timers .. One in
- * the kernel for clearing out WOVF every 2ms or so (again, this depends on
- * HZ == 1000), and another for monitoring userspace writes to the WDT device.
- *
- * As such, we currently use a configurable heartbeat interval which defaults
- * to 30s. In this case, the userspace daemon is only responsible for periodic
- * writes to the device before the next heartbeat is scheduled. If the daemon
- * misses its deadline, the kernel timer will allow the WDT to overflow.
- */
-static int clock_division_ratio = WTCSR_CKS_4096;
-#define next_ping_period(cks)	(jiffies + msecs_to_jiffies(cks - 4))
-
-#define WATCHDOG_HEARTBEAT 30			/* 30 sec default heartbeat */
-static int heartbeat = WATCHDOG_HEARTBEAT;	/* in seconds */
-static bool nowayout = WATCHDOG_NOWAYOUT;
-static unsigned long next_heartbeat;
-
-struct sh_wdt {
-	void __iomem		*base;
-	struct device		*dev;
-	struct clk		*clk;
-	spinlock_t		lock;
-
-	struct timer_list	timer;
-};
-
-static int sh_wdt_start(struct watchdog_device *wdt_dev)
-{
-	struct sh_wdt *wdt = watchdog_get_drvdata(wdt_dev);
-	unsigned long flags;
-	u8 csr;
-
-	pm_runtime_get_sync(wdt->dev);
-	clk_enable(wdt->clk);
-
-	spin_lock_irqsave(&wdt->lock, flags);
-
-	next_heartbeat = jiffies + (heartbeat * HZ);
-	mod_timer(&wdt->timer, next_ping_period(clock_division_ratio));
-
-	csr = sh_wdt_read_csr();
-	csr |= WTCSR_WT | clock_division_ratio;
-	sh_wdt_write_csr(csr);
-
-	sh_wdt_write_cnt(0);
-
-	/*
-	 * These processors have a bit of an inconsistent initialization
-	 * process.. starting with SH-3, RSTS was moved to WTCSR, and the
-	 * RSTCSR register was removed.
-	 *
-	 * On the SH-2 however, in addition with bits being in different
-	 * locations, we must deal with RSTCSR outright..
-	 */
-	csr = sh_wdt_read_csr();
-	csr |= WTCSR_TME;
-	csr &= ~WTCSR_RSTS;
-	sh_wdt_write_csr(csr);
-
-#ifdef CONFIG_CPU_SH2
-	csr = sh_wdt_read_rstcsr();
-	csr &= ~RSTCSR_RSTS;
-	sh_wdt_write_rstcsr(csr);
-#endif
-	spin_unlock_irqrestore(&wdt->lock, flags);
-
-	return 0;
-}
-
-static int sh_wdt_stop(struct watchdog_device *wdt_dev)
-{
-	struct sh_wdt *wdt = watchdog_get_drvdata(wdt_dev);
-	unsigned long flags;
-	u8 csr;
-
-	spin_lock_irqsave(&wdt->lock, flags);
-
-	del_timer(&wdt->timer);
-
-	csr = sh_wdt_read_csr();
-	csr &= ~WTCSR_TME;
-	sh_wdt_write_csr(csr);
-
-	spin_unlock_irqrestore(&wdt->lock, flags);
-
-	clk_disable(wdt->clk);
-	pm_runtime_put_sync(wdt->dev);
-
-	return 0;
-}
-
-static int sh_wdt_keepalive(struct watchdog_device *wdt_dev)
-{
-	struct sh_wdt *wdt = watchdog_get_drvdata(wdt_dev);
-	unsigned long flags;
-
-	spin_lock_irqsave(&wdt->lock, flags);
-	next_heartbeat = jiffies + (heartbeat * HZ);
-	spin_unlock_irqrestore(&wdt->lock, flags);
-
-	return 0;
-}
-
-static int sh_wdt_set_heartbeat(struct watchdog_device *wdt_dev, unsigned t)
-{
-	struct sh_wdt *wdt = watchdog_get_drvdata(wdt_dev);
-	unsigned long flags;
-
-	if (unlikely(t < 1 || t > 3600)) /* arbitrary upper limit */
-		return -EINVAL;
-
-	spin_lock_irqsave(&wdt->lock, flags);
-	heartbeat = t;
-	wdt_dev->timeout = t;
-	spin_unlock_irqrestore(&wdt->lock, flags);
-
-	return 0;
-}
-
-static void sh_wdt_ping(struct timer_list *t)
-{
-	struct sh_wdt *wdt = from_timer(wdt, t, timer);
-	unsigned long flags;
-
-	spin_lock_irqsave(&wdt->lock, flags);
-	if (time_before(jiffies, next_heartbeat)) {
-		u8 csr;
-
-		csr = sh_wdt_read_csr();
-		csr &= ~WTCSR_IOVF;
-		sh_wdt_write_csr(csr);
-
-		sh_wdt_write_cnt(0);
-
-		mod_timer(&wdt->timer, next_ping_period(clock_division_ratio));
-	} else
-		dev_warn(wdt->dev, "Heartbeat lost! Will not ping "
-		         "the watchdog\n");
-	spin_unlock_irqrestore(&wdt->lock, flags);
-}
-
-static const struct watchdog_info sh_wdt_info = {
-	.options		= WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
-				  WDIOF_MAGICCLOSE,
-	.firmware_version	= 1,
-	.identity		= "SH WDT",
-};
-
-static const struct watchdog_ops sh_wdt_ops = {
-	.owner		= THIS_MODULE,
-	.start		= sh_wdt_start,
-	.stop		= sh_wdt_stop,
-	.ping		= sh_wdt_keepalive,
-	.set_timeout	= sh_wdt_set_heartbeat,
-};
-
-static struct watchdog_device sh_wdt_dev = {
-	.info	= &sh_wdt_info,
-	.ops	= &sh_wdt_ops,
-};
-
-static int sh_wdt_probe(struct platform_device *pdev)
-{
-	struct sh_wdt *wdt;
-	int rc;
-
-	/*
-	 * As this driver only covers the global watchdog case, reject
-	 * any attempts to register per-CPU watchdogs.
-	 */
-	if (pdev->id != -1)
-		return -EINVAL;
-
-	wdt = devm_kzalloc(&pdev->dev, sizeof(struct sh_wdt), GFP_KERNEL);
-	if (unlikely(!wdt))
-		return -ENOMEM;
-
-	wdt->dev = &pdev->dev;
-
-	wdt->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(wdt->clk)) {
-		/*
-		 * Clock framework support is optional, continue on
-		 * anyways if we don't find a matching clock.
-		 */
-		wdt->clk = NULL;
-	}
-
-	wdt->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(wdt->base))
-		return PTR_ERR(wdt->base);
-
-	watchdog_set_nowayout(&sh_wdt_dev, nowayout);
-	watchdog_set_drvdata(&sh_wdt_dev, wdt);
-	sh_wdt_dev.parent = &pdev->dev;
-
-	spin_lock_init(&wdt->lock);
-
-	rc = sh_wdt_set_heartbeat(&sh_wdt_dev, heartbeat);
-	if (unlikely(rc)) {
-		/* Default timeout if invalid */
-		sh_wdt_set_heartbeat(&sh_wdt_dev, WATCHDOG_HEARTBEAT);
-
-		dev_warn(&pdev->dev,
-			 "heartbeat value must be 1<=x<=3600, using %d\n",
-			 sh_wdt_dev.timeout);
-	}
-
-	dev_info(&pdev->dev, "configured with heartbeat=%d sec (nowayout=%d)\n",
-		 sh_wdt_dev.timeout, nowayout);
-
-	rc = watchdog_register_device(&sh_wdt_dev);
-	if (unlikely(rc)) {
-		dev_err(&pdev->dev, "Can't register watchdog (err=%d)\n", rc);
-		return rc;
-	}
-
-	timer_setup(&wdt->timer, sh_wdt_ping, 0);
-	wdt->timer.expires	= next_ping_period(clock_division_ratio);
-
-	dev_info(&pdev->dev, "initialized.\n");
-
-	pm_runtime_enable(&pdev->dev);
-
-	return 0;
-}
-
-static int sh_wdt_remove(struct platform_device *pdev)
-{
-	watchdog_unregister_device(&sh_wdt_dev);
-
-	pm_runtime_disable(&pdev->dev);
-
-	return 0;
-}
-
-static void sh_wdt_shutdown(struct platform_device *pdev)
-{
-	sh_wdt_stop(&sh_wdt_dev);
-}
-
-static struct platform_driver sh_wdt_driver = {
-	.driver		= {
-		.name	= DRV_NAME,
-	},
-
-	.probe		= sh_wdt_probe,
-	.remove		= sh_wdt_remove,
-	.shutdown	= sh_wdt_shutdown,
-};
-
-static int __init sh_wdt_init(void)
-{
-	if (unlikely(clock_division_ratio < 0x5 ||
-		     clock_division_ratio > 0x7)) {
-		clock_division_ratio = WTCSR_CKS_4096;
-
-		pr_info("divisor must be 0x5<=x<=0x7, using %d\n",
-			clock_division_ratio);
-	}
-
-	return platform_driver_register(&sh_wdt_driver);
-}
-
-static void __exit sh_wdt_exit(void)
-{
-	platform_driver_unregister(&sh_wdt_driver);
-}
-module_init(sh_wdt_init);
-module_exit(sh_wdt_exit);
-
-MODULE_AUTHOR("Paul Mundt <lethal@linux-sh.org>");
-MODULE_DESCRIPTION("SuperH watchdog driver");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:" DRV_NAME);
-
-module_param(clock_division_ratio, int, 0);
-MODULE_PARM_DESC(clock_division_ratio,
-	"Clock division ratio. Valid ranges are from 0x5 (1.31ms) "
-	"to 0x7 (5.25ms). (default=" __MODULE_STRING(WTCSR_CKS_4096) ")");
-
-module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat,
-	"Watchdog heartbeat in seconds. (1 <= heartbeat <= 3600, default="
-				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
-
-module_param(nowayout, bool, 0);
-MODULE_PARM_DESC(nowayout,
-	"Watchdog cannot be stopped once started (default="
-				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-- 
2.39.0

