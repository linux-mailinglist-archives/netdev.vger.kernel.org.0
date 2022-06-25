Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A3855A9AA
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbiFYMGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbiFYMGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4941402D
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YS-0002eh-GF
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B49379F275
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:05:15 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D5E239F24A;
        Sat, 25 Jun 2022 12:05:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0c6aa1a2;
        Sat, 25 Jun 2022 12:03:37 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Frank Jungclaus <frank.jungclaus@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 20/22] can/esd_usb: Rename all terms USB2 to USB
Date:   Sat, 25 Jun 2022 14:03:33 +0200
Message-Id: <20220625120335.324697-21-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220625120335.324697-1-mkl@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Jungclaus <frank.jungclaus@esd.eu>

Each occurrence of the term "usb2" within variables, function names,
comments, etc. is changed to "usb" where it is shared for all
esd CAN/USB devices.

Link: https://lore.kernel.org/all/20220624190517.2299701-4-frank.jungclaus@esd.eu
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/esd_usb.c | 213 +++++++++++++++++-----------------
 1 file changed, 109 insertions(+), 104 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 286daaaea0b8..befd570018d7 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -18,16 +18,19 @@ MODULE_AUTHOR("Matthias Fuchs <matthias.fuchs@esd.eu>");
 MODULE_DESCRIPTION("CAN driver for esd CAN-USB/2 and CAN-USB/Micro interfaces");
 MODULE_LICENSE("GPL v2");
 
-/* Define these values to match your devices */
+/* USB vendor and product ID */
 #define USB_ESDGMBH_VENDOR_ID	0x0ab4
 #define USB_CANUSB2_PRODUCT_ID	0x0010
 #define USB_CANUSBM_PRODUCT_ID	0x0011
 
+/* CAN controller clock frequencies */
 #define ESD_USB2_CAN_CLOCK	60000000
 #define ESD_USBM_CAN_CLOCK	36000000
-#define ESD_USB2_MAX_NETS	2
 
-/* USB2 commands */
+/* Maximum number of CAN nets */
+#define ESD_USB_MAX_NETS	2
+
+/* USB commands */
 #define CMD_VERSION		1 /* also used for VERSION_REPLY */
 #define CMD_CAN_RX		2 /* device to host only */
 #define CMD_CAN_TX		3 /* also used for TX_DONE */
@@ -43,13 +46,15 @@ MODULE_LICENSE("GPL v2");
 #define ESD_EVENT		0x40000000
 #define ESD_IDMASK		0x1fffffff
 
-/* esd CAN event ids used by this driver */
-#define ESD_EV_CAN_ERROR_EXT	2
+/* esd CAN event ids */
+#define ESD_EV_CAN_ERROR_EXT	2 /* CAN controller specific diagnostic data */
 
 /* baudrate message flags */
-#define ESD_USB2_UBR		0x80000000
-#define ESD_USB2_LOM		0x40000000
-#define ESD_USB2_NO_BAUDRATE	0x7fffffff
+#define ESD_USB_UBR		0x80000000
+#define ESD_USB_LOM		0x40000000
+#define ESD_USB_NO_BAUDRATE	0x7fffffff
+
+/* bit timing CAN-USB/2 */
 #define ESD_USB2_TSEG1_MIN	1
 #define ESD_USB2_TSEG1_MAX	16
 #define ESD_USB2_TSEG1_SHIFT	16
@@ -68,7 +73,7 @@ MODULE_LICENSE("GPL v2");
 #define ESD_ID_ENABLE		0x80
 #define ESD_MAX_ID_SEGMENT	64
 
-/* SJA1000 ECC register (emulated by usb2 firmware) */
+/* SJA1000 ECC register (emulated by usb firmware) */
 #define SJA1000_ECC_SEG		0x1F
 #define SJA1000_ECC_DIR		0x20
 #define SJA1000_ECC_ERR		0x06
@@ -158,7 +163,7 @@ struct set_baudrate_msg {
 };
 
 /* Main message type used between library and application */
-struct __attribute__ ((packed)) esd_usb2_msg {
+struct __attribute__ ((packed)) esd_usb_msg {
 	union {
 		struct header_msg hdr;
 		struct version_msg version;
@@ -171,23 +176,23 @@ struct __attribute__ ((packed)) esd_usb2_msg {
 	} msg;
 };
 
-static struct usb_device_id esd_usb2_table[] = {
+static struct usb_device_id esd_usb_table[] = {
 	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB2_PRODUCT_ID)},
 	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSBM_PRODUCT_ID)},
 	{}
 };
-MODULE_DEVICE_TABLE(usb, esd_usb2_table);
+MODULE_DEVICE_TABLE(usb, esd_usb_table);
 
-struct esd_usb2_net_priv;
+struct esd_usb_net_priv;
 
 struct esd_tx_urb_context {
-	struct esd_usb2_net_priv *priv;
+	struct esd_usb_net_priv *priv;
 	u32 echo_index;
 };
 
-struct esd_usb2 {
+struct esd_usb {
 	struct usb_device *udev;
-	struct esd_usb2_net_priv *nets[ESD_USB2_MAX_NETS];
+	struct esd_usb_net_priv *nets[ESD_USB_MAX_NETS];
 
 	struct usb_anchor rx_submitted;
 
@@ -198,22 +203,22 @@ struct esd_usb2 {
 	dma_addr_t rxbuf_dma[MAX_RX_URBS];
 };
 
-struct esd_usb2_net_priv {
+struct esd_usb_net_priv {
 	struct can_priv can; /* must be the first member */
 
 	atomic_t active_tx_jobs;
 	struct usb_anchor tx_submitted;
 	struct esd_tx_urb_context tx_contexts[MAX_TX_URBS];
 
-	struct esd_usb2 *usb2;
+	struct esd_usb *usb;
 	struct net_device *netdev;
 	int index;
 	u8 old_state;
 	struct can_berr_counter bec;
 };
 
-static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
-			      struct esd_usb2_msg *msg)
+static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
+			     struct esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct can_frame *cf;
@@ -296,8 +301,8 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 	}
 }
 
-static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
-				struct esd_usb2_msg *msg)
+static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
+			       struct esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct can_frame *cf;
@@ -311,7 +316,7 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
 	id = le32_to_cpu(msg->msg.rx.id);
 
 	if (id & ESD_EVENT) {
-		esd_usb2_rx_event(priv, msg);
+		esd_usb_rx_event(priv, msg);
 	} else {
 		skb = alloc_can_skb(priv->netdev, &cf);
 		if (skb == NULL) {
@@ -342,8 +347,8 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
 	return;
 }
 
-static void esd_usb2_tx_done_msg(struct esd_usb2_net_priv *priv,
-				 struct esd_usb2_msg *msg)
+static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv,
+				struct esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct net_device *netdev = priv->netdev;
@@ -370,9 +375,9 @@ static void esd_usb2_tx_done_msg(struct esd_usb2_net_priv *priv,
 	netif_wake_queue(netdev);
 }
 
-static void esd_usb2_read_bulk_callback(struct urb *urb)
+static void esd_usb_read_bulk_callback(struct urb *urb)
 {
-	struct esd_usb2 *dev = urb->context;
+	struct esd_usb *dev = urb->context;
 	int retval;
 	int pos = 0;
 	int i;
@@ -394,9 +399,9 @@ static void esd_usb2_read_bulk_callback(struct urb *urb)
 	}
 
 	while (pos < urb->actual_length) {
-		struct esd_usb2_msg *msg;
+		struct esd_usb_msg *msg;
 
-		msg = (struct esd_usb2_msg *)(urb->transfer_buffer + pos);
+		msg = (struct esd_usb_msg *)(urb->transfer_buffer + pos);
 
 		switch (msg->msg.hdr.cmd) {
 		case CMD_CAN_RX:
@@ -405,7 +410,7 @@ static void esd_usb2_read_bulk_callback(struct urb *urb)
 				break;
 			}
 
-			esd_usb2_rx_can_msg(dev->nets[msg->msg.rx.net], msg);
+			esd_usb_rx_can_msg(dev->nets[msg->msg.rx.net], msg);
 			break;
 
 		case CMD_CAN_TX:
@@ -414,8 +419,8 @@ static void esd_usb2_read_bulk_callback(struct urb *urb)
 				break;
 			}
 
-			esd_usb2_tx_done_msg(dev->nets[msg->msg.txdone.net],
-					     msg);
+			esd_usb_tx_done_msg(dev->nets[msg->msg.txdone.net],
+					    msg);
 			break;
 		}
 
@@ -430,7 +435,7 @@ static void esd_usb2_read_bulk_callback(struct urb *urb)
 resubmit_urb:
 	usb_fill_bulk_urb(urb, dev->udev, usb_rcvbulkpipe(dev->udev, 1),
 			  urb->transfer_buffer, RX_BUFFER_SIZE,
-			  esd_usb2_read_bulk_callback, dev);
+			  esd_usb_read_bulk_callback, dev);
 
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval == -ENODEV) {
@@ -449,12 +454,12 @@ static void esd_usb2_read_bulk_callback(struct urb *urb)
 /*
  * callback for bulk IN urb
  */
-static void esd_usb2_write_bulk_callback(struct urb *urb)
+static void esd_usb_write_bulk_callback(struct urb *urb)
 {
 	struct esd_tx_urb_context *context = urb->context;
-	struct esd_usb2_net_priv *priv;
+	struct esd_usb_net_priv *priv;
 	struct net_device *netdev;
-	size_t size = sizeof(struct esd_usb2_msg);
+	size_t size = sizeof(struct esd_usb_msg);
 
 	WARN_ON(!context);
 
@@ -478,7 +483,7 @@ static ssize_t firmware_show(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(d);
-	struct esd_usb2 *dev = usb_get_intfdata(intf);
+	struct esd_usb *dev = usb_get_intfdata(intf);
 
 	return sprintf(buf, "%d.%d.%d\n",
 		       (dev->version >> 12) & 0xf,
@@ -491,7 +496,7 @@ static ssize_t hardware_show(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(d);
-	struct esd_usb2 *dev = usb_get_intfdata(intf);
+	struct esd_usb *dev = usb_get_intfdata(intf);
 
 	return sprintf(buf, "%d.%d.%d\n",
 		       (dev->version >> 28) & 0xf,
@@ -504,13 +509,13 @@ static ssize_t nets_show(struct device *d,
 			 struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(d);
-	struct esd_usb2 *dev = usb_get_intfdata(intf);
+	struct esd_usb *dev = usb_get_intfdata(intf);
 
 	return sprintf(buf, "%d", dev->net_count);
 }
 static DEVICE_ATTR_RO(nets);
 
-static int esd_usb2_send_msg(struct esd_usb2 *dev, struct esd_usb2_msg *msg)
+static int esd_usb_send_msg(struct esd_usb *dev, struct esd_usb_msg *msg)
 {
 	int actual_length;
 
@@ -522,8 +527,8 @@ static int esd_usb2_send_msg(struct esd_usb2 *dev, struct esd_usb2_msg *msg)
 			    1000);
 }
 
-static int esd_usb2_wait_msg(struct esd_usb2 *dev,
-			     struct esd_usb2_msg *msg)
+static int esd_usb_wait_msg(struct esd_usb *dev,
+			    struct esd_usb_msg *msg)
 {
 	int actual_length;
 
@@ -535,7 +540,7 @@ static int esd_usb2_wait_msg(struct esd_usb2 *dev,
 			    1000);
 }
 
-static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
+static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 {
 	int i, err = 0;
 
@@ -568,7 +573,7 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
 		usb_fill_bulk_urb(urb, dev->udev,
 				  usb_rcvbulkpipe(dev->udev, 1),
 				  buf, RX_BUFFER_SIZE,
-				  esd_usb2_read_bulk_callback, dev);
+				  esd_usb_read_bulk_callback, dev);
 		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		usb_anchor_urb(urb, &dev->rx_submitted);
 
@@ -609,11 +614,11 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
 /*
  * Start interface
  */
-static int esd_usb2_start(struct esd_usb2_net_priv *priv)
+static int esd_usb_start(struct esd_usb_net_priv *priv)
 {
-	struct esd_usb2 *dev = priv->usb2;
+	struct esd_usb *dev = priv->usb;
 	struct net_device *netdev = priv->netdev;
-	struct esd_usb2_msg *msg;
+	struct esd_usb_msg *msg;
 	int err, i;
 
 	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
@@ -644,11 +649,11 @@ static int esd_usb2_start(struct esd_usb2_net_priv *priv)
 	/* enable 29bit extended IDs */
 	msg->msg.filter.mask[ESD_MAX_ID_SEGMENT] = cpu_to_le32(0x00000001);
 
-	err = esd_usb2_send_msg(dev, msg);
+	err = esd_usb_send_msg(dev, msg);
 	if (err)
 		goto out;
 
-	err = esd_usb2_setup_rx_urbs(dev);
+	err = esd_usb_setup_rx_urbs(dev);
 	if (err)
 		goto out;
 
@@ -664,9 +669,9 @@ static int esd_usb2_start(struct esd_usb2_net_priv *priv)
 	return err;
 }
 
-static void unlink_all_urbs(struct esd_usb2 *dev)
+static void unlink_all_urbs(struct esd_usb *dev)
 {
-	struct esd_usb2_net_priv *priv;
+	struct esd_usb_net_priv *priv;
 	int i, j;
 
 	usb_kill_anchored_urbs(&dev->rx_submitted);
@@ -687,9 +692,9 @@ static void unlink_all_urbs(struct esd_usb2 *dev)
 	}
 }
 
-static int esd_usb2_open(struct net_device *netdev)
+static int esd_usb_open(struct net_device *netdev)
 {
-	struct esd_usb2_net_priv *priv = netdev_priv(netdev);
+	struct esd_usb_net_priv *priv = netdev_priv(netdev);
 	int err;
 
 	/* common open */
@@ -698,7 +703,7 @@ static int esd_usb2_open(struct net_device *netdev)
 		return err;
 
 	/* finally start device */
-	err = esd_usb2_start(priv);
+	err = esd_usb_start(priv);
 	if (err) {
 		netdev_warn(netdev, "couldn't start device: %d\n", err);
 		close_candev(netdev);
@@ -710,20 +715,20 @@ static int esd_usb2_open(struct net_device *netdev)
 	return 0;
 }
 
-static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
+static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 				      struct net_device *netdev)
 {
-	struct esd_usb2_net_priv *priv = netdev_priv(netdev);
-	struct esd_usb2 *dev = priv->usb2;
+	struct esd_usb_net_priv *priv = netdev_priv(netdev);
+	struct esd_usb *dev = priv->usb;
 	struct esd_tx_urb_context *context = NULL;
 	struct net_device_stats *stats = &netdev->stats;
 	struct can_frame *cf = (struct can_frame *)skb->data;
-	struct esd_usb2_msg *msg;
+	struct esd_usb_msg *msg;
 	struct urb *urb;
 	u8 *buf;
 	int i, err;
 	int ret = NETDEV_TX_OK;
-	size_t size = sizeof(struct esd_usb2_msg);
+	size_t size = sizeof(struct esd_usb_msg);
 
 	if (can_dropped_invalid_skb(netdev, skb))
 		return NETDEV_TX_OK;
@@ -745,7 +750,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 		goto nobufmem;
 	}
 
-	msg = (struct esd_usb2_msg *)buf;
+	msg = (struct esd_usb_msg *)buf;
 
 	msg->msg.hdr.len = 3; /* minimal length */
 	msg->msg.hdr.cmd = CMD_CAN_TX;
@@ -788,7 +793,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 
 	usb_fill_bulk_urb(urb, dev->udev, usb_sndbulkpipe(dev->udev, 2), buf,
 			  msg->msg.hdr.len << 2,
-			  esd_usb2_write_bulk_callback, context);
+			  esd_usb_write_bulk_callback, context);
 
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
@@ -839,24 +844,24 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
-static int esd_usb2_close(struct net_device *netdev)
+static int esd_usb_close(struct net_device *netdev)
 {
-	struct esd_usb2_net_priv *priv = netdev_priv(netdev);
-	struct esd_usb2_msg *msg;
+	struct esd_usb_net_priv *priv = netdev_priv(netdev);
+	struct esd_usb_msg *msg;
 	int i;
 
 	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
-	/* Disable all IDs (see esd_usb2_start()) */
+	/* Disable all IDs (see esd_usb_start()) */
 	msg->msg.hdr.cmd = CMD_IDADD;
 	msg->msg.hdr.len = 2 + ESD_MAX_ID_SEGMENT;
 	msg->msg.filter.net = priv->index;
 	msg->msg.filter.option = ESD_ID_ENABLE; /* start with segment 0 */
 	for (i = 0; i <= ESD_MAX_ID_SEGMENT; i++)
 		msg->msg.filter.mask[i] = 0;
-	if (esd_usb2_send_msg(priv->usb2, msg) < 0)
+	if (esd_usb_send_msg(priv->usb, msg) < 0)
 		netdev_err(netdev, "sending idadd message failed\n");
 
 	/* set CAN controller to reset mode */
@@ -864,8 +869,8 @@ static int esd_usb2_close(struct net_device *netdev)
 	msg->msg.hdr.cmd = CMD_SETBAUD;
 	msg->msg.setbaud.net = priv->index;
 	msg->msg.setbaud.rsvd = 0;
-	msg->msg.setbaud.baud = cpu_to_le32(ESD_USB2_NO_BAUDRATE);
-	if (esd_usb2_send_msg(priv->usb2, msg) < 0)
+	msg->msg.setbaud.baud = cpu_to_le32(ESD_USB_NO_BAUDRATE);
+	if (esd_usb_send_msg(priv->usb, msg) < 0)
 		netdev_err(netdev, "sending setbaud message failed\n");
 
 	priv->can.state = CAN_STATE_STOPPED;
@@ -879,10 +884,10 @@ static int esd_usb2_close(struct net_device *netdev)
 	return 0;
 }
 
-static const struct net_device_ops esd_usb2_netdev_ops = {
-	.ndo_open = esd_usb2_open,
-	.ndo_stop = esd_usb2_close,
-	.ndo_start_xmit = esd_usb2_start_xmit,
+static const struct net_device_ops esd_usb_netdev_ops = {
+	.ndo_open = esd_usb_open,
+	.ndo_stop = esd_usb_close,
+	.ndo_start_xmit = esd_usb_start_xmit,
 	.ndo_change_mtu = can_change_mtu,
 };
 
@@ -900,20 +905,20 @@ static const struct can_bittiming_const esd_usb2_bittiming_const = {
 
 static int esd_usb2_set_bittiming(struct net_device *netdev)
 {
-	struct esd_usb2_net_priv *priv = netdev_priv(netdev);
+	struct esd_usb_net_priv *priv = netdev_priv(netdev);
 	struct can_bittiming *bt = &priv->can.bittiming;
-	struct esd_usb2_msg *msg;
+	struct esd_usb_msg *msg;
 	int err;
 	u32 canbtr;
 	int sjw_shift;
 
-	canbtr = ESD_USB2_UBR;
+	canbtr = ESD_USB_UBR;
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
-		canbtr |= ESD_USB2_LOM;
+		canbtr |= ESD_USB_LOM;
 
 	canbtr |= (bt->brp - 1) & (ESD_USB2_BRP_MAX - 1);
 
-	if (le16_to_cpu(priv->usb2->udev->descriptor.idProduct) ==
+	if (le16_to_cpu(priv->usb->udev->descriptor.idProduct) ==
 	    USB_CANUSBM_PRODUCT_ID)
 		sjw_shift = ESD_USBM_SJW_SHIFT;
 	else
@@ -941,16 +946,16 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 
 	netdev_info(netdev, "setting BTR=%#x\n", canbtr);
 
-	err = esd_usb2_send_msg(priv->usb2, msg);
+	err = esd_usb_send_msg(priv->usb, msg);
 
 	kfree(msg);
 	return err;
 }
 
-static int esd_usb2_get_berr_counter(const struct net_device *netdev,
-				     struct can_berr_counter *bec)
+static int esd_usb_get_berr_counter(const struct net_device *netdev,
+				    struct can_berr_counter *bec)
 {
-	struct esd_usb2_net_priv *priv = netdev_priv(netdev);
+	struct esd_usb_net_priv *priv = netdev_priv(netdev);
 
 	bec->txerr = priv->bec.txerr;
 	bec->rxerr = priv->bec.rxerr;
@@ -958,7 +963,7 @@ static int esd_usb2_get_berr_counter(const struct net_device *netdev,
 	return 0;
 }
 
-static int esd_usb2_set_mode(struct net_device *netdev, enum can_mode mode)
+static int esd_usb_set_mode(struct net_device *netdev, enum can_mode mode)
 {
 	switch (mode) {
 	case CAN_MODE_START:
@@ -972,11 +977,11 @@ static int esd_usb2_set_mode(struct net_device *netdev, enum can_mode mode)
 	return 0;
 }
 
-static int esd_usb2_probe_one_net(struct usb_interface *intf, int index)
+static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 {
-	struct esd_usb2 *dev = usb_get_intfdata(intf);
+	struct esd_usb *dev = usb_get_intfdata(intf);
 	struct net_device *netdev;
-	struct esd_usb2_net_priv *priv;
+	struct esd_usb_net_priv *priv;
 	int err = 0;
 	int i;
 
@@ -995,7 +1000,7 @@ static int esd_usb2_probe_one_net(struct usb_interface *intf, int index)
 	for (i = 0; i < MAX_TX_URBS; i++)
 		priv->tx_contexts[i].echo_index = MAX_TX_URBS;
 
-	priv->usb2 = dev;
+	priv->usb = dev;
 	priv->netdev = netdev;
 	priv->index = index;
 
@@ -1013,12 +1018,12 @@ static int esd_usb2_probe_one_net(struct usb_interface *intf, int index)
 
 	priv->can.bittiming_const = &esd_usb2_bittiming_const;
 	priv->can.do_set_bittiming = esd_usb2_set_bittiming;
-	priv->can.do_set_mode = esd_usb2_set_mode;
-	priv->can.do_get_berr_counter = esd_usb2_get_berr_counter;
+	priv->can.do_set_mode = esd_usb_set_mode;
+	priv->can.do_get_berr_counter = esd_usb_get_berr_counter;
 
 	netdev->flags |= IFF_ECHO; /* we support local echo */
 
-	netdev->netdev_ops = &esd_usb2_netdev_ops;
+	netdev->netdev_ops = &esd_usb_netdev_ops;
 
 	SET_NETDEV_DEV(netdev, &intf->dev);
 	netdev->dev_id = index;
@@ -1039,16 +1044,16 @@ static int esd_usb2_probe_one_net(struct usb_interface *intf, int index)
 }
 
 /*
- * probe function for new USB2 devices
+ * probe function for new USB devices
  *
  * check version information and number of available
  * CAN interfaces
  */
-static int esd_usb2_probe(struct usb_interface *intf,
+static int esd_usb_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
-	struct esd_usb2 *dev;
-	struct esd_usb2_msg *msg;
+	struct esd_usb *dev;
+	struct esd_usb_msg *msg;
 	int i, err;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -1076,13 +1081,13 @@ static int esd_usb2_probe(struct usb_interface *intf,
 	msg->msg.version.flags = 0;
 	msg->msg.version.drv_version = 0;
 
-	err = esd_usb2_send_msg(dev, msg);
+	err = esd_usb_send_msg(dev, msg);
 	if (err < 0) {
 		dev_err(&intf->dev, "sending version message failed\n");
 		goto free_msg;
 	}
 
-	err = esd_usb2_wait_msg(dev, msg);
+	err = esd_usb_wait_msg(dev, msg);
 	if (err < 0) {
 		dev_err(&intf->dev, "no version message answer\n");
 		goto free_msg;
@@ -1105,7 +1110,7 @@ static int esd_usb2_probe(struct usb_interface *intf,
 
 	/* do per device probing */
 	for (i = 0; i < dev->net_count; i++)
-		esd_usb2_probe_one_net(intf, i);
+		esd_usb_probe_one_net(intf, i);
 
 free_msg:
 	kfree(msg);
@@ -1118,9 +1123,9 @@ static int esd_usb2_probe(struct usb_interface *intf,
 /*
  * called by the usb core when the device is removed from the system
  */
-static void esd_usb2_disconnect(struct usb_interface *intf)
+static void esd_usb_disconnect(struct usb_interface *intf)
 {
-	struct esd_usb2 *dev = usb_get_intfdata(intf);
+	struct esd_usb *dev = usb_get_intfdata(intf);
 	struct net_device *netdev;
 	int i;
 
@@ -1144,11 +1149,11 @@ static void esd_usb2_disconnect(struct usb_interface *intf)
 }
 
 /* usb specific object needed to register this driver with the usb subsystem */
-static struct usb_driver esd_usb2_driver = {
-	.name = "esd_usb2",
-	.probe = esd_usb2_probe,
-	.disconnect = esd_usb2_disconnect,
-	.id_table = esd_usb2_table,
+static struct usb_driver esd_usb_driver = {
+	.name = "esd_usb",
+	.probe = esd_usb_probe,
+	.disconnect = esd_usb_disconnect,
+	.id_table = esd_usb_table,
 };
 
-module_usb_driver(esd_usb2_driver);
+module_usb_driver(esd_usb_driver);
-- 
2.35.1


