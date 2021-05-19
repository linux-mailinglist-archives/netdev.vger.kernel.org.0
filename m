Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C083886B8
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344733AbhESFiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:38:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3417 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243360AbhESFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:36:03 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FlM1h67x3zCt8n;
        Wed, 19 May 2021 13:31:52 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:38 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>
Subject: [PATCH 16/20] net: sun: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:49 +0800
Message-ID: <1621402253-27200-17-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/sun/cassini.c |  2 +-
 drivers/net/ethernet/sun/sungem.c  | 20 ++++++++++----------
 drivers/net/ethernet/sun/sunhme.c  |  6 +++---
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 54f45d8..981685c 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -486,7 +486,7 @@ static cas_page_t *cas_page_alloc(struct cas *cp, const gfp_t flags)
 /* initialize spare pool of rx buffers, but allocate during the open */
 static void cas_spare_init(struct cas *cp)
 {
-  	spin_lock(&cp->rx_inuse_lock);
+	spin_lock(&cp->rx_inuse_lock);
 	INIT_LIST_HEAD(&cp->rx_inuse_list);
 	spin_unlock(&cp->rx_inuse_lock);
 
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 9790656..cfb9e21 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -1258,8 +1258,8 @@ static void gem_begin_auto_negotiation(struct gem *gp,
 			&advertising, ep->link_modes.advertising);
 
 	if (gp->phy_type != phy_mii_mdio0 &&
-     	    gp->phy_type != phy_mii_mdio1)
-     	    	goto non_mii;
+	    gp->phy_type != phy_mii_mdio1)
+		goto non_mii;
 
 	/* Setup advertise */
 	if (found_mii_phy(gp))
@@ -1410,7 +1410,7 @@ static int gem_set_link_modes(struct gem *gp)
 
 	if (gp->phy_type == phy_serialink ||
 	    gp->phy_type == phy_serdes) {
- 		u32 pcs_lpa = readl(gp->regs + PCS_MIILP);
+		u32 pcs_lpa = readl(gp->regs + PCS_MIILP);
 
 		if (pcs_lpa & (PCS_MIIADV_SP | PCS_MIIADV_AP))
 			pause = 1;
@@ -1892,7 +1892,7 @@ static void gem_init_mac(struct gem *gp)
 
 static void gem_init_pause_thresholds(struct gem *gp)
 {
-       	u32 cfg;
+	u32 cfg;
 
 	/* Calculate pause thresholds.  Setting the OFF threshold to the
 	 * full RX fifo size effectively disables PAUSE generation which
@@ -1914,15 +1914,15 @@ static void gem_init_pause_thresholds(struct gem *gp)
 	/* Configure the chip "burst" DMA mode & enable some
 	 * HW bug fixes on Apple version
 	 */
-       	cfg  = 0;
-       	if (gp->pdev->vendor == PCI_VENDOR_ID_APPLE)
+	cfg  = 0;
+	if (gp->pdev->vendor == PCI_VENDOR_ID_APPLE)
 		cfg |= GREG_CFG_RONPAULBIT | GREG_CFG_ENBUG2FIX;
 #if !defined(CONFIG_SPARC64) && !defined(CONFIG_ALPHA)
-       	cfg |= GREG_CFG_IBURST;
+	cfg |= GREG_CFG_IBURST;
 #endif
-       	cfg |= ((31 << 1) & GREG_CFG_TXDMALIM);
-       	cfg |= ((31 << 6) & GREG_CFG_RXDMALIM);
-       	writel(cfg, gp->regs + GREG_CFG);
+	cfg |= ((31 << 1) & GREG_CFG_TXDMALIM);
+	cfg |= ((31 << 6) & GREG_CFG_RXDMALIM);
+	writel(cfg, gp->regs + GREG_CFG);
 
 	/* If Infinite Burst didn't stick, then use different
 	 * thresholds (and Apple bug fixes don't exist)
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 54b53db..a2c1a40 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2286,8 +2286,8 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev)
 {
 	struct happy_meal *hp = netdev_priv(dev);
- 	int entry;
- 	u32 tx_flags;
+	int entry;
+	u32 tx_flags;
 
 	tx_flags = TXFLAG_OWN;
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
@@ -2301,7 +2301,7 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 
 	spin_lock_irq(&hp->happy_lock);
 
- 	if (TX_BUFFS_AVAIL(hp) <= (skb_shinfo(skb)->nr_frags + 1)) {
+	if (TX_BUFFS_AVAIL(hp) <= (skb_shinfo(skb)->nr_frags + 1)) {
 		netif_stop_queue(dev);
 		spin_unlock_irq(&hp->happy_lock);
 		printk(KERN_ERR "%s: BUG! Tx Ring full when queue awake!\n",
-- 
2.8.1

