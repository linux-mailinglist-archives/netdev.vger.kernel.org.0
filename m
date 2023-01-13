Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F65A668D52
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241255AbjAMG3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240753AbjAMG0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:26:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873DE5BA14;
        Thu, 12 Jan 2023 22:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=iukbm4IkjfomIK3EfPQb3pM2uZtgleJjPX7CiCdGPsw=; b=bctQ26YIIgDNETWqWEH1faeoiC
        5ktgEfTapXGrurmR9U4e7rnZhY6Cwur/HNcTFDEguI7nrrjhQMk5LJZRnXQk/Lh/SgAsj5oUR1cNC
        6SWrceAqwQKLhXM4b9+5hQvSpMqgJj6Fi1i/TaketNXyVfW/AwoYVQnx70z7dzq4fJub9GsHbuyZ5
        HDmhDiNuu8m8OdZDuEJyIrydgrmSdNheR0U9+6Rotsg72jUQftqVDSCn6tM1GTULxOLQT60TelhnY
        qeYO2LcPFeCb7ZL/Bxwy4AWEhdIRBjlajWtTjxyUMXW5KzAfXsUm2V07QOaprHacrHX0gFnJIBipd
        ZAhGSquQ==;
Received: from [2001:4bb8:181:656b:9509:7d20:8d39:f895] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGDUZ-000lye-Sk; Fri, 13 Jan 2023 06:24:44 +0000
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
Subject: [PATCH 17/22] spi: remove spi-jcore
Date:   Fri, 13 Jan 2023 07:23:34 +0100
Message-Id: <20230113062339.1909087-18-hch@lst.de>
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
 drivers/spi/Kconfig     |   7 --
 drivers/spi/Makefile    |   1 -
 drivers/spi/spi-jcore.c | 235 ----------------------------------------
 3 files changed, 243 deletions(-)
 delete mode 100644 drivers/spi/spi-jcore.c

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 76f3bc6f8c81fc..17c75f5c19be75 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -483,13 +483,6 @@ config SPI_INTEL_PLATFORM
 	  To compile this driver as a module, choose M here: the module
 	  will be called spi-intel-platform.
 
-config SPI_JCORE
-	tristate "J-Core SPI Master"
-	depends on OF && (SUPERH || COMPILE_TEST)
-	help
-	  This enables support for the SPI master controller in the J-Core
-	  synthesizable, open source SoC.
-
 config SPI_LM70_LLP
 	tristate "Parallel port adapter for LM70 eval board (DEVELOPMENT)"
 	depends on PARPORT
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 27d877440c6539..2d03fcefc11ea2 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -67,7 +67,6 @@ obj-$(CONFIG_SPI_INTEL)			+= spi-intel.o
 obj-$(CONFIG_SPI_INTEL_PCI)		+= spi-intel-pci.o
 obj-$(CONFIG_SPI_INTEL_PLATFORM)	+= spi-intel-platform.o
 obj-$(CONFIG_SPI_LANTIQ_SSC)		+= spi-lantiq-ssc.o
-obj-$(CONFIG_SPI_JCORE)			+= spi-jcore.o
 obj-$(CONFIG_SPI_LM70_LLP)		+= spi-lm70llp.o
 obj-$(CONFIG_SPI_LP8841_RTC)		+= spi-lp8841-rtc.o
 obj-$(CONFIG_SPI_MESON_SPICC)		+= spi-meson-spicc.o
diff --git a/drivers/spi/spi-jcore.c b/drivers/spi/spi-jcore.c
deleted file mode 100644
index 74c8319c29f170..00000000000000
--- a/drivers/spi/spi-jcore.c
+++ /dev/null
@@ -1,235 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * J-Core SPI controller driver
- *
- * Copyright (C) 2012-2016 Smart Energy Instruments, Inc.
- *
- * Current version by Rich Felker
- * Based loosely on initial version by Oleksandr G Zhadan
- *
- */
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/errno.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/spi/spi.h>
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/of.h>
-#include <linux/delay.h>
-
-#define DRV_NAME	"jcore_spi"
-
-#define CTRL_REG	0x0
-#define DATA_REG	0x4
-
-#define JCORE_SPI_CTRL_XMIT		0x02
-#define JCORE_SPI_STAT_BUSY		0x02
-#define JCORE_SPI_CTRL_LOOP		0x08
-#define JCORE_SPI_CTRL_CS_BITS		0x15
-
-#define JCORE_SPI_WAIT_RDY_MAX_LOOP	2000000
-
-struct jcore_spi {
-	struct spi_master *master;
-	void __iomem *base;
-	unsigned int cs_reg;
-	unsigned int speed_reg;
-	unsigned int speed_hz;
-	unsigned int clock_freq;
-};
-
-static int jcore_spi_wait(void __iomem *ctrl_reg)
-{
-	unsigned timeout = JCORE_SPI_WAIT_RDY_MAX_LOOP;
-
-	do {
-		if (!(readl(ctrl_reg) & JCORE_SPI_STAT_BUSY))
-			return 0;
-		cpu_relax();
-	} while (--timeout);
-
-	return -EBUSY;
-}
-
-static void jcore_spi_program(struct jcore_spi *hw)
-{
-	void __iomem *ctrl_reg = hw->base + CTRL_REG;
-
-	if (jcore_spi_wait(ctrl_reg))
-		dev_err(hw->master->dev.parent,
-			"timeout waiting to program ctrl reg.\n");
-
-	writel(hw->cs_reg | hw->speed_reg, ctrl_reg);
-}
-
-static void jcore_spi_chipsel(struct spi_device *spi, bool value)
-{
-	struct jcore_spi *hw = spi_master_get_devdata(spi->master);
-	u32 csbit = 1U << (2 * spi->chip_select);
-
-	dev_dbg(hw->master->dev.parent, "chipselect %d\n", spi->chip_select);
-
-	if (value)
-		hw->cs_reg |= csbit;
-	else
-		hw->cs_reg &= ~csbit;
-
-	jcore_spi_program(hw);
-}
-
-static void jcore_spi_baudrate(struct jcore_spi *hw, int speed)
-{
-	if (speed == hw->speed_hz)
-		return;
-	hw->speed_hz = speed;
-	if (speed >= hw->clock_freq / 2)
-		hw->speed_reg = 0;
-	else
-		hw->speed_reg = ((hw->clock_freq / 2 / speed) - 1) << 27;
-	jcore_spi_program(hw);
-	dev_dbg(hw->master->dev.parent, "speed=%d reg=0x%x\n",
-		speed, hw->speed_reg);
-}
-
-static int jcore_spi_txrx(struct spi_master *master, struct spi_device *spi,
-			  struct spi_transfer *t)
-{
-	struct jcore_spi *hw = spi_master_get_devdata(master);
-
-	void __iomem *ctrl_reg = hw->base + CTRL_REG;
-	void __iomem *data_reg = hw->base + DATA_REG;
-	u32 xmit;
-
-	/* data buffers */
-	const unsigned char *tx;
-	unsigned char *rx;
-	unsigned int len;
-	unsigned int count;
-
-	jcore_spi_baudrate(hw, t->speed_hz);
-
-	xmit = hw->cs_reg | hw->speed_reg | JCORE_SPI_CTRL_XMIT;
-	tx = t->tx_buf;
-	rx = t->rx_buf;
-	len = t->len;
-
-	for (count = 0; count < len; count++) {
-		if (jcore_spi_wait(ctrl_reg))
-			break;
-
-		writel(tx ? *tx++ : 0, data_reg);
-		writel(xmit, ctrl_reg);
-
-		if (jcore_spi_wait(ctrl_reg))
-			break;
-
-		if (rx)
-			*rx++ = readl(data_reg);
-	}
-
-	spi_finalize_current_transfer(master);
-
-	if (count < len)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int jcore_spi_probe(struct platform_device *pdev)
-{
-	struct device_node *node = pdev->dev.of_node;
-	struct jcore_spi *hw;
-	struct spi_master *master;
-	struct resource *res;
-	u32 clock_freq;
-	struct clk *clk;
-	int err = -ENODEV;
-
-	master = spi_alloc_master(&pdev->dev, sizeof(struct jcore_spi));
-	if (!master)
-		return err;
-
-	/* Setup the master state. */
-	master->num_chipselect = 3;
-	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
-	master->transfer_one = jcore_spi_txrx;
-	master->set_cs = jcore_spi_chipsel;
-	master->dev.of_node = node;
-	master->bus_num = pdev->id;
-
-	hw = spi_master_get_devdata(master);
-	hw->master = master;
-	platform_set_drvdata(pdev, hw);
-
-	/* Find and map our resources */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		goto exit_busy;
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res), pdev->name))
-		goto exit_busy;
-	hw->base = devm_ioremap(&pdev->dev, res->start,
-					resource_size(res));
-	if (!hw->base)
-		goto exit_busy;
-
-	/*
-	 * The SPI clock rate controlled via a configurable clock divider
-	 * which is applied to the reference clock. A 50 MHz reference is
-	 * most suitable for obtaining standard SPI clock rates, but some
-	 * designs may have a different reference clock, and the DT must
-	 * make the driver aware so that it can properly program the
-	 * requested rate. If the clock is omitted, 50 MHz is assumed.
-	 */
-	clock_freq = 50000000;
-	clk = devm_clk_get(&pdev->dev, "ref_clk");
-	if (!IS_ERR(clk)) {
-		if (clk_prepare_enable(clk) == 0) {
-			clock_freq = clk_get_rate(clk);
-			clk_disable_unprepare(clk);
-		} else
-			dev_warn(&pdev->dev, "could not enable ref_clk\n");
-	}
-	hw->clock_freq = clock_freq;
-
-	/* Initialize all CS bits to high. */
-	hw->cs_reg = JCORE_SPI_CTRL_CS_BITS;
-	jcore_spi_baudrate(hw, 400000);
-
-	/* Register our spi controller */
-	err = devm_spi_register_master(&pdev->dev, master);
-	if (err)
-		goto exit;
-
-	return 0;
-
-exit_busy:
-	err = -EBUSY;
-exit:
-	spi_master_put(master);
-	return err;
-}
-
-static const struct of_device_id jcore_spi_of_match[] = {
-	{ .compatible = "jcore,spi2" },
-	{},
-};
-MODULE_DEVICE_TABLE(of, jcore_spi_of_match);
-
-static struct platform_driver jcore_spi_driver = {
-	.probe = jcore_spi_probe,
-	.driver = {
-		.name = DRV_NAME,
-		.of_match_table = jcore_spi_of_match,
-	},
-};
-
-module_platform_driver(jcore_spi_driver);
-
-MODULE_DESCRIPTION("J-Core SPI driver");
-MODULE_AUTHOR("Rich Felker <dalias@libc.org>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:" DRV_NAME);
-- 
2.39.0

