Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F195A68BDB8
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjBFNRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjBFNRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD84F23872
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N1-0007Tt-QX
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:19 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2D80E171421
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1C8CF1712BC;
        Mon,  6 Feb 2023 13:16:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3f28cbaf;
        Mon, 6 Feb 2023 13:16:22 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 15/47] can: ems_pci: Fix code style, copyright and email address
Date:   Mon,  6 Feb 2023 14:15:48 +0100
Message-Id: <20230206131620.2758724-16-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>

Fix code style complained by checkpatch.pl, add Copyright and
fix email address

Signed-off-by: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>
Link: https://lore.kernel.org/all/20230120112616.6071-2-uttenthaler@ems-wuensche.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sja1000/ems_pci.c | 45 ++++++++++++++-----------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/net/can/sja1000/ems_pci.c b/drivers/net/can/sja1000/ems_pci.c
index 4ab91759a5c6..c34788b9a6d5 100644
--- a/drivers/net/can/sja1000/ems_pci.c
+++ b/drivers/net/can/sja1000/ems_pci.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2007 Wolfgang Grandegger <wg@grandegger.com>
  * Copyright (C) 2008 Markus Plessing <plessing@ems-wuensche.com>
  * Copyright (C) 2008 Sebastian Haas <haas@ems-wuensche.com>
+ * Copyright (C) 2023 EMS Dr. Thomas Wuensche
  */
 
 #include <linux/kernel.h>
@@ -19,7 +20,7 @@
 
 #define DRV_NAME  "ems_pci"
 
-MODULE_AUTHOR("Sebastian Haas <haas@ems-wuenche.com>");
+MODULE_AUTHOR("Sebastian Haas <support@ems-wuensche.com>");
 MODULE_DESCRIPTION("Socket-CAN driver for EMS CPC-PCI/PCIe/104P CAN cards");
 MODULE_LICENSE("GPL v2");
 
@@ -40,8 +41,7 @@ struct ems_pci_card {
 
 #define EMS_PCI_CAN_CLOCK (16000000 / 2)
 
-/*
- * Register definitions and descriptions are from LinCAN 0.3.3.
+/* Register definitions and descriptions are from LinCAN 0.3.3.
  *
  * PSB4610 PITA-2 bridge control registers
  */
@@ -52,8 +52,7 @@ struct ems_pci_card {
 #define PITA2_MISC          0x1c	/* Miscellaneous Register */
 #define PITA2_MISC_CONFIG   0x04000000	/* Multiplexed parallel interface */
 
-/*
- * Register definitions for the PLX 9030
+/* Register definitions for the PLX 9030
  */
 #define PLX_ICSR            0x4c   /* Interrupt Control/Status register */
 #define PLX_ICSR_LINTI1_ENA 0x0001 /* LINTi1 Enable */
@@ -62,8 +61,7 @@ struct ems_pci_card {
 #define PLX_ICSR_ENA_CLR    (PLX_ICSR_LINTI1_ENA | PLX_ICSR_PCIINT_ENA | \
 			     PLX_ICSR_LINTI1_CLR)
 
-/*
- * The board configuration is probably following:
+/* The board configuration is probably following:
  * RX1 is connected to ground.
  * TX1 is not connected.
  * CLKO is not connected.
@@ -72,8 +70,7 @@ struct ems_pci_card {
  */
 #define EMS_PCI_OCR         (OCR_TX0_PUSHPULL | OCR_TX1_PUSHPULL)
 
-/*
- * In the CDR register, you should set CBP to 1.
+/* In the CDR register, you should set CBP to 1.
  * You will probably also want to set the clock divider value to 7
  * (meaning direct oscillator output) because the second SJA1000 chip
  * is driven by the first one CLKOUT output.
@@ -100,8 +97,7 @@ static const struct pci_device_id ems_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, ems_pci_tbl);
 
-/*
- * Helper to read internal registers from card logic (not CAN)
+/* Helper to read internal registers from card logic (not CAN)
  */
 static u8 ems_pci_v1_readb(struct ems_pci_card *card, unsigned int port)
 {
@@ -146,8 +142,7 @@ static void ems_pci_v2_post_irq(const struct sja1000_priv *priv)
 	writel(PLX_ICSR_ENA_CLR, card->conf_addr + PLX_ICSR);
 }
 
-/*
- * Check if a CAN controller is present at the specified location
+/* Check if a CAN controller is present at the specified location
  * by trying to set 'em into the PeliCAN mode
  */
 static inline int ems_pci_check_chan(const struct sja1000_priv *priv)
@@ -185,10 +180,10 @@ static void ems_pci_del_card(struct pci_dev *pdev)
 		free_sja1000dev(dev);
 	}
 
-	if (card->base_addr != NULL)
+	if (card->base_addr)
 		pci_iounmap(card->pci_dev, card->base_addr);
 
-	if (card->conf_addr != NULL)
+	if (card->conf_addr)
 		pci_iounmap(card->pci_dev, card->conf_addr);
 
 	kfree(card);
@@ -202,8 +197,7 @@ static void ems_pci_card_reset(struct ems_pci_card *card)
 	writeb(0, card->base_addr);
 }
 
-/*
- * Probe PCI device for EMS CAN signature and register each available
+/* Probe PCI device for EMS CAN signature and register each available
  * CAN channel to SJA1000 Socket-CAN subsystem.
  */
 static int ems_pci_add_card(struct pci_dev *pdev,
@@ -222,8 +216,8 @@ static int ems_pci_add_card(struct pci_dev *pdev,
 	}
 
 	/* Allocating card structures to hold addresses, ... */
-	card = kzalloc(sizeof(struct ems_pci_card), GFP_KERNEL);
-	if (card == NULL) {
+	card = kzalloc(sizeof(*card), GFP_KERNEL);
+	if (!card) {
 		pci_disable_device(pdev);
 		return -ENOMEM;
 	}
@@ -248,13 +242,13 @@ static int ems_pci_add_card(struct pci_dev *pdev,
 
 	/* Remap configuration space and controller memory area */
 	card->conf_addr = pci_iomap(pdev, 0, conf_size);
-	if (card->conf_addr == NULL) {
+	if (!card->conf_addr) {
 		err = -ENOMEM;
 		goto failure_cleanup;
 	}
 
 	card->base_addr = pci_iomap(pdev, base_bar, EMS_PCI_BASE_SIZE);
-	if (card->base_addr == NULL) {
+	if (!card->base_addr) {
 		err = -ENOMEM;
 		goto failure_cleanup;
 	}
@@ -281,7 +275,7 @@ static int ems_pci_add_card(struct pci_dev *pdev,
 	/* Detect available channels */
 	for (i = 0; i < max_chan; i++) {
 		dev = alloc_sja1000dev(0);
-		if (dev == NULL) {
+		if (!dev) {
 			err = -ENOMEM;
 			goto failure_cleanup;
 		}
@@ -325,8 +319,9 @@ static int ems_pci_add_card(struct pci_dev *pdev,
 			/* Register SJA1000 device */
 			err = register_sja1000dev(dev);
 			if (err) {
-				dev_err(&pdev->dev, "Registering device failed "
-							"(err=%d)\n", err);
+				dev_err(&pdev->dev,
+					"Registering device failed: %pe\n",
+					ERR_PTR(err));
 				free_sja1000dev(dev);
 				goto failure_cleanup;
 			}
@@ -334,7 +329,7 @@ static int ems_pci_add_card(struct pci_dev *pdev,
 			card->channels++;
 
 			dev_info(&pdev->dev, "Channel #%d at 0x%p, irq %d\n",
-					i + 1, priv->reg_base, dev->irq);
+				 i + 1, priv->reg_base, dev->irq);
 		} else {
 			free_sja1000dev(dev);
 		}
-- 
2.39.1


