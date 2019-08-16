Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5068F811
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfHPApO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41119 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfHPApJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id j16so3788501wrr.8;
        Thu, 15 Aug 2019 17:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7rdbKkJ8VMSjMUOcNRC+MbsZYKBs+Ac7JiZfi2fsQ6E=;
        b=B0/58s10N8ZJ2XaRr5B0QMBmqxbR52g1OoHTLcW9BsNTAa331CI+ojK60jYfxEpzOV
         2lv1YgDMYpTYRHrSsVbKXl5X0c/5DgtNSefxfb5PUTLhZJBurL51cO4naHBiEw7Hzzfn
         VbDuJPbfI3KknrlNzHWOzC/3Kko2AUoQXxyCFc/5aLFKH3PWU8la2zUS2e121ub/n/qK
         c8sM0tivPk7sKxualu2yng5G8QuYS/sZc8lHU0p3iES+BWQaG38IVh6W8bqayh6RYeXD
         Z4CTyQYyk+qQNBbzplV+upovc9zfqM5DJnpycY0GlqBm2QgAEI6VRADkd6WVJevwLLnJ
         97XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7rdbKkJ8VMSjMUOcNRC+MbsZYKBs+Ac7JiZfi2fsQ6E=;
        b=Q1n3ArWAdilwmJezLuCt5tdKQRS0Xta2EOgNpJ68EdNknoxPdZj9w1QsEG9nMldcvJ
         R8P1N6t9Nm0pI/Dpn6AmiWoTIBiaSNyzNK7a6fEl23c0XEKr+4gG2BWTk+SXriNIemAw
         O8Vsj0v02IhhHVwxV4D6sXO2eG4wn4S/TqYAMDXh3b4Dp9JQlO3RQqsnqwYC2BzwlgUp
         d/uD2IEx0b0TS44Z7+44GM8aIJPwnCMYEshLLDaOHeWU+gv4alQwG6Bs9aDuGu7uMW+m
         M++4NJdsOI0jBRp036/3xRQZcj6bJMyTqtvNtGM/bNAF1xPiXW5WfFbm5fqujJ0bvK0s
         Cv2g==
X-Gm-Message-State: APjAAAXy0YXPNfF+RMWAOBNsDIahcsDlPGeB2MopVM/7boWnOxn01IDL
        2LmJ7xhM9hEZJcnjdepFYSo=
X-Google-Smtp-Source: APXvYqyeFoN0kAbdlWCPtUKgE0TV1PykdjI2xhdqdmulJ+ehr7gcb1rWgsYS658ovmUmtd2Kt1kFkw==
X-Received: by 2002:adf:f3c5:: with SMTP id g5mr8775wrp.189.1565916306348;
        Thu, 15 Aug 2019 17:45:06 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 04/11] spi: spi-fsl-dspi: Cosmetic cleanup
Date:   Fri, 16 Aug 2019 03:44:42 +0300
Message-Id: <20190816004449.10100-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816004449.10100-1-olteanv@gmail.com>
References: <20190816004449.10100-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses some cosmetic issues:
- Alignment
- Typos
- (Non-)use of BIT() and GENMASK() macros
- Unused definitions
- Unused includes
- Abuse of ternary operator in detriment of readability
- Reduce indentation level

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi-fsl-dspi.c | 312 ++++++++++++++++++-------------------
 1 file changed, 154 insertions(+), 158 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 53335ccc98f6..99708b36ee4f 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -9,26 +9,16 @@
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
-#include <linux/err.h>
-#include <linux/errno.h>
 #include <linux/interrupt.h>
-#include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/math64.h>
 #include <linux/module.h>
-#include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/pinctrl/consumer.h>
-#include <linux/platform_device.h>
-#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
-#include <linux/sched.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/spi-fsl-dspi.h>
-#include <linux/spi/spi_bitbang.h>
-#include <linux/time.h>
 
-#define DRIVER_NAME "fsl-dspi"
+#define DRIVER_NAME			"fsl-dspi"
 
 #ifdef CONFIG_M5441x
 #define DSPI_FIFO_SIZE			16
@@ -37,97 +27,98 @@
 #endif
 #define DSPI_DMA_BUFSIZE		(DSPI_FIFO_SIZE * 1024)
 
-#define SPI_MCR		0x00
-#define SPI_MCR_MASTER		(1 << 31)
-#define SPI_MCR_PCSIS		(0x3F << 16)
-#define SPI_MCR_CLR_TXF	(1 << 11)
-#define SPI_MCR_CLR_RXF	(1 << 10)
-#define SPI_MCR_XSPI		(1 << 3)
-
-#define SPI_TCR			0x08
-#define SPI_TCR_GET_TCNT(x)	(((x) & 0xffff0000) >> 16)
-
-#define SPI_CTAR(x)		(0x0c + (((x) & 0x3) * 4))
-#define SPI_CTAR_FMSZ(x)	(((x) & 0x0000000f) << 27)
-#define SPI_CTAR_CPOL(x)	((x) << 26)
-#define SPI_CTAR_CPHA(x)	((x) << 25)
-#define SPI_CTAR_LSBFE(x)	((x) << 24)
-#define SPI_CTAR_PCSSCK(x)	(((x) & 0x00000003) << 22)
-#define SPI_CTAR_PASC(x)	(((x) & 0x00000003) << 20)
-#define SPI_CTAR_PDT(x)	(((x) & 0x00000003) << 18)
-#define SPI_CTAR_PBR(x)	(((x) & 0x00000003) << 16)
-#define SPI_CTAR_CSSCK(x)	(((x) & 0x0000000f) << 12)
-#define SPI_CTAR_ASC(x)	(((x) & 0x0000000f) << 8)
-#define SPI_CTAR_DT(x)		(((x) & 0x0000000f) << 4)
-#define SPI_CTAR_BR(x)		((x) & 0x0000000f)
-#define SPI_CTAR_SCALE_BITS	0xf
-
-#define SPI_CTAR0_SLAVE	0x0c
-
-#define SPI_SR			0x2c
-#define SPI_SR_EOQF		0x10000000
-#define SPI_SR_TCFQF		0x80000000
-#define SPI_SR_CLEAR		0x9aaf0000
-
-#define SPI_RSER_TFFFE		BIT(25)
-#define SPI_RSER_TFFFD		BIT(24)
-#define SPI_RSER_RFDFE		BIT(17)
-#define SPI_RSER_RFDFD		BIT(16)
-
-#define SPI_RSER		0x30
-#define SPI_RSER_EOQFE		0x10000000
-#define SPI_RSER_TCFQE		0x80000000
-
-#define SPI_PUSHR		0x34
-#define SPI_PUSHR_CMD_CONT	(1 << 15)
-#define SPI_PUSHR_CONT		(SPI_PUSHR_CMD_CONT << 16)
-#define SPI_PUSHR_CMD_CTAS(x)	(((x) & 0x0003) << 12)
-#define SPI_PUSHR_CTAS(x)	(SPI_PUSHR_CMD_CTAS(x) << 16)
-#define SPI_PUSHR_CMD_EOQ	(1 << 11)
-#define SPI_PUSHR_EOQ		(SPI_PUSHR_CMD_EOQ << 16)
-#define SPI_PUSHR_CMD_CTCNT	(1 << 10)
-#define SPI_PUSHR_CTCNT		(SPI_PUSHR_CMD_CTCNT << 16)
-#define SPI_PUSHR_CMD_PCS(x)	((1 << x) & 0x003f)
-#define SPI_PUSHR_PCS(x)	(SPI_PUSHR_CMD_PCS(x) << 16)
-#define SPI_PUSHR_TXDATA(x)	((x) & 0x0000ffff)
-
-#define SPI_PUSHR_SLAVE	0x34
-
-#define SPI_POPR		0x38
-#define SPI_POPR_RXDATA(x)	((x) & 0x0000ffff)
-
-#define SPI_TXFR0		0x3c
-#define SPI_TXFR1		0x40
-#define SPI_TXFR2		0x44
-#define SPI_TXFR3		0x48
-#define SPI_RXFR0		0x7c
-#define SPI_RXFR1		0x80
-#define SPI_RXFR2		0x84
-#define SPI_RXFR3		0x88
-
-#define SPI_CTARE(x)		(0x11c + (((x) & 0x3) * 4))
-#define SPI_CTARE_FMSZE(x)	(((x) & 0x1) << 16)
-#define SPI_CTARE_DTCP(x)	((x) & 0x7ff)
-
-#define SPI_SREX		0x13c
-
-#define SPI_FRAME_BITS(bits)	SPI_CTAR_FMSZ((bits) - 1)
-#define SPI_FRAME_BITS_MASK	SPI_CTAR_FMSZ(0xf)
-#define SPI_FRAME_BITS_16	SPI_CTAR_FMSZ(0xf)
-#define SPI_FRAME_BITS_8	SPI_CTAR_FMSZ(0x7)
-
-#define SPI_FRAME_EBITS(bits)	SPI_CTARE_FMSZE(((bits) - 1) >> 4)
-#define SPI_FRAME_EBITS_MASK	SPI_CTARE_FMSZE(1)
+#define SPI_MCR				0x00
+#define SPI_MCR_MASTER			BIT(31)
+#define SPI_MCR_PCSIS			(0x3F << 16)
+#define SPI_MCR_CLR_TXF			BIT(11)
+#define SPI_MCR_CLR_RXF			BIT(10)
+#define SPI_MCR_XSPI			BIT(3)
+
+#define SPI_TCR				0x08
+#define SPI_TCR_GET_TCNT(x)		(((x) & GENMASK(31, 16)) >> 16)
+
+#define SPI_CTAR(x)			(0x0c + (((x) & GENMASK(1, 0)) * 4))
+#define SPI_CTAR_FMSZ(x)		(((x) << 27) & GENMASK(30, 27))
+#define SPI_CTAR_CPOL			BIT(26)
+#define SPI_CTAR_CPHA			BIT(25)
+#define SPI_CTAR_LSBFE			BIT(24)
+#define SPI_CTAR_PCSSCK(x)		(((x) << 22) & GENMASK(23, 22))
+#define SPI_CTAR_PASC(x)		(((x) << 20) & GENMASK(21, 20))
+#define SPI_CTAR_PDT(x)			(((x) << 18) & GENMASK(19, 18))
+#define SPI_CTAR_PBR(x)			(((x) << 16) & GENMASK(17, 16))
+#define SPI_CTAR_CSSCK(x)		(((x) << 12) & GENMASK(15, 12))
+#define SPI_CTAR_ASC(x)			(((x) << 8) & GENMASK(11, 8))
+#define SPI_CTAR_DT(x)			(((x) << 4) & GENMASK(7, 4))
+#define SPI_CTAR_BR(x)			((x) & GENMASK(3, 0))
+#define SPI_CTAR_SCALE_BITS		0xf
+
+#define SPI_CTAR0_SLAVE			0x0c
+
+#define SPI_SR				0x2c
+#define SPI_SR_TCFQF			BIT(31)
+#define SPI_SR_EOQF			BIT(28)
+#define SPI_SR_TFUF			BIT(27)
+#define SPI_SR_TFFF			BIT(25)
+#define SPI_SR_CMDTCF			BIT(23)
+#define SPI_SR_SPEF			BIT(21)
+#define SPI_SR_RFOF			BIT(19)
+#define SPI_SR_TFIWF			BIT(18)
+#define SPI_SR_RFDF			BIT(17)
+#define SPI_SR_CMDFFF			BIT(16)
+#define SPI_SR_CLEAR			(SPI_SR_TCFQF | SPI_SR_EOQF | \
+					SPI_SR_TFUF | SPI_SR_TFFF | \
+					SPI_SR_CMDTCF | SPI_SR_SPEF | \
+					SPI_SR_RFOF | SPI_SR_TFIWF | \
+					SPI_SR_RFDF | SPI_SR_CMDFFF)
+
+#define SPI_RSER_TFFFE			BIT(25)
+#define SPI_RSER_TFFFD			BIT(24)
+#define SPI_RSER_RFDFE			BIT(17)
+#define SPI_RSER_RFDFD			BIT(16)
+
+#define SPI_RSER			0x30
+#define SPI_RSER_TCFQE			BIT(31)
+#define SPI_RSER_EOQFE			BIT(28)
+
+#define SPI_PUSHR			0x34
+#define SPI_PUSHR_CMD_CONT		BIT(15)
+#define SPI_PUSHR_CMD_CTAS(x)		(((x) << 12 & GENMASK(14, 12)))
+#define SPI_PUSHR_CMD_EOQ		BIT(11)
+#define SPI_PUSHR_CMD_CTCNT		BIT(10)
+#define SPI_PUSHR_CMD_PCS(x)		(BIT(x) & GENMASK(5, 0))
+
+#define SPI_PUSHR_SLAVE			0x34
+
+#define SPI_POPR			0x38
+#define SPI_POPR_RXDATA(x)		((x) & GENMASK(15, 0))
+
+#define SPI_TXFR0			0x3c
+#define SPI_TXFR1			0x40
+#define SPI_TXFR2			0x44
+#define SPI_TXFR3			0x48
+#define SPI_RXFR0			0x7c
+#define SPI_RXFR1			0x80
+#define SPI_RXFR2			0x84
+#define SPI_RXFR3			0x88
+
+#define SPI_CTARE(x)			(0x11c + (((x) & GENMASK(1, 0)) * 4))
+#define SPI_CTARE_FMSZE(x)		(((x) & 0x1) << 16)
+#define SPI_CTARE_DTCP(x)		((x) & 0x7ff)
+
+#define SPI_SREX			0x13c
+
+#define SPI_FRAME_BITS(bits)		SPI_CTAR_FMSZ((bits) - 1)
+#define SPI_FRAME_EBITS(bits)		SPI_CTARE_FMSZE(((bits) - 1) >> 4)
 
 /* Register offsets for regmap_pushr */
-#define PUSHR_CMD		0x0
-#define PUSHR_TX		0x2
+#define PUSHR_CMD			0x0
+#define PUSHR_TX			0x2
 
-#define SPI_CS_INIT		0x01
-#define SPI_CS_ASSERT		0x02
-#define SPI_CS_DROP		0x04
+#define SPI_CS_INIT			0x01
+#define SPI_CS_ASSERT			0x02
+#define SPI_CS_DROP			0x04
 
-#define DMA_COMPLETION_TIMEOUT	msecs_to_jiffies(3000)
+#define DMA_COMPLETION_TIMEOUT		msecs_to_jiffies(3000)
 
 struct chip_data {
 	u32 ctar_val;
@@ -246,7 +237,7 @@ static void dspi_push_rx(struct fsl_dspi *dspi, u32 rxdata)
 	if (!dspi->rx)
 		return;
 
-	/* Mask of undefined bits */
+	/* Mask off undefined bits */
 	rxdata &= (1 << dspi->bits_per_word) - 1;
 
 	if (dspi->bytes_per_word == 1)
@@ -282,8 +273,8 @@ static void dspi_rx_dma_callback(void *arg)
 
 static int dspi_next_xfer_dma_submit(struct fsl_dspi *dspi)
 {
-	struct fsl_dspi_dma *dma = dspi->dma;
 	struct device *dev = &dspi->pdev->dev;
+	struct fsl_dspi_dma *dma = dspi->dma;
 	int time_left;
 	int i;
 
@@ -360,9 +351,9 @@ static int dspi_next_xfer_dma_submit(struct fsl_dspi *dspi)
 
 static int dspi_dma_xfer(struct fsl_dspi *dspi)
 {
-	struct fsl_dspi_dma *dma = dspi->dma;
-	struct device *dev = &dspi->pdev->dev;
 	struct spi_message *message = dspi->cur_msg;
+	struct device *dev = &dspi->pdev->dev;
+	struct fsl_dspi_dma *dma = dspi->dma;
 	int curr_remaining_bytes;
 	int bytes_per_buffer;
 	int ret = 0;
@@ -397,9 +388,9 @@ static int dspi_dma_xfer(struct fsl_dspi *dspi)
 
 static int dspi_request_dma(struct fsl_dspi *dspi, phys_addr_t phy_addr)
 {
-	struct fsl_dspi_dma *dma;
-	struct dma_slave_config cfg;
 	struct device *dev = &dspi->pdev->dev;
+	struct dma_slave_config cfg;
+	struct fsl_dspi_dma *dma;
 	int ret;
 
 	dma = devm_kzalloc(dev, sizeof(*dma), GFP_KERNEL);
@@ -421,14 +412,14 @@ static int dspi_request_dma(struct fsl_dspi *dspi, phys_addr_t phy_addr)
 	}
 
 	dma->tx_dma_buf = dma_alloc_coherent(dev, DSPI_DMA_BUFSIZE,
-					&dma->tx_dma_phys, GFP_KERNEL);
+					     &dma->tx_dma_phys, GFP_KERNEL);
 	if (!dma->tx_dma_buf) {
 		ret = -ENOMEM;
 		goto err_tx_dma_buf;
 	}
 
 	dma->rx_dma_buf = dma_alloc_coherent(dev, DSPI_DMA_BUFSIZE,
-					&dma->rx_dma_phys, GFP_KERNEL);
+					     &dma->rx_dma_phys, GFP_KERNEL);
 	if (!dma->rx_dma_buf) {
 		ret = -ENOMEM;
 		goto err_rx_dma_buf;
@@ -485,30 +476,31 @@ static void dspi_release_dma(struct fsl_dspi *dspi)
 	struct fsl_dspi_dma *dma = dspi->dma;
 	struct device *dev = &dspi->pdev->dev;
 
-	if (dma) {
-		if (dma->chan_tx) {
-			dma_unmap_single(dev, dma->tx_dma_phys,
-					DSPI_DMA_BUFSIZE, DMA_TO_DEVICE);
-			dma_release_channel(dma->chan_tx);
-		}
+	if (!dma)
+		return;
 
-		if (dma->chan_rx) {
-			dma_unmap_single(dev, dma->rx_dma_phys,
-					DSPI_DMA_BUFSIZE, DMA_FROM_DEVICE);
-			dma_release_channel(dma->chan_rx);
-		}
+	if (dma->chan_tx) {
+		dma_unmap_single(dev, dma->tx_dma_phys,
+				 DSPI_DMA_BUFSIZE, DMA_TO_DEVICE);
+		dma_release_channel(dma->chan_tx);
+	}
+
+	if (dma->chan_rx) {
+		dma_unmap_single(dev, dma->rx_dma_phys,
+				 DSPI_DMA_BUFSIZE, DMA_FROM_DEVICE);
+		dma_release_channel(dma->chan_rx);
 	}
 }
 
 static void hz_to_spi_baud(char *pbr, char *br, int speed_hz,
-		unsigned long clkrate)
+			   unsigned long clkrate)
 {
 	/* Valid baud rate pre-scaler values */
 	int pbr_tbl[4] = {2, 3, 5, 7};
 	int brs[16] = {	2,	4,	6,	8,
-		16,	32,	64,	128,
-		256,	512,	1024,	2048,
-		4096,	8192,	16384,	32768 };
+			16,	32,	64,	128,
+			256,	512,	1024,	2048,
+			4096,	8192,	16384,	32768 };
 	int scale_needed, scale, minscale = INT_MAX;
 	int i, j;
 
@@ -538,15 +530,15 @@ static void hz_to_spi_baud(char *pbr, char *br, int speed_hz,
 }
 
 static void ns_delay_scale(char *psc, char *sc, int delay_ns,
-		unsigned long clkrate)
+			   unsigned long clkrate)
 {
-	int pscale_tbl[4] = {1, 3, 5, 7};
 	int scale_needed, scale, minscale = INT_MAX;
-	int i, j;
+	int pscale_tbl[4] = {1, 3, 5, 7};
 	u32 remainder;
+	int i, j;
 
 	scale_needed = div_u64_rem((u64)delay_ns * clkrate, NSEC_PER_SEC,
-			&remainder);
+				   &remainder);
 	if (remainder)
 		scale_needed++;
 
@@ -601,7 +593,7 @@ static void dspi_tcfq_write(struct fsl_dspi *dspi)
 		 */
 		u32 data = dspi_pop_tx(dspi);
 
-		if (dspi->cur_chip->ctar_val & SPI_CTAR_LSBFE(1)) {
+		if (dspi->cur_chip->ctar_val & SPI_CTAR_LSBFE) {
 			/* LSB */
 			tx_fifo_write(dspi, data & 0xFFFF);
 			tx_fifo_write(dspi, data >> 16);
@@ -655,19 +647,19 @@ static void dspi_eoq_read(struct fsl_dspi *dspi)
 {
 	int fifo_size = DSPI_FIFO_SIZE;
 
-	/* Read one FIFO entry at and push to rx buffer */
+	/* Read one FIFO entry and push to rx buffer */
 	while ((dspi->rx < dspi->rx_end) && fifo_size--)
 		dspi_push_rx(dspi, fifo_read(dspi));
 }
 
 static int dspi_transfer_one_message(struct spi_master *master,
-		struct spi_message *message)
+				     struct spi_message *message)
 {
 	struct fsl_dspi *dspi = spi_master_get_devdata(master);
 	struct spi_device *spi = message->spi;
+	enum dspi_trans_mode trans_mode;
 	struct spi_transfer *transfer;
 	int status = 0;
-	enum dspi_trans_mode trans_mode;
 
 	message->actual_length = 0;
 
@@ -677,7 +669,7 @@ static int dspi_transfer_one_message(struct spi_master *master,
 		dspi->cur_chip = spi_get_ctldata(spi);
 		/* Prepare command word for CMD FIFO */
 		dspi->tx_cmd = SPI_PUSHR_CMD_CTAS(0) |
-			SPI_PUSHR_CMD_PCS(spi->chip_select);
+			       SPI_PUSHR_CMD_PCS(spi->chip_select);
 		if (list_is_last(&dspi->cur_transfer->transfer_list,
 				 &dspi->cur_msg->transfers)) {
 			/* Leave PCS activated after last transfer when
@@ -718,8 +710,8 @@ static int dspi_transfer_one_message(struct spi_master *master,
 			     SPI_FRAME_BITS(transfer->bits_per_word));
 		if (dspi->devtype_data->xspi_mode)
 			regmap_write(dspi->regmap, SPI_CTARE(0),
-				     SPI_FRAME_EBITS(transfer->bits_per_word)
-				     | SPI_CTARE_DTCP(1));
+				     SPI_FRAME_EBITS(transfer->bits_per_word) |
+				     SPI_CTARE_DTCP(1));
 
 		trans_mode = dspi->devtype_data->trans_mode;
 		switch (trans_mode) {
@@ -733,8 +725,8 @@ static int dspi_transfer_one_message(struct spi_master *master,
 			break;
 		case DSPI_DMA_MODE:
 			regmap_write(dspi->regmap, SPI_RSER,
-				SPI_RSER_TFFFE | SPI_RSER_TFFFD |
-				SPI_RSER_RFDFE | SPI_RSER_RFDFD);
+				     SPI_RSER_TFFFE | SPI_RSER_TFFFD |
+				     SPI_RSER_RFDFE | SPI_RSER_RFDFD);
 			status = dspi_dma_xfer(dspi);
 			break;
 		default:
@@ -746,7 +738,7 @@ static int dspi_transfer_one_message(struct spi_master *master,
 
 		if (trans_mode != DSPI_DMA_MODE) {
 			if (wait_event_interruptible(dspi->waitq,
-						dspi->waitflags))
+						     dspi->waitflags))
 				dev_err(&dspi->pdev->dev,
 					"wait transfer complete fail!\n");
 			dspi->waitflags = 0;
@@ -765,12 +757,12 @@ static int dspi_transfer_one_message(struct spi_master *master,
 
 static int dspi_setup(struct spi_device *spi)
 {
-	struct chip_data *chip;
 	struct fsl_dspi *dspi = spi_master_get_devdata(spi->master);
-	struct fsl_dspi_platform_data *pdata;
-	u32 cs_sck_delay = 0, sck_cs_delay = 0;
 	unsigned char br = 0, pbr = 0, pcssck = 0, cssck = 0;
+	u32 cs_sck_delay = 0, sck_cs_delay = 0;
+	struct fsl_dspi_platform_data *pdata;
 	unsigned char pasc = 0, asc = 0;
+	struct chip_data *chip;
 	unsigned long clkrate;
 
 	/* Only alloc on first setup */
@@ -805,18 +797,22 @@ static int dspi_setup(struct spi_device *spi)
 	/* Set After SCK delay scale values */
 	ns_delay_scale(&pasc, &asc, sck_cs_delay, clkrate);
 
-	chip->ctar_val = SPI_CTAR_CPOL(spi->mode & SPI_CPOL ? 1 : 0)
-		| SPI_CTAR_CPHA(spi->mode & SPI_CPHA ? 1 : 0);
+	chip->ctar_val = 0;
+	if (spi->mode & SPI_CPOL)
+		chip->ctar_val |= SPI_CTAR_CPOL;
+	if (spi->mode & SPI_CPHA)
+		chip->ctar_val |= SPI_CTAR_CPHA;
 
 	if (!spi_controller_is_slave(dspi->master)) {
-		chip->ctar_val |= SPI_CTAR_LSBFE(spi->mode &
-						 SPI_LSB_FIRST ? 1 : 0)
-			| SPI_CTAR_PCSSCK(pcssck)
-			| SPI_CTAR_CSSCK(cssck)
-			| SPI_CTAR_PASC(pasc)
-			| SPI_CTAR_ASC(asc)
-			| SPI_CTAR_PBR(pbr)
-			| SPI_CTAR_BR(br);
+		chip->ctar_val |= SPI_CTAR_PCSSCK(pcssck) |
+				  SPI_CTAR_CSSCK(cssck) |
+				  SPI_CTAR_PASC(pasc) |
+				  SPI_CTAR_ASC(asc) |
+				  SPI_CTAR_PBR(pbr) |
+				  SPI_CTAR_BR(br);
+
+		if (spi->mode & SPI_LSB_FIRST)
+			chip->ctar_val |= SPI_CTAR_LSBFE;
 	}
 
 	spi_set_ctldata(spi, chip);
@@ -829,7 +825,7 @@ static void dspi_cleanup(struct spi_device *spi)
 	struct chip_data *chip = spi_get_ctldata((struct spi_device *)spi);
 
 	dev_dbg(&spi->dev, "spi_device %u.%u cleanup\n",
-			spi->master->bus_num, spi->chip_select);
+		spi->master->bus_num, spi->chip_select);
 
 	kfree(chip);
 }
@@ -845,7 +841,6 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 	regmap_read(dspi->regmap, SPI_SR, &spi_sr);
 	regmap_write(dspi->regmap, SPI_SR, spi_sr);
 
-
 	if (spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF)) {
 		/* Get transfer counter (in number of SPI transfers). It was
 		 * reset to 0 when transfer(s) were started.
@@ -982,9 +977,10 @@ static const struct regmap_config dspi_xspi_regmap_config[] = {
 
 static void dspi_init(struct fsl_dspi *dspi)
 {
-	unsigned int mcr = SPI_MCR_PCSIS |
-		(dspi->devtype_data->xspi_mode ? SPI_MCR_XSPI : 0);
+	unsigned int mcr = SPI_MCR_PCSIS;
 
+	if (dspi->devtype_data->xspi_mode)
+		mcr |= SPI_MCR_XSPI;
 	if (!spi_controller_is_slave(dspi->master))
 		mcr |= SPI_MCR_MASTER;
 
@@ -1161,12 +1157,12 @@ static int dspi_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver fsl_dspi_driver = {
-	.driver.name    = DRIVER_NAME,
-	.driver.of_match_table = fsl_dspi_dt_ids,
-	.driver.owner   = THIS_MODULE,
-	.driver.pm = &dspi_pm,
-	.probe          = dspi_probe,
-	.remove		= dspi_remove,
+	.driver.name		= DRIVER_NAME,
+	.driver.of_match_table	= fsl_dspi_dt_ids,
+	.driver.owner		= THIS_MODULE,
+	.driver.pm		= &dspi_pm,
+	.probe			= dspi_probe,
+	.remove			= dspi_remove,
 };
 module_platform_driver(fsl_dspi_driver);
 
-- 
2.17.1

