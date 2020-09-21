Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7244C272600
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgIUNqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgIUNqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55016C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:05 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8p-0003ED-D6; Mon, 21 Sep 2020 15:46:03 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 05/38] can: drivers: fix spelling mistakes
Date:   Mon, 21 Sep 2020 15:45:24 +0200
Message-Id: <20200921134557.2251383-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes spelling erros found by "codespell" in the
drivers/net/can subtree.

Link: https://lore.kernel.org/r/20200915223527.1417033-6-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/at91_can.c                  | 8 ++++----
 drivers/net/can/cc770/cc770.c               | 2 +-
 drivers/net/can/cc770/cc770.h               | 2 +-
 drivers/net/can/grcan.c                     | 2 +-
 drivers/net/can/m_can/Kconfig               | 2 +-
 drivers/net/can/pch_can.c                   | 4 ++--
 drivers/net/can/sja1000/peak_pci.c          | 2 +-
 drivers/net/can/sja1000/peak_pcmcia.c       | 2 +-
 drivers/net/can/softing/Kconfig             | 4 ++--
 drivers/net/can/softing/softing_fw.c        | 8 ++++----
 drivers/net/can/softing/softing_main.c      | 8 ++++----
 drivers/net/can/softing/softing_platform.h  | 2 +-
 drivers/net/can/ti_hecc.c                   | 2 +-
 drivers/net/can/usb/Kconfig                 | 2 +-
 drivers/net/can/usb/gs_usb.c                | 4 ++--
 drivers/net/can/usb/mcba_usb.c              | 2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c  | 4 ++--
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c | 2 +-
 drivers/net/can/usb/ucan.c                  | 4 ++--
 drivers/net/can/usb/usb_8dev.c              | 4 ++--
 drivers/net/can/xilinx_can.c                | 2 +-
 21 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 38e9f80ed1ef..c14de95d2ca7 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -643,7 +643,7 @@ static void at91_read_msg(struct net_device *dev, unsigned int mb)
  *
  * The first message goes into mb nr. 1 and issues an interrupt. All
  * rx ints are disabled in the interrupt handler and a napi poll is
- * scheduled. We read the mailbox, but do _not_ reenable the mb (to
+ * scheduled. We read the mailbox, but do _not_ re-enable the mb (to
  * receive another message).
  *
  *    lower mbxs      upper
@@ -661,13 +661,13 @@ static void at91_read_msg(struct net_device *dev, unsigned int mb)
  *
  * The variable priv->rx_next points to the next mailbox to read a
  * message from. As long we're in the lower mailboxes we just read the
- * mailbox but not reenable it.
+ * mailbox but not re-enable it.
  *
- * With completion of the last of the lower mailboxes, we reenable the
+ * With completion of the last of the lower mailboxes, we re-enable the
  * whole first group, but continue to look for filled mailboxes in the
  * upper mailboxes. Imagine the second group like overflow mailboxes,
  * which takes CAN messages if the lower goup is full. While in the
- * upper group we reenable the mailbox right after reading it. Giving
+ * upper group we re-enable the mailbox right after reading it. Giving
  * the chip more room to store messages.
  *
  * After finishing we look again in the lower group if we've still
diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index 7cdc232cbfea..07e2b8df5153 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -538,7 +538,7 @@ static int cc770_err(struct net_device *dev, u8 status)
 			priv->can.can_stats.error_warning++;
 		}
 	} else {
-		/* Back to error avtive */
+		/* Back to error active */
 		cf->can_id |= CAN_ERR_PROT;
 		cf->data[2] = CAN_ERR_PROT_ACTIVE;
 		priv->can.state = CAN_STATE_ERROR_ACTIVE;
diff --git a/drivers/net/can/cc770/cc770.h b/drivers/net/can/cc770/cc770.h
index 948541491ab5..0628fd9e1980 100644
--- a/drivers/net/can/cc770/cc770.h
+++ b/drivers/net/can/cc770/cc770.h
@@ -184,7 +184,7 @@ struct cc770_priv {
 	u8 control_normal_mode;	/* Control register for normal mode */
 	u8 cpu_interface;	/* CPU interface register */
 	u8 clkout;		/* Clock out register */
-	u8 bus_config;		/* Bus conffiguration register */
+	u8 bus_config;		/* Bus configuration register */
 
 	struct sk_buff *tx_skb;
 };
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 5d1f15843181..39802f107eb1 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1243,7 +1243,7 @@ static int grcan_poll(struct napi_struct *napi, int budget)
 	int rx_budget = budget / 2;
 	int tx_budget = budget - rx_budget;
 
-	/* Half of the budget for receiveing messages */
+	/* Half of the budget for receiving messages */
 	rx_work_done = grcan_receive(dev, rx_budget);
 
 	/* Half of the budget for transmitting messages as that can trigger echo
diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index d9216147ca93..48be627c85c2 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -20,5 +20,5 @@ config CAN_M_CAN_TCAN4X5X
 	tristate "TCAN4X5X M_CAN device"
 	help
 	  Say Y here if you want support for Texas Instruments TCAN4x5x
-	  M_CAN controller.  This device is a peripherial device that uses the
+	  M_CAN controller.  This device is a peripheral device that uses the
 	  SPI bus for communication.
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index db41dddd5771..af4fbd8f9077 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -461,7 +461,7 @@ static void pch_can_int_clr(struct pch_can_priv *priv, u32 mask)
 			       PCH_ID2_DIR | (0x7ff << 2));
 		iowrite32(0x0, &priv->regs->ifregs[1].id1);
 
-		/* Claring NewDat, TxRqst & IntPnd */
+		/* Clearing NewDat, TxRqst & IntPnd */
 		pch_can_bit_clear(&priv->regs->ifregs[1].mcont,
 				  PCH_IF_MCONT_NEWDAT | PCH_IF_MCONT_INTPND |
 				  PCH_IF_MCONT_TXRQXT);
@@ -834,7 +834,7 @@ static int pch_can_open(struct net_device *ndev)
 	struct pch_can_priv *priv = netdev_priv(ndev);
 	int retval;
 
-	/* Regstering the interrupt. */
+	/* Registering the interrupt. */
 	retval = request_irq(priv->dev->irq, pch_can_interrupt, IRQF_SHARED,
 			     ndev->name, ndev);
 	if (retval) {
diff --git a/drivers/net/can/sja1000/peak_pci.c b/drivers/net/can/sja1000/peak_pci.c
index 8c0244f51059..4713921bd511 100644
--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -97,7 +97,7 @@ MODULE_DEVICE_TABLE(pci, peak_pci_tbl);
 /* GPIOICR byte access offsets */
 #define PITA_GPOUT		0x18	/* GPx output value */
 #define PITA_GPIN		0x19	/* GPx input value */
-#define PITA_GPOEN		0x1A	/* configure GPx as ouput pin */
+#define PITA_GPOEN		0x1A	/* configure GPx as output pin */
 
 /* I2C GP bits */
 #define PITA_GPIN_SCL		0x01	/* Serial Clock Line */
diff --git a/drivers/net/can/sja1000/peak_pcmcia.c b/drivers/net/can/sja1000/peak_pcmcia.c
index 5e0d5e8101c8..cf951a783078 100644
--- a/drivers/net/can/sja1000/peak_pcmcia.c
+++ b/drivers/net/can/sja1000/peak_pcmcia.c
@@ -671,7 +671,7 @@ static int pcan_probe(struct pcmcia_device *pdev)
 	card->fw_major = pcan_read_reg(card, PCC_FW_MAJOR);
 	card->fw_minor = pcan_read_reg(card, PCC_FW_MINOR);
 
-	/* display board name and firware version */
+	/* display board name and firmware version */
 	dev_info(&pdev->dev, "PEAK-System pcmcia card %s fw %d.%d\n",
 		pdev->prod_id[1] ? pdev->prod_id[1] : "PCAN-PC Card",
 		card->fw_major, card->fw_minor);
diff --git a/drivers/net/can/softing/Kconfig b/drivers/net/can/softing/Kconfig
index 16b9eec63490..9edc73b13014 100644
--- a/drivers/net/can/softing/Kconfig
+++ b/drivers/net/can/softing/Kconfig
@@ -5,14 +5,14 @@ config CAN_SOFTING
 	help
 	  Support for CAN cards from Softing Gmbh & some cards
 	  from Vector Gmbh.
-	  Softing Gmbh CAN cards come with 1 or 2 physical busses.
+	  Softing Gmbh CAN cards come with 1 or 2 physical buses.
 	  Those cards typically use Dual Port RAM to communicate
 	  with the host CPU. The interface is then identical for PCI
 	  and PCMCIA cards. This driver operates on a platform device,
 	  which has been created by softing_cs or softing_pci driver.
 	  Warning:
 	  The API of the card does not allow fine control per bus, but
-	  controls the 2 busses on the card together.
+	  controls the 2 buses on the card together.
 	  As such, some actions (start/stop/busoff recovery) on 1 bus
 	  must bring down the other bus too temporarily.
 
diff --git a/drivers/net/can/softing/softing_fw.c b/drivers/net/can/softing/softing_fw.c
index 8f44fdd8804b..ccd649a8e37b 100644
--- a/drivers/net/can/softing/softing_fw.c
+++ b/drivers/net/can/softing/softing_fw.c
@@ -273,7 +273,7 @@ int softing_load_app_fw(const char *file, struct softing *card)
 			goto failed;
 		}
 
-		/* regualar data */
+		/* regular data */
 		for (sum = 0, j = 0; j < len; ++j)
 			sum += dat[j];
 		/* work in 16bit (target) */
@@ -474,14 +474,14 @@ int softing_startstop(struct net_device *dev, int up)
 	if (ret)
 		goto failed;
 	if (!bus_bitmask_start)
-		/* no busses to be brought up */
+		/* no buses to be brought up */
 		goto card_done;
 
 	if ((bus_bitmask_start & 1) && (bus_bitmask_start & 2)
 			&& (softing_error_reporting(card->net[0])
 				!= softing_error_reporting(card->net[1]))) {
 		dev_alert(&card->pdev->dev,
-				"err_reporting flag differs for busses\n");
+				"err_reporting flag differs for buses\n");
 		goto invalid;
 	}
 	error_reporting = 0;
@@ -635,7 +635,7 @@ int softing_startstop(struct net_device *dev, int up)
 		priv->can.state = CAN_STATE_ERROR_ACTIVE;
 		open_candev(netdev);
 		if (dev != netdev) {
-			/* notify other busses on the restart */
+			/* notify other buses on the restart */
 			softing_netdev_rx(netdev, &msg, 0);
 			++priv->can.can_stats.restarts;
 		}
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index d1ddf763b188..11b0f3bcfe80 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -170,8 +170,8 @@ static int softing_handle_1(struct softing *card)
 		msg.can_dlc = CAN_ERR_DLC;
 		msg.data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 		/*
-		 * service to all busses, we don't know which it was applicable
-		 * but only service busses that are online
+		 * service to all buses, we don't know which it was applicable
+		 * but only service buses that are online
 		 */
 		for (j = 0; j < ARRAY_SIZE(card->net); ++j) {
 			netdev = card->net[j];
@@ -339,7 +339,7 @@ static irqreturn_t softing_irq_thread(int irq, void *dev_id)
 			continue;
 		priv = netdev_priv(netdev);
 		if (!canif_is_active(netdev))
-			/* it makes no sense to wake dead busses */
+			/* it makes no sense to wake dead buses */
 			continue;
 		if (priv->tx.pending >= TX_ECHO_SKB_MAX)
 			continue;
@@ -374,7 +374,7 @@ static irqreturn_t softing_irq_v1(int irq, void *dev_id)
 }
 
 /*
- * netdev/candev inter-operability
+ * netdev/candev interoperability
  */
 static int softing_netdev_open(struct net_device *ndev)
 {
diff --git a/drivers/net/can/softing/softing_platform.h b/drivers/net/can/softing/softing_platform.h
index 68a161547644..cd8d7904c5f0 100644
--- a/drivers/net/can/softing/softing_platform.h
+++ b/drivers/net/can/softing/softing_platform.h
@@ -19,7 +19,7 @@ struct softing_platform_data {
 	 * 16bit, shared interrupt
 	 */
 	int generation;
-	int nbus; /* # busses on device */
+	int nbus; /* # buses on device */
 	unsigned int freq; /* operating frequency in Hz */
 	unsigned int max_brp;
 	unsigned int max_sjw;
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 94b1491b569f..fc76f7ad735a 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -454,7 +454,7 @@ static int ti_hecc_get_berr_counter(const struct net_device *ndev,
 /* ti_hecc_xmit: HECC Transmit
  *
  * The transmit mailboxes start from 0 to HECC_MAX_TX_MBOX. In HECC the
- * priority of the mailbox for tranmission is dependent upon priority setting
+ * priority of the mailbox for transmission is dependent upon priority setting
  * field in mailbox registers. The mailbox with highest value in priority field
  * is transmitted first. Only when two mailboxes have the same value in
  * priority field the highest numbered mailbox is transmitted first.
diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index 77fa830fe7dd..bcb331b0c958 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -90,7 +90,7 @@ config CAN_PEAK_USB
 	tristate "PEAK PCAN-USB/USB Pro interfaces for CAN 2.0b/CAN-FD"
 	help
 	  This driver supports the PEAK-System Technik USB adapters that enable
-	  access to the CAN bus, with repect to the CAN 2.0b and/or CAN-FD
+	  access to the CAN bus, with respect to the CAN 2.0b and/or CAN-FD
 	  standards, that is:
 
 	  PCAN-USB             single CAN 2.0b channel USB adapter
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index a4b4b742c80c..3005157059ca 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -828,7 +828,7 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 
 	netdev->flags |= IFF_ECHO; /* we support full roundtrip echo */
 
-	/* dev settup */
+	/* dev setup */
 	strcpy(dev->bt_const.name, "gs_usb");
 	dev->bt_const.tseg1_min = bt_const->tseg1_min;
 	dev->bt_const.tseg1_max = bt_const->tseg1_max;
@@ -852,7 +852,7 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 		dev->tx_context[rc].echo_id = GS_MAX_TX_URBS;
 	}
 
-	/* can settup */
+	/* can setup */
 	dev->can.state = CAN_STATE_STOPPED;
 	dev->can.clock.freq = bt_const->fclk_can;
 	dev->can.bittiming_const = &dev->bt_const;
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 21faa2ec4632..eb6fb7435061 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -28,7 +28,7 @@
 #define MCBA_CTX_FREE MCBA_MAX_TX_URBS
 
 /* RX buffer must be bigger than msg size since at the
- * beggining USB messages are stacked.
+ * beginning USB messages are stacked.
  */
 #define MCBA_USB_RX_BUFF_SIZE 64
 #define MCBA_USB_TX_BUFF_SIZE (sizeof(struct mcba_usb_msg))
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 47cc1ff5b88e..ab63fd9eb982 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -35,7 +35,7 @@ MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB Pro FD adapter");
 #define PCAN_UFD_RX_BUFFER_SIZE		2048
 #define PCAN_UFD_TX_BUFFER_SIZE		512
 
-/* read some versions info from the hw devcie */
+/* read some versions info from the hw device */
 struct __packed pcan_ufd_fw_info {
 	__le16	size_of;	/* sizeof this */
 	__le16	type;		/* type of this structure */
@@ -796,7 +796,7 @@ static int pcan_usb_fd_start(struct peak_usb_device *dev)
 	return err;
 }
 
-/* socket callback used to copy berr counters values receieved through USB */
+/* socket callback used to copy berr counters values received through USB */
 static int pcan_usb_fd_get_berr_counter(const struct net_device *netdev,
 					struct can_berr_counter *bec)
 {
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index 1689ab387612..f85b560e05db 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -973,7 +973,7 @@ int pcan_usb_pro_probe(struct usb_interface *intf)
 		struct usb_endpoint_descriptor *ep = &if_desc->endpoint[i].desc;
 
 		/*
-		 * below is the list of valid ep addreses. Any other ep address
+		 * below is the list of valid ep addresses. Any other ep address
 		 * is considered as not-CAN interface address => no dev created
 		 */
 		switch (ep->bEndpointAddress) {
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 81e942f713e6..dc5290b36598 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1445,7 +1445,7 @@ static int ucan_probe(struct usb_interface *intf,
 
 	/* request the device information and store it in ctl_msg_buffer
 	 *
-	 * note: ucan_ctrl_command_* wrappers connot be used yet
+	 * note: ucan_ctrl_command_* wrappers cannot be used yet
 	 * because `up` is initialised in Stage 3
 	 */
 	ret = usb_control_msg(udev,
@@ -1494,7 +1494,7 @@ static int ucan_probe(struct usb_interface *intf,
 
 	up = netdev_priv(netdev);
 
-	/* initialze data */
+	/* initialize data */
 	up->udev = udev;
 	up->intf = intf;
 	up->netdev = netdev;
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 8fa224b28218..62749c67c959 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -88,7 +88,7 @@ enum usb_8dev_cmd {
 
 /* status */
 #define USB_8DEV_STATUSMSG_OK		0x00  /* Normal condition. */
-#define USB_8DEV_STATUSMSG_OVERRUN	0x01  /* Overrun occured when sending */
+#define USB_8DEV_STATUSMSG_OVERRUN	0x01  /* Overrun occurred when sending */
 #define USB_8DEV_STATUSMSG_BUSLIGHT	0x02  /* Error counter has reached 96 */
 #define USB_8DEV_STATUSMSG_BUSHEAVY	0x03  /* Error count. has reached 128 */
 #define USB_8DEV_STATUSMSG_BUSOFF	0x04  /* Device is in BUSOFF */
@@ -165,7 +165,7 @@ struct __packed usb_8dev_rx_msg {
 /* command frame */
 struct __packed usb_8dev_cmd_msg {
 	u8 begin;
-	u8 channel;	/* unkown - always 0 */
+	u8 channel;	/* unknown - always 0 */
 	u8 command;	/* command to execute */
 	u8 opt1;	/* optional parameter / return value */
 	u8 opt2;	/* optional parameter 2 */
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index c1dbab8c896d..7ae268468d2c 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1308,7 +1308,7 @@ static void xcan_tx_interrupt(struct net_device *ndev, u32 isr)
 /**
  * xcan_interrupt - CAN Isr
  * @irq:	irq number
- * @dev_id:	device id poniter
+ * @dev_id:	device id pointer
  *
  * This is the xilinx CAN Isr. It checks for the type of interrupt
  * and invokes the corresponding ISR.
-- 
2.28.0

