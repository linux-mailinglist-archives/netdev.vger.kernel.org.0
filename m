Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D3C50D1C8
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 15:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiDXNGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 09:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiDXNGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 09:06:15 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E2D17C51C;
        Sun, 24 Apr 2022 06:03:14 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KmStZ1qGrzGp43;
        Sun, 24 Apr 2022 21:00:38 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 24 Apr 2022 21:03:12 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 24 Apr 2022 21:03:12 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 2/6] net: hns3: align the debugfs output to the left
Date:   Sun, 24 Apr 2022 20:57:21 +0800
Message-ID: <20220424125725.43232-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220424125725.43232-1-huangguangbin2@huawei.com>
References: <20220424125725.43232-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

For debugfs node rx/tx_queue_info and rx/tx_bd_info, their output info is
aligned to the right, it's not aligned with output of other debugfs node,
so uniform their output info.

Fixes: 907676b13071 ("net: hns3: use tx bounce buffer for small packets")
Fixes: e44c495d95e0 ("net: hns3: refactor queue info of debugfs")
Fixes: 77e9184869c9 ("net: hns3: refactor dump bd info of debugfs")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 84 +++++++++----------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 44d9b560b337..93aeb615191d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -562,12 +562,12 @@ static void hns3_dbg_tx_spare_info(struct hns3_enet_ring *ring, char *buf,
 
 	for (i = 0; i < ring_num; i++) {
 		j = 0;
-		sprintf(result[j++], "%8u", i);
-		sprintf(result[j++], "%9u", ring->tx_copybreak);
-		sprintf(result[j++], "%3u", tx_spare->len);
-		sprintf(result[j++], "%3u", tx_spare->next_to_use);
-		sprintf(result[j++], "%3u", tx_spare->next_to_clean);
-		sprintf(result[j++], "%3u", tx_spare->last_to_clean);
+		sprintf(result[j++], "%u", i);
+		sprintf(result[j++], "%u", ring->tx_copybreak);
+		sprintf(result[j++], "%u", tx_spare->len);
+		sprintf(result[j++], "%u", tx_spare->next_to_use);
+		sprintf(result[j++], "%u", tx_spare->next_to_clean);
+		sprintf(result[j++], "%u", tx_spare->last_to_clean);
 		sprintf(result[j++], "%pad", &tx_spare->dma);
 		hns3_dbg_fill_content(content, sizeof(content),
 				      tx_spare_info_items,
@@ -598,35 +598,35 @@ static void hns3_dump_rx_queue_info(struct hns3_enet_ring *ring,
 	u32 base_add_l, base_add_h;
 	u32 j = 0;
 
-	sprintf(result[j++], "%8u", index);
+	sprintf(result[j++], "%u", index);
 
-	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_RX_RING_BD_NUM_REG));
 
-	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_RX_RING_BD_LEN_REG));
 
-	sprintf(result[j++], "%4u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_RX_RING_TAIL_REG));
 
-	sprintf(result[j++], "%4u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_RX_RING_HEAD_REG));
 
-	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_RX_RING_FBDNUM_REG));
 
-	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_RX_RING_PKTNUM_RECORD_REG));
-	sprintf(result[j++], "%9u", ring->rx_copybreak);
+	sprintf(result[j++], "%u", ring->rx_copybreak);
 
-	sprintf(result[j++], "%7s", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%s", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_EN_REG) ? "on" : "off");
 
 	if (hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev))
-		sprintf(result[j++], "%10s", readl_relaxed(ring->tqp->io_base +
+		sprintf(result[j++], "%s", readl_relaxed(ring->tqp->io_base +
 			HNS3_RING_RX_EN_REG) ? "on" : "off");
 	else
-		sprintf(result[j++], "%10s", "NA");
+		sprintf(result[j++], "%s", "NA");
 
 	base_add_h = readl_relaxed(ring->tqp->io_base +
 					HNS3_RING_RX_RING_BASEADDR_H_REG);
@@ -700,36 +700,36 @@ static void hns3_dump_tx_queue_info(struct hns3_enet_ring *ring,
 	u32 base_add_l, base_add_h;
 	u32 j = 0;
 
-	sprintf(result[j++], "%8u", index);
-	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", index);
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_TX_RING_BD_NUM_REG));
 
-	sprintf(result[j++], "%2u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_TX_RING_TC_REG));
 
-	sprintf(result[j++], "%4u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_TX_RING_TAIL_REG));
 
-	sprintf(result[j++], "%4u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_TX_RING_HEAD_REG));
 
-	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_TX_RING_FBDNUM_REG));
 
-	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_TX_RING_OFFSET_REG));
 
-	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_TX_RING_PKTNUM_RECORD_REG));
 
-	sprintf(result[j++], "%7s", readl_relaxed(ring->tqp->io_base +
+	sprintf(result[j++], "%s", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_EN_REG) ? "on" : "off");
 
 	if (hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev))
-		sprintf(result[j++], "%10s", readl_relaxed(ring->tqp->io_base +
+		sprintf(result[j++], "%s", readl_relaxed(ring->tqp->io_base +
 			HNS3_RING_TX_EN_REG) ? "on" : "off");
 	else
-		sprintf(result[j++], "%10s", "NA");
+		sprintf(result[j++], "%s", "NA");
 
 	base_add_h = readl_relaxed(ring->tqp->io_base +
 					HNS3_RING_TX_RING_BASEADDR_H_REG);
@@ -848,15 +848,15 @@ static void hns3_dump_rx_bd_info(struct hns3_nic_priv *priv,
 {
 	unsigned int j = 0;
 
-	sprintf(result[j++], "%5d", idx);
+	sprintf(result[j++], "%d", idx);
 	sprintf(result[j++], "%#x", le32_to_cpu(desc->rx.l234_info));
-	sprintf(result[j++], "%7u", le16_to_cpu(desc->rx.pkt_len));
-	sprintf(result[j++], "%4u", le16_to_cpu(desc->rx.size));
+	sprintf(result[j++], "%u", le16_to_cpu(desc->rx.pkt_len));
+	sprintf(result[j++], "%u", le16_to_cpu(desc->rx.size));
 	sprintf(result[j++], "%#x", le32_to_cpu(desc->rx.rss_hash));
-	sprintf(result[j++], "%5u", le16_to_cpu(desc->rx.fd_id));
-	sprintf(result[j++], "%8u", le16_to_cpu(desc->rx.vlan_tag));
-	sprintf(result[j++], "%15u", le16_to_cpu(desc->rx.o_dm_vlan_id_fb));
-	sprintf(result[j++], "%11u", le16_to_cpu(desc->rx.ot_vlan_tag));
+	sprintf(result[j++], "%u", le16_to_cpu(desc->rx.fd_id));
+	sprintf(result[j++], "%u", le16_to_cpu(desc->rx.vlan_tag));
+	sprintf(result[j++], "%u", le16_to_cpu(desc->rx.o_dm_vlan_id_fb));
+	sprintf(result[j++], "%u", le16_to_cpu(desc->rx.ot_vlan_tag));
 	sprintf(result[j++], "%#x", le32_to_cpu(desc->rx.bd_base_info));
 	if (test_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state)) {
 		u32 ol_info = le32_to_cpu(desc->rx.ol_info);
@@ -930,19 +930,19 @@ static void hns3_dump_tx_bd_info(struct hns3_nic_priv *priv,
 {
 	unsigned int j = 0;
 
-	sprintf(result[j++], "%6d", idx);
+	sprintf(result[j++], "%d", idx);
 	sprintf(result[j++], "%#llx", le64_to_cpu(desc->addr));
-	sprintf(result[j++], "%5u", le16_to_cpu(desc->tx.vlan_tag));
-	sprintf(result[j++], "%5u", le16_to_cpu(desc->tx.send_size));
+	sprintf(result[j++], "%u", le16_to_cpu(desc->tx.vlan_tag));
+	sprintf(result[j++], "%u", le16_to_cpu(desc->tx.send_size));
 	sprintf(result[j++], "%#x",
 		le32_to_cpu(desc->tx.type_cs_vlan_tso_len));
-	sprintf(result[j++], "%5u", le16_to_cpu(desc->tx.outer_vlan_tag));
-	sprintf(result[j++], "%5u", le16_to_cpu(desc->tx.tv));
-	sprintf(result[j++], "%10u",
+	sprintf(result[j++], "%u", le16_to_cpu(desc->tx.outer_vlan_tag));
+	sprintf(result[j++], "%u", le16_to_cpu(desc->tx.tv));
+	sprintf(result[j++], "%u",
 		le32_to_cpu(desc->tx.ol_type_vlan_len_msec));
 	sprintf(result[j++], "%#x", le32_to_cpu(desc->tx.paylen_ol4cs));
 	sprintf(result[j++], "%#x", le16_to_cpu(desc->tx.bdtp_fe_sc_vld_ra_ri));
-	sprintf(result[j++], "%5u", le16_to_cpu(desc->tx.mss_hw_csum));
+	sprintf(result[j++], "%u", le16_to_cpu(desc->tx.mss_hw_csum));
 }
 
 static int hns3_dbg_tx_bd_info(struct hns3_dbg_data *d, char *buf, int len)
-- 
2.33.0

