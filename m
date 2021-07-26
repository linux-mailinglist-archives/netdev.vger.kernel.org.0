Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776C93D5B55
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhGZNdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbhGZNdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C794DC0619CF
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81LV-0002I8-5C
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:41 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 90D196582AB
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:22 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 254186581F1;
        Mon, 26 Jul 2021 14:12:01 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 09bb9e68;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: [PATCH net-next 31/46] can: peak_pci: convert comments to network style comments
Date:   Mon, 26 Jul 2021 16:11:29 +0200
Message-Id: <20210726141144.862529-32-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts all comments to network subsystem style comments.

Cc: Stephane Grosjean <s.grosjean@peak-system.com>
Link: https://lore.kernel.org/r/20210616102811.2449426-8-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sja1000/peak_pci.c | 49 +++++++++---------------------
 1 file changed, 14 insertions(+), 35 deletions(-)

diff --git a/drivers/net/can/sja1000/peak_pci.c b/drivers/net/can/sja1000/peak_pci.c
index 84eac8cb8686..5fec26c6df42 100644
--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -41,9 +41,7 @@ struct peak_pci_chan {
 #define PEAK_PCI_CDR		(CDR_CBP | CDR_CLKOUT_MASK)
 #define PEAK_PCI_OCR		OCR_TX0_PUSHPULL
 
-/*
- * Important PITA registers
- */
+/* Important PITA registers */
 #define PITA_ICR		0x00	/* Interrupt control register */
 #define PITA_GPIOICR		0x18	/* GPIO interface control register */
 #define PITA_MISC		0x1C	/* Miscellaneous register */
@@ -88,9 +86,7 @@ static const struct pci_device_id peak_pci_tbl[] = {
 MODULE_DEVICE_TABLE(pci, peak_pci_tbl);
 
 #ifdef CONFIG_CAN_PEAK_PCIEC
-/*
- * PCAN-ExpressCard needs I2C bit-banging configuration option.
- */
+/* PCAN-ExpressCard needs I2C bit-banging configuration option. */
 
 /* GPIOICR byte access offsets */
 #define PITA_GPOUT		0x18	/* GPx output value */
@@ -230,9 +226,7 @@ static int pita_getscl(void *data)
 	return (readb(card->cfg_base + PITA_GPIN) & PITA_GPIN_SCL) ? 1 : 0;
 }
 
-/*
- * write commands to the LED chip though the I2C-bus of the PCAN-PCIeC
- */
+/* write commands to the LED chip though the I2C-bus of the PCAN-PCIeC */
 static int peak_pciec_write_pca9553(struct peak_pciec_card *card,
 				    u8 offset, u8 data)
 {
@@ -261,9 +255,7 @@ static int peak_pciec_write_pca9553(struct peak_pciec_card *card,
 	return 0;
 }
 
-/*
- * delayed work callback used to control the LEDs
- */
+/* delayed work callback used to control the LEDs */
 static void peak_pciec_led_work(struct work_struct *work)
 {
 	struct peak_pciec_card *card =
@@ -309,9 +301,7 @@ static void peak_pciec_led_work(struct work_struct *work)
 		schedule_delayed_work(&card->led_work, HZ);
 }
 
-/*
- * set LEDs blinking state
- */
+/* set LEDs blinking state */
 static void peak_pciec_set_leds(struct peak_pciec_card *card, u8 led_mask, u8 s)
 {
 	u8 new_led = card->led_cache;
@@ -328,25 +318,19 @@ static void peak_pciec_set_leds(struct peak_pciec_card *card, u8 led_mask, u8 s)
 	peak_pciec_write_pca9553(card, 5, new_led);
 }
 
-/*
- * start one second delayed work to control LEDs
- */
+/* start one second delayed work to control LEDs */
 static void peak_pciec_start_led_work(struct peak_pciec_card *card)
 {
 	schedule_delayed_work(&card->led_work, HZ);
 }
 
-/*
- * stop LEDs delayed work
- */
+/* stop LEDs delayed work */
 static void peak_pciec_stop_led_work(struct peak_pciec_card *card)
 {
 	cancel_delayed_work_sync(&card->led_work);
 }
 
-/*
- * initialize the PCA9553 4-bit I2C-bus LED chip
- */
+/* initialize the PCA9553 4-bit I2C-bus LED chip */
 static int peak_pciec_init_leds(struct peak_pciec_card *card)
 {
 	int err;
@@ -375,17 +359,14 @@ static int peak_pciec_init_leds(struct peak_pciec_card *card)
 	return peak_pciec_write_pca9553(card, 5, PCA9553_LS0_INIT);
 }
 
-/*
- * restore LEDs state to off peak_pciec_leds_exit
- */
+/* restore LEDs state to off peak_pciec_leds_exit */
 static void peak_pciec_leds_exit(struct peak_pciec_card *card)
 {
 	/* switch LEDs to off */
 	peak_pciec_write_pca9553(card, 5, PCA9553_LED_OFF_ALL);
 }
 
-/*
- * normal write sja1000 register method overloaded to catch when controller
+/* normal write sja1000 register method overloaded to catch when controller
  * is started or stopped, to control leds
  */
 static void peak_pciec_write_reg(const struct sja1000_priv *priv,
@@ -506,9 +487,7 @@ static void peak_pciec_remove(struct peak_pciec_card *card)
 
 #else /* CONFIG_CAN_PEAK_PCIEC */
 
-/*
- * Placebo functions when PCAN-ExpressCard support is not selected
- */
+/* Placebo functions when PCAN-ExpressCard support is not selected */
 static inline int peak_pciec_probe(struct pci_dev *pdev, struct net_device *dev)
 {
 	return -ENODEV;
@@ -642,8 +621,7 @@ static int peak_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		chan->prev_dev = pci_get_drvdata(pdev);
 		pci_set_drvdata(pdev, dev);
 
-		/*
-		 * PCAN-ExpressCard needs some additional i2c init.
+		/* PCAN-ExpressCard needs some additional i2c init.
 		 * This must be done *before* register_sja1000dev() but
 		 * *after* devices linkage
 		 */
@@ -709,7 +687,8 @@ static int peak_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* pci_xxx_config_word() return positive PCIBIOS_xxx error codes while
 	 * the probe() function must return a negative errno in case of failure
-	 * (err is unchanged if negative) */
+	 * (err is unchanged if negative)
+	 */
 	return pcibios_err_to_errno(err);
 }
 
-- 
2.30.2


