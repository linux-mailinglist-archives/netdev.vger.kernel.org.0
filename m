Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDB83F6971
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 21:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhHXTDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 15:03:23 -0400
Received: from bee.dogwood.relay.mailchannels.net ([23.83.211.14]:34612 "EHLO
        bee.dogwood.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233578AbhHXTDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 15:03:21 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2021 15:03:20 EDT
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id BF589920B03;
        Tue, 24 Aug 2021 18:57:21 +0000 (UTC)
Received: from ares.krystal.co.uk (unknown [127.0.0.6])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id E9B59920B78;
        Tue, 24 Aug 2021 18:57:19 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.114.12.88 (trex/6.4.3);
        Tue, 24 Aug 2021 18:57:21 +0000
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Relation-Illustrious: 2ece11bd435934d3_1629831441556_212299161
X-MC-Loop-Signature: 1629831441556:2667369973
X-MC-Ingress-Time: 1629831441556
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TAOYQM2xKgwR8WKXZT+qSZ63rAx/IdgHp+O009rVNaI=; b=qNBvqPfndyYk1kTDmrc6e6aqOL
        3pB6yeHw4IAVX8EN4igZmz6WTj3xZz3cL5oBshP1Ulgw6il0gnYPkPAT9STAOehWSYZv4DpOt8Rqv
        BkYEfzcbKgl8SezSO8L0r7f7Z63j5fXNeLXQh/gYkdGrs+eE79qkGvah49fzX3m5K02k6TPXFvSPr
        4GCgKbRpdL/hKpMg0BjT0ZxYnRADBuO/hEAfyYnWfUo5+BqBgvXdPOhVPzapUvOf4jZKZYH18BaI1
        WBOiPNsaFKm2Pl0pUfF4TBuuZb3jSr/IXQGFk83a3c4+lFmKO9umAF4TQE3YxuE4o9yNpq9sEWr/Y
        YGLQiITg==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51816 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIbbq-00BQSi-Tk; Tue, 24 Aug 2021 19:57:17 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-usb@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next v2 01/10] lan78xx: Fix white space and style issues
Date:   Tue, 24 Aug 2021 19:56:04 +0100
Message-Id: <20210824185613.49545-2-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
References: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix white space and code style issues identified by checkpatch.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 80 ++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 38 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 4e8d3c28f73e..ece044dd0236 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -382,7 +382,7 @@ struct lan78xx_net {
 	struct usb_anchor	deferred;
 
 	struct mutex		phy_mutex; /* for phy access */
-	unsigned		pipe_in, pipe_out, pipe_intr;
+	unsigned int		pipe_in, pipe_out, pipe_intr;
 
 	u32			hard_mtu;	/* count any extra framing */
 	size_t			rx_urb_size;	/* size for rx urbs */
@@ -392,7 +392,7 @@ struct lan78xx_net {
 	wait_queue_head_t	*wait;
 	unsigned char		suspend_count;
 
-	unsigned		maxpacket;
+	unsigned int		maxpacket;
 	struct timer_list	delay;
 	struct timer_list	stat_monitor;
 
@@ -501,7 +501,7 @@ static int lan78xx_read_stats(struct lan78xx_net *dev,
 	if (likely(ret >= 0)) {
 		src = (u32 *)stats;
 		dst = (u32 *)data;
-		for (i = 0; i < sizeof(*stats)/sizeof(u32); i++) {
+		for (i = 0; i < sizeof(*stats) / sizeof(u32); i++) {
 			le32_to_cpus(&src[i]);
 			dst[i] = src[i];
 		}
@@ -515,10 +515,11 @@ static int lan78xx_read_stats(struct lan78xx_net *dev,
 	return ret;
 }
 
-#define check_counter_rollover(struct1, dev_stats, member) {	\
-	if (struct1->member < dev_stats.saved.member)		\
-		dev_stats.rollover_count.member++;		\
-	}
+#define check_counter_rollover(struct1, dev_stats, member)		\
+	do {								\
+		if ((struct1)->member < (dev_stats).saved.member)	\
+			(dev_stats).rollover_count.member++;		\
+	} while (0)
 
 static void lan78xx_check_stat_rollover(struct lan78xx_net *dev,
 					struct lan78xx_statstage *stats)
@@ -844,9 +845,9 @@ static int lan78xx_read_raw_otp(struct lan78xx_net *dev, u32 offset,
 
 	for (i = 0; i < length; i++) {
 		lan78xx_write_reg(dev, OTP_ADDR1,
-					((offset + i) >> 8) & OTP_ADDR1_15_11);
+				  ((offset + i) >> 8) & OTP_ADDR1_15_11);
 		lan78xx_write_reg(dev, OTP_ADDR2,
-					((offset + i) & OTP_ADDR2_10_3));
+				  ((offset + i) & OTP_ADDR2_10_3));
 
 		lan78xx_write_reg(dev, OTP_FUNC_CMD, OTP_FUNC_CMD_READ_);
 		lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
@@ -900,9 +901,9 @@ static int lan78xx_write_raw_otp(struct lan78xx_net *dev, u32 offset,
 
 	for (i = 0; i < length; i++) {
 		lan78xx_write_reg(dev, OTP_ADDR1,
-					((offset + i) >> 8) & OTP_ADDR1_15_11);
+				  ((offset + i) >> 8) & OTP_ADDR1_15_11);
 		lan78xx_write_reg(dev, OTP_ADDR2,
-					((offset + i) & OTP_ADDR2_10_3));
+				  ((offset + i) & OTP_ADDR2_10_3));
 		lan78xx_write_reg(dev, OTP_PRGM_DATA, data[i]);
 		lan78xx_write_reg(dev, OTP_TST_CMD, OTP_TST_CMD_PRGVRFY_);
 		lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
@@ -959,7 +960,7 @@ static int lan78xx_dataport_wait_not_busy(struct lan78xx_net *dev)
 		usleep_range(40, 100);
 	}
 
-	netdev_warn(dev->net, "lan78xx_dataport_wait_not_busy timed out");
+	netdev_warn(dev->net, "%s timed out", __func__);
 
 	return -EIO;
 }
@@ -972,7 +973,7 @@ static int lan78xx_dataport_write(struct lan78xx_net *dev, u32 ram_select,
 	int i, ret;
 
 	if (usb_autopm_get_interface(dev->intf) < 0)
-			return 0;
+		return 0;
 
 	mutex_lock(&pdata->dataport_mutex);
 
@@ -1045,9 +1046,9 @@ static void lan78xx_deferred_multicast_write(struct work_struct *param)
 	for (i = 1; i < NUM_OF_MAF; i++) {
 		lan78xx_write_reg(dev, MAF_HI(i), 0);
 		lan78xx_write_reg(dev, MAF_LO(i),
-					pdata->pfilter_table[i][1]);
+				  pdata->pfilter_table[i][1]);
 		lan78xx_write_reg(dev, MAF_HI(i),
-					pdata->pfilter_table[i][0]);
+				  pdata->pfilter_table[i][0]);
 	}
 
 	lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
@@ -1066,11 +1067,12 @@ static void lan78xx_set_multicast(struct net_device *netdev)
 			    RFE_CTL_DA_PERFECT_ | RFE_CTL_MCAST_HASH_);
 
 	for (i = 0; i < DP_SEL_VHF_HASH_LEN; i++)
-			pdata->mchash_table[i] = 0;
+		pdata->mchash_table[i] = 0;
+
 	/* pfilter_table[0] has own HW address */
 	for (i = 1; i < NUM_OF_MAF; i++) {
-			pdata->pfilter_table[i][0] =
-			pdata->pfilter_table[i][1] = 0;
+		pdata->pfilter_table[i][0] = 0;
+		pdata->pfilter_table[i][1] = 0;
 	}
 
 	pdata->rfe_ctl |= RFE_CTL_BCAST_EN_;
@@ -1264,9 +1266,10 @@ static void lan78xx_status(struct lan78xx_net *dev, struct urb *urb)
 			generic_handle_irq(dev->domain_data.phyirq);
 			local_irq_enable();
 		}
-	} else
+	} else {
 		netdev_warn(dev->net,
 			    "unexpected interrupt: 0x%08x\n", intdata);
+	}
 }
 
 static int lan78xx_ethtool_get_eeprom_len(struct net_device *netdev)
@@ -1355,7 +1358,7 @@ static void lan78xx_get_wol(struct net_device *netdev,
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
 
 	if (usb_autopm_get_interface(dev->intf) < 0)
-			return;
+		return;
 
 	ret = lan78xx_read_reg(dev, USB_CFG0, &buf);
 	if (unlikely(ret < 0)) {
@@ -2003,7 +2006,7 @@ static int lan8835_fixup(struct phy_device *phydev)
 
 	/* RGMII MAC TXC Delay Enable */
 	lan78xx_write_reg(dev, MAC_RGMII_ID,
-				MAC_RGMII_ID_TXC_DELAY_EN_);
+			  MAC_RGMII_ID_TXC_DELAY_EN_);
 
 	/* RGMII TX DLL Tune Adjust */
 	lan78xx_write_reg(dev, RGMII_TX_BYP_DLL, 0x3D00);
@@ -3356,9 +3359,10 @@ static void lan78xx_tx_bh(struct lan78xx_net *dev)
 		if (skb)
 			dev_kfree_skb_any(skb);
 		usb_free_urb(urb);
-	} else
+	} else {
 		netif_dbg(dev, tx_queued, dev->net,
 			  "> tx, len %d, type 0x%x\n", length, skb->protocol);
+	}
 }
 
 static void lan78xx_rx_bh(struct lan78xx_net *dev)
@@ -3459,7 +3463,7 @@ static void lan78xx_delayedwork(struct work_struct *work)
 		unlink_urbs(dev, &dev->rxq);
 		status = usb_autopm_get_interface(dev->intf);
 		if (status < 0)
-				goto fail_halt;
+			goto fail_halt;
 		status = usb_clear_halt(dev->udev, dev->pipe_in);
 		usb_autopm_put_interface(dev->intf);
 		if (status < 0 &&
@@ -3632,8 +3636,8 @@ static int lan78xx_probe(struct usb_interface *intf,
 	struct net_device *netdev;
 	struct usb_device *udev;
 	int ret;
-	unsigned maxp;
-	unsigned period;
+	unsigned int maxp;
+	unsigned int period;
 	u8 *buf = NULL;
 
 	udev = interface_to_usbdev(intf);
@@ -3858,10 +3862,10 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		/* set WUF_CFG & WUF_MASK for IPv4 Multicast */
 		crc = lan78xx_wakeframe_crc16(ipv4_multicast, 3);
 		lan78xx_write_reg(dev, WUF_CFG(mask_index),
-					WUF_CFGX_EN_ |
-					WUF_CFGX_TYPE_MCAST_ |
-					(0 << WUF_CFGX_OFFSET_SHIFT_) |
-					(crc & WUF_CFGX_CRC16_MASK_));
+				  WUF_CFGX_EN_ |
+				  WUF_CFGX_TYPE_MCAST_ |
+				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
+				  (crc & WUF_CFGX_CRC16_MASK_));
 
 		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 7);
 		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
@@ -3872,10 +3876,10 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		/* for IPv6 Multicast */
 		crc = lan78xx_wakeframe_crc16(ipv6_multicast, 2);
 		lan78xx_write_reg(dev, WUF_CFG(mask_index),
-					WUF_CFGX_EN_ |
-					WUF_CFGX_TYPE_MCAST_ |
-					(0 << WUF_CFGX_OFFSET_SHIFT_) |
-					(crc & WUF_CFGX_CRC16_MASK_));
+				  WUF_CFGX_EN_ |
+				  WUF_CFGX_TYPE_MCAST_ |
+				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
+				  (crc & WUF_CFGX_CRC16_MASK_));
 
 		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 3);
 		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
@@ -3902,10 +3906,10 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		 */
 		crc = lan78xx_wakeframe_crc16(arp_type, 2);
 		lan78xx_write_reg(dev, WUF_CFG(mask_index),
-					WUF_CFGX_EN_ |
-					WUF_CFGX_TYPE_ALL_ |
-					(0 << WUF_CFGX_OFFSET_SHIFT_) |
-					(crc & WUF_CFGX_CRC16_MASK_));
+				  WUF_CFGX_EN_ |
+				  WUF_CFGX_TYPE_ALL_ |
+				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
+				  (crc & WUF_CFGX_CRC16_MASK_));
 
 		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 0x3000);
 		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
@@ -4050,7 +4054,7 @@ static int lan78xx_resume(struct usb_interface *intf)
 	if (!--dev->suspend_count) {
 		/* resume interrupt URBs */
 		if (dev->urb_intr && test_bit(EVENT_DEV_OPEN, &dev->flags))
-				usb_submit_urb(dev->urb_intr, GFP_NOIO);
+			usb_submit_urb(dev->urb_intr, GFP_NOIO);
 
 		spin_lock_irq(&dev->txq.lock);
 		while ((res = usb_get_from_anchor(&dev->deferred))) {
-- 
2.25.1

