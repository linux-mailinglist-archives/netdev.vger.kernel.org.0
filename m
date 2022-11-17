Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6D062D235
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 05:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238529AbiKQEQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 23:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239201AbiKQEPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 23:15:47 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAC85BD6A;
        Wed, 16 Nov 2022 20:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668658519; x=1700194519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EnePFvhGfKbl2ud+JLIFkHLrcC90umgCGaxzD9qalXk=;
  b=Bg4Vw+tw07lGBLXmO0lL960Tpwb6GayTm6mBHyZcG61954Ujc2ZlAn0z
   fX73JYDJdzhVLanIPv2WtiS4TABAfy7xCmauqosO/uveY5XBjoHRPFLNh
   H2XDeglZoccmBDyj3my63/LZPxobnr7H5uh3bEV9Mz8xzFAQQ0P6c1iY8
   RLM8QWSLpQ2Puwoa68011xcptKLlbvsMNRfkgetESCv027wiydQ04vJ7h
   hRZXGqTw7WCvNmjXkih6h7L4sMig/2P07SzMUF3Vav1qmLxpB/0o9JDJx
   h375w+sXk8MTmNlCtVF/SXjEW+LBUbTB5cSjL6NT6L4HZLGSZf6hFrQXr
   g==;
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="189317680"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Nov 2022 21:15:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 16 Nov 2022 21:15:06 -0700
Received: from che-lt-i64410lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 16 Nov 2022 21:15:01 -0700
From:   Balamanikandan Gunasundar 
        <balamanikandan.gunasundar@microchip.com>
To:     <ludovic.desroches@microchip.com>, <ulf.hansson@linaro.org>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <3chas3@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-atm-general@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linus.walleij@linaro.org>,
        <hari.prasathge@microchip.com>
CC:     <balamanikandan.gunasundar@microchip.com>
Subject: [PATCH v2 2/2] mmc: atmel-mci: move atmel MCI header file
Date:   Thu, 17 Nov 2022 09:44:30 +0530
Message-ID: <20221117041430.9108-3-balamanikandan.gunasundar@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221117041430.9108-1-balamanikandan.gunasundar@microchip.com>
References: <20221117041430.9108-1-balamanikandan.gunasundar@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the contents of linux/atmel-mci.h into
drivers/mmc/host/atmel-mci.c as it is only used in one file

Signed-off-by: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
---
 drivers/mmc/host/atmel-mci.c | 39 +++++++++++++++++++++++++++++-
 include/linux/atmel-mci.h    | 46 ------------------------------------
 2 files changed, 38 insertions(+), 47 deletions(-)
 delete mode 100644 include/linux/atmel-mci.h

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index f6194aab17df..d1e2011f881b 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -30,7 +30,6 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/sdio.h>
 
-#include <linux/atmel-mci.h>
 #include <linux/atmel_pdc.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
@@ -41,6 +40,8 @@
 #include <asm/unaligned.h>
 #include "../core/pwrseq.h"
 
+#define ATMCI_MAX_NR_SLOTS	2
+
 /*
  * Superset of MCI IP registers integrated in Atmel AT91 Processor
  * Registers and bitfields marked with [2] are only available in MCI2
@@ -202,6 +203,42 @@ enum atmci_pdc_buf {
 	PDC_SECOND_BUF,
 };
 
+/**
+ * struct mci_slot_pdata - board-specific per-slot configuration
+ * @bus_width: Number of data lines wired up the slot
+ * @detect_pin: GPIO pin wired to the card detect switch
+ * @wp_pin: GPIO pin wired to the write protect sensor
+ * @detect_is_active_high: The state of the detect pin when it is active
+ * @non_removable: The slot is not removable, only detect once
+ *
+ * If a given slot is not present on the board, @bus_width should be
+ * set to 0. The other fields are ignored in this case.
+ *
+ * Any pins that aren't available should be set to a negative value.
+ *
+ * Note that support for multiple slots is experimental -- some cards
+ * might get upset if we don't get the clock management exactly right.
+ * But in most cases, it should work just fine.
+ */
+struct mci_slot_pdata {
+	unsigned int		bus_width;
+	struct gpio_desc        *detect_pin;
+	struct gpio_desc	*wp_pin;
+	bool			detect_is_active_high;
+	bool			non_removable;
+};
+
+/**
+ * struct mci_platform_data - board-specific MMC/SDcard configuration
+ * @dma_slave: DMA slave interface to use in data transfers.
+ * @slot: Per-slot configuration data.
+ */
+struct mci_platform_data {
+	void			*dma_slave;
+	dma_filter_fn		dma_filter;
+	struct mci_slot_pdata	slot[ATMCI_MAX_NR_SLOTS];
+};
+
 struct atmel_mci_caps {
 	bool    has_dma_conf_reg;
 	bool    has_pdc;
diff --git a/include/linux/atmel-mci.h b/include/linux/atmel-mci.h
deleted file mode 100644
index 017e7d8f6126..000000000000
--- a/include/linux/atmel-mci.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_ATMEL_MCI_H
-#define __LINUX_ATMEL_MCI_H
-
-#include <linux/types.h>
-#include <linux/dmaengine.h>
-
-#define ATMCI_MAX_NR_SLOTS	2
-
-/**
- * struct mci_slot_pdata - board-specific per-slot configuration
- * @bus_width: Number of data lines wired up the slot
- * @detect_pin: GPIO pin wired to the card detect switch
- * @wp_pin: GPIO pin wired to the write protect sensor
- * @detect_is_active_high: The state of the detect pin when it is active
- * @non_removable: The slot is not removable, only detect once
- *
- * If a given slot is not present on the board, @bus_width should be
- * set to 0. The other fields are ignored in this case.
- *
- * Any pins that aren't available should be set to a negative value.
- *
- * Note that support for multiple slots is experimental -- some cards
- * might get upset if we don't get the clock management exactly right.
- * But in most cases, it should work just fine.
- */
-struct mci_slot_pdata {
-	unsigned int		bus_width;
-	struct gpio_desc        *detect_pin;
-	struct gpio_desc	*wp_pin;
-	bool			detect_is_active_high;
-	bool			non_removable;
-};
-
-/**
- * struct mci_platform_data - board-specific MMC/SDcard configuration
- * @dma_slave: DMA slave interface to use in data transfers.
- * @slot: Per-slot configuration data.
- */
-struct mci_platform_data {
-	void			*dma_slave;
-	dma_filter_fn		dma_filter;
-	struct mci_slot_pdata	slot[ATMCI_MAX_NR_SLOTS];
-};
-
-#endif /* __LINUX_ATMEL_MCI_H */
-- 
2.25.1

