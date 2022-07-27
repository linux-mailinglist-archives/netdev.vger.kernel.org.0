Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C465821D0
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 10:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiG0INl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 04:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiG0INk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 04:13:40 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DBF7412618;
        Wed, 27 Jul 2022 01:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=6XnCe
        a9yoiW31TrsttMsxP++0aBbuQBm1X7eC68itbM=; b=A+Zp2bmeuzrZrIk/u0HRK
        qwc5ACR655gOU38zOAVMePm4Ni/mA/jVUgQRGs7BM1USMfe8tX+p0PXkoCswQXpd
        apR8aTMdNNYR2hnWI9ViNC7tkuJfQFwXVCKZBVdxwgYyMpXMHhlE9Jm2fzQao/hA
        5egHE5hKK3N03sG+li7StU=
Received: from localhost.localdomain (unknown [123.58.221.99])
        by smtp4 (Coremail) with SMTP id HNxpCgCn2NCJ8+Bi86CaRA--.243S2;
        Wed, 27 Jul 2022 16:12:59 +0800 (CST)
From:   studentxswpy@163.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, oliver@neukum.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Xie Shaowen <studentxswpy@163.com>
Subject: [PATCH net-next] net: usb: delete extra space and tab in blank line
Date:   Wed, 27 Jul 2022 16:12:53 +0800
Message-Id: <20220727081253.3043941-1-studentxswpy@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgCn2NCJ8+Bi86CaRA--.243S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Gr15Zw43XF4fWryUGF1Utrb_yoWxKFykpF
        43JF43tr15Xr45X3yxXrs7Zry5Xw4UK340kr1xZ3s5ZF98A34jqr17GFyIkr90yrWfAFy3
        tF4DC3yUWF15C37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jr0eQUUUUU=
X-Originating-IP: [123.58.221.99]
X-CM-SenderInfo: xvwxvv5qw024ls16il2tof0z/1tbiqwxLJFUMezch2gAAsm
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie Shaowen <studentxswpy@163.com>

delete extra space and tab in blank line, there is no functional change.

Signed-off-by: Xie Shaowen <studentxswpy@163.com>
---
 drivers/net/usb/catc.c       | 44 ++++++++++++++++++------------------
 drivers/net/usb/cdc_subset.c | 10 ++++----
 drivers/net/usb/kaweth.c     |  2 +-
 drivers/net/usb/plusb.c      |  2 +-
 drivers/net/usb/usbnet.c     |  2 +-
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index 1a376ed45d7a..f536d65bb045 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -8,13 +8,13 @@
  *
  *  Based on the work of
  *		Donald Becker
- * 
+ *
  *  Old chipset support added by Simon Evans <spse@secret.org.uk> 2002
  *    - adds support for Belkin F5U011
  */
 
 /*
- * 
+ *
  * Should you need to contact me, the author, you can do so either by
  * e-mail - mail your message to <vojtech@suse.cz>, or by paper mail:
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
@@ -54,7 +54,7 @@ static const char driver_name[] = "catc";
 
 /*
  * Some defines.
- */ 
+ */
 
 #define STATS_UPDATE		(HZ)	/* Time between stats updates */
 #define TX_TIMEOUT		(5*HZ)	/* Max time the queue can be stopped */
@@ -332,7 +332,7 @@ static void catc_irq_done(struct urb *urb)
 				dev_err(&catc->usbdev->dev,
 					"submit(rx_urb) status %d\n", res);
 			}
-		} 
+		}
 	}
 resubmit:
 	res = usb_submit_urb (urb, GFP_ATOMIC);
@@ -538,7 +538,7 @@ static int catc_ctrl_async(struct catc *catc, u8 dir, u8 request, u16 value,
 	unsigned long flags;
 
 	spin_lock_irqsave(&catc->ctrl_lock, flags);
-	
+
 	q = catc->ctrl_queue + catc->ctrl_head;
 
 	q->dir = dir;
@@ -639,7 +639,7 @@ static void catc_set_multicast_list(struct net_device *netdev)
 	if (netdev->flags & IFF_PROMISC) {
 		memset(catc->multicast, 0xff, 64);
 		rx |= (!catc->is_f5u011) ? RxPromisc : AltRxPromisc;
-	} 
+	}
 
 	if (netdev->flags & IFF_ALLMULTI) {
 		memset(catc->multicast, 0xff, 64);
@@ -806,7 +806,7 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	catc->tx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	catc->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	catc->irq_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if ((!catc->ctrl_urb) || (!catc->tx_urb) || 
+	if ((!catc->ctrl_urb) || (!catc->tx_urb) ||
 	    (!catc->rx_urb) || (!catc->irq_urb)) {
 		dev_err(&intf->dev, "No free urbs available.\n");
 		ret = -ENOMEM;
@@ -814,17 +814,17 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	}
 
 	/* The F5U011 has the same vendor/product as the netmate but a device version of 0x130 */
-	if (le16_to_cpu(usbdev->descriptor.idVendor) == 0x0423 && 
+	if (le16_to_cpu(usbdev->descriptor.idVendor) == 0x0423 &&
 	    le16_to_cpu(usbdev->descriptor.idProduct) == 0xa &&
 	    le16_to_cpu(catc->usbdev->descriptor.bcdDevice) == 0x0130) {
 		dev_dbg(dev, "Testing for f5u011\n");
-		catc->is_f5u011 = 1;		
+		catc->is_f5u011 = 1;
 		atomic_set(&catc->recq_sz, 0);
 		pktsz = RX_PKT_SZ;
 	} else {
 		pktsz = RX_MAX_BURST * (PKT_SZ + 2);
 	}
-	
+
 	usb_fill_control_urb(catc->ctrl_urb, usbdev, usb_sndctrlpipe(usbdev, 0),
 		NULL, NULL, 0, catc_ctrl_done, catc);
 
@@ -854,7 +854,7 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 		*buf = 0x87654321;
 		catc_write_mem(catc, 0xfa80, buf, 4);
 		catc_read_mem(catc, 0x7a80, buf, 4);
-	  
+
 		switch (*buf) {
 		case 0x12345678:
 			catc_set_reg(catc, TxBufCount, 8);
@@ -873,32 +873,32 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 		}
 
 		kfree(buf);
-	  
+
 		dev_dbg(dev, "Getting MAC from SEEROM.\n");
-	  
+
 		catc_get_mac(catc, macbuf);
 		eth_hw_addr_set(netdev, macbuf);
-		
+
 		dev_dbg(dev, "Setting MAC into registers.\n");
-	  
+
 		for (i = 0; i < 6; i++)
 			catc_set_reg(catc, StationAddr0 - i, netdev->dev_addr[i]);
-		
+
 		dev_dbg(dev, "Filling the multicast list.\n");
-	  
+
 		eth_broadcast_addr(broadcast);
 		catc_multicast(broadcast, catc->multicast);
 		catc_multicast(netdev->dev_addr, catc->multicast);
 		catc_write_mem(catc, 0xfa80, catc->multicast, 64);
-		
+
 		dev_dbg(dev, "Clearing error counters.\n");
-		
+
 		for (i = 0; i < 8; i++)
 			catc_set_reg(catc, EthStats + i, 0);
 		catc->last_stats = jiffies;
-		
+
 		dev_dbg(dev, "Enabling.\n");
-		
+
 		catc_set_reg(catc, MaxBurst, RX_MAX_BURST);
 		catc_set_reg(catc, OpModes, OpTxMerge | OpRxMerge | OpLenInclude | Op3MemWaits);
 		catc_set_reg(catc, LEDCtrl, LEDLink);
@@ -908,7 +908,7 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 		catc_reset(catc);
 		catc_get_mac(catc, macbuf);
 		eth_hw_addr_set(netdev, macbuf);
-		
+
 		dev_dbg(dev, "Setting RX Mode\n");
 		catc->rxmode[0] = RxEnable | RxPolarity | RxMultiCast;
 		catc->rxmode[1] = 0;
diff --git a/drivers/net/usb/cdc_subset.c b/drivers/net/usb/cdc_subset.c
index 32637df0f4cc..f4a44f05c6ab 100644
--- a/drivers/net/usb/cdc_subset.c
+++ b/drivers/net/usb/cdc_subset.c
@@ -120,7 +120,7 @@ static const struct driver_info	an2720_info = {
 
 #endif	/* CONFIG_USB_AN2720 */
 
-
+
 #ifdef	CONFIG_USB_BELKIN
 #define	HAVE_HARDWARE
 
@@ -140,7 +140,7 @@ static const struct driver_info	belkin_info = {
 #endif	/* CONFIG_USB_BELKIN */
 
 
-
+
 #ifdef	CONFIG_USB_EPSON2888
 #define	HAVE_HARDWARE
 
@@ -167,7 +167,7 @@ static const struct driver_info	epson2888_info = {
 
 #endif	/* CONFIG_USB_EPSON2888 */
 
-
+
 /*-------------------------------------------------------------------------
  *
  * info from Jonathan McDowell <noodles@earth.li>
@@ -181,7 +181,7 @@ static const struct driver_info kc2190_info = {
 };
 #endif /* CONFIG_USB_KC2190 */
 
-
+
 #ifdef	CONFIG_USB_ARMLINUX
 #define	HAVE_HARDWARE
 
@@ -222,7 +222,7 @@ static const struct driver_info	blob_info = {
 
 #endif	/* CONFIG_USB_ARMLINUX */
 
-
+
 /*-------------------------------------------------------------------------*/
 
 #ifndef	HAVE_HARDWARE
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 9b2bc1993ece..c9efb7df892e 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -221,7 +221,7 @@ struct kaweth_device
 	dma_addr_t rxbufferhandle;
 	__u8 *rx_buf;
 
-	
+
 	struct sk_buff *tx_skb;
 
 	__u8 *firmware_buf;
diff --git a/drivers/net/usb/plusb.c b/drivers/net/usb/plusb.c
index 17c9c63b8eeb..2c82fbcaab22 100644
--- a/drivers/net/usb/plusb.c
+++ b/drivers/net/usb/plusb.c
@@ -18,7 +18,7 @@
 
 
 /*
- * Prolific PL-2301/PL-2302 driver ... http://www.prolific.com.tw/ 
+ * Prolific PL-2301/PL-2302 driver ... http://www.prolific.com.tw/
  *
  * The protocol and handshaking used here should be bug-compatible
  * with the Linux 2.2 "plusb" driver, by Deti Fliegl.
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 78a92751ce4c..acef8936a203 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -384,7 +384,7 @@ void usbnet_update_max_qlen(struct usbnet *dev)
 }
 EXPORT_SYMBOL_GPL(usbnet_update_max_qlen);
 
-
+
 /*-------------------------------------------------------------------------
  *
  * Network Device Driver (peer link to "Host Device", from USB host)
-- 
2.25.1

