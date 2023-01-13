Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3990D668D6B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240575AbjAMG3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbjAMGZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:25:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F136ADB3;
        Thu, 12 Jan 2023 22:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JbdvnYG1GWIlI+mjR040Fz2HmYek241Q0TguaG7+sfY=; b=tzfdnSJqgAUXBCbR9jbeCtdG+k
        Wi2+ukoLPUYfwY4oRYG2G65CrLpHfCH7IZIGEmOBzuo2AOm57p4YVKhyyUSErQ/iIGMHRToCCfdf/
        ktArnslU9c1GvDmR4UkceU2GUGqLzdTYlWtq3WsFqI46PrezV3almirhHOY1EgLXgwetLPHLE3dz4
        2GoK8l9g2L+uO3MM192VOrBKVPmFiTXFEqVyPchcY6p43ebcOag5FCHnp6JVdvVjlJ96YLX/45Mi9
        BCvOZVDckZcIaWRSsQl7roLaFbisbPzI3+C2vMQZUL7wC/PjrWG2okWzz8h9wGWMS/aXQsfNTjHUX
        1o7HZ5UA==;
Received: from [2001:4bb8:181:656b:9509:7d20:8d39:f895] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGDUB-000leH-Ap; Fri, 13 Jan 2023 06:24:19 +0000
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
Subject: [PATCH 10/22] input: remove sh_keysc
Date:   Fri, 13 Jan 2023 07:23:27 +0100
Message-Id: <20230113062339.1909087-11-hch@lst.de>
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
 drivers/input/keyboard/Kconfig    |  10 -
 drivers/input/keyboard/Makefile   |   1 -
 drivers/input/keyboard/sh_keysc.c | 334 ------------------------------
 3 files changed, 345 deletions(-)
 delete mode 100644 drivers/input/keyboard/sh_keysc.c

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 84490915ae4d5a..882ec5fef214ac 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -625,16 +625,6 @@ config KEYBOARD_SUNKBD
 	  To compile this driver as a module, choose M here: the
 	  module will be called sunkbd.
 
-config KEYBOARD_SH_KEYSC
-	tristate "SuperH KEYSC keypad support"
-	depends on ARCH_SHMOBILE || COMPILE_TEST
-	help
-	  Say Y here if you want to use a keypad attached to the KEYSC block
-	  on SuperH processors such as sh7722 and sh7343.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called sh_keysc.
-
 config KEYBOARD_STMPE
 	tristate "STMPE keypad support"
 	depends on MFD_STMPE
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 5f67196bb2c1ea..8aba0b052b4504 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -60,7 +60,6 @@ obj-$(CONFIG_KEYBOARD_QT1050)           += qt1050.o
 obj-$(CONFIG_KEYBOARD_QT1070)           += qt1070.o
 obj-$(CONFIG_KEYBOARD_QT2160)		+= qt2160.o
 obj-$(CONFIG_KEYBOARD_SAMSUNG)		+= samsung-keypad.o
-obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
 obj-$(CONFIG_KEYBOARD_SNVS_PWRKEY)	+= snvs_pwrkey.o
 obj-$(CONFIG_KEYBOARD_SPEAR)		+= spear-keyboard.o
 obj-$(CONFIG_KEYBOARD_STMPE)		+= stmpe-keypad.o
diff --git a/drivers/input/keyboard/sh_keysc.c b/drivers/input/keyboard/sh_keysc.c
deleted file mode 100644
index 2c00320f739fc1..00000000000000
--- a/drivers/input/keyboard/sh_keysc.c
+++ /dev/null
@@ -1,334 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * SuperH KEYSC Keypad Driver
- *
- * Copyright (C) 2008 Magnus Damm
- *
- * Based on gpio_keys.c, Copyright 2005 Phil Blundell
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/delay.h>
-#include <linux/platform_device.h>
-#include <linux/input.h>
-#include <linux/input/sh_keysc.h>
-#include <linux/bitmap.h>
-#include <linux/pm_runtime.h>
-#include <linux/io.h>
-#include <linux/slab.h>
-
-static const struct {
-	unsigned char kymd, keyout, keyin;
-} sh_keysc_mode[] = {
-	[SH_KEYSC_MODE_1] = { 0, 6, 5 },
-	[SH_KEYSC_MODE_2] = { 1, 5, 6 },
-	[SH_KEYSC_MODE_3] = { 2, 4, 7 },
-	[SH_KEYSC_MODE_4] = { 3, 6, 6 },
-	[SH_KEYSC_MODE_5] = { 4, 6, 7 },
-	[SH_KEYSC_MODE_6] = { 5, 8, 8 },
-};
-
-struct sh_keysc_priv {
-	void __iomem *iomem_base;
-	DECLARE_BITMAP(last_keys, SH_KEYSC_MAXKEYS);
-	struct input_dev *input;
-	struct sh_keysc_info pdata;
-};
-
-#define KYCR1 0
-#define KYCR2 1
-#define KYINDR 2
-#define KYOUTDR 3
-
-#define KYCR2_IRQ_LEVEL    0x10
-#define KYCR2_IRQ_DISABLED 0x00
-
-static unsigned long sh_keysc_read(struct sh_keysc_priv *p, int reg_nr)
-{
-	return ioread16(p->iomem_base + (reg_nr << 2));
-}
-
-static void sh_keysc_write(struct sh_keysc_priv *p, int reg_nr,
-			   unsigned long value)
-{
-	iowrite16(value, p->iomem_base + (reg_nr << 2));
-}
-
-static void sh_keysc_level_mode(struct sh_keysc_priv *p,
-				unsigned long keys_set)
-{
-	struct sh_keysc_info *pdata = &p->pdata;
-
-	sh_keysc_write(p, KYOUTDR, 0);
-	sh_keysc_write(p, KYCR2, KYCR2_IRQ_LEVEL | (keys_set << 8));
-
-	if (pdata->kycr2_delay)
-		udelay(pdata->kycr2_delay);
-}
-
-static void sh_keysc_map_dbg(struct device *dev, unsigned long *map,
-			     const char *str)
-{
-	int k;
-
-	for (k = 0; k < BITS_TO_LONGS(SH_KEYSC_MAXKEYS); k++)
-		dev_dbg(dev, "%s[%d] 0x%lx\n", str, k, map[k]);
-}
-
-static irqreturn_t sh_keysc_isr(int irq, void *dev_id)
-{
-	struct platform_device *pdev = dev_id;
-	struct sh_keysc_priv *priv = platform_get_drvdata(pdev);
-	struct sh_keysc_info *pdata = &priv->pdata;
-	int keyout_nr = sh_keysc_mode[pdata->mode].keyout;
-	int keyin_nr = sh_keysc_mode[pdata->mode].keyin;
-	DECLARE_BITMAP(keys, SH_KEYSC_MAXKEYS);
-	DECLARE_BITMAP(keys0, SH_KEYSC_MAXKEYS);
-	DECLARE_BITMAP(keys1, SH_KEYSC_MAXKEYS);
-	unsigned char keyin_set, tmp;
-	int i, k, n;
-
-	dev_dbg(&pdev->dev, "isr!\n");
-
-	bitmap_fill(keys1, SH_KEYSC_MAXKEYS);
-	bitmap_zero(keys0, SH_KEYSC_MAXKEYS);
-
-	do {
-		bitmap_zero(keys, SH_KEYSC_MAXKEYS);
-		keyin_set = 0;
-
-		sh_keysc_write(priv, KYCR2, KYCR2_IRQ_DISABLED);
-
-		for (i = 0; i < keyout_nr; i++) {
-			n = keyin_nr * i;
-
-			/* drive one KEYOUT pin low, read KEYIN pins */
-			sh_keysc_write(priv, KYOUTDR, 0xffff ^ (3 << (i * 2)));
-			udelay(pdata->delay);
-			tmp = sh_keysc_read(priv, KYINDR);
-
-			/* set bit if key press has been detected */
-			for (k = 0; k < keyin_nr; k++) {
-				if (tmp & (1 << k))
-					__set_bit(n + k, keys);
-			}
-
-			/* keep track of which KEYIN bits that have been set */
-			keyin_set |= tmp ^ ((1 << keyin_nr) - 1);
-		}
-
-		sh_keysc_level_mode(priv, keyin_set);
-
-		bitmap_complement(keys, keys, SH_KEYSC_MAXKEYS);
-		bitmap_and(keys1, keys1, keys, SH_KEYSC_MAXKEYS);
-		bitmap_or(keys0, keys0, keys, SH_KEYSC_MAXKEYS);
-
-		sh_keysc_map_dbg(&pdev->dev, keys, "keys");
-
-	} while (sh_keysc_read(priv, KYCR2) & 0x01);
-
-	sh_keysc_map_dbg(&pdev->dev, priv->last_keys, "last_keys");
-	sh_keysc_map_dbg(&pdev->dev, keys0, "keys0");
-	sh_keysc_map_dbg(&pdev->dev, keys1, "keys1");
-
-	for (i = 0; i < SH_KEYSC_MAXKEYS; i++) {
-		k = pdata->keycodes[i];
-		if (!k)
-			continue;
-
-		if (test_bit(i, keys0) == test_bit(i, priv->last_keys))
-			continue;
-
-		if (test_bit(i, keys1) || test_bit(i, keys0)) {
-			input_event(priv->input, EV_KEY, k, 1);
-			__set_bit(i, priv->last_keys);
-		}
-
-		if (!test_bit(i, keys1)) {
-			input_event(priv->input, EV_KEY, k, 0);
-			__clear_bit(i, priv->last_keys);
-		}
-
-	}
-	input_sync(priv->input);
-
-	return IRQ_HANDLED;
-}
-
-static int sh_keysc_probe(struct platform_device *pdev)
-{
-	struct sh_keysc_priv *priv;
-	struct sh_keysc_info *pdata;
-	struct resource *res;
-	struct input_dev *input;
-	int i;
-	int irq, error;
-
-	if (!dev_get_platdata(&pdev->dev)) {
-		dev_err(&pdev->dev, "no platform data defined\n");
-		error = -EINVAL;
-		goto err0;
-	}
-
-	error = -ENXIO;
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to get I/O memory\n");
-		goto err0;
-	}
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		goto err0;
-
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
-		error = -ENOMEM;
-		goto err0;
-	}
-
-	platform_set_drvdata(pdev, priv);
-	memcpy(&priv->pdata, dev_get_platdata(&pdev->dev), sizeof(priv->pdata));
-	pdata = &priv->pdata;
-
-	priv->iomem_base = ioremap(res->start, resource_size(res));
-	if (priv->iomem_base == NULL) {
-		dev_err(&pdev->dev, "failed to remap I/O memory\n");
-		error = -ENXIO;
-		goto err1;
-	}
-
-	priv->input = input_allocate_device();
-	if (!priv->input) {
-		dev_err(&pdev->dev, "failed to allocate input device\n");
-		error = -ENOMEM;
-		goto err2;
-	}
-
-	input = priv->input;
-	input->evbit[0] = BIT_MASK(EV_KEY);
-
-	input->name = pdev->name;
-	input->phys = "sh-keysc-keys/input0";
-	input->dev.parent = &pdev->dev;
-
-	input->id.bustype = BUS_HOST;
-	input->id.vendor = 0x0001;
-	input->id.product = 0x0001;
-	input->id.version = 0x0100;
-
-	input->keycode = pdata->keycodes;
-	input->keycodesize = sizeof(pdata->keycodes[0]);
-	input->keycodemax = ARRAY_SIZE(pdata->keycodes);
-
-	error = request_threaded_irq(irq, NULL, sh_keysc_isr, IRQF_ONESHOT,
-				     dev_name(&pdev->dev), pdev);
-	if (error) {
-		dev_err(&pdev->dev, "failed to request IRQ\n");
-		goto err3;
-	}
-
-	for (i = 0; i < SH_KEYSC_MAXKEYS; i++)
-		__set_bit(pdata->keycodes[i], input->keybit);
-	__clear_bit(KEY_RESERVED, input->keybit);
-
-	error = input_register_device(input);
-	if (error) {
-		dev_err(&pdev->dev, "failed to register input device\n");
-		goto err4;
-	}
-
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
-
-	sh_keysc_write(priv, KYCR1, (sh_keysc_mode[pdata->mode].kymd << 8) |
-		       pdata->scan_timing);
-	sh_keysc_level_mode(priv, 0);
-
-	device_init_wakeup(&pdev->dev, 1);
-
-	return 0;
-
- err4:
-	free_irq(irq, pdev);
- err3:
-	input_free_device(input);
- err2:
-	iounmap(priv->iomem_base);
- err1:
-	kfree(priv);
- err0:
-	return error;
-}
-
-static int sh_keysc_remove(struct platform_device *pdev)
-{
-	struct sh_keysc_priv *priv = platform_get_drvdata(pdev);
-
-	sh_keysc_write(priv, KYCR2, KYCR2_IRQ_DISABLED);
-
-	input_unregister_device(priv->input);
-	free_irq(platform_get_irq(pdev, 0), pdev);
-	iounmap(priv->iomem_base);
-
-	pm_runtime_put_sync(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-
-	kfree(priv);
-
-	return 0;
-}
-
-static int sh_keysc_suspend(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct sh_keysc_priv *priv = platform_get_drvdata(pdev);
-	int irq = platform_get_irq(pdev, 0);
-	unsigned short value;
-
-	value = sh_keysc_read(priv, KYCR1);
-
-	if (device_may_wakeup(dev)) {
-		sh_keysc_write(priv, KYCR1, value | 0x80);
-		enable_irq_wake(irq);
-	} else {
-		sh_keysc_write(priv, KYCR1, value & ~0x80);
-		pm_runtime_put_sync(dev);
-	}
-
-	return 0;
-}
-
-static int sh_keysc_resume(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	int irq = platform_get_irq(pdev, 0);
-
-	if (device_may_wakeup(dev))
-		disable_irq_wake(irq);
-	else
-		pm_runtime_get_sync(dev);
-
-	return 0;
-}
-
-static DEFINE_SIMPLE_DEV_PM_OPS(sh_keysc_dev_pm_ops,
-				sh_keysc_suspend, sh_keysc_resume);
-
-static struct platform_driver sh_keysc_device_driver = {
-	.probe		= sh_keysc_probe,
-	.remove		= sh_keysc_remove,
-	.driver		= {
-		.name	= "sh_keysc",
-		.pm	= pm_sleep_ptr(&sh_keysc_dev_pm_ops),
-	}
-};
-module_platform_driver(sh_keysc_device_driver);
-
-MODULE_AUTHOR("Magnus Damm");
-MODULE_DESCRIPTION("SuperH KEYSC Keypad Driver");
-MODULE_LICENSE("GPL");
-- 
2.39.0

