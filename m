Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95763318A41
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhBKMSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhBKMNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:13:54 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A49C06178B;
        Thu, 11 Feb 2021 04:13:13 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id x1so430483ljj.11;
        Thu, 11 Feb 2021 04:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3LYo1Qei5Cl0fQ9W8gRaAOjNN70EI6+Y1kg7e/hnHow=;
        b=BktiqkYw12/dPHtSJKD6t/LlOrUrFwrc2lLYbHG0gdCe3yqGiIksocpP5Wm+UrJeKX
         RafbEubv3M+xioBrJ2MsKEohR1gY9NXJVDeyj4pp10bq0zO1XLEnD0u7O8VqWbCniVf1
         1N2zbkSMgV8Xqwh9r1MSLqAzrsUyTOzqHPwC3jkrQhQWX6ZIaML77ogwSAHX4KTj3aPd
         0Mcr3o+mj5OPT7FH/di1+Jk4Zdh05lsmscI3hUmRpSIsl1CaA0ICr+WsYyfngFX4TREJ
         1rqIsbdgvsV1fOVHTddG31g/CVgoQS+/tFJZzWt/nqhHXI2vu4Jp41jU8MoQfMNY7QEp
         Wd2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3LYo1Qei5Cl0fQ9W8gRaAOjNN70EI6+Y1kg7e/hnHow=;
        b=WBWWFUmrgMC2jtsmIifTnbrfoWrCnvM7j19613GZE/fxevVyjJo6hDIUDDvQchVf02
         elLdoTsz87Y7NFuVknWVZoJTk1i4XTPQmfKyWZXhi3NyzUp/Ty1K3KY1nHNn8jwt7DL8
         JtiOtdHzxVILA/Xl/SYvLagzd7JpayyOy76bnPHKJuk+jQkY86CnkAJatl9i0lg52r1K
         EwN1uEuVDRhpOqO06WpDyVugyWtRJrcEHd5P9TPX8tP3fLnD/GcnlgZiPFe0Yo/ffwKV
         4lL/0stNQuXDvbDk6ca15hW0k9XtRrhDQa5d5R8bkydMwgvmKZJH/oDQ3M7S9+Dp63fh
         ZrlA==
X-Gm-Message-State: AOAM530Hr7KQkyltbudMEa9jVJMsjZqyFVXxP8LirByAcIdWnVgxElJW
        4HCysfTwUa1M0n7WEeLJL3w=
X-Google-Smtp-Source: ABdhPJxv9vzXmGIdmFu7WrnQfcLcFo2iJeD7iiZ2wqdraIl8i9u3xHW25D9hc8A5xB+qjhoSRMWY1g==
X-Received: by 2002:a2e:9588:: with SMTP id w8mr1793665ljh.339.1613045591938;
        Thu, 11 Feb 2021 04:13:11 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f23sm834783ljn.131.2021.02.11.04.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:13:11 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 5.12 3/8] net: broadcom: rename BCM4908 driver & update DT binding
Date:   Thu, 11 Feb 2021 13:12:34 +0100
Message-Id: <20210211121239.728-4-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211121239.728-1-zajec5@gmail.com>
References: <20210209230130.4690-2-zajec5@gmail.com>
 <20210211121239.728-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

compatible string was updated to match normal naming convention so
update driver as well

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 MAINTAINERS                                   |   2 +-
 drivers/net/ethernet/broadcom/Kconfig         |   2 +-
 drivers/net/ethernet/broadcom/Makefile        |   2 +-
 .../{bcm4908enet.c => bcm4908_enet.c}         | 215 +++++++++---------
 .../{bcm4908enet.h => bcm4908_enet.h}         |   4 +-
 5 files changed, 113 insertions(+), 112 deletions(-)
 rename drivers/net/ethernet/broadcom/{bcm4908enet.c => bcm4908_enet.c} (68%)
 rename drivers/net/ethernet/broadcom/{bcm4908enet.h => bcm4908_enet.h} (98%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 63fb312dedcf..9016541d6555 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3451,7 +3451,7 @@ M:	bcm-kernel-feedback-list@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
-F:	drivers/net/ethernet/broadcom/bcm4908enet.*
+F:	drivers/net/ethernet/broadcom/bcm4908_enet.*
 F:	drivers/net/ethernet/broadcom/unimac.h
 
 BROADCOM BCM5301X ARM ARCHITECTURE
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index bcf9e0a410fd..f8a168b73307 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -51,7 +51,7 @@ config B44_PCI
 	depends on B44_PCI_AUTOSELECT && B44_PCICORE_AUTOSELECT
 	default y
 
-config BCM4908ENET
+config BCM4908_ENET
 	tristate "Broadcom BCM4908 internal mac support"
 	depends on ARCH_BCM4908 || COMPILE_TEST
 	default y
diff --git a/drivers/net/ethernet/broadcom/Makefile b/drivers/net/ethernet/broadcom/Makefile
index 379012de3569..0ddfb5b5d53c 100644
--- a/drivers/net/ethernet/broadcom/Makefile
+++ b/drivers/net/ethernet/broadcom/Makefile
@@ -4,7 +4,7 @@
 #
 
 obj-$(CONFIG_B44) += b44.o
-obj-$(CONFIG_BCM4908ENET) += bcm4908enet.o
+obj-$(CONFIG_BCM4908_ENET) += bcm4908_enet.o
 obj-$(CONFIG_BCM63XX_ENET) += bcm63xx_enet.o
 obj-$(CONFIG_BCMGENET) += genet/
 obj-$(CONFIG_BNX2) += bnx2.o
diff --git a/drivers/net/ethernet/broadcom/bcm4908enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
similarity index 68%
rename from drivers/net/ethernet/broadcom/bcm4908enet.c
rename to drivers/net/ethernet/broadcom/bcm4908_enet.c
index d68b328e7596..e56348eb188f 100644
--- a/drivers/net/ethernet/broadcom/bcm4908enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 
-#include "bcm4908enet.h"
+#include "bcm4908_enet.h"
 #include "unimac.h"
 
 #define ENET_DMA_CH_RX_CFG			ENET_DMA_CH0_CFG
@@ -33,18 +33,18 @@
 #define ENET_MTU_MAX				1500 /* Is it possible to support 2044? */
 #define ENET_MTU_MAX_EXTRA_SIZE			32 /* L2 */
 
-struct bcm4908enet_dma_ring_bd {
+struct bcm4908_enet_dma_ring_bd {
 	__le32 ctl;
 	__le32 addr;
 } __packed;
 
-struct bcm4908enet_dma_ring_slot {
+struct bcm4908_enet_dma_ring_slot {
 	struct sk_buff *skb;
 	unsigned int len;
 	dma_addr_t dma_addr;
 };
 
-struct bcm4908enet_dma_ring {
+struct bcm4908_enet_dma_ring {
 	int is_tx;
 	int read_idx;
 	int write_idx;
@@ -54,38 +54,38 @@ struct bcm4908enet_dma_ring {
 
 	union {
 		void *cpu_addr;
-		struct bcm4908enet_dma_ring_bd *buf_desc;
+		struct bcm4908_enet_dma_ring_bd *buf_desc;
 	};
 	dma_addr_t dma_addr;
 
-	struct bcm4908enet_dma_ring_slot *slots;
+	struct bcm4908_enet_dma_ring_slot *slots;
 };
 
-struct bcm4908enet {
+struct bcm4908_enet {
 	struct device *dev;
 	struct net_device *netdev;
 	struct napi_struct napi;
 	void __iomem *base;
 
-	struct bcm4908enet_dma_ring tx_ring;
-	struct bcm4908enet_dma_ring rx_ring;
+	struct bcm4908_enet_dma_ring tx_ring;
+	struct bcm4908_enet_dma_ring rx_ring;
 };
 
 /***
  * R/W ops
  */
 
-static inline u32 enet_read(struct bcm4908enet *enet, u16 offset)
+static inline u32 enet_read(struct bcm4908_enet *enet, u16 offset)
 {
 	return readl(enet->base + offset);
 }
 
-static inline void enet_write(struct bcm4908enet *enet, u16 offset, u32 value)
+static inline void enet_write(struct bcm4908_enet *enet, u16 offset, u32 value)
 {
 	writel(value, enet->base + offset);
 }
 
-static inline void enet_maskset(struct bcm4908enet *enet, u16 offset, u32 mask, u32 set)
+static inline void enet_maskset(struct bcm4908_enet *enet, u16 offset, u32 mask, u32 set)
 {
 	u32 val;
 
@@ -96,27 +96,27 @@ static inline void enet_maskset(struct bcm4908enet *enet, u16 offset, u32 mask,
 	enet_write(enet, offset, val);
 }
 
-static inline void enet_set(struct bcm4908enet *enet, u16 offset, u32 set)
+static inline void enet_set(struct bcm4908_enet *enet, u16 offset, u32 set)
 {
 	enet_maskset(enet, offset, set, set);
 }
 
-static inline u32 enet_umac_read(struct bcm4908enet *enet, u16 offset)
+static inline u32 enet_umac_read(struct bcm4908_enet *enet, u16 offset)
 {
 	return enet_read(enet, ENET_UNIMAC + offset);
 }
 
-static inline void enet_umac_write(struct bcm4908enet *enet, u16 offset, u32 value)
+static inline void enet_umac_write(struct bcm4908_enet *enet, u16 offset, u32 value)
 {
 	enet_write(enet, ENET_UNIMAC + offset, value);
 }
 
-static inline void enet_umac_maskset(struct bcm4908enet *enet, u16 offset, u32 mask, u32 set)
+static inline void enet_umac_maskset(struct bcm4908_enet *enet, u16 offset, u32 mask, u32 set)
 {
 	enet_maskset(enet, ENET_UNIMAC + offset, mask, set);
 }
 
-static inline void enet_umac_set(struct bcm4908enet *enet, u16 offset, u32 set)
+static inline void enet_umac_set(struct bcm4908_enet *enet, u16 offset, u32 set)
 {
 	enet_set(enet, ENET_UNIMAC + offset, set);
 }
@@ -125,17 +125,17 @@ static inline void enet_umac_set(struct bcm4908enet *enet, u16 offset, u32 set)
  * Helpers
  */
 
-static void bcm4908enet_intrs_on(struct bcm4908enet *enet)
+static void bcm4908_enet_intrs_on(struct bcm4908_enet *enet)
 {
 	enet_write(enet, ENET_DMA_CH_RX_CFG + ENET_DMA_CH_CFG_INT_MASK, ENET_DMA_INT_DEFAULTS);
 }
 
-static void bcm4908enet_intrs_off(struct bcm4908enet *enet)
+static void bcm4908_enet_intrs_off(struct bcm4908_enet *enet)
 {
 	enet_write(enet, ENET_DMA_CH_RX_CFG + ENET_DMA_CH_CFG_INT_MASK, 0);
 }
 
-static void bcm4908enet_intrs_ack(struct bcm4908enet *enet)
+static void bcm4908_enet_intrs_ack(struct bcm4908_enet *enet)
 {
 	enet_write(enet, ENET_DMA_CH_RX_CFG + ENET_DMA_CH_CFG_INT_STAT, ENET_DMA_INT_DEFAULTS);
 }
@@ -144,9 +144,10 @@ static void bcm4908enet_intrs_ack(struct bcm4908enet *enet)
  * DMA
  */
 
-static int bcm4908_dma_alloc_buf_descs(struct bcm4908enet *enet, struct bcm4908enet_dma_ring *ring)
+static int bcm4908_dma_alloc_buf_descs(struct bcm4908_enet *enet,
+				       struct bcm4908_enet_dma_ring *ring)
 {
-	int size = ring->length * sizeof(struct bcm4908enet_dma_ring_bd);
+	int size = ring->length * sizeof(struct bcm4908_enet_dma_ring_bd);
 	struct device *dev = enet->dev;
 
 	ring->cpu_addr = dma_alloc_coherent(dev, size, &ring->dma_addr, GFP_KERNEL);
@@ -174,28 +175,28 @@ static int bcm4908_dma_alloc_buf_descs(struct bcm4908enet *enet, struct bcm4908e
 	return -ENOMEM;
 }
 
-static void bcm4908enet_dma_free(struct bcm4908enet *enet)
+static void bcm4908_enet_dma_free(struct bcm4908_enet *enet)
 {
-	struct bcm4908enet_dma_ring *tx_ring = &enet->tx_ring;
-	struct bcm4908enet_dma_ring *rx_ring = &enet->rx_ring;
+	struct bcm4908_enet_dma_ring *tx_ring = &enet->tx_ring;
+	struct bcm4908_enet_dma_ring *rx_ring = &enet->rx_ring;
 	struct device *dev = enet->dev;
 	int size;
 
-	size = rx_ring->length * sizeof(struct bcm4908enet_dma_ring_bd);
+	size = rx_ring->length * sizeof(struct bcm4908_enet_dma_ring_bd);
 	if (rx_ring->cpu_addr)
 		dma_free_coherent(dev, size, rx_ring->cpu_addr, rx_ring->dma_addr);
 	kfree(rx_ring->slots);
 
-	size = tx_ring->length * sizeof(struct bcm4908enet_dma_ring_bd);
+	size = tx_ring->length * sizeof(struct bcm4908_enet_dma_ring_bd);
 	if (tx_ring->cpu_addr)
 		dma_free_coherent(dev, size, tx_ring->cpu_addr, tx_ring->dma_addr);
 	kfree(tx_ring->slots);
 }
 
-static int bcm4908enet_dma_alloc(struct bcm4908enet *enet)
+static int bcm4908_enet_dma_alloc(struct bcm4908_enet *enet)
 {
-	struct bcm4908enet_dma_ring *tx_ring = &enet->tx_ring;
-	struct bcm4908enet_dma_ring *rx_ring = &enet->rx_ring;
+	struct bcm4908_enet_dma_ring *tx_ring = &enet->tx_ring;
+	struct bcm4908_enet_dma_ring *rx_ring = &enet->rx_ring;
 	struct device *dev = enet->dev;
 	int err;
 
@@ -216,16 +217,16 @@ static int bcm4908enet_dma_alloc(struct bcm4908enet *enet)
 	err = bcm4908_dma_alloc_buf_descs(enet, rx_ring);
 	if (err) {
 		dev_err(dev, "Failed to alloc RX buf descriptors: %d\n", err);
-		bcm4908enet_dma_free(enet);
+		bcm4908_enet_dma_free(enet);
 		return err;
 	}
 
 	return 0;
 }
 
-static void bcm4908enet_dma_reset(struct bcm4908enet *enet)
+static void bcm4908_enet_dma_reset(struct bcm4908_enet *enet)
 {
-	struct bcm4908enet_dma_ring *rings[] = { &enet->rx_ring, &enet->tx_ring };
+	struct bcm4908_enet_dma_ring *rings[] = { &enet->rx_ring, &enet->tx_ring };
 	int i;
 
 	/* Disable the DMA controller and channel */
@@ -235,7 +236,7 @@ static void bcm4908enet_dma_reset(struct bcm4908enet *enet)
 
 	/* Reset channels state */
 	for (i = 0; i < ARRAY_SIZE(rings); i++) {
-		struct bcm4908enet_dma_ring *ring = rings[i];
+		struct bcm4908_enet_dma_ring *ring = rings[i];
 
 		enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_BASE_DESC_PTR, 0);
 		enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_STATE_DATA, 0);
@@ -244,10 +245,10 @@ static void bcm4908enet_dma_reset(struct bcm4908enet *enet)
 	}
 }
 
-static int bcm4908enet_dma_alloc_rx_buf(struct bcm4908enet *enet, unsigned int idx)
+static int bcm4908_enet_dma_alloc_rx_buf(struct bcm4908_enet *enet, unsigned int idx)
 {
-	struct bcm4908enet_dma_ring_bd *buf_desc = &enet->rx_ring.buf_desc[idx];
-	struct bcm4908enet_dma_ring_slot *slot = &enet->rx_ring.slots[idx];
+	struct bcm4908_enet_dma_ring_bd *buf_desc = &enet->rx_ring.buf_desc[idx];
+	struct bcm4908_enet_dma_ring_slot *slot = &enet->rx_ring.slots[idx];
 	struct device *dev = enet->dev;
 	u32 tmp;
 	int err;
@@ -277,8 +278,8 @@ static int bcm4908enet_dma_alloc_rx_buf(struct bcm4908enet *enet, unsigned int i
 	return 0;
 }
 
-static void bcm4908enet_dma_ring_init(struct bcm4908enet *enet,
-				      struct bcm4908enet_dma_ring *ring)
+static void bcm4908_enet_dma_ring_init(struct bcm4908_enet *enet,
+				       struct bcm4908_enet_dma_ring *ring)
 {
 	int reset_channel = 0; /* We support only 1 main channel (with TX and RX) */
 	int reset_subch = ring->is_tx ? 1 : 0;
@@ -295,10 +296,10 @@ static void bcm4908enet_dma_ring_init(struct bcm4908enet *enet,
 		   (uint32_t)ring->dma_addr);
 }
 
-static void bcm4908enet_dma_uninit(struct bcm4908enet *enet)
+static void bcm4908_enet_dma_uninit(struct bcm4908_enet *enet)
 {
-	struct bcm4908enet_dma_ring *rx_ring = &enet->rx_ring;
-	struct bcm4908enet_dma_ring_slot *slot;
+	struct bcm4908_enet_dma_ring *rx_ring = &enet->rx_ring;
+	struct bcm4908_enet_dma_ring_slot *slot;
 	struct device *dev = enet->dev;
 	int i;
 
@@ -312,48 +313,48 @@ static void bcm4908enet_dma_uninit(struct bcm4908enet *enet)
 	}
 }
 
-static int bcm4908enet_dma_init(struct bcm4908enet *enet)
+static int bcm4908_enet_dma_init(struct bcm4908_enet *enet)
 {
-	struct bcm4908enet_dma_ring *rx_ring = &enet->rx_ring;
+	struct bcm4908_enet_dma_ring *rx_ring = &enet->rx_ring;
 	struct device *dev = enet->dev;
 	int err;
 	int i;
 
 	for (i = 0; i < rx_ring->length; i++) {
-		err = bcm4908enet_dma_alloc_rx_buf(enet, i);
+		err = bcm4908_enet_dma_alloc_rx_buf(enet, i);
 		if (err) {
 			dev_err(dev, "Failed to alloc RX buffer: %d\n", err);
-			bcm4908enet_dma_uninit(enet);
+			bcm4908_enet_dma_uninit(enet);
 			return err;
 		}
 	}
 
-	bcm4908enet_dma_ring_init(enet, &enet->tx_ring);
-	bcm4908enet_dma_ring_init(enet, &enet->rx_ring);
+	bcm4908_enet_dma_ring_init(enet, &enet->tx_ring);
+	bcm4908_enet_dma_ring_init(enet, &enet->rx_ring);
 
 	return 0;
 }
 
-static void bcm4908enet_dma_tx_ring_ensable(struct bcm4908enet *enet,
-					    struct bcm4908enet_dma_ring *ring)
+static void bcm4908_enet_dma_tx_ring_ensable(struct bcm4908_enet *enet,
+					     struct bcm4908_enet_dma_ring *ring)
 {
 	enet_write(enet, ring->cfg_block + ENET_DMA_CH_CFG, ENET_DMA_CH_CFG_ENABLE);
 }
 
-static void bcm4908enet_dma_tx_ring_disable(struct bcm4908enet *enet,
-					    struct bcm4908enet_dma_ring *ring)
+static void bcm4908_enet_dma_tx_ring_disable(struct bcm4908_enet *enet,
+					     struct bcm4908_enet_dma_ring *ring)
 {
 	enet_write(enet, ring->cfg_block + ENET_DMA_CH_CFG, 0);
 }
 
-static void bcm4908enet_dma_rx_ring_enable(struct bcm4908enet *enet,
-					   struct bcm4908enet_dma_ring *ring)
+static void bcm4908_enet_dma_rx_ring_enable(struct bcm4908_enet *enet,
+					    struct bcm4908_enet_dma_ring *ring)
 {
 	enet_set(enet, ring->cfg_block + ENET_DMA_CH_CFG, ENET_DMA_CH_CFG_ENABLE);
 }
 
-static void bcm4908enet_dma_rx_ring_disable(struct bcm4908enet *enet,
-					    struct bcm4908enet_dma_ring *ring)
+static void bcm4908_enet_dma_rx_ring_disable(struct bcm4908_enet *enet,
+					     struct bcm4908_enet_dma_ring *ring)
 {
 	unsigned long deadline;
 	u32 tmp;
@@ -376,7 +377,7 @@ static void bcm4908enet_dma_rx_ring_disable(struct bcm4908enet *enet,
  * Ethernet driver
  */
 
-static void bcm4908enet_gmac_init(struct bcm4908enet *enet)
+static void bcm4908_enet_gmac_init(struct bcm4908_enet *enet)
 {
 	u32 cmd;
 
@@ -407,75 +408,75 @@ static void bcm4908enet_gmac_init(struct bcm4908enet *enet)
 		     ENET_GMAC_STATUS_LINK_UP);
 }
 
-static irqreturn_t bcm4908enet_irq_handler(int irq, void *dev_id)
+static irqreturn_t bcm4908_enet_irq_handler(int irq, void *dev_id)
 {
-	struct bcm4908enet *enet = dev_id;
+	struct bcm4908_enet *enet = dev_id;
 
-	bcm4908enet_intrs_off(enet);
-	bcm4908enet_intrs_ack(enet);
+	bcm4908_enet_intrs_off(enet);
+	bcm4908_enet_intrs_ack(enet);
 
 	napi_schedule(&enet->napi);
 
 	return IRQ_HANDLED;
 }
 
-static int bcm4908enet_open(struct net_device *netdev)
+static int bcm4908_enet_open(struct net_device *netdev)
 {
-	struct bcm4908enet *enet = netdev_priv(netdev);
+	struct bcm4908_enet *enet = netdev_priv(netdev);
 	struct device *dev = enet->dev;
 	int err;
 
-	err = request_irq(netdev->irq, bcm4908enet_irq_handler, 0, "enet", enet);
+	err = request_irq(netdev->irq, bcm4908_enet_irq_handler, 0, "enet", enet);
 	if (err) {
 		dev_err(dev, "Failed to request IRQ %d: %d\n", netdev->irq, err);
 		return err;
 	}
 
-	bcm4908enet_gmac_init(enet);
-	bcm4908enet_dma_reset(enet);
-	bcm4908enet_dma_init(enet);
+	bcm4908_enet_gmac_init(enet);
+	bcm4908_enet_dma_reset(enet);
+	bcm4908_enet_dma_init(enet);
 
 	enet_umac_set(enet, UMAC_CMD, CMD_TX_EN | CMD_RX_EN);
 
 	enet_set(enet, ENET_DMA_CONTROLLER_CFG, ENET_DMA_CTRL_CFG_MASTER_EN);
 	enet_maskset(enet, ENET_DMA_CONTROLLER_CFG, ENET_DMA_CTRL_CFG_FLOWC_CH1_EN, 0);
-	bcm4908enet_dma_rx_ring_enable(enet, &enet->rx_ring);
+	bcm4908_enet_dma_rx_ring_enable(enet, &enet->rx_ring);
 
 	napi_enable(&enet->napi);
 	netif_carrier_on(netdev);
 	netif_start_queue(netdev);
 
-	bcm4908enet_intrs_ack(enet);
-	bcm4908enet_intrs_on(enet);
+	bcm4908_enet_intrs_ack(enet);
+	bcm4908_enet_intrs_on(enet);
 
 	return 0;
 }
 
-static int bcm4908enet_stop(struct net_device *netdev)
+static int bcm4908_enet_stop(struct net_device *netdev)
 {
-	struct bcm4908enet *enet = netdev_priv(netdev);
+	struct bcm4908_enet *enet = netdev_priv(netdev);
 
 	netif_stop_queue(netdev);
 	netif_carrier_off(netdev);
 	napi_disable(&enet->napi);
 
-	bcm4908enet_dma_rx_ring_disable(enet, &enet->rx_ring);
-	bcm4908enet_dma_tx_ring_disable(enet, &enet->tx_ring);
+	bcm4908_enet_dma_rx_ring_disable(enet, &enet->rx_ring);
+	bcm4908_enet_dma_tx_ring_disable(enet, &enet->tx_ring);
 
-	bcm4908enet_dma_uninit(enet);
+	bcm4908_enet_dma_uninit(enet);
 
 	free_irq(enet->netdev->irq, enet);
 
 	return 0;
 }
 
-static int bcm4908enet_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+static int bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
-	struct bcm4908enet *enet = netdev_priv(netdev);
-	struct bcm4908enet_dma_ring *ring = &enet->tx_ring;
-	struct bcm4908enet_dma_ring_slot *slot;
+	struct bcm4908_enet *enet = netdev_priv(netdev);
+	struct bcm4908_enet_dma_ring *ring = &enet->tx_ring;
+	struct bcm4908_enet_dma_ring_slot *slot;
 	struct device *dev = enet->dev;
-	struct bcm4908enet_dma_ring_bd *buf_desc;
+	struct bcm4908_enet_dma_ring_bd *buf_desc;
 	int free_buf_descs;
 	u32 tmp;
 
@@ -525,7 +526,7 @@ static int bcm4908enet_start_xmit(struct sk_buff *skb, struct net_device *netdev
 	buf_desc->addr = cpu_to_le32((uint32_t)slot->dma_addr);
 	buf_desc->ctl = cpu_to_le32(tmp);
 
-	bcm4908enet_dma_tx_ring_ensable(enet, &enet->tx_ring);
+	bcm4908_enet_dma_tx_ring_ensable(enet, &enet->tx_ring);
 
 	if (++ring->write_idx == ring->length - 1)
 		ring->write_idx = 0;
@@ -535,15 +536,15 @@ static int bcm4908enet_start_xmit(struct sk_buff *skb, struct net_device *netdev
 	return NETDEV_TX_OK;
 }
 
-static int bcm4908enet_poll(struct napi_struct *napi, int weight)
+static int bcm4908_enet_poll(struct napi_struct *napi, int weight)
 {
-	struct bcm4908enet *enet = container_of(napi, struct bcm4908enet, napi);
+	struct bcm4908_enet *enet = container_of(napi, struct bcm4908_enet, napi);
 	struct device *dev = enet->dev;
 	int handled = 0;
 
 	while (handled < weight) {
-		struct bcm4908enet_dma_ring_bd *buf_desc;
-		struct bcm4908enet_dma_ring_slot slot;
+		struct bcm4908_enet_dma_ring_bd *buf_desc;
+		struct bcm4908_enet_dma_ring_slot slot;
 		u32 ctl;
 		int len;
 		int err;
@@ -556,7 +557,7 @@ static int bcm4908enet_poll(struct napi_struct *napi, int weight)
 		slot = enet->rx_ring.slots[enet->rx_ring.read_idx];
 
 		/* Provide new buffer before unpinning the old one */
-		err = bcm4908enet_dma_alloc_rx_buf(enet, enet->rx_ring.read_idx);
+		err = bcm4908_enet_dma_alloc_rx_buf(enet, enet->rx_ring.read_idx);
 		if (err)
 			break;
 
@@ -583,24 +584,24 @@ static int bcm4908enet_poll(struct napi_struct *napi, int weight)
 
 	if (handled < weight) {
 		napi_complete_done(napi, handled);
-		bcm4908enet_intrs_on(enet);
+		bcm4908_enet_intrs_on(enet);
 	}
 
 	return handled;
 }
 
 static const struct net_device_ops bcm96xx_netdev_ops = {
-	.ndo_open = bcm4908enet_open,
-	.ndo_stop = bcm4908enet_stop,
-	.ndo_start_xmit = bcm4908enet_start_xmit,
+	.ndo_open = bcm4908_enet_open,
+	.ndo_stop = bcm4908_enet_stop,
+	.ndo_start_xmit = bcm4908_enet_start_xmit,
 	.ndo_set_mac_address = eth_mac_addr,
 };
 
-static int bcm4908enet_probe(struct platform_device *pdev)
+static int bcm4908_enet_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct net_device *netdev;
-	struct bcm4908enet *enet;
+	struct bcm4908_enet *enet;
 	int err;
 
 	netdev = devm_alloc_etherdev(dev, sizeof(*enet));
@@ -623,7 +624,7 @@ static int bcm4908enet_probe(struct platform_device *pdev)
 
 	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
 
-	err = bcm4908enet_dma_alloc(enet);
+	err = bcm4908_enet_dma_alloc(enet);
 	if (err)
 		return err;
 
@@ -633,11 +634,11 @@ static int bcm4908enet_probe(struct platform_device *pdev)
 	netdev->min_mtu = ETH_ZLEN;
 	netdev->mtu = ENET_MTU_MAX;
 	netdev->max_mtu = ENET_MTU_MAX;
-	netif_napi_add(netdev, &enet->napi, bcm4908enet_poll, 64);
+	netif_napi_add(netdev, &enet->napi, bcm4908_enet_poll, 64);
 
 	err = register_netdev(netdev);
 	if (err) {
-		bcm4908enet_dma_free(enet);
+		bcm4908_enet_dma_free(enet);
 		return err;
 	}
 
@@ -646,31 +647,31 @@ static int bcm4908enet_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int bcm4908enet_remove(struct platform_device *pdev)
+static int bcm4908_enet_remove(struct platform_device *pdev)
 {
-	struct bcm4908enet *enet = platform_get_drvdata(pdev);
+	struct bcm4908_enet *enet = platform_get_drvdata(pdev);
 
 	unregister_netdev(enet->netdev);
 	netif_napi_del(&enet->napi);
-	bcm4908enet_dma_free(enet);
+	bcm4908_enet_dma_free(enet);
 
 	return 0;
 }
 
-static const struct of_device_id bcm4908enet_of_match[] = {
-	{ .compatible = "brcm,bcm4908enet"},
+static const struct of_device_id bcm4908_enet_of_match[] = {
+	{ .compatible = "brcm,bcm4908-enet"},
 	{},
 };
 
-static struct platform_driver bcm4908enet_driver = {
+static struct platform_driver bcm4908_enet_driver = {
 	.driver = {
-		.name = "bcm4908enet",
-		.of_match_table = bcm4908enet_of_match,
+		.name = "bcm4908_enet",
+		.of_match_table = bcm4908_enet_of_match,
 	},
-	.probe	= bcm4908enet_probe,
-	.remove = bcm4908enet_remove,
+	.probe	= bcm4908_enet_probe,
+	.remove = bcm4908_enet_remove,
 };
-module_platform_driver(bcm4908enet_driver);
+module_platform_driver(bcm4908_enet_driver);
 
 MODULE_LICENSE("GPL v2");
-MODULE_DEVICE_TABLE(of, bcm4908enet_of_match);
+MODULE_DEVICE_TABLE(of, bcm4908_enet_of_match);
diff --git a/drivers/net/ethernet/broadcom/bcm4908enet.h b/drivers/net/ethernet/broadcom/bcm4908_enet.h
similarity index 98%
rename from drivers/net/ethernet/broadcom/bcm4908enet.h
rename to drivers/net/ethernet/broadcom/bcm4908_enet.h
index 11aadf0715d3..8a3ede2da537 100644
--- a/drivers/net/ethernet/broadcom/bcm4908enet.h
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef __BCM4908ENET_H
-#define __BCM4908ENET_H
+#ifndef __BCM4908_ENET_H
+#define __BCM4908_ENET_H
 
 #define ENET_CONTROL					0x000
 #define ENET_MIB_CTRL					0x004
-- 
2.26.2

