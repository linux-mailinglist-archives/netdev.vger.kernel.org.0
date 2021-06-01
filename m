Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3303974E7
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhFAOGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:06:21 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3371 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbhFAOGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:06:19 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FvYj03g5Vz65Qn;
        Tue,  1 Jun 2021 22:00:52 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 22:04:34 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <oliver@neukum.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: usb: Fix spelling mistakes
Date:   Tue, 1 Jun 2021 22:18:13 +0800
Message-ID: <20210601141813.4131621-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wierdness  ==> weirdness
multicat  ==> multicast
limite  ==> limit
adddress  ==> address
operater  ==> operator
intial  ==> initial
smaler  ==> smaller
Communcation  ==> Communication
funcitons  ==> functions
everytime  ==> every time
Neigbor  ==> Neighbor
performace  ==> performance

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/usb/cdc_ether.c  | 2 +-
 drivers/net/usb/cdc_mbim.c   | 6 +++---
 drivers/net/usb/cdc_ncm.c    | 4 ++--
 drivers/net/usb/int51x1.c    | 2 +-
 drivers/net/usb/lan78xx.c    | 2 +-
 drivers/net/usb/lg-vl600.c   | 4 ++--
 drivers/net/usb/r8152.c      | 4 ++--
 drivers/net/usb/rndis_host.c | 2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 7eb0109e9baa..eb3817d70f2b 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -217,7 +217,7 @@ int usbnet_generic_cdc_bind(struct usbnet *dev, struct usb_interface *intf)
 		goto bad_desc;
 	}
 skip:
-	/* Communcation class functions with bmCapabilities are not
+	/* Communication class functions with bmCapabilities are not
 	 * RNDIS.  But some Wireless class RNDIS functions use
 	 * bmCapabilities for their own purpose. The failsafe is
 	 * therefore applied only to Communication class RNDIS
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 5db66272fc82..98bb1597fdea 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -300,8 +300,8 @@ static struct sk_buff *cdc_mbim_tx_fixup(struct usbnet *dev, struct sk_buff *skb
 	return NULL;
 }
 
-/* Some devices are known to send Neigbor Solicitation messages and
- * require Neigbor Advertisement replies.  The IPv6 core will not
+/* Some devices are known to send Neighbor Solicitation messages and
+ * require Neighbor Advertisement replies.  The IPv6 core will not
  * respond since IFF_NOARP is set, so we must handle them ourselves.
  */
 static void do_neigh_solicit(struct usbnet *dev, u8 *buf, u16 tci)
@@ -588,7 +588,7 @@ static const struct driver_info cdc_mbim_info_zlp = {
  *
  * Note: The current implementation of this feature restricts each NTB
  * to a single NDP, implying that multiplexed sessions cannot share an
- * NTB. This might affect performace for multiplexed sessions.
+ * NTB. This might affect performance for multiplexed sessions.
  */
 static const struct driver_info cdc_mbim_info_ndp_to_end = {
 	.description = "CDC MBIM",
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index b04055fd1b79..4486bcaefbe6 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -628,7 +628,7 @@ static void cdc_ncm_set_dgram_size(struct usbnet *dev, int new_size)
 	/* set MTU to max supported by the device if necessary */
 	dev->net->mtu = min_t(int, dev->net->mtu, ctx->max_datagram_size - cdc_ncm_eth_hlen(dev));
 
-	/* do not exceed operater preferred MTU */
+	/* do not exceed operator preferred MTU */
 	if (ctx->mbim_extended_desc) {
 		mbim_mtu = le16_to_cpu(ctx->mbim_extended_desc->wMTU);
 		if (mbim_mtu != 0 && mbim_mtu < dev->net->mtu)
@@ -685,7 +685,7 @@ static int cdc_ncm_setup(struct usbnet *dev)
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
 	u32 def_rx, def_tx;
 
-	/* be conservative when selecting intial buffer size to
+	/* be conservative when selecting initial buffer size to
 	 * increase the number of hosts this will work for
 	 */
 	def_rx = min_t(u32, CDC_NCM_NTB_DEF_SIZE_RX,
diff --git a/drivers/net/usb/int51x1.c b/drivers/net/usb/int51x1.c
index ed05f992c612..6fde41550de1 100644
--- a/drivers/net/usb/int51x1.c
+++ b/drivers/net/usb/int51x1.c
@@ -61,7 +61,7 @@ static struct sk_buff *int51x1_tx_fixup(struct usbnet *dev,
 	int need_tail = 0;
 	__le16 *len;
 
-	/* if packet and our header is smaler than 64 pad to 64 (+ ZLP) */
+	/* if packet and our header is smaller than 64 pad to 64 (+ ZLP) */
 	if ((pack_with_header_len) < dev->maxpacket)
 		need_tail = dev->maxpacket - pack_with_header_len + 1;
 	/*
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 02bce40a67e5..25489389ea49 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -298,7 +298,7 @@ struct lan78xx_net;
 struct lan78xx_priv {
 	struct lan78xx_net *dev;
 	u32 rfe_ctl;
-	u32 mchash_table[DP_SEL_VHF_HASH_LEN]; /* multicat hash table */
+	u32 mchash_table[DP_SEL_VHF_HASH_LEN]; /* multicast hash table */
 	u32 pfilter_table[NUM_OF_MAF][2]; /* perfect filter table */
 	u32 vlan_table[DP_SEL_VHF_VLAN_LEN];
 	struct mutex dataport_mutex; /* for dataport access */
diff --git a/drivers/net/usb/lg-vl600.c b/drivers/net/usb/lg-vl600.c
index 217a2d8fa47b..b2495fa80171 100644
--- a/drivers/net/usb/lg-vl600.c
+++ b/drivers/net/usb/lg-vl600.c
@@ -31,7 +31,7 @@
  * Windows/Mac drivers do send a couple of such frames to the device
  * during initialisation, with protocol set to 0x0906 or 0x0b06 and (what
  * seems to be) a flag in the .dummy_flags.  This doesn't seem necessary
- * for modem operation but can possibly be used for GPS or other funcitons.
+ * for modem operation but can possibly be used for GPS or other functions.
  */
 
 struct vl600_frame_hdr {
@@ -72,7 +72,7 @@ static int vl600_bind(struct usbnet *dev, struct usb_interface *intf)
 	/* ARP packets don't go through, but they're also of no use.  The
 	 * subnet has only two hosts anyway: us and the gateway / DHCP
 	 * server (probably simulated by modem firmware or network operator)
-	 * whose address changes everytime we connect to the intarwebz and
+	 * whose address changes every time we connect to the intarwebz and
 	 * who doesn't bother answering ARP requests either.  So hardware
 	 * addresses have no meaning, the destination and the source of every
 	 * packet depend only on whether it is on the IN or OUT endpoint.  */
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f6abb2fbf972..b5adb6a75c61 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2445,7 +2445,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 			unsigned int pkt_len, rx_frag_head_sz;
 			struct sk_buff *skb;
 
-			/* limite the skb numbers for rx_queue */
+			/* limit the skb numbers for rx_queue */
 			if (unlikely(skb_queue_len(&tp->rx_queue) >= 1000))
 				break;
 
@@ -8211,7 +8211,7 @@ static int rtl8152_post_reset(struct usb_interface *intf)
 	if (!tp)
 		return 0;
 
-	/* reset the MAC adddress in case of policy change */
+	/* reset the MAC address in case of policy change */
 	if (determine_ethernet_addr(tp, &sa) >= 0) {
 		rtnl_lock();
 		dev_set_mac_address (tp->netdev, &sa, NULL);
diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index f813ca9dec53..85a8b96e39a6 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -324,7 +324,7 @@ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
 	 * For RX we handle drivers that zero-pad to end-of-packet.
 	 * Don't let userspace change these settings.
 	 *
-	 * NOTE: there still seems to be wierdness here, as if we need
+	 * NOTE: there still seems to be weirdness here, as if we need
 	 * to do some more things to make sure WinCE targets accept this.
 	 * They default to jumbograms of 8KB or 16KB, which is absurd
 	 * for such low data rates and which is also more than Linux
-- 
2.25.1

