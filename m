Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C882BAB5E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgKTNeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgKTNdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EB5C061A04
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:24 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XS-0006Fn-BO; Fri, 20 Nov 2020 14:33:22 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 03/25] can: rename get_can_dlc() macro with can_cc_dlc2len()
Date:   Fri, 20 Nov 2020 14:32:56 +0100
Message-Id: <20201120133318.3428231-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

The get_can_dlc() macro is used to ensure the payload length information of
the Classical CAN frame to be max 8 bytes (the CAN_MAX_DLEN).

Rename the macro and use the correct constant in preparation of the len/dlc
cleanup for Classical CAN frames.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201110101852.1973-3-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/at91_can.c                        | 2 +-
 drivers/net/can/c_can/c_can.c                     | 2 +-
 drivers/net/can/cc770/cc770.c                     | 2 +-
 drivers/net/can/flexcan.c                         | 2 +-
 drivers/net/can/grcan.c                           | 2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c             | 2 +-
 drivers/net/can/janz-ican3.c                      | 4 ++--
 drivers/net/can/m_can/m_can.c                     | 2 +-
 drivers/net/can/mscan/mscan.c                     | 2 +-
 drivers/net/can/pch_can.c                         | 4 ++--
 drivers/net/can/peak_canfd/peak_canfd.c           | 2 +-
 drivers/net/can/rcar/rcar_can.c                   | 2 +-
 drivers/net/can/rcar/rcar_canfd.c                 | 4 ++--
 drivers/net/can/sja1000/sja1000.c                 | 2 +-
 drivers/net/can/softing/softing_main.c            | 2 +-
 drivers/net/can/spi/hi311x.c                      | 2 +-
 drivers/net/can/spi/mcp251x.c                     | 4 ++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c    | 2 +-
 drivers/net/can/sun4i_can.c                       | 2 +-
 drivers/net/can/ti_hecc.c                         | 2 +-
 drivers/net/can/usb/ems_usb.c                     | 2 +-
 drivers/net/can/usb/esd_usb2.c                    | 2 +-
 drivers/net/can/usb/gs_usb.c                      | 2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 4 ++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 4 ++--
 drivers/net/can/usb/mcba_usb.c                    | 2 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c           | 2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c        | 2 +-
 drivers/net/can/usb/ucan.c                        | 8 ++++----
 drivers/net/can/usb/usb_8dev.c                    | 2 +-
 drivers/net/can/xilinx_can.c                      | 4 ++--
 include/linux/can/dev.h                           | 8 ++++----
 32 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index c14de95d2ca7..db06254f8eb7 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -580,7 +580,7 @@ static void at91_read_mb(struct net_device *dev, unsigned int mb,
 		cf->can_id = (reg_mid >> 18) & CAN_SFF_MASK;
 
 	reg_msr = at91_read(priv, AT91_MSR(mb));
-	cf->can_dlc = get_can_dlc((reg_msr >> 16) & 0xf);
+	cf->can_dlc = can_cc_dlc2len((reg_msr >> 16) & 0xf);
 
 	if (reg_msr & AT91_MSR_MRTR)
 		cf->can_id |= CAN_RTR_FLAG;
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 1ccdbe89585b..56cc705959ea 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -397,7 +397,7 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, u32 ctrl)
 		return -ENOMEM;
 	}
 
-	frame->can_dlc = get_can_dlc(ctrl & 0x0F);
+	frame->can_dlc = can_cc_dlc2len(ctrl & 0x0F);
 
 	arb = priv->read_reg32(priv, C_CAN_IFACE(ARB1_REG, iface));
 
diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index 07e2b8df5153..3fd2a276dd93 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -486,7 +486,7 @@ static void cc770_rx(struct net_device *dev, unsigned int mo, u8 ctrl1)
 		}
 
 		cf->can_id = id;
-		cf->can_dlc = get_can_dlc((config & 0xf0) >> 4);
+		cf->can_dlc = can_cc_dlc2len((config & 0xf0) >> 4);
 		for (i = 0; i < cf->can_dlc; i++)
 			cf->data[i] = cc770_read_reg(priv, msgobj[mo].data[i]);
 	}
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 99e5f272205d..50ccd18170c8 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1005,7 +1005,7 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 		if (reg_ctrl & FLEXCAN_MB_CNT_BRS)
 			cfd->flags |= CANFD_BRS;
 	} else {
-		cfd->len = get_can_dlc((reg_ctrl >> 16) & 0xf);
+		cfd->len = can_cc_dlc2len((reg_ctrl >> 16) & 0xf);
 
 		if (reg_ctrl & FLEXCAN_MB_CNT_RTR)
 			cfd->can_id |= CAN_RTR_FLAG;
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 39802f107eb1..c71c9b8683d5 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1201,7 +1201,7 @@ static int grcan_receive(struct net_device *dev, int budget)
 			cf->can_id = ((slot[0] & GRCAN_MSG_BID)
 				      >> GRCAN_MSG_BID_BIT);
 		}
-		cf->can_dlc = get_can_dlc((slot[1] & GRCAN_MSG_DLC)
+		cf->can_dlc = can_cc_dlc2len((slot[1] & GRCAN_MSG_DLC)
 					  >> GRCAN_MSG_DLC_BIT);
 		if (rtr) {
 			cf->can_id |= CAN_RTR_FLAG;
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index 74503cacf594..cc790354a8ee 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -273,7 +273,7 @@ static void ifi_canfd_read_fifo(struct net_device *ndev)
 	if (rxdlc & IFI_CANFD_RXFIFO_DLC_EDL)
 		cf->len = can_dlc2len(dlc);
 	else
-		cf->len = get_can_dlc(dlc);
+		cf->len = can_cc_dlc2len(dlc);
 
 	rxid = readl(priv->base + IFI_CANFD_RXFIFO_ID);
 	id = (rxid >> IFI_CANFD_RXFIFO_ID_ID_OFFSET);
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index f929db893957..6a21af05ba27 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -916,10 +916,10 @@ static void ican3_to_can_frame(struct ican3_dev *mod,
 
 		cf->can_id |= desc->data[0] << 3;
 		cf->can_id |= (desc->data[1] & 0xe0) >> 5;
-		cf->can_dlc = get_can_dlc(desc->data[1] & ICAN3_CAN_DLC_MASK);
+		cf->can_dlc = can_cc_dlc2len(desc->data[1] & ICAN3_CAN_DLC_MASK);
 		memcpy(cf->data, &desc->data[2], cf->can_dlc);
 	} else {
-		cf->can_dlc = get_can_dlc(desc->data[0] & ICAN3_CAN_DLC_MASK);
+		cf->can_dlc = can_cc_dlc2len(desc->data[0] & ICAN3_CAN_DLC_MASK);
 		if (desc->data[0] & ICAN3_EFF_RTR)
 			cf->can_id |= CAN_RTR_FLAG;
 
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index f3fc37e96b08..2e46a5916656 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -459,7 +459,7 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	if (dlc & RX_BUF_FDF)
 		cf->len = can_dlc2len((dlc >> 16) & 0x0F);
 	else
-		cf->len = get_can_dlc((dlc >> 16) & 0x0F);
+		cf->len = can_cc_dlc2len((dlc >> 16) & 0x0F);
 
 	id = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_ID);
 	if (id & RX_BUF_XTD)
diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index 640ba1b356ec..95bf7338b358 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -312,7 +312,7 @@ static void mscan_get_rx_frame(struct net_device *dev, struct can_frame *frame)
 	if (can_id & 1)
 		frame->can_id |= CAN_RTR_FLAG;
 
-	frame->can_dlc = get_can_dlc(in_8(&regs->rx.dlr) & 0xf);
+	frame->can_dlc = can_cc_dlc2len(in_8(&regs->rx.dlr) & 0xf);
 
 	if (!(frame->can_id & CAN_RTR_FLAG)) {
 		void __iomem *data = &regs->rx.dsr1_0;
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 5c180d2f3c3c..9509bac8352d 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -683,7 +683,7 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 		if (id2 & PCH_ID2_DIR)
 			cf->can_id |= CAN_RTR_FLAG;
 
-		cf->can_dlc = get_can_dlc((ioread32(&priv->regs->
+		cf->can_dlc = can_cc_dlc2len((ioread32(&priv->regs->
 						    ifregs[0].mcont)) & 0xF);
 
 		for (i = 0; i < cf->can_dlc; i += 2) {
@@ -715,7 +715,7 @@ static void pch_can_tx_complete(struct net_device *ndev, u32 int_stat)
 	iowrite32(PCH_CMASK_RX_TX_GET | PCH_CMASK_CLRINTPND,
 		  &priv->regs->ifregs[1].cmask);
 	pch_can_rw_msg_obj(&priv->regs->ifregs[1].creq, int_stat);
-	dlc = get_can_dlc(ioread32(&priv->regs->ifregs[1].mcont) &
+	dlc = can_cc_dlc2len(ioread32(&priv->regs->ifregs[1].mcont) &
 			  PCH_IF_MCONT_DLC);
 	stats->tx_bytes += dlc;
 	stats->tx_packets++;
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index 40c33b8a5fda..9ea2adea3f0f 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -259,7 +259,7 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 	if (rx_msg_flags & PUCAN_MSG_EXT_DATA_LEN)
 		cf_len = can_dlc2len(get_canfd_dlc(pucan_msg_get_dlc(msg)));
 	else
-		cf_len = get_can_dlc(pucan_msg_get_dlc(msg));
+		cf_len = can_cc_dlc2len(pucan_msg_get_dlc(msg));
 
 	/* if this frame is an echo, */
 	if (rx_msg_flags & PUCAN_MSG_LOOPED_BACK) {
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 48575900adb7..711ef4996b48 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -659,7 +659,7 @@ static void rcar_can_rx_pkt(struct rcar_can_priv *priv)
 		cf->can_id = (data >> RCAR_CAN_SID_SHIFT) & CAN_SFF_MASK;
 
 	dlc = readb(&priv->regs->mb[RCAR_CAN_RX_FIFO_MBX].dlc);
-	cf->can_dlc = get_can_dlc(dlc);
+	cf->can_dlc = can_cc_dlc2len(dlc);
 	if (data & RCAR_CAN_RTR) {
 		cf->can_id |= CAN_RTR_FLAG;
 	} else {
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index de59dd6aad29..899a3218ce5e 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1448,7 +1448,7 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 		if (sts & RCANFD_RFFDSTS_RFFDF)
 			cf->len = can_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
 		else
-			cf->len = get_can_dlc(RCANFD_RFPTR_RFDLC(dlc));
+			cf->len = can_cc_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
 
 		if (sts & RCANFD_RFFDSTS_RFESI) {
 			cf->flags |= CANFD_ESI;
@@ -1464,7 +1464,7 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 			rcar_canfd_get_data(priv, cf, RCANFD_F_RFDF(ridx, 0));
 		}
 	} else {
-		cf->len = get_can_dlc(RCANFD_RFPTR_RFDLC(dlc));
+		cf->len = can_cc_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
 		if (id & RCANFD_RFID_RFRTR)
 			cf->can_id |= CAN_RTR_FLAG;
 		else
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 9f107798f904..1f188f2d126e 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -367,7 +367,7 @@ static void sja1000_rx(struct net_device *dev)
 		    | (priv->read_reg(priv, SJA1000_ID2) >> 5);
 	}
 
-	cf->can_dlc = get_can_dlc(fi & 0x0F);
+	cf->can_dlc = can_cc_dlc2len(fi & 0x0F);
 	if (fi & SJA1000_FI_RTR) {
 		id |= CAN_RTR_FLAG;
 	} else {
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index 9d2faaa39ce4..39e8275ee7ba 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -261,7 +261,7 @@ static int softing_handle_1(struct softing *card)
 	} else {
 		if (cmd & CMD_RTR)
 			msg.can_id |= CAN_RTR_FLAG;
-		msg.can_dlc = get_can_dlc(*ptr++);
+		msg.can_dlc = can_cc_dlc2len(*ptr++);
 		if (cmd & CMD_XTD) {
 			msg.can_id |= CAN_EFF_FLAG;
 			msg.can_id |= le32_to_cpup((void *)ptr);
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 73d48c3b8ded..728f34b696a7 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -341,7 +341,7 @@ static void hi3110_hw_rx(struct spi_device *spi)
 	}
 
 	/* Data length */
-	frame->can_dlc = get_can_dlc(buf[HI3110_FIFO_WOTIME_DLC_OFF] & 0x0F);
+	frame->can_dlc = can_cc_dlc2len(buf[HI3110_FIFO_WOTIME_DLC_OFF] & 0x0F);
 
 	if (buf[HI3110_FIFO_WOTIME_ID_OFF + 3] & HI3110_FIFO_WOTIME_ID_RTR)
 		frame->can_id |= CAN_RTR_FLAG;
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 22d814ae4edc..6ddebb1c4a24 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -664,7 +664,7 @@ static void mcp251x_hw_rx_frame(struct spi_device *spi, u8 *buf,
 		for (i = 1; i < RXBDAT_OFF; i++)
 			buf[i] = mcp251x_read_reg(spi, RXBCTRL(buf_idx) + i);
 
-		len = get_can_dlc(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
+		len = can_cc_dlc2len(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
 		for (; i < (RXBDAT_OFF + len); i++)
 			buf[i] = mcp251x_read_reg(spi, RXBCTRL(buf_idx) + i);
 	} else {
@@ -720,7 +720,7 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
 			frame->can_id |= CAN_RTR_FLAG;
 	}
 	/* Data length */
-	frame->can_dlc = get_can_dlc(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
+	frame->can_dlc = can_cc_dlc2len(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
 	memcpy(frame->data, buf + RXBDAT_OFF, frame->can_dlc);
 
 	priv->net->stats.rx_packets++;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 9c215f7c5f81..c0a08400f444 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1410,7 +1410,7 @@ mcp251xfd_hw_rx_obj_to_skb(const struct mcp251xfd_priv *priv,
 		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_RTR)
 			cfd->can_id |= CAN_RTR_FLAG;
 
-		cfd->len = get_can_dlc(FIELD_GET(MCP251XFD_OBJ_FLAGS_DLC,
+		cfd->len = can_cc_dlc2len(FIELD_GET(MCP251XFD_OBJ_FLAGS_DLC,
 						 hw_rx_obj->flags));
 	}
 
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index e2c6cf4b2228..0e2569779895 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -475,7 +475,7 @@ static void sun4i_can_rx(struct net_device *dev)
 		return;
 
 	fi = readl(priv->base + SUN4I_REG_BUF0_ADDR);
-	cf->can_dlc = get_can_dlc(fi & 0x0F);
+	cf->can_dlc = can_cc_dlc2len(fi & 0x0F);
 	if (fi & SUN4I_MSG_EFF_FLAG) {
 		dreg = SUN4I_REG_BUF5_ADDR;
 		id = (readl(priv->base + SUN4I_REG_BUF1_ADDR) << 21) |
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 2c22f40e12bd..0b1fd34f4c83 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -566,7 +566,7 @@ static struct sk_buff *ti_hecc_mailbox_read(struct can_rx_offload *offload,
 	data = hecc_read_mbx(priv, mbxno, HECC_CANMCF);
 	if (data & HECC_CANMCF_RTR)
 		cf->can_id |= CAN_RTR_FLAG;
-	cf->can_dlc = get_can_dlc(data & 0xF);
+	cf->can_dlc = can_cc_dlc2len(data & 0xF);
 
 	data = hecc_read_mbx(priv, mbxno, HECC_CANMDL);
 	*(__be32 *)(cf->data) = cpu_to_be32(data);
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 4f52810bebf8..288781934149 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -306,7 +306,7 @@ static void ems_usb_rx_can_msg(struct ems_usb *dev, struct ems_cpc_msg *msg)
 		return;
 
 	cf->can_id = le32_to_cpu(msg->msg.can_msg.id);
-	cf->can_dlc = get_can_dlc(msg->msg.can_msg.length & 0xF);
+	cf->can_dlc = can_cc_dlc2len(msg->msg.can_msg.length & 0xF);
 
 	if (msg->type == CPC_MSG_TYPE_EXT_CAN_FRAME ||
 	    msg->type == CPC_MSG_TYPE_EXT_RTR_FRAME)
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index b5d7ed21d7d9..72999de550d1 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -321,7 +321,7 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
 		}
 
 		cf->can_id = id & ESD_IDMASK;
-		cf->can_dlc = get_can_dlc(msg->msg.rx.dlc & ~ESD_RTR);
+		cf->can_dlc = can_cc_dlc2len(msg->msg.rx.dlc & ~ESD_RTR);
 
 		if (id & ESD_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 3005157059ca..b1729b208788 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -331,7 +331,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 
 		cf->can_id = hf->can_id;
 
-		cf->can_dlc = get_can_dlc(hf->can_dlc);
+		cf->can_dlc = can_cc_dlc2len(hf->can_dlc);
 		memcpy(cf->data, hf->data, 8);
 
 		/* ERROR frames tell us information about the controller */
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 218fadc91155..493a614bf333 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1180,7 +1180,7 @@ static void kvaser_usb_hydra_rx_msg_std(const struct kvaser_usb *dev,
 	if (flags & KVASER_USB_HYDRA_CF_FLAG_OVERRUN)
 		kvaser_usb_can_rx_over_error(priv->netdev);
 
-	cf->can_dlc = get_can_dlc(cmd->rx_can.dlc);
+	cf->can_dlc = can_cc_dlc2len(cmd->rx_can.dlc);
 
 	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME)
 		cf->can_id |= CAN_RTR_FLAG;
@@ -1257,7 +1257,7 @@ static void kvaser_usb_hydra_rx_msg_ext(const struct kvaser_usb *dev,
 		if (flags & KVASER_USB_HYDRA_CF_FLAG_ESI)
 			cf->flags |= CANFD_ESI;
 	} else {
-		cf->len = get_can_dlc(dlc);
+		cf->len = can_cc_dlc2len(dlc);
 	}
 
 	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME)
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 1b9957f12459..916ab994cce4 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -978,7 +978,7 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 		else
 			cf->can_id &= CAN_SFF_MASK;
 
-		cf->can_dlc = get_can_dlc(cmd->u.leaf.log_message.dlc);
+		cf->can_dlc = can_cc_dlc2len(cmd->u.leaf.log_message.dlc);
 
 		if (cmd->u.leaf.log_message.flags & MSG_FLAG_REMOTE_FRAME)
 			cf->can_id |= CAN_RTR_FLAG;
@@ -996,7 +996,7 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 			cf->can_id |= CAN_EFF_FLAG;
 		}
 
-		cf->can_dlc = get_can_dlc(rx_data[5]);
+		cf->can_dlc = can_cc_dlc2len(rx_data[5]);
 
 		if (cmd->u.rx_can_header.flag & MSG_FLAG_REMOTE_FRAME)
 			cf->can_id |= CAN_RTR_FLAG;
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index e97f2e0da6b0..295886c6b565 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -451,7 +451,7 @@ static void mcba_usb_process_can(struct mcba_priv *priv,
 	if (msg->dlc & MCBA_DLC_RTR_MASK)
 		cf->can_id |= CAN_RTR_FLAG;
 
-	cf->can_dlc = get_can_dlc(msg->dlc & MCBA_DLC_MASK);
+	cf->can_dlc = can_cc_dlc2len(msg->dlc & MCBA_DLC_MASK);
 
 	memcpy(cf->data, msg->data, cf->can_dlc);
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 63bd2ed96697..f7fc82203489 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -734,7 +734,7 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		cf->can_id = le16_to_cpu(tmp16) >> 5;
 	}
 
-	cf->can_dlc = get_can_dlc(rec_len);
+	cf->can_dlc = can_cc_dlc2len(rec_len);
 
 	/* Only first packet timestamp is a word */
 	if (pcan_usb_decode_ts(mc, !mc->rec_ts_idx))
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index d29d20525588..1f08dd22b3d5 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -499,7 +499,7 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 		if (!skb)
 			return -ENOMEM;
 
-		cfd->len = get_can_dlc(pucan_msg_get_dlc(rm));
+		cfd->len = can_cc_dlc2len(pucan_msg_get_dlc(rm));
 	}
 
 	cfd->can_id = le32_to_cpu(rm->can_id);
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index dc5290b36598..072058c6f6e8 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -303,12 +303,12 @@ struct ucan_priv {
 	struct ucan_urb_context *context_array;
 };
 
-static u8 ucan_get_can_dlc(struct ucan_can_msg *msg, u16 len)
+static u8 ucan_can_cc_dlc2len(struct ucan_can_msg *msg, u16 len)
 {
 	if (le32_to_cpu(msg->id) & CAN_RTR_FLAG)
-		return get_can_dlc(msg->dlc);
+		return can_cc_dlc2len(msg->dlc);
 	else
-		return get_can_dlc(len - (UCAN_IN_HDR_SIZE + sizeof(msg->id)));
+		return can_cc_dlc2len(len - (UCAN_IN_HDR_SIZE + sizeof(msg->id)));
 }
 
 static void ucan_release_context_array(struct ucan_priv *up)
@@ -614,7 +614,7 @@ static void ucan_rx_can_msg(struct ucan_priv *up, struct ucan_message_in *m)
 	cf->can_id = canid;
 
 	/* compute DLC taking RTR_FLAG into account */
-	cf->can_dlc = ucan_get_can_dlc(&m->msg.can_msg, len);
+	cf->can_dlc = ucan_can_cc_dlc2len(&m->msg.can_msg, len);
 
 	/* copy the payload of non RTR frames */
 	if (!(cf->can_id & CAN_RTR_FLAG) || (cf->can_id & CAN_ERR_FLAG))
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 62749c67c959..216c58f8df6e 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -470,7 +470,7 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
 			return;
 
 		cf->can_id = be32_to_cpu(msg->id);
-		cf->can_dlc = get_can_dlc(msg->dlc & 0xF);
+		cf->can_dlc = can_cc_dlc2len(msg->dlc & 0xF);
 
 		if (msg->flags & USB_8DEV_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 48d746e18f30..73e8b1df1071 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -759,7 +759,7 @@ static int xcan_rx(struct net_device *ndev, int frame_base)
 				   XCAN_DLCR_DLC_SHIFT;
 
 	/* Change Xilinx CAN data length format to socketCAN data format */
-	cf->can_dlc = get_can_dlc(dlc);
+	cf->can_dlc = can_cc_dlc2len(dlc);
 
 	/* Change Xilinx CAN ID format to socketCAN ID format */
 	if (id_xcan & XCAN_IDR_IDE_MASK) {
@@ -835,7 +835,7 @@ static int xcanfd_rx(struct net_device *ndev, int frame_base)
 		cf->len = can_dlc2len((dlc & XCAN_DLCR_DLC_MASK) >>
 				  XCAN_DLCR_DLC_SHIFT);
 	else
-		cf->len = get_can_dlc((dlc & XCAN_DLCR_DLC_MASK) >>
+		cf->len = can_cc_dlc2len((dlc & XCAN_DLCR_DLC_MASK) >>
 					  XCAN_DLCR_DLC_SHIFT);
 
 	/* Change Xilinx CAN ID format to socketCAN ID format */
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 41ff31795320..9bc84c6978ec 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -98,14 +98,14 @@ static inline unsigned int can_bit_time(const struct can_bittiming *bt)
 }
 
 /*
- * get_can_dlc(value) - helper macro to cast a given data length code (dlc)
- * to u8 and ensure the dlc value to be max. 8 bytes.
+ * can_cc_dlc2len(value) - convert a given data length code (dlc) of a
+ * Classical CAN frame into a valid data length of max. 8 bytes.
  *
  * To be used in the CAN netdriver receive path to ensure conformance with
  * ISO 11898-1 Chapter 8.4.2.3 (DLC field)
  */
-#define get_can_dlc(i)		(min_t(u8, (i), CAN_MAX_DLC))
-#define get_canfd_dlc(i)	(min_t(u8, (i), CANFD_MAX_DLC))
+#define can_cc_dlc2len(dlc)	(min_t(u8, (dlc), CAN_MAX_DLEN))
+#define get_canfd_dlc(dlc)	(min_t(u8, (dlc), CANFD_MAX_DLC))
 
 /* Check for outgoing skbs that have not been created by the CAN subsystem */
 static inline bool can_skb_headroom_valid(struct net_device *dev,
-- 
2.29.2

