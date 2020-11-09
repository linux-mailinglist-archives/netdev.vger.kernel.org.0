Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5562AB4D2
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgKIK05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:26:57 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:31751 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbgKIK0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:26:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1604917605;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Y7t/ompzoFc0Fq0Z8DZldpZ9is3m2MgBj4RzM2f5+TU=;
        b=TUze3dItpUhs9QLa121UiU28QIFSFsRmCFGw6MuIqrfQsiSwkjqQmGXidfy+A0pVWr
        e0bYtWvDzTVnevyF85+s/mnIwBRzeEN7KuE0I7AmzwwO+qGpyk5jbZSLTgIS/66JIHs5
        v5p6XN3DvwFT/r0ncWMtlbBJ1fv/aCP9S9IlDuY6YM9bzf/ABV59yAX+iU48ib8c18UT
        s13AZu8eJHd2P8fGvtGy1Pdec0N7nisZOAtPotlW1AVqGB/R0pBWPsi7ODT2FjDfw5lv
        8Sr8AXZmxTH6Ojyonufo/khQtKSpwFoCE/Lh2ubLLN6IIbf5/PQ3REKiLnJKmS5J2jXE
        fkLA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJywjskA="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwA9AQf6dN
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 9 Nov 2020 11:26:41 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v4 2/7] can: rename get_can_dlc() macro with can_get_cc_len()
Date:   Mon,  9 Nov 2020 11:26:13 +0100
Message-Id: <20201109102618.2495-3-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201109102618.2495-1-socketcan@hartkopp.net>
References: <20201109102618.2495-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The get_can_dlc() macro is used to ensure the payload length information of
the Classical CAN frame to be max 8 bytes (the CAN_MAX_DLEN).

Rename the macro and use the correct constant in preparation of the len/dlc
cleanup for Classical CAN frames.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
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
index c14de95d2ca7..cf515e3134dc 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -578,11 +578,11 @@ static void at91_read_mb(struct net_device *dev, unsigned int mb,
 		cf->can_id = ((reg_mid >> 0) & CAN_EFF_MASK) | CAN_EFF_FLAG;
 	else
 		cf->can_id = (reg_mid >> 18) & CAN_SFF_MASK;
 
 	reg_msr = at91_read(priv, AT91_MSR(mb));
-	cf->can_dlc = get_can_dlc((reg_msr >> 16) & 0xf);
+	cf->can_dlc = can_get_cc_len((reg_msr >> 16) & 0xf);
 
 	if (reg_msr & AT91_MSR_MRTR)
 		cf->can_id |= CAN_RTR_FLAG;
 	else {
 		*(u32 *)(cf->data + 0) = at91_read(priv, AT91_MDL(mb));
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 1ccdbe89585b..b36c69983f69 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -395,11 +395,11 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, u32 ctrl)
 	if (!skb) {
 		stats->rx_dropped++;
 		return -ENOMEM;
 	}
 
-	frame->can_dlc = get_can_dlc(ctrl & 0x0F);
+	frame->can_dlc = can_get_cc_len(ctrl & 0x0F);
 
 	arb = priv->read_reg32(priv, C_CAN_IFACE(ARB1_REG, iface));
 
 	if (arb & IF_ARB_MSGXTD)
 		frame->can_id = (arb & CAN_EFF_MASK) | CAN_EFF_FLAG;
diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index 07e2b8df5153..55ebf006484e 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -484,11 +484,11 @@ static void cc770_rx(struct net_device *dev, unsigned int mo, u8 ctrl1)
 			id |= cc770_read_reg(priv, msgobj[mo].id[0]) << 8;
 			id >>= 5;
 		}
 
 		cf->can_id = id;
-		cf->can_dlc = get_can_dlc((config & 0xf0) >> 4);
+		cf->can_dlc = can_get_cc_len((config & 0xf0) >> 4);
 		for (i = 0; i < cf->can_dlc; i++)
 			cf->data[i] = cc770_read_reg(priv, msgobj[mo].data[i]);
 	}
 
 	stats->rx_packets++;
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 881799bd9c5e..b30e3171cbd0 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1001,11 +1001,11 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 		cfd->len = can_dlc2len(get_canfd_dlc((reg_ctrl >> 16) & 0xf));
 
 		if (reg_ctrl & FLEXCAN_MB_CNT_BRS)
 			cfd->flags |= CANFD_BRS;
 	} else {
-		cfd->len = get_can_dlc((reg_ctrl >> 16) & 0xf);
+		cfd->len = can_get_cc_len((reg_ctrl >> 16) & 0xf);
 
 		if (reg_ctrl & FLEXCAN_MB_CNT_RTR)
 			cfd->can_id |= CAN_RTR_FLAG;
 	}
 
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 39802f107eb1..56e6902b3121 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1199,11 +1199,11 @@ static int grcan_receive(struct net_device *dev, int budget)
 			cf->can_id |= CAN_EFF_FLAG;
 		} else {
 			cf->can_id = ((slot[0] & GRCAN_MSG_BID)
 				      >> GRCAN_MSG_BID_BIT);
 		}
-		cf->can_dlc = get_can_dlc((slot[1] & GRCAN_MSG_DLC)
+		cf->can_dlc = can_get_cc_len((slot[1] & GRCAN_MSG_DLC)
 					  >> GRCAN_MSG_DLC_BIT);
 		if (rtr) {
 			cf->can_id |= CAN_RTR_FLAG;
 		} else {
 			for (i = 0; i < cf->can_dlc; i++) {
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index 74503cacf594..67f6d72cdc71 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -271,11 +271,11 @@ static void ifi_canfd_read_fifo(struct net_device *ndev)
 	dlc = (rxdlc >> IFI_CANFD_RXFIFO_DLC_DLC_OFFSET) &
 	      IFI_CANFD_RXFIFO_DLC_DLC_MASK;
 	if (rxdlc & IFI_CANFD_RXFIFO_DLC_EDL)
 		cf->len = can_dlc2len(dlc);
 	else
-		cf->len = get_can_dlc(dlc);
+		cf->len = can_get_cc_len(dlc);
 
 	rxid = readl(priv->base + IFI_CANFD_RXFIFO_ID);
 	id = (rxid >> IFI_CANFD_RXFIFO_ID_ID_OFFSET);
 	if (id & IFI_CANFD_RXFIFO_ID_IDE) {
 		id &= IFI_CANFD_RXFIFO_ID_ID_XTD_MASK;
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index f929db893957..a0af78b15319 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -914,14 +914,14 @@ static void ican3_to_can_frame(struct ican3_dev *mod,
 		if (desc->data[1] & ICAN3_SFF_RTR)
 			cf->can_id |= CAN_RTR_FLAG;
 
 		cf->can_id |= desc->data[0] << 3;
 		cf->can_id |= (desc->data[1] & 0xe0) >> 5;
-		cf->can_dlc = get_can_dlc(desc->data[1] & ICAN3_CAN_DLC_MASK);
+		cf->can_dlc = can_get_cc_len(desc->data[1] & ICAN3_CAN_DLC_MASK);
 		memcpy(cf->data, &desc->data[2], cf->can_dlc);
 	} else {
-		cf->can_dlc = get_can_dlc(desc->data[0] & ICAN3_CAN_DLC_MASK);
+		cf->can_dlc = can_get_cc_len(desc->data[0] & ICAN3_CAN_DLC_MASK);
 		if (desc->data[0] & ICAN3_EFF_RTR)
 			cf->can_id |= CAN_RTR_FLAG;
 
 		if (desc->data[0] & ICAN3_EFF) {
 			cf->can_id |= CAN_EFF_FLAG;
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 02c5795b7393..34cbb358731c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -457,11 +457,11 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	}
 
 	if (dlc & RX_BUF_FDF)
 		cf->len = can_dlc2len((dlc >> 16) & 0x0F);
 	else
-		cf->len = get_can_dlc((dlc >> 16) & 0x0F);
+		cf->len = can_get_cc_len((dlc >> 16) & 0x0F);
 
 	id = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_ID);
 	if (id & RX_BUF_XTD)
 		cf->can_id = (id & CAN_EFF_MASK) | CAN_EFF_FLAG;
 	else
diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index 640ba1b356ec..153650b8341a 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -310,11 +310,11 @@ static void mscan_get_rx_frame(struct net_device *dev, struct can_frame *frame)
 
 	frame->can_id |= can_id >> 1;
 	if (can_id & 1)
 		frame->can_id |= CAN_RTR_FLAG;
 
-	frame->can_dlc = get_can_dlc(in_8(&regs->rx.dlr) & 0xf);
+	frame->can_dlc = can_get_cc_len(in_8(&regs->rx.dlr) & 0xf);
 
 	if (!(frame->can_id & CAN_RTR_FLAG)) {
 		void __iomem *data = &regs->rx.dsr1_0;
 		u16 *payload = (u16 *)frame->data;
 
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 5c180d2f3c3c..86c610d7033f 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -681,11 +681,11 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 		}
 
 		if (id2 & PCH_ID2_DIR)
 			cf->can_id |= CAN_RTR_FLAG;
 
-		cf->can_dlc = get_can_dlc((ioread32(&priv->regs->
+		cf->can_dlc = can_get_cc_len((ioread32(&priv->regs->
 						    ifregs[0].mcont)) & 0xF);
 
 		for (i = 0; i < cf->can_dlc; i += 2) {
 			data_reg = ioread16(&priv->regs->ifregs[0].data[i / 2]);
 			cf->data[i] = data_reg;
@@ -713,11 +713,11 @@ static void pch_can_tx_complete(struct net_device *ndev, u32 int_stat)
 
 	can_get_echo_skb(ndev, int_stat - PCH_RX_OBJ_END - 1);
 	iowrite32(PCH_CMASK_RX_TX_GET | PCH_CMASK_CLRINTPND,
 		  &priv->regs->ifregs[1].cmask);
 	pch_can_rw_msg_obj(&priv->regs->ifregs[1].creq, int_stat);
-	dlc = get_can_dlc(ioread32(&priv->regs->ifregs[1].mcont) &
+	dlc = can_get_cc_len(ioread32(&priv->regs->ifregs[1].mcont) &
 			  PCH_IF_MCONT_DLC);
 	stats->tx_bytes += dlc;
 	stats->tx_packets++;
 	if (int_stat == PCH_TX_OBJ_END)
 		netif_wake_queue(ndev);
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index 40c33b8a5fda..dc94ea6821c3 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -257,11 +257,11 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 	u8 cf_len;
 
 	if (rx_msg_flags & PUCAN_MSG_EXT_DATA_LEN)
 		cf_len = can_dlc2len(get_canfd_dlc(pucan_msg_get_dlc(msg)));
 	else
-		cf_len = get_can_dlc(pucan_msg_get_dlc(msg));
+		cf_len = can_get_cc_len(pucan_msg_get_dlc(msg));
 
 	/* if this frame is an echo, */
 	if (rx_msg_flags & PUCAN_MSG_LOOPED_BACK) {
 		unsigned long flags;
 
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 48575900adb7..874cd0badf0f 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -657,11 +657,11 @@ static void rcar_can_rx_pkt(struct rcar_can_priv *priv)
 		cf->can_id = (data & CAN_EFF_MASK) | CAN_EFF_FLAG;
 	else
 		cf->can_id = (data >> RCAR_CAN_SID_SHIFT) & CAN_SFF_MASK;
 
 	dlc = readb(&priv->regs->mb[RCAR_CAN_RX_FIFO_MBX].dlc);
-	cf->can_dlc = get_can_dlc(dlc);
+	cf->can_dlc = can_get_cc_len(dlc);
 	if (data & RCAR_CAN_RTR) {
 		cf->can_id |= CAN_RTR_FLAG;
 	} else {
 		for (dlc = 0; dlc < cf->can_dlc; dlc++)
 			cf->data[dlc] =
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index de59dd6aad29..7fc885dbdf56 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1446,11 +1446,11 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 		if (sts & RCANFD_RFFDSTS_RFFDF)
 			cf->len = can_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
 		else
-			cf->len = get_can_dlc(RCANFD_RFPTR_RFDLC(dlc));
+			cf->len = can_get_cc_len(RCANFD_RFPTR_RFDLC(dlc));
 
 		if (sts & RCANFD_RFFDSTS_RFESI) {
 			cf->flags |= CANFD_ESI;
 			netdev_dbg(priv->ndev, "ESI Error\n");
 		}
@@ -1462,11 +1462,11 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 				cf->flags |= CANFD_BRS;
 
 			rcar_canfd_get_data(priv, cf, RCANFD_F_RFDF(ridx, 0));
 		}
 	} else {
-		cf->len = get_can_dlc(RCANFD_RFPTR_RFDLC(dlc));
+		cf->len = can_get_cc_len(RCANFD_RFPTR_RFDLC(dlc));
 		if (id & RCANFD_RFID_RFRTR)
 			cf->can_id |= CAN_RTR_FLAG;
 		else
 			rcar_canfd_get_data(priv, cf, RCANFD_C_RFDF(ridx, 0));
 	}
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 9f107798f904..ddb09172c1af 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -365,11 +365,11 @@ static void sja1000_rx(struct net_device *dev)
 		dreg = SJA1000_SFF_BUF;
 		id = (priv->read_reg(priv, SJA1000_ID1) << 3)
 		    | (priv->read_reg(priv, SJA1000_ID2) >> 5);
 	}
 
-	cf->can_dlc = get_can_dlc(fi & 0x0F);
+	cf->can_dlc = can_get_cc_len(fi & 0x0F);
 	if (fi & SJA1000_FI_RTR) {
 		id |= CAN_RTR_FLAG;
 	} else {
 		for (i = 0; i < cf->can_dlc; i++)
 			cf->data[i] = priv->read_reg(priv, dreg++);
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index 9d2faaa39ce4..5cc175fd7067 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -259,11 +259,11 @@ static int softing_handle_1(struct softing *card)
 		}
 
 	} else {
 		if (cmd & CMD_RTR)
 			msg.can_id |= CAN_RTR_FLAG;
-		msg.can_dlc = get_can_dlc(*ptr++);
+		msg.can_dlc = can_get_cc_len(*ptr++);
 		if (cmd & CMD_XTD) {
 			msg.can_id |= CAN_EFF_FLAG;
 			msg.can_id |= le32_to_cpup((void *)ptr);
 			ptr += 4;
 		} else {
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 73d48c3b8ded..b182951dba52 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -339,11 +339,11 @@ static void hi3110_hw_rx(struct spi_device *spi)
 			(buf[HI3110_FIFO_WOTIME_ID_OFF] << 3) |
 			((buf[HI3110_FIFO_WOTIME_ID_OFF + 1] & 0xE0) >> 5);
 	}
 
 	/* Data length */
-	frame->can_dlc = get_can_dlc(buf[HI3110_FIFO_WOTIME_DLC_OFF] & 0x0F);
+	frame->can_dlc = can_get_cc_len(buf[HI3110_FIFO_WOTIME_DLC_OFF] & 0x0F);
 
 	if (buf[HI3110_FIFO_WOTIME_ID_OFF + 3] & HI3110_FIFO_WOTIME_ID_RTR)
 		frame->can_id |= CAN_RTR_FLAG;
 	else
 		memcpy(frame->data, buf + HI3110_FIFO_WOTIME_DAT_OFF,
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 22d814ae4edc..5764f88f2347 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -662,11 +662,11 @@ static void mcp251x_hw_rx_frame(struct spi_device *spi, u8 *buf,
 		int i, len;
 
 		for (i = 1; i < RXBDAT_OFF; i++)
 			buf[i] = mcp251x_read_reg(spi, RXBCTRL(buf_idx) + i);
 
-		len = get_can_dlc(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
+		len = can_get_cc_len(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
 		for (; i < (RXBDAT_OFF + len); i++)
 			buf[i] = mcp251x_read_reg(spi, RXBCTRL(buf_idx) + i);
 	} else {
 		priv->spi_tx_buf[RXBCTRL_OFF] = INSTRUCTION_READ_RXB(buf_idx);
 		if (spi->controller->flags & SPI_CONTROLLER_HALF_DUPLEX) {
@@ -718,11 +718,11 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
 			(buf[RXBSIDL_OFF] >> RXBSIDL_SHIFT);
 		if (buf[RXBSIDL_OFF] & RXBSIDL_SRR)
 			frame->can_id |= CAN_RTR_FLAG;
 	}
 	/* Data length */
-	frame->can_dlc = get_can_dlc(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
+	frame->can_dlc = can_get_cc_len(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
 	memcpy(frame->data, buf + RXBDAT_OFF, frame->can_dlc);
 
 	priv->net->stats.rx_packets++;
 	priv->net->stats.rx_bytes += frame->can_dlc;
 
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 9c215f7c5f81..ae9e9bafba23 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1408,11 +1408,11 @@ mcp251xfd_hw_rx_obj_to_skb(const struct mcp251xfd_priv *priv,
 		cfd->len = can_dlc2len(get_canfd_dlc(dlc));
 	} else {
 		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_RTR)
 			cfd->can_id |= CAN_RTR_FLAG;
 
-		cfd->len = get_can_dlc(FIELD_GET(MCP251XFD_OBJ_FLAGS_DLC,
+		cfd->len = can_get_cc_len(FIELD_GET(MCP251XFD_OBJ_FLAGS_DLC,
 						 hw_rx_obj->flags));
 	}
 
 	memcpy(cfd->data, hw_rx_obj->data, cfd->len);
 }
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index e2c6cf4b2228..28cc9e0f3982 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -473,11 +473,11 @@ static void sun4i_can_rx(struct net_device *dev)
 	skb = alloc_can_skb(dev, &cf);
 	if (!skb)
 		return;
 
 	fi = readl(priv->base + SUN4I_REG_BUF0_ADDR);
-	cf->can_dlc = get_can_dlc(fi & 0x0F);
+	cf->can_dlc = can_get_cc_len(fi & 0x0F);
 	if (fi & SUN4I_MSG_EFF_FLAG) {
 		dreg = SUN4I_REG_BUF5_ADDR;
 		id = (readl(priv->base + SUN4I_REG_BUF1_ADDR) << 21) |
 		     (readl(priv->base + SUN4I_REG_BUF2_ADDR) << 13) |
 		     (readl(priv->base + SUN4I_REG_BUF3_ADDR) << 5)  |
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 9913f5458279..02e4260fd8f2 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -564,11 +564,11 @@ static struct sk_buff *ti_hecc_mailbox_read(struct can_rx_offload *offload,
 		cf->can_id = (data >> 18) & CAN_SFF_MASK;
 
 	data = hecc_read_mbx(priv, mbxno, HECC_CANMCF);
 	if (data & HECC_CANMCF_RTR)
 		cf->can_id |= CAN_RTR_FLAG;
-	cf->can_dlc = get_can_dlc(data & 0xF);
+	cf->can_dlc = can_get_cc_len(data & 0xF);
 
 	data = hecc_read_mbx(priv, mbxno, HECC_CANMDL);
 	*(__be32 *)(cf->data) = cpu_to_be32(data);
 	if (cf->can_dlc > 4) {
 		data = hecc_read_mbx(priv, mbxno, HECC_CANMDH);
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 4f52810bebf8..0ccf8c0f7db5 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -304,11 +304,11 @@ static void ems_usb_rx_can_msg(struct ems_usb *dev, struct ems_cpc_msg *msg)
 	skb = alloc_can_skb(dev->netdev, &cf);
 	if (skb == NULL)
 		return;
 
 	cf->can_id = le32_to_cpu(msg->msg.can_msg.id);
-	cf->can_dlc = get_can_dlc(msg->msg.can_msg.length & 0xF);
+	cf->can_dlc = can_get_cc_len(msg->msg.can_msg.length & 0xF);
 
 	if (msg->type == CPC_MSG_TYPE_EXT_CAN_FRAME ||
 	    msg->type == CPC_MSG_TYPE_EXT_RTR_FRAME)
 		cf->can_id |= CAN_EFF_FLAG;
 
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index b5d7ed21d7d9..8752bda36b46 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -319,11 +319,11 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
 			stats->rx_dropped++;
 			return;
 		}
 
 		cf->can_id = id & ESD_IDMASK;
-		cf->can_dlc = get_can_dlc(msg->msg.rx.dlc & ~ESD_RTR);
+		cf->can_dlc = can_get_cc_len(msg->msg.rx.dlc & ~ESD_RTR);
 
 		if (id & ESD_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
 		if (msg->msg.rx.dlc & ESD_RTR) {
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 3005157059ca..07fe84968391 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -329,11 +329,11 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		if (!skb)
 			return;
 
 		cf->can_id = hf->can_id;
 
-		cf->can_dlc = get_can_dlc(hf->can_dlc);
+		cf->can_dlc = can_get_cc_len(hf->can_dlc);
 		memcpy(cf->data, hf->data, 8);
 
 		/* ERROR frames tell us information about the controller */
 		if (hf->can_id & CAN_ERR_FLAG)
 			gs_update_state(dev, cf);
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 7ab87a758754..1626f73337ab 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1178,11 +1178,11 @@ static void kvaser_usb_hydra_rx_msg_std(const struct kvaser_usb *dev,
 	}
 
 	if (flags & KVASER_USB_HYDRA_CF_FLAG_OVERRUN)
 		kvaser_usb_can_rx_over_error(priv->netdev);
 
-	cf->can_dlc = get_can_dlc(cmd->rx_can.dlc);
+	cf->can_dlc = can_get_cc_len(cmd->rx_can.dlc);
 
 	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME)
 		cf->can_id |= CAN_RTR_FLAG;
 	else
 		memcpy(cf->data, cmd->rx_can.data, cf->can_dlc);
@@ -1255,11 +1255,11 @@ static void kvaser_usb_hydra_rx_msg_ext(const struct kvaser_usb *dev,
 		if (flags & KVASER_USB_HYDRA_CF_FLAG_BRS)
 			cf->flags |= CANFD_BRS;
 		if (flags & KVASER_USB_HYDRA_CF_FLAG_ESI)
 			cf->flags |= CANFD_ESI;
 	} else {
-		cf->len = get_can_dlc(dlc);
+		cf->len = can_get_cc_len(dlc);
 	}
 
 	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME)
 		cf->can_id |= CAN_RTR_FLAG;
 	else
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 1b9957f12459..dcc5aa022e8f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -976,11 +976,11 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 		if (cf->can_id & KVASER_EXTENDED_FRAME)
 			cf->can_id &= CAN_EFF_MASK | CAN_EFF_FLAG;
 		else
 			cf->can_id &= CAN_SFF_MASK;
 
-		cf->can_dlc = get_can_dlc(cmd->u.leaf.log_message.dlc);
+		cf->can_dlc = can_get_cc_len(cmd->u.leaf.log_message.dlc);
 
 		if (cmd->u.leaf.log_message.flags & MSG_FLAG_REMOTE_FRAME)
 			cf->can_id |= CAN_RTR_FLAG;
 		else
 			memcpy(cf->data, &cmd->u.leaf.log_message.data,
@@ -994,11 +994,11 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 				      ((rx_data[3] & 0xff) << 6) |
 				      (rx_data[4] & 0x3f);
 			cf->can_id |= CAN_EFF_FLAG;
 		}
 
-		cf->can_dlc = get_can_dlc(rx_data[5]);
+		cf->can_dlc = can_get_cc_len(rx_data[5]);
 
 		if (cmd->u.rx_can_header.flag & MSG_FLAG_REMOTE_FRAME)
 			cf->can_id |= CAN_RTR_FLAG;
 		else
 			memcpy(cf->data, &rx_data[6], cf->can_dlc);
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 5857b37dcd96..14352718b004 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -449,11 +449,11 @@ static void mcba_usb_process_can(struct mcba_priv *priv,
 	}
 
 	if (msg->dlc & MCBA_DLC_RTR_MASK)
 		cf->can_id |= CAN_RTR_FLAG;
 
-	cf->can_dlc = get_can_dlc(msg->dlc & MCBA_DLC_MASK);
+	cf->can_dlc = can_get_cc_len(msg->dlc & MCBA_DLC_MASK);
 
 	memcpy(cf->data, msg->data, cf->can_dlc);
 
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 63bd2ed96697..5df74533ba4d 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -732,11 +732,11 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		mc->ptr += 2;
 
 		cf->can_id = le16_to_cpu(tmp16) >> 5;
 	}
 
-	cf->can_dlc = get_can_dlc(rec_len);
+	cf->can_dlc = can_get_cc_len(rec_len);
 
 	/* Only first packet timestamp is a word */
 	if (pcan_usb_decode_ts(mc, !mc->rec_ts_idx))
 		goto decode_failed;
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index d29d20525588..cf32bcfabba3 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -497,11 +497,11 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 		/* CAN 2.0 frame case */
 		skb = alloc_can_skb(netdev, (struct can_frame **)&cfd);
 		if (!skb)
 			return -ENOMEM;
 
-		cfd->len = get_can_dlc(pucan_msg_get_dlc(rm));
+		cfd->len = can_get_cc_len(pucan_msg_get_dlc(rm));
 	}
 
 	cfd->can_id = le32_to_cpu(rm->can_id);
 
 	if (rx_msg_flags & PUCAN_MSG_EXT_ID)
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index dc5290b36598..ea11a3f0392b 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -301,16 +301,16 @@ struct ucan_priv {
 	spinlock_t context_lock;
 	unsigned int available_tx_urbs;
 	struct ucan_urb_context *context_array;
 };
 
-static u8 ucan_get_can_dlc(struct ucan_can_msg *msg, u16 len)
+static u8 ucan_can_get_cc_len(struct ucan_can_msg *msg, u16 len)
 {
 	if (le32_to_cpu(msg->id) & CAN_RTR_FLAG)
-		return get_can_dlc(msg->dlc);
+		return can_get_cc_len(msg->dlc);
 	else
-		return get_can_dlc(len - (UCAN_IN_HDR_SIZE + sizeof(msg->id)));
+		return can_get_cc_len(len - (UCAN_IN_HDR_SIZE + sizeof(msg->id)));
 }
 
 static void ucan_release_context_array(struct ucan_priv *up)
 {
 	if (!up->context_array)
@@ -612,11 +612,11 @@ static void ucan_rx_can_msg(struct ucan_priv *up, struct ucan_message_in *m)
 
 	/* fill the can frame */
 	cf->can_id = canid;
 
 	/* compute DLC taking RTR_FLAG into account */
-	cf->can_dlc = ucan_get_can_dlc(&m->msg.can_msg, len);
+	cf->can_dlc = ucan_can_get_cc_len(&m->msg.can_msg, len);
 
 	/* copy the payload of non RTR frames */
 	if (!(cf->can_id & CAN_RTR_FLAG) || (cf->can_id & CAN_ERR_FLAG))
 		memcpy(cf->data, m->msg.can_msg.data, cf->can_dlc);
 
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 62749c67c959..9d1597ad7ba4 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -468,11 +468,11 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
 		skb = alloc_can_skb(priv->netdev, &cf);
 		if (!skb)
 			return;
 
 		cf->can_id = be32_to_cpu(msg->id);
-		cf->can_dlc = get_can_dlc(msg->dlc & 0xF);
+		cf->can_dlc = can_get_cc_len(msg->dlc & 0xF);
 
 		if (msg->flags & USB_8DEV_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
 		if (msg->flags & USB_8DEV_RTR)
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 48d746e18f30..1740fbc371c4 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -757,11 +757,11 @@ static int xcan_rx(struct net_device *ndev, int frame_base)
 	id_xcan = priv->read_reg(priv, XCAN_FRAME_ID_OFFSET(frame_base));
 	dlc = priv->read_reg(priv, XCAN_FRAME_DLC_OFFSET(frame_base)) >>
 				   XCAN_DLCR_DLC_SHIFT;
 
 	/* Change Xilinx CAN data length format to socketCAN data format */
-	cf->can_dlc = get_can_dlc(dlc);
+	cf->can_dlc = can_get_cc_len(dlc);
 
 	/* Change Xilinx CAN ID format to socketCAN ID format */
 	if (id_xcan & XCAN_IDR_IDE_MASK) {
 		/* The received frame is an Extended format frame */
 		cf->can_id = (id_xcan & XCAN_IDR_ID1_MASK) >> 3;
@@ -833,11 +833,11 @@ static int xcanfd_rx(struct net_device *ndev, int frame_base)
 	 */
 	if (dlc & XCAN_DLCR_EDL_MASK)
 		cf->len = can_dlc2len((dlc & XCAN_DLCR_DLC_MASK) >>
 				  XCAN_DLCR_DLC_SHIFT);
 	else
-		cf->len = get_can_dlc((dlc & XCAN_DLCR_DLC_MASK) >>
+		cf->len = can_get_cc_len((dlc & XCAN_DLCR_DLC_MASK) >>
 					  XCAN_DLCR_DLC_SHIFT);
 
 	/* Change Xilinx CAN ID format to socketCAN ID format */
 	if (id_xcan & XCAN_IDR_IDE_MASK) {
 		/* The received frame is an Extended format frame */
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 41ff31795320..92463cda7ac8 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -96,18 +96,18 @@ static inline unsigned int can_bit_time(const struct can_bittiming *bt)
 {
 	return CAN_SYNC_SEG + bt->prop_seg + bt->phase_seg1 + bt->phase_seg2;
 }
 
 /*
- * get_can_dlc(value) - helper macro to cast a given data length code (dlc)
- * to u8 and ensure the dlc value to be max. 8 bytes.
+ * can_get_cc_len(value) - convert a given data length code (dlc) of a
+ * Classical CAN frame into a valid data length of max. 8 bytes.
  *
  * To be used in the CAN netdriver receive path to ensure conformance with
  * ISO 11898-1 Chapter 8.4.2.3 (DLC field)
  */
-#define get_can_dlc(i)		(min_t(u8, (i), CAN_MAX_DLC))
-#define get_canfd_dlc(i)	(min_t(u8, (i), CANFD_MAX_DLC))
+#define can_get_cc_len(dlc)	(min_t(u8, (dlc), CAN_MAX_DLEN))
+#define get_canfd_dlc(dlc)	(min_t(u8, (dlc), CANFD_MAX_DLC))
 
 /* Check for outgoing skbs that have not been created by the CAN subsystem */
 static inline bool can_skb_headroom_valid(struct net_device *dev,
 					  struct sk_buff *skb)
 {
-- 
2.28.0

