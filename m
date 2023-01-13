Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B55F668D26
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241282AbjAMG37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240696AbjAMG0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:26:06 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681155A880;
        Thu, 12 Jan 2023 22:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=brkgyM1hhrmjLwT1BCvS491OM9ZvmSvWuQcY6ZdmaEQ=; b=rclg5IcyZx3hAYAW2A82gKgG/R
        9h9Oe/wM1Koo+NmcZ4yMIJIFj+qyIun0yWyAuormOj2yAyWxmpqiP2tOTjglLnHiXw+LO8ETgIdA+
        5Svhx7nVkyRr8shQSGKZC980O+hinT+yIkJMia9iivbaAqpxScAjdfS1ylAfFTuFfEpPajKlizKuC
        x920Cmh9IN6hilV+vdW649ilBNPtNcRIhR92SLyVFpjckwWhuUlUQEzckeqR1pXS3MdV0ZyVfntjY
        4ZjNun8OKq1jiBsWb6I8b5g9mXdhx5n98DESlAo/jfRw7Kht5JW4J78GkDbW2pZIH+YhQxqch531J
        NCRDTDXw==;
Received: from [2001:4bb8:181:656b:9509:7d20:8d39:f895] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGDUT-000lua-TT; Fri, 13 Jan 2023 06:24:38 +0000
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
Subject: [PATCH 15/22] spi: remove spi-sh
Date:   Fri, 13 Jan 2023 07:23:32 +0100
Message-Id: <20230113062339.1909087-16-hch@lst.de>
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
 drivers/spi/Kconfig  |   6 -
 drivers/spi/Makefile |   1 -
 drivers/spi/spi-sh.c | 474 -------------------------------------------
 3 files changed, 481 deletions(-)
 delete mode 100644 drivers/spi/spi-sh.c

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 2c5226adf5e1d3..7508dcef909c78 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -882,12 +882,6 @@ config SPI_SH_MSIOF
 	help
 	  SPI driver for SuperH and SH Mobile MSIOF blocks.
 
-config SPI_SH
-	tristate "SuperH SPI controller"
-	depends on SUPERH || COMPILE_TEST
-	help
-	  SPI driver for SuperH SPI blocks.
-
 config SPI_SH_SCI
 	tristate "SuperH SCI SPI controller"
 	depends on SUPERH
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index be9ba40ef8d03d..342a7eb5181c9b 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -116,7 +116,6 @@ obj-$(CONFIG_SPI_S3C24XX)		+= spi-s3c24xx-hw.o
 spi-s3c24xx-hw-y			:= spi-s3c24xx.o
 obj-$(CONFIG_SPI_S3C64XX)		+= spi-s3c64xx.o
 obj-$(CONFIG_SPI_SC18IS602)		+= spi-sc18is602.o
-obj-$(CONFIG_SPI_SH)			+= spi-sh.o
 obj-$(CONFIG_SPI_SH_HSPI)		+= spi-sh-hspi.o
 obj-$(CONFIG_SPI_SH_MSIOF)		+= spi-sh-msiof.o
 obj-$(CONFIG_SPI_SH_SCI)		+= spi-sh-sci.o
diff --git a/drivers/spi/spi-sh.c b/drivers/spi/spi-sh.c
deleted file mode 100644
index 3e72fad99adfd4..00000000000000
--- a/drivers/spi/spi-sh.c
+++ /dev/null
@@ -1,474 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * SH SPI bus driver
- *
- * Copyright (C) 2011  Renesas Solutions Corp.
- *
- * Based on pxa2xx_spi.c:
- * Copyright (C) 2005 Stephen Street / StreetFire Sound Labs
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/errno.h>
-#include <linux/timer.h>
-#include <linux/delay.h>
-#include <linux/list.h>
-#include <linux/workqueue.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/io.h>
-#include <linux/spi/spi.h>
-
-#define SPI_SH_TBR		0x00
-#define SPI_SH_RBR		0x00
-#define SPI_SH_CR1		0x08
-#define SPI_SH_CR2		0x10
-#define SPI_SH_CR3		0x18
-#define SPI_SH_CR4		0x20
-#define SPI_SH_CR5		0x28
-
-/* CR1 */
-#define SPI_SH_TBE		0x80
-#define SPI_SH_TBF		0x40
-#define SPI_SH_RBE		0x20
-#define SPI_SH_RBF		0x10
-#define SPI_SH_PFONRD		0x08
-#define SPI_SH_SSDB		0x04
-#define SPI_SH_SSD		0x02
-#define SPI_SH_SSA		0x01
-
-/* CR2 */
-#define SPI_SH_RSTF		0x80
-#define SPI_SH_LOOPBK		0x40
-#define SPI_SH_CPOL		0x20
-#define SPI_SH_CPHA		0x10
-#define SPI_SH_L1M0		0x08
-
-/* CR3 */
-#define SPI_SH_MAX_BYTE		0xFF
-
-/* CR4 */
-#define SPI_SH_TBEI		0x80
-#define SPI_SH_TBFI		0x40
-#define SPI_SH_RBEI		0x20
-#define SPI_SH_RBFI		0x10
-#define SPI_SH_WPABRT		0x04
-#define SPI_SH_SSS		0x01
-
-/* CR8 */
-#define SPI_SH_P1L0		0x80
-#define SPI_SH_PP1L0		0x40
-#define SPI_SH_MUXI		0x20
-#define SPI_SH_MUXIRQ		0x10
-
-#define SPI_SH_FIFO_SIZE	32
-#define SPI_SH_SEND_TIMEOUT	(3 * HZ)
-#define SPI_SH_RECEIVE_TIMEOUT	(HZ >> 3)
-
-#undef DEBUG
-
-struct spi_sh_data {
-	void __iomem *addr;
-	int irq;
-	struct spi_master *master;
-	unsigned long cr1;
-	wait_queue_head_t wait;
-	int width;
-};
-
-static void spi_sh_write(struct spi_sh_data *ss, unsigned long data,
-			     unsigned long offset)
-{
-	if (ss->width == 8)
-		iowrite8(data, ss->addr + (offset >> 2));
-	else if (ss->width == 32)
-		iowrite32(data, ss->addr + offset);
-}
-
-static unsigned long spi_sh_read(struct spi_sh_data *ss, unsigned long offset)
-{
-	if (ss->width == 8)
-		return ioread8(ss->addr + (offset >> 2));
-	else if (ss->width == 32)
-		return ioread32(ss->addr + offset);
-	else
-		return 0;
-}
-
-static void spi_sh_set_bit(struct spi_sh_data *ss, unsigned long val,
-				unsigned long offset)
-{
-	unsigned long tmp;
-
-	tmp = spi_sh_read(ss, offset);
-	tmp |= val;
-	spi_sh_write(ss, tmp, offset);
-}
-
-static void spi_sh_clear_bit(struct spi_sh_data *ss, unsigned long val,
-				unsigned long offset)
-{
-	unsigned long tmp;
-
-	tmp = spi_sh_read(ss, offset);
-	tmp &= ~val;
-	spi_sh_write(ss, tmp, offset);
-}
-
-static void clear_fifo(struct spi_sh_data *ss)
-{
-	spi_sh_set_bit(ss, SPI_SH_RSTF, SPI_SH_CR2);
-	spi_sh_clear_bit(ss, SPI_SH_RSTF, SPI_SH_CR2);
-}
-
-static int spi_sh_wait_receive_buffer(struct spi_sh_data *ss)
-{
-	int timeout = 100000;
-
-	while (spi_sh_read(ss, SPI_SH_CR1) & SPI_SH_RBE) {
-		udelay(10);
-		if (timeout-- < 0)
-			return -ETIMEDOUT;
-	}
-	return 0;
-}
-
-static int spi_sh_wait_write_buffer_empty(struct spi_sh_data *ss)
-{
-	int timeout = 100000;
-
-	while (!(spi_sh_read(ss, SPI_SH_CR1) & SPI_SH_TBE)) {
-		udelay(10);
-		if (timeout-- < 0)
-			return -ETIMEDOUT;
-	}
-	return 0;
-}
-
-static int spi_sh_send(struct spi_sh_data *ss, struct spi_message *mesg,
-			struct spi_transfer *t)
-{
-	int i, retval = 0;
-	int remain = t->len;
-	int cur_len;
-	unsigned char *data;
-	long ret;
-
-	if (t->len)
-		spi_sh_set_bit(ss, SPI_SH_SSA, SPI_SH_CR1);
-
-	data = (unsigned char *)t->tx_buf;
-	while (remain > 0) {
-		cur_len = min(SPI_SH_FIFO_SIZE, remain);
-		for (i = 0; i < cur_len &&
-				!(spi_sh_read(ss, SPI_SH_CR4) &
-							SPI_SH_WPABRT) &&
-				!(spi_sh_read(ss, SPI_SH_CR1) & SPI_SH_TBF);
-				i++)
-			spi_sh_write(ss, (unsigned long)data[i], SPI_SH_TBR);
-
-		if (spi_sh_read(ss, SPI_SH_CR4) & SPI_SH_WPABRT) {
-			/* Abort SPI operation */
-			spi_sh_set_bit(ss, SPI_SH_WPABRT, SPI_SH_CR4);
-			retval = -EIO;
-			break;
-		}
-
-		cur_len = i;
-
-		remain -= cur_len;
-		data += cur_len;
-
-		if (remain > 0) {
-			ss->cr1 &= ~SPI_SH_TBE;
-			spi_sh_set_bit(ss, SPI_SH_TBE, SPI_SH_CR4);
-			ret = wait_event_interruptible_timeout(ss->wait,
-						 ss->cr1 & SPI_SH_TBE,
-						 SPI_SH_SEND_TIMEOUT);
-			if (ret == 0 && !(ss->cr1 & SPI_SH_TBE)) {
-				printk(KERN_ERR "%s: timeout\n", __func__);
-				return -ETIMEDOUT;
-			}
-		}
-	}
-
-	if (list_is_last(&t->transfer_list, &mesg->transfers)) {
-		spi_sh_clear_bit(ss, SPI_SH_SSD | SPI_SH_SSDB, SPI_SH_CR1);
-		spi_sh_set_bit(ss, SPI_SH_SSA, SPI_SH_CR1);
-
-		ss->cr1 &= ~SPI_SH_TBE;
-		spi_sh_set_bit(ss, SPI_SH_TBE, SPI_SH_CR4);
-		ret = wait_event_interruptible_timeout(ss->wait,
-					 ss->cr1 & SPI_SH_TBE,
-					 SPI_SH_SEND_TIMEOUT);
-		if (ret == 0 && (ss->cr1 & SPI_SH_TBE)) {
-			printk(KERN_ERR "%s: timeout\n", __func__);
-			return -ETIMEDOUT;
-		}
-	}
-
-	return retval;
-}
-
-static int spi_sh_receive(struct spi_sh_data *ss, struct spi_message *mesg,
-			  struct spi_transfer *t)
-{
-	int i;
-	int remain = t->len;
-	int cur_len;
-	unsigned char *data;
-	long ret;
-
-	if (t->len > SPI_SH_MAX_BYTE)
-		spi_sh_write(ss, SPI_SH_MAX_BYTE, SPI_SH_CR3);
-	else
-		spi_sh_write(ss, t->len, SPI_SH_CR3);
-
-	spi_sh_clear_bit(ss, SPI_SH_SSD | SPI_SH_SSDB, SPI_SH_CR1);
-	spi_sh_set_bit(ss, SPI_SH_SSA, SPI_SH_CR1);
-
-	spi_sh_wait_write_buffer_empty(ss);
-
-	data = (unsigned char *)t->rx_buf;
-	while (remain > 0) {
-		if (remain >= SPI_SH_FIFO_SIZE) {
-			ss->cr1 &= ~SPI_SH_RBF;
-			spi_sh_set_bit(ss, SPI_SH_RBF, SPI_SH_CR4);
-			ret = wait_event_interruptible_timeout(ss->wait,
-						 ss->cr1 & SPI_SH_RBF,
-						 SPI_SH_RECEIVE_TIMEOUT);
-			if (ret == 0 &&
-			    spi_sh_read(ss, SPI_SH_CR1) & SPI_SH_RBE) {
-				printk(KERN_ERR "%s: timeout\n", __func__);
-				return -ETIMEDOUT;
-			}
-		}
-
-		cur_len = min(SPI_SH_FIFO_SIZE, remain);
-		for (i = 0; i < cur_len; i++) {
-			if (spi_sh_wait_receive_buffer(ss))
-				break;
-			data[i] = (unsigned char)spi_sh_read(ss, SPI_SH_RBR);
-		}
-
-		remain -= cur_len;
-		data += cur_len;
-	}
-
-	/* deassert CS when SPI is receiving. */
-	if (t->len > SPI_SH_MAX_BYTE) {
-		clear_fifo(ss);
-		spi_sh_write(ss, 1, SPI_SH_CR3);
-	} else {
-		spi_sh_write(ss, 0, SPI_SH_CR3);
-	}
-
-	return 0;
-}
-
-static int spi_sh_transfer_one_message(struct spi_controller *ctlr,
-					struct spi_message *mesg)
-{
-	struct spi_sh_data *ss = spi_controller_get_devdata(ctlr);
-	struct spi_transfer *t;
-	int ret;
-
-	pr_debug("%s: enter\n", __func__);
-
-	spi_sh_clear_bit(ss, SPI_SH_SSA, SPI_SH_CR1);
-
-	list_for_each_entry(t, &mesg->transfers, transfer_list) {
-		pr_debug("tx_buf = %p, rx_buf = %p\n",
-			 t->tx_buf, t->rx_buf);
-		pr_debug("len = %d, delay.value = %d\n",
-			 t->len, t->delay.value);
-
-		if (t->tx_buf) {
-			ret = spi_sh_send(ss, mesg, t);
-			if (ret < 0)
-				goto error;
-		}
-		if (t->rx_buf) {
-			ret = spi_sh_receive(ss, mesg, t);
-			if (ret < 0)
-				goto error;
-		}
-		mesg->actual_length += t->len;
-	}
-
-	mesg->status = 0;
-	spi_finalize_current_message(ctlr);
-
-	clear_fifo(ss);
-	spi_sh_set_bit(ss, SPI_SH_SSD, SPI_SH_CR1);
-	udelay(100);
-
-	spi_sh_clear_bit(ss, SPI_SH_SSA | SPI_SH_SSDB | SPI_SH_SSD,
-			 SPI_SH_CR1);
-
-	clear_fifo(ss);
-
-	return 0;
-
- error:
-	mesg->status = ret;
-	spi_finalize_current_message(ctlr);
-	if (mesg->complete)
-		mesg->complete(mesg->context);
-
-	spi_sh_clear_bit(ss, SPI_SH_SSA | SPI_SH_SSDB | SPI_SH_SSD,
-			 SPI_SH_CR1);
-	clear_fifo(ss);
-
-	return ret;
-}
-
-static int spi_sh_setup(struct spi_device *spi)
-{
-	struct spi_sh_data *ss = spi_master_get_devdata(spi->master);
-
-	pr_debug("%s: enter\n", __func__);
-
-	spi_sh_write(ss, 0xfe, SPI_SH_CR1);	/* SPI sycle stop */
-	spi_sh_write(ss, 0x00, SPI_SH_CR1);	/* CR1 init */
-	spi_sh_write(ss, 0x00, SPI_SH_CR3);	/* CR3 init */
-
-	clear_fifo(ss);
-
-	/* 1/8 clock */
-	spi_sh_write(ss, spi_sh_read(ss, SPI_SH_CR2) | 0x07, SPI_SH_CR2);
-	udelay(10);
-
-	return 0;
-}
-
-static void spi_sh_cleanup(struct spi_device *spi)
-{
-	struct spi_sh_data *ss = spi_master_get_devdata(spi->master);
-
-	pr_debug("%s: enter\n", __func__);
-
-	spi_sh_clear_bit(ss, SPI_SH_SSA | SPI_SH_SSDB | SPI_SH_SSD,
-			 SPI_SH_CR1);
-}
-
-static irqreturn_t spi_sh_irq(int irq, void *_ss)
-{
-	struct spi_sh_data *ss = (struct spi_sh_data *)_ss;
-	unsigned long cr1;
-
-	cr1 = spi_sh_read(ss, SPI_SH_CR1);
-	if (cr1 & SPI_SH_TBE)
-		ss->cr1 |= SPI_SH_TBE;
-	if (cr1 & SPI_SH_TBF)
-		ss->cr1 |= SPI_SH_TBF;
-	if (cr1 & SPI_SH_RBE)
-		ss->cr1 |= SPI_SH_RBE;
-	if (cr1 & SPI_SH_RBF)
-		ss->cr1 |= SPI_SH_RBF;
-
-	if (ss->cr1) {
-		spi_sh_clear_bit(ss, ss->cr1, SPI_SH_CR4);
-		wake_up(&ss->wait);
-	}
-
-	return IRQ_HANDLED;
-}
-
-static int spi_sh_remove(struct platform_device *pdev)
-{
-	struct spi_sh_data *ss = platform_get_drvdata(pdev);
-
-	spi_unregister_master(ss->master);
-	free_irq(ss->irq, ss);
-
-	return 0;
-}
-
-static int spi_sh_probe(struct platform_device *pdev)
-{
-	struct resource *res;
-	struct spi_master *master;
-	struct spi_sh_data *ss;
-	int ret, irq;
-
-	/* get base addr */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (unlikely(res == NULL)) {
-		dev_err(&pdev->dev, "invalid resource\n");
-		return -EINVAL;
-	}
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
-	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct spi_sh_data));
-	if (master == NULL) {
-		dev_err(&pdev->dev, "spi_alloc_master error.\n");
-		return -ENOMEM;
-	}
-
-	ss = spi_master_get_devdata(master);
-	platform_set_drvdata(pdev, ss);
-
-	switch (res->flags & IORESOURCE_MEM_TYPE_MASK) {
-	case IORESOURCE_MEM_8BIT:
-		ss->width = 8;
-		break;
-	case IORESOURCE_MEM_32BIT:
-		ss->width = 32;
-		break;
-	default:
-		dev_err(&pdev->dev, "No support width\n");
-		return -ENODEV;
-	}
-	ss->irq = irq;
-	ss->master = master;
-	ss->addr = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	if (ss->addr == NULL) {
-		dev_err(&pdev->dev, "ioremap error.\n");
-		return -ENOMEM;
-	}
-	init_waitqueue_head(&ss->wait);
-
-	ret = request_irq(irq, spi_sh_irq, 0, "spi_sh", ss);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "request_irq error\n");
-		return ret;
-	}
-
-	master->num_chipselect = 2;
-	master->bus_num = pdev->id;
-	master->setup = spi_sh_setup;
-	master->transfer_one_message = spi_sh_transfer_one_message;
-	master->cleanup = spi_sh_cleanup;
-
-	ret = spi_register_master(master);
-	if (ret < 0) {
-		printk(KERN_ERR "spi_register_master error.\n");
-		goto error3;
-	}
-
-	return 0;
-
- error3:
-	free_irq(irq, ss);
-	return ret;
-}
-
-static struct platform_driver spi_sh_driver = {
-	.probe = spi_sh_probe,
-	.remove = spi_sh_remove,
-	.driver = {
-		.name = "sh_spi",
-	},
-};
-module_platform_driver(spi_sh_driver);
-
-MODULE_DESCRIPTION("SH SPI bus driver");
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Yoshihiro Shimoda");
-MODULE_ALIAS("platform:sh_spi");
-- 
2.39.0

