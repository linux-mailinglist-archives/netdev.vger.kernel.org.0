Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C69668D1A
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241296AbjAMGaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240712AbjAMG0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:26:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AF759FA7;
        Thu, 12 Jan 2023 22:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4Cn32+DwniiE8Ivc8k8ZYXVlFs6gh/3Rw72W3/GZ4ag=; b=Fve8lBIQorfiJ/FhMD6e1GvYXc
        rGSPgQTVMyq0dxlP00mFanqHXFeH9t17eVtoz/JRWr+oFTQ0ynGMwYJHt5mfB04KzdaQjOX8Iu9fs
        nIQCq/R62BjdnWiSBeuBxN7hx5e4sYqYWJU6VIfqx17ddSCZZlu7ubY/3XF9PkfW4XzApYx2Cd9k9
        zs2s4D1MofDj9wf4eoTSyb6ybNKwpiGOqGQt9CBguMf+78gDheVOOw6bNmSUU/Blr1SaKqbcwa66y
        6cpVyf3vy//XvyjihCdST/c6G+qVI++1b+7abn1kff1W7YyuOYJBrAFCIknOxvbFhCUglhpOxZ9Fo
        xk7GnO7w==;
Received: from [2001:4bb8:181:656b:9509:7d20:8d39:f895] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGDUW-000lwz-NO; Fri, 13 Jan 2023 06:24:41 +0000
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
Subject: [PATCH 16/22] spi: remove spi-sh-sci
Date:   Fri, 13 Jan 2023 07:23:33 +0100
Message-Id: <20230113062339.1909087-17-hch@lst.de>
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
 drivers/spi/Kconfig      |   7 --
 drivers/spi/Makefile     |   1 -
 drivers/spi/spi-sh-sci.c | 197 ---------------------------------------
 3 files changed, 205 deletions(-)
 delete mode 100644 drivers/spi/spi-sh-sci.c

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 7508dcef909c78..76f3bc6f8c81fc 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -882,13 +882,6 @@ config SPI_SH_MSIOF
 	help
 	  SPI driver for SuperH and SH Mobile MSIOF blocks.
 
-config SPI_SH_SCI
-	tristate "SuperH SCI SPI controller"
-	depends on SUPERH
-	select SPI_BITBANG
-	help
-	  SPI driver for SuperH SCI blocks.
-
 config SPI_SH_HSPI
 	tristate "SuperH HSPI controller"
 	depends on ARCH_RENESAS || COMPILE_TEST
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 342a7eb5181c9b..27d877440c6539 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -118,7 +118,6 @@ obj-$(CONFIG_SPI_S3C64XX)		+= spi-s3c64xx.o
 obj-$(CONFIG_SPI_SC18IS602)		+= spi-sc18is602.o
 obj-$(CONFIG_SPI_SH_HSPI)		+= spi-sh-hspi.o
 obj-$(CONFIG_SPI_SH_MSIOF)		+= spi-sh-msiof.o
-obj-$(CONFIG_SPI_SH_SCI)		+= spi-sh-sci.o
 obj-$(CONFIG_SPI_SIFIVE)		+= spi-sifive.o
 obj-$(CONFIG_SPI_SLAVE_MT27XX)          += spi-slave-mt27xx.o
 obj-$(CONFIG_SPI_SN_F_OSPI)		+= spi-sn-f-ospi.o
diff --git a/drivers/spi/spi-sh-sci.c b/drivers/spi/spi-sh-sci.c
deleted file mode 100644
index 8f30531e141867..00000000000000
--- a/drivers/spi/spi-sh-sci.c
+++ /dev/null
@@ -1,197 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * SH SCI SPI interface
- *
- * Copyright (c) 2008 Magnus Damm
- *
- * Based on S3C24XX GPIO based SPI driver, which is:
- *   Copyright (c) 2006 Ben Dooks
- *   Copyright (c) 2006 Simtec Electronics
- */
-
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/spinlock.h>
-#include <linux/platform_device.h>
-
-#include <linux/spi/spi.h>
-#include <linux/spi/spi_bitbang.h>
-#include <linux/module.h>
-
-#include <asm/spi.h>
-#include <asm/io.h>
-
-struct sh_sci_spi {
-	struct spi_bitbang bitbang;
-
-	void __iomem *membase;
-	unsigned char val;
-	struct sh_spi_info *info;
-	struct platform_device *dev;
-};
-
-#define SCSPTR(sp)	(sp->membase + 0x1c)
-#define PIN_SCK		(1 << 2)
-#define PIN_TXD		(1 << 0)
-#define PIN_RXD		PIN_TXD
-#define PIN_INIT	((1 << 1) | (1 << 3) | PIN_SCK | PIN_TXD)
-
-static inline void setbits(struct sh_sci_spi *sp, int bits, int on)
-{
-	/*
-	 * We are the only user of SCSPTR so no locking is required.
-	 * Reading bit 2 and 0 in SCSPTR gives pin state as input.
-	 * Writing the same bits sets the output value.
-	 * This makes regular read-modify-write difficult so we
-	 * use sp->val to keep track of the latest register value.
-	 */
-
-	if (on)
-		sp->val |= bits;
-	else
-		sp->val &= ~bits;
-
-	iowrite8(sp->val, SCSPTR(sp));
-}
-
-static inline void setsck(struct spi_device *dev, int on)
-{
-	setbits(spi_master_get_devdata(dev->master), PIN_SCK, on);
-}
-
-static inline void setmosi(struct spi_device *dev, int on)
-{
-	setbits(spi_master_get_devdata(dev->master), PIN_TXD, on);
-}
-
-static inline u32 getmiso(struct spi_device *dev)
-{
-	struct sh_sci_spi *sp = spi_master_get_devdata(dev->master);
-
-	return (ioread8(SCSPTR(sp)) & PIN_RXD) ? 1 : 0;
-}
-
-#define spidelay(x) ndelay(x)
-
-#include "spi-bitbang-txrx.h"
-
-static u32 sh_sci_spi_txrx_mode0(struct spi_device *spi,
-				 unsigned nsecs, u32 word, u8 bits,
-				 unsigned flags)
-{
-	return bitbang_txrx_be_cpha0(spi, nsecs, 0, flags, word, bits);
-}
-
-static u32 sh_sci_spi_txrx_mode1(struct spi_device *spi,
-				 unsigned nsecs, u32 word, u8 bits,
-				 unsigned flags)
-{
-	return bitbang_txrx_be_cpha1(spi, nsecs, 0, flags, word, bits);
-}
-
-static u32 sh_sci_spi_txrx_mode2(struct spi_device *spi,
-				 unsigned nsecs, u32 word, u8 bits,
-				 unsigned flags)
-{
-	return bitbang_txrx_be_cpha0(spi, nsecs, 1, flags, word, bits);
-}
-
-static u32 sh_sci_spi_txrx_mode3(struct spi_device *spi,
-				 unsigned nsecs, u32 word, u8 bits,
-				 unsigned flags)
-{
-	return bitbang_txrx_be_cpha1(spi, nsecs, 1, flags, word, bits);
-}
-
-static void sh_sci_spi_chipselect(struct spi_device *dev, int value)
-{
-	struct sh_sci_spi *sp = spi_master_get_devdata(dev->master);
-
-	if (sp->info->chip_select)
-		(sp->info->chip_select)(sp->info, dev->chip_select, value);
-}
-
-static int sh_sci_spi_probe(struct platform_device *dev)
-{
-	struct resource	*r;
-	struct spi_master *master;
-	struct sh_sci_spi *sp;
-	int ret;
-
-	master = spi_alloc_master(&dev->dev, sizeof(struct sh_sci_spi));
-	if (master == NULL) {
-		dev_err(&dev->dev, "failed to allocate spi master\n");
-		ret = -ENOMEM;
-		goto err0;
-	}
-
-	sp = spi_master_get_devdata(master);
-
-	platform_set_drvdata(dev, sp);
-	sp->info = dev_get_platdata(&dev->dev);
-	if (!sp->info) {
-		dev_err(&dev->dev, "platform data is missing\n");
-		ret = -ENOENT;
-		goto err1;
-	}
-
-	/* setup spi bitbang adaptor */
-	sp->bitbang.master = master;
-	sp->bitbang.master->bus_num = sp->info->bus_num;
-	sp->bitbang.master->num_chipselect = sp->info->num_chipselect;
-	sp->bitbang.chipselect = sh_sci_spi_chipselect;
-
-	sp->bitbang.txrx_word[SPI_MODE_0] = sh_sci_spi_txrx_mode0;
-	sp->bitbang.txrx_word[SPI_MODE_1] = sh_sci_spi_txrx_mode1;
-	sp->bitbang.txrx_word[SPI_MODE_2] = sh_sci_spi_txrx_mode2;
-	sp->bitbang.txrx_word[SPI_MODE_3] = sh_sci_spi_txrx_mode3;
-
-	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (r == NULL) {
-		ret = -ENOENT;
-		goto err1;
-	}
-	sp->membase = ioremap(r->start, resource_size(r));
-	if (!sp->membase) {
-		ret = -ENXIO;
-		goto err1;
-	}
-	sp->val = ioread8(SCSPTR(sp));
-	setbits(sp, PIN_INIT, 1);
-
-	ret = spi_bitbang_start(&sp->bitbang);
-	if (!ret)
-		return 0;
-
-	setbits(sp, PIN_INIT, 0);
-	iounmap(sp->membase);
- err1:
-	spi_master_put(sp->bitbang.master);
- err0:
-	return ret;
-}
-
-static int sh_sci_spi_remove(struct platform_device *dev)
-{
-	struct sh_sci_spi *sp = platform_get_drvdata(dev);
-
-	spi_bitbang_stop(&sp->bitbang);
-	setbits(sp, PIN_INIT, 0);
-	iounmap(sp->membase);
-	spi_master_put(sp->bitbang.master);
-	return 0;
-}
-
-static struct platform_driver sh_sci_spi_drv = {
-	.probe		= sh_sci_spi_probe,
-	.remove		= sh_sci_spi_remove,
-	.driver		= {
-		.name	= "spi_sh_sci",
-	},
-};
-module_platform_driver(sh_sci_spi_drv);
-
-MODULE_DESCRIPTION("SH SCI SPI Driver");
-MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:spi_sh_sci");
-- 
2.39.0

