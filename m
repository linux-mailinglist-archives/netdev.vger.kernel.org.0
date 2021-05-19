Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96ED3886B4
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244199AbhESFi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:38:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3031 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243123AbhESFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:36:03 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FlM2F2qlfzmX7P;
        Wed, 19 May 2021 13:32:21 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:37 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:36 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH 10/20] net: marvell: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:43 +0800
Message-ID: <1621402253-27200-11-git-send-email-tanghui20@huawei.com>
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

Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/marvell/skge.h |  2 +-
 drivers/net/ethernet/marvell/sky2.c | 30 +++++++++++++++---------------
 drivers/net/ethernet/marvell/sky2.h |  8 ++++----
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.h b/drivers/net/ethernet/marvell/skge.h
index 6928abc..f722173 100644
--- a/drivers/net/ethernet/marvell/skge.h
+++ b/drivers/net/ethernet/marvell/skge.h
@@ -263,7 +263,7 @@ enum {
 	CHIP_ID_YUKON_LP   = 0xb2, /* Chip ID for YUKON-LP */
 	CHIP_ID_YUKON_XL   = 0xb3, /* Chip ID for YUKON-2 XL */
 	CHIP_ID_YUKON_EC   = 0xb6, /* Chip ID for YUKON-2 EC */
- 	CHIP_ID_YUKON_FE   = 0xb7, /* Chip ID for YUKON-2 FE */
+	CHIP_ID_YUKON_FE   = 0xb7, /* Chip ID for YUKON-2 FE */
 
 	CHIP_REV_YU_LITE_A1  = 3,	/* Chip Rev. for YUKON-Lite A1,A2 */
 	CHIP_REV_YU_LITE_A3  = 7,	/* Chip Rev. for YUKON-Lite A3 */
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 222c323..324c280 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -471,7 +471,7 @@ static void sky2_phy_init(struct sky2_hw *hw, unsigned port)
 			adv |= fiber_fc_adv[sky2->flow_mode];
 	} else {
 		reg |= GM_GPCR_AU_FCT_DIS;
- 		reg |= gm_fc_disable[sky2->flow_mode];
+		reg |= gm_fc_disable[sky2->flow_mode];
 
 		/* Forward pause packets to GMAC? */
 		if (sky2->flow_mode & FC_RX)
@@ -1656,16 +1656,16 @@ static void sky2_hw_up(struct sky2_port *sky2)
 	tx_init(sky2);
 
 	/*
- 	 * On dual port PCI-X card, there is an problem where status
+	 * On dual port PCI-X card, there is an problem where status
 	 * can be received out of order due to split transactions
 	 */
 	if (otherdev && netif_running(otherdev) &&
- 	    (cap = pci_find_capability(hw->pdev, PCI_CAP_ID_PCIX))) {
- 		u16 cmd;
+	    (cap = pci_find_capability(hw->pdev, PCI_CAP_ID_PCIX))) {
+		u16 cmd;
 
 		cmd = sky2_pci_read16(hw, cap + PCI_X_CMD);
- 		cmd &= ~PCI_X_CMD_MAX_SPLIT;
- 		sky2_pci_write16(hw, cap + PCI_X_CMD, cmd);
+		cmd &= ~PCI_X_CMD_MAX_SPLIT;
+		sky2_pci_write16(hw, cap + PCI_X_CMD, cmd);
 	}
 
 	sky2_mac_init(hw, port);
@@ -1836,8 +1836,8 @@ static netdev_tx_t sky2_xmit_frame(struct sk_buff *skb,
 	u16 mss;
 	u8 ctrl;
 
- 	if (unlikely(tx_avail(sky2) < tx_le_req(skb)))
-  		return NETDEV_TX_BUSY;
+	if (unlikely(tx_avail(sky2) < tx_le_req(skb)))
+		return NETDEV_TX_BUSY;
 
 	len = skb_headlen(skb);
 	mapping = dma_map_single(&hw->pdev->dev, skb->data, len,
@@ -1866,9 +1866,9 @@ static netdev_tx_t sky2_xmit_frame(struct sk_buff *skb,
 		if (!(hw->flags & SKY2_HW_NEW_LE))
 			mss += ETH_HLEN + ip_hdrlen(skb) + tcp_hdrlen(skb);
 
-  		if (mss != sky2->tx_last_mss) {
+		if (mss != sky2->tx_last_mss) {
 			le = get_tx_le(sky2, &slot);
-  			le->addr = cpu_to_le32(mss);
+			le->addr = cpu_to_le32(mss);
 
 			if (hw->flags & SKY2_HW_NEW_LE)
 				le->opcode = OP_MSS | HW_OWNER;
@@ -1895,8 +1895,8 @@ static netdev_tx_t sky2_xmit_frame(struct sk_buff *skb,
 	/* Handle TCP checksum offload */
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		/* On Yukon EX (some versions) encoding change. */
- 		if (hw->flags & SKY2_HW_AUTO_TX_SUM)
- 			ctrl |= CALSUM;	/* auto checksum */
+		if (hw->flags & SKY2_HW_AUTO_TX_SUM)
+			ctrl |= CALSUM;	/* auto checksum */
 		else {
 			const unsigned offset = skb_transport_offset(skb);
 			u32 tcpsum;
@@ -2557,7 +2557,7 @@ static struct sk_buff *receive_new(struct sky2_port *sky2,
 static struct sk_buff *sky2_receive(struct net_device *dev,
 				    u16 length, u32 status)
 {
- 	struct sky2_port *sky2 = netdev_priv(dev);
+	struct sky2_port *sky2 = netdev_priv(dev);
 	struct rx_ring_info *re = sky2->rx_ring + sky2->rx_next;
 	struct sk_buff *skb = NULL;
 	u16 count = (status & GMR_FS_LEN) >> 16;
@@ -5063,11 +5063,11 @@ static int sky2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!disable_msi && pci_enable_msi(pdev) == 0) {
 		err = sky2_test_msi(hw);
 		if (err) {
- 			pci_disable_msi(pdev);
+			pci_disable_msi(pdev);
 			if (err != -EOPNOTSUPP)
 				goto err_out_free_netdev;
 		}
- 	}
+	}
 
 	netif_napi_add(dev, &hw->napi, sky2_poll, NAPI_WEIGHT);
 
diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/marvell/sky2.h
index b2dddd8..ddec162 100644
--- a/drivers/net/ethernet/marvell/sky2.h
+++ b/drivers/net/ethernet/marvell/sky2.h
@@ -538,8 +538,8 @@ enum {
 	CHIP_ID_YUKON_EC_U = 0xb4, /* YUKON-2 EC Ultra */
 	CHIP_ID_YUKON_EX   = 0xb5, /* YUKON-2 Extreme */
 	CHIP_ID_YUKON_EC   = 0xb6, /* YUKON-2 EC */
- 	CHIP_ID_YUKON_FE   = 0xb7, /* YUKON-2 FE */
- 	CHIP_ID_YUKON_FE_P = 0xb8, /* YUKON-2 FE+ */
+	CHIP_ID_YUKON_FE   = 0xb7, /* YUKON-2 FE */
+	CHIP_ID_YUKON_FE_P = 0xb8, /* YUKON-2 FE+ */
 	CHIP_ID_YUKON_SUPR = 0xb9, /* YUKON-2 Supreme */
 	CHIP_ID_YUKON_UL_2 = 0xba, /* YUKON-2 Ultra 2 */
 	CHIP_ID_YUKON_OPT  = 0xbc, /* YUKON-2 Optima */
@@ -2262,8 +2262,8 @@ struct sky2_port {
 #define SKY2_FLAG_AUTO_SPEED		0x0002
 #define SKY2_FLAG_AUTO_PAUSE		0x0004
 
- 	enum flow_control    flow_mode;
- 	enum flow_control    flow_status;
+	enum flow_control    flow_mode;
+	enum flow_control    flow_status;
 
 #ifdef CONFIG_SKY2_DEBUG
 	struct dentry	     *debugfs;
-- 
2.8.1

