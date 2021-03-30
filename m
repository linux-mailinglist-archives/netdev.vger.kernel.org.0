Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C35C34E6C7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhC3Lrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhC3Lqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFE8C061764
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:47 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpa-0006Z4-DP
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:46 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C97CB603EE2
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:31 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A8B8F603E4A;
        Tue, 30 Mar 2021 11:46:14 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2d460847;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 30/39] can: c_can: fix indention
Date:   Tue, 30 Mar 2021 13:45:50 +0200
Message-Id: <20210330114559.1114855-31-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the indention in the driver.

Link: https://lore.kernel.org/r/20210304154240.2747987-4-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c     | 12 ++++++------
 drivers/net/can/c_can/c_can.h     | 10 +++++-----
 drivers/net/can/c_can/c_can_pci.c | 16 ++++++++--------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index cb0707a899d5..cd98d30dd083 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -502,7 +502,7 @@ static int c_can_set_bittiming(struct net_device *dev)
 	reg_brpe = brpe & BRP_EXT_BRPE_MASK;
 
 	netdev_info(dev,
-		"setting BTR=%04x BRPE=%04x\n", reg_btr, reg_brpe);
+		    "setting BTR=%04x BRPE=%04x\n", reg_btr, reg_brpe);
 
 	ctrl_save = priv->read_reg(priv, C_CAN_CTRL_REG);
 	ctrl_save &= ~CONTROL_INIT;
@@ -836,7 +836,7 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 	 * for a maximum number of 16 objects.
 	 */
 	BUILD_BUG_ON_MSG(C_CAN_MSG_OBJ_RX_LAST > 16,
-			"Implementation does not support more message objects than 16");
+			 "Implementation does not support more message objects than 16");
 
 	while (quota > 0) {
 		if (!pend) {
@@ -865,7 +865,7 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 }
 
 static int c_can_handle_state_change(struct net_device *dev,
-				enum c_can_bus_error_types error_type)
+				     enum c_can_bus_error_types error_type)
 {
 	unsigned int reg_err_counter;
 	unsigned int rx_err_passive;
@@ -1127,7 +1127,7 @@ static int c_can_open(struct net_device *dev)
 
 	/* register interrupt handler */
 	err = request_irq(dev->irq, &c_can_isr, IRQF_SHARED, dev->name,
-				dev);
+			  dev);
 	if (err < 0) {
 		netdev_err(dev, "failed to request interrupt\n");
 		goto exit_irq_fail;
@@ -1219,7 +1219,7 @@ int c_can_power_down(struct net_device *dev)
 	/* Wait for the PDA bit to get set */
 	time_out = jiffies + msecs_to_jiffies(INIT_WAIT_MS);
 	while (!(priv->read_reg(priv, C_CAN_STS_REG) & STATUS_PDA) &&
-				time_after(time_out, jiffies))
+	       time_after(time_out, jiffies))
 		cpu_relax();
 
 	if (time_after(jiffies, time_out))
@@ -1260,7 +1260,7 @@ int c_can_power_up(struct net_device *dev)
 	/* Wait for the PDA bit to get clear */
 	time_out = jiffies + msecs_to_jiffies(INIT_WAIT_MS);
 	while ((priv->read_reg(priv, C_CAN_STS_REG) & STATUS_PDA) &&
-				time_after(time_out, jiffies))
+	       time_after(time_out, jiffies))
 		cpu_relax();
 
 	if (time_after(jiffies, time_out)) {
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 92213d3d96eb..3d07285e46c1 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -201,16 +201,16 @@ struct c_can_priv {
 	atomic_t sie_pending;
 	unsigned long tx_dir;
 	int last_status;
-	u16 (*read_reg) (const struct c_can_priv *priv, enum reg index);
-	void (*write_reg) (const struct c_can_priv *priv, enum reg index, u16 val);
-	u32 (*read_reg32) (const struct c_can_priv *priv, enum reg index);
-	void (*write_reg32) (const struct c_can_priv *priv, enum reg index, u32 val);
+	u16 (*read_reg)(const struct c_can_priv *priv, enum reg index);
+	void (*write_reg)(const struct c_can_priv *priv, enum reg index, u16 val);
+	u32 (*read_reg32)(const struct c_can_priv *priv, enum reg index);
+	void (*write_reg32)(const struct c_can_priv *priv, enum reg index, u32 val);
 	void __iomem *base;
 	const u16 *regs;
 	void *priv;		/* for board-specific data */
 	enum c_can_dev_id type;
 	struct c_can_raminit raminit_sys;	/* RAMINIT via syscon regmap */
-	void (*raminit) (const struct c_can_priv *priv, bool enable);
+	void (*raminit)(const struct c_can_priv *priv, bool enable);
 	u32 comm_rcv_high;
 	u32 rxmasked;
 	u32 dlc[C_CAN_MSG_OBJ_TX_NUM];
diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_can_pci.c
index 35a914e70cc9..248baa350ef0 100644
--- a/drivers/net/can/c_can/c_can_pci.c
+++ b/drivers/net/can/c_can/c_can_pci.c
@@ -47,25 +47,25 @@ struct c_can_pci_data {
  * Handle the same by providing a common read/write interface.
  */
 static u16 c_can_pci_read_reg_aligned_to_16bit(const struct c_can_priv *priv,
-						enum reg index)
+					       enum reg index)
 {
 	return readw(priv->base + priv->regs[index]);
 }
 
 static void c_can_pci_write_reg_aligned_to_16bit(const struct c_can_priv *priv,
-						enum reg index, u16 val)
+						 enum reg index, u16 val)
 {
 	writew(val, priv->base + priv->regs[index]);
 }
 
 static u16 c_can_pci_read_reg_aligned_to_32bit(const struct c_can_priv *priv,
-						enum reg index)
+					       enum reg index)
 {
 	return readw(priv->base + 2 * priv->regs[index]);
 }
 
 static void c_can_pci_write_reg_aligned_to_32bit(const struct c_can_priv *priv,
-						enum reg index, u16 val)
+						 enum reg index, u16 val)
 {
 	writew(val, priv->base + 2 * priv->regs[index]);
 }
@@ -87,13 +87,13 @@ static u32 c_can_pci_read_reg32(const struct c_can_priv *priv, enum reg index)
 	u32 val;
 
 	val = priv->read_reg(priv, index);
-	val |= ((u32) priv->read_reg(priv, index + 1)) << 16;
+	val |= ((u32)priv->read_reg(priv, index + 1)) << 16;
 
 	return val;
 }
 
 static void c_can_pci_write_reg32(const struct c_can_priv *priv, enum reg index,
-		u32 val)
+				  u32 val)
 {
 	priv->write_reg(priv, index + 1, val >> 16);
 	priv->write_reg(priv, index, val);
@@ -216,7 +216,7 @@ static int c_can_pci_probe(struct pci_dev *pdev,
 	}
 
 	dev_dbg(&pdev->dev, "%s device registered (regs=%p, irq=%d)\n",
-		 KBUILD_MODNAME, priv->regs, dev->irq);
+		KBUILD_MODNAME, priv->regs, dev->irq);
 
 	return 0;
 
@@ -251,7 +251,7 @@ static void c_can_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static const struct c_can_pci_data c_can_sta2x11= {
+static const struct c_can_pci_data c_can_sta2x11 = {
 	.type = BOSCH_C_CAN,
 	.reg_align = C_CAN_REG_ALIGN_32,
 	.freq = 52000000, /* 52 Mhz */
-- 
2.30.2


