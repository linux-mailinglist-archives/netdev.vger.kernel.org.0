Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2959134C61A
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhC2IE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:04:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15086 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbhC2IDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:03:54 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F84mF03pFz19Js9;
        Mon, 29 Mar 2021 16:01:49 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 16:03:41 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sebastian.hesselbarth@gmail.com>, <thomas.petazzoni@bootlin.com>,
        <mlindner@marvell.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Yangyang Li <liyangyang20@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 2/4] net: marvell: Fix the trailing format of some block comments
Date:   Mon, 29 Mar 2021 16:01:10 +0800
Message-ID: <1617004872-38974-3-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617004872-38974-1-git-send-email-liweihang@huawei.com>
References: <1617004872-38974-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

Use a trailing */ on a separate line for block comments.

Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 6 ++++--
 drivers/net/ethernet/marvell/mvneta.c      | 6 ++++--
 drivers/net/ethernet/marvell/sky2.c        | 9 ++++++---
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 90e6111..860b531 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -700,7 +700,8 @@ static int skb_tx_csum(struct mv643xx_eth_private *mp, struct sk_buff *skb,
 			   ip_hdr(skb)->ihl << TX_IHL_SHIFT;
 
 		/* TODO: Revisit this. With the usage of GEN_TCP_UDP_CHK_FULL
-		 * it seems we don't need to pass the initial checksum. */
+		 * it seems we don't need to pass the initial checksum.
+		 */
 		switch (ip_hdr(skb)->protocol) {
 		case IPPROTO_UDP:
 			cmd |= UDP_FRAME;
@@ -790,7 +791,8 @@ txq_put_hdr_tso(struct sk_buff *skb, struct tx_queue *txq, int length,
 		WARN(1, "failed to prepare checksum!");
 
 	/* Should we set this? Can't use the value from skb_tx_csum()
-	 * as it's not the correct initial L4 checksum to use. */
+	 * as it's not the correct initial L4 checksum to use.
+	 */
 	desc->l4i_chk = 0;
 
 	desc->byte_cnt = hdr_len;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 88545be..3c6f4db 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3993,7 +3993,8 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 
 	/* Armada 370 documentation says we can only change the port mode
 	 * and in-band enable when the link is down, so force it down
-	 * while making these changes. We also do this for GMAC_CTRL2 */
+	 * while making these changes. We also do this for GMAC_CTRL2
+	 */
 	if ((new_ctrl0 ^ gmac_ctrl0) & MVNETA_GMAC0_PORT_1000BASE_X ||
 	    (new_ctrl2 ^ gmac_ctrl2) & MVNETA_GMAC2_INBAND_AN_ENABLE ||
 	    (new_an  ^ gmac_an) & MVNETA_GMAC_INBAND_AN_ENABLE) {
@@ -4900,7 +4901,8 @@ static int mvneta_ethtool_set_eee(struct net_device *dev,
 	u32 lpi_ctl0;
 
 	/* The Armada 37x documents do not give limits for this other than
-	 * it being an 8-bit register. */
+	 * it being an 8-bit register.
+	 */
 	if (eee->tx_lpi_enabled && eee->tx_lpi_timer > 255)
 		return -EINVAL;
 
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index ebe1406..0ce43d7 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -55,7 +55,8 @@
 #define RX_DEF_PENDING		RX_MAX_PENDING
 
 /* This is the worst case number of transmit list elements for a single skb:
-   VLAN:GSO + CKSUM + Data + skb_frags * DMA */
+ * VLAN:GSO + CKSUM + Data + skb_frags * DMA
+ */
 #define MAX_SKB_TX_LE	(2 + (sizeof(dma_addr_t)/sizeof(u32))*(MAX_SKB_FRAGS+1))
 #define TX_MIN_PENDING		(MAX_SKB_TX_LE+1)
 #define TX_MAX_PENDING		1024
@@ -1529,7 +1530,8 @@ static void sky2_rx_start(struct sky2_port *sky2)
 		sky2_write32(hw, Q_ADDR(rxq, Q_WM), BMU_WM_PEX);
 
 	/* These chips have no ram buffer?
-	 * MAC Rx RAM Read is controlled by hardware */
+	 * MAC Rx RAM Read is controlled by hardware
+	 */
 	if (hw->chip_id == CHIP_ID_YUKON_EC_U &&
 	    hw->chip_rev > CHIP_REV_YU_EC_U_A0)
 		sky2_write32(hw, Q_ADDR(rxq, Q_TEST), F_M_RX_RAM_DIS);
@@ -4684,7 +4686,8 @@ static __exit void sky2_debug_cleanup(void)
 #endif
 
 /* Two copies of network device operations to handle special case of
-   not allowing netpoll on second port */
+ * not allowing netpoll on second port
+ */
 static const struct net_device_ops sky2_netdev_ops[2] = {
   {
 	.ndo_open		= sky2_open,
-- 
2.8.1

