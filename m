Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD4293827F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 04:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfFGCFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 22:05:31 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58504 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728201AbfFGCFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 22:05:25 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 096333E3275C83007B9A;
        Fri,  7 Jun 2019 10:05:18 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 7 Jun 2019 10:05:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        HuiSong Li <lihuisong@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 12/12] net: hns3: fix some coding style issues
Date:   Fri, 7 Jun 2019 10:03:13 +0800
Message-ID: <1559872993-14507-13-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
References: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

This patch fixes some coding style issues reported by some static code
analysis tools and code review, such as modify some comments, rename
some variables, log some errors in detail, and fixes some alignment
errors.

BTW, these cleanups do not change the logic of code.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: HuiSong Li <lihuisong@huawei.com>
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c   | 12 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 73 +++++++++-------------
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  6 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 10 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 15 +++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 70 ++++++++-------------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 22 ++++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 18 ++----
 8 files changed, 96 insertions(+), 130 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c b/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
index b6fabbb..d2ec4c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
@@ -4,8 +4,7 @@
 #include "hnae3.h"
 #include "hns3_enet.h"
 
-static
-int hns3_dcbnl_ieee_getets(struct net_device *ndev, struct ieee_ets *ets)
+static int hns3_dcbnl_ieee_getets(struct net_device *ndev, struct ieee_ets *ets)
 {
 	struct hnae3_handle *h = hns3_get_handle(ndev);
 
@@ -18,8 +17,7 @@ int hns3_dcbnl_ieee_getets(struct net_device *ndev, struct ieee_ets *ets)
 	return -EOPNOTSUPP;
 }
 
-static
-int hns3_dcbnl_ieee_setets(struct net_device *ndev, struct ieee_ets *ets)
+static int hns3_dcbnl_ieee_setets(struct net_device *ndev, struct ieee_ets *ets)
 {
 	struct hnae3_handle *h = hns3_get_handle(ndev);
 
@@ -32,8 +30,7 @@ int hns3_dcbnl_ieee_setets(struct net_device *ndev, struct ieee_ets *ets)
 	return -EOPNOTSUPP;
 }
 
-static
-int hns3_dcbnl_ieee_getpfc(struct net_device *ndev, struct ieee_pfc *pfc)
+static int hns3_dcbnl_ieee_getpfc(struct net_device *ndev, struct ieee_pfc *pfc)
 {
 	struct hnae3_handle *h = hns3_get_handle(ndev);
 
@@ -46,8 +43,7 @@ int hns3_dcbnl_ieee_getpfc(struct net_device *ndev, struct ieee_pfc *pfc)
 	return -EOPNOTSUPP;
 }
 
-static
-int hns3_dcbnl_ieee_setpfc(struct net_device *ndev, struct ieee_pfc *pfc)
+static int hns3_dcbnl_ieee_setpfc(struct net_device *ndev, struct ieee_pfc *pfc)
 {
 	struct hnae3_handle *h = hns3_get_handle(ndev);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 07e7c3a..fe2c2c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -139,8 +139,7 @@ static int hns3_nic_init_irq(struct hns3_nic_priv *priv)
 		tqp_vectors->name[HNAE3_INT_NAME_LEN - 1] = '\0';
 
 		ret = request_irq(tqp_vectors->vector_irq, hns3_irq_handle, 0,
-				  tqp_vectors->name,
-				       tqp_vectors);
+				  tqp_vectors->name, tqp_vectors);
 		if (ret) {
 			netdev_err(priv->netdev, "request irq(%d) fail\n",
 				   tqp_vectors->vector_irq);
@@ -277,8 +276,7 @@ static int hns3_nic_set_real_num_queue(struct net_device *netdev)
 	ret = netif_set_real_num_tx_queues(netdev, queue_size);
 	if (ret) {
 		netdev_err(netdev,
-			   "netif_set_real_num_tx_queues fail, ret=%d!\n",
-			   ret);
+			   "netif_set_real_num_tx_queues fail, ret=%d!\n", ret);
 		return ret;
 	}
 
@@ -373,7 +371,7 @@ static int hns3_nic_net_up(struct net_device *netdev)
 	/* get irq resource for all vectors */
 	ret = hns3_nic_init_irq(priv);
 	if (ret) {
-		netdev_err(netdev, "hns init irq failed! ret=%d\n", ret);
+		netdev_err(netdev, "init irq failed! ret=%d\n", ret);
 		goto free_rmap;
 	}
 
@@ -449,16 +447,13 @@ static int hns3_nic_net_open(struct net_device *netdev)
 
 	ret = hns3_nic_net_up(netdev);
 	if (ret) {
-		netdev_err(netdev,
-			   "hns net up fail, ret=%d!\n", ret);
+		netdev_err(netdev, "net up fail, ret=%d!\n", ret);
 		return ret;
 	}
 
 	kinfo = &h->kinfo;
-	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++) {
-		netdev_set_prio_tc_map(netdev, i,
-				       kinfo->prio_tc[i]);
-	}
+	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
+		netdev_set_prio_tc_map(netdev, i, kinfo->prio_tc[i]);
 
 	if (h->ae_algo->ops->set_timer_task)
 		h->ae_algo->ops->set_timer_task(priv->ae_handle, true);
@@ -663,7 +658,7 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen,
 	if (l3.v4->version == 4)
 		l3.v4->check = 0;
 
-	/* tunnel packet.*/
+	/* tunnel packet */
 	if (skb_shinfo(skb)->gso_type & (SKB_GSO_GRE |
 					 SKB_GSO_GRE_CSUM |
 					 SKB_GSO_UDP_TUNNEL |
@@ -688,11 +683,11 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen,
 			l3.v4->check = 0;
 	}
 
-	/* normal or tunnel packet*/
+	/* normal or tunnel packet */
 	l4_offset = l4.hdr - skb->data;
 	hdr_len = (l4.tcp->doff << 2) + l4_offset;
 
-	/* remove payload length from inner pseudo checksum when tso*/
+	/* remove payload length from inner pseudo checksum when tso */
 	l4_paylen = skb->len - l4_offset;
 	csum_replace_by_diff(&l4.tcp->check,
 			     (__force __wsum)htonl(l4_paylen));
@@ -800,7 +795,7 @@ static void hns3_set_outer_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 	hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_L3LEN_S, l3_len >> 2);
 
 	il2_hdr = skb_inner_mac_header(skb);
-	/* compute OL4 header size, defined in 4 Bytes. */
+	/* compute OL4 header size, defined in 4 Bytes */
 	l4_len = il2_hdr - l4.hdr;
 	hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_L4LEN_S, l4_len >> 2);
 
@@ -1060,8 +1055,7 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		/* Set txbd */
 		desc->tx.ol_type_vlan_len_msec =
 			cpu_to_le32(ol_type_vlan_len_msec);
-		desc->tx.type_cs_vlan_tso_len =
-			cpu_to_le32(type_cs_vlan_tso);
+		desc->tx.type_cs_vlan_tso_len =	cpu_to_le32(type_cs_vlan_tso);
 		desc->tx.paylen = cpu_to_le32(paylen);
 		desc->tx.mss = cpu_to_le16(mss);
 		desc->tx.vlan_tag = cpu_to_le16(inner_vtag);
@@ -1108,19 +1102,19 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		desc_cb->priv = priv;
 		desc_cb->dma = dma + HNS3_MAX_BD_SIZE * k;
 		desc_cb->type = (type == DESC_TYPE_SKB && !k) ?
-					DESC_TYPE_SKB : DESC_TYPE_PAGE;
+				DESC_TYPE_SKB : DESC_TYPE_PAGE;
 
 		/* now, fill the descriptor */
 		desc->addr = cpu_to_le64(dma + HNS3_MAX_BD_SIZE * k);
 		desc->tx.send_size = cpu_to_le16((k == frag_buf_num - 1) ?
-				(u16)sizeoflast : (u16)HNS3_MAX_BD_SIZE);
+				     (u16)sizeoflast : (u16)HNS3_MAX_BD_SIZE);
 		hns3_set_txbd_baseinfo(&bdtp_fe_sc_vld_ra_ri,
 				       frag_end && (k == frag_buf_num - 1) ?
 						1 : 0);
 		desc->tx.bdtp_fe_sc_vld_ra_ri =
 				cpu_to_le16(bdtp_fe_sc_vld_ra_ri);
 
-		/* move ring pointer to next.*/
+		/* move ring pointer to next */
 		ring_ptr_move_fw(ring, next_to_use);
 
 		desc_cb = &ring->desc_cb[ring->next_to_use];
@@ -1577,7 +1571,7 @@ static int hns3_ndo_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 
 	if (h->ae_algo->ops->set_vf_vlan_filter)
 		ret = h->ae_algo->ops->set_vf_vlan_filter(h, vf, vlan,
-						   qos, vlan_proto);
+							  qos, vlan_proto);
 
 	return ret;
 }
@@ -1828,8 +1822,7 @@ static int hns3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct hnae3_ae_dev *ae_dev;
 	int ret;
 
-	ae_dev = devm_kzalloc(&pdev->dev, sizeof(*ae_dev),
-			      GFP_KERNEL);
+	ae_dev = devm_kzalloc(&pdev->dev, sizeof(*ae_dev), GFP_KERNEL);
 	if (!ae_dev) {
 		ret = -ENOMEM;
 		return ret;
@@ -2196,7 +2189,7 @@ static int hns3_alloc_ring_buffers(struct hns3_enet_ring *ring)
 	return ret;
 }
 
-/* detach a in-used buffer and replace with a reserved one  */
+/* detach a in-used buffer and replace with a reserved one */
 static void hns3_replace_buffer(struct hns3_enet_ring *ring, int i,
 				struct hns3_desc_cb *res_cb)
 {
@@ -2209,8 +2202,8 @@ static void hns3_replace_buffer(struct hns3_enet_ring *ring, int i,
 static void hns3_reuse_buffer(struct hns3_enet_ring *ring, int i)
 {
 	ring->desc_cb[i].reuse_flag = 0;
-	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma
-		+ ring->desc_cb[i].page_offset);
+	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
+					 ring->desc_cb[i].page_offset);
 	ring->desc[i].rx.bd_base_info = 0;
 }
 
@@ -2312,8 +2305,8 @@ static int hns3_desc_unused(struct hns3_enet_ring *ring)
 	return ((ntc >= ntu) ? 0 : ring->desc_num) + ntc - ntu;
 }
 
-static void
-hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring, int cleand_count)
+static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
+				      int cleand_count)
 {
 	struct hns3_desc_cb *desc_cb;
 	struct hns3_desc_cb res_cbs;
@@ -2375,7 +2368,7 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 
 	if (desc_cb->page_offset + truesize <= hnae3_page_size(ring)) {
 		desc_cb->reuse_flag = 1;
-		/* Bump ref count on page before it is given*/
+		/* Bump ref count on page before it is given */
 		get_page(desc_cb->priv);
 	} else if (page_count(desc_cb->priv) == 1) {
 		desc_cb->reuse_flag = 1;
@@ -2619,7 +2612,7 @@ static int hns3_add_frag(struct hns3_enet_ring *ring, struct hns3_desc *desc,
 	 */
 	if (pending) {
 		pre_bd = (ring->next_to_clean - 1 + ring->desc_num) %
-			ring->desc_num;
+			 ring->desc_num;
 		pre_desc = &ring->desc[pre_bd];
 		bd_base_info = le32_to_cpu(pre_desc->rx.bd_base_info);
 	} else {
@@ -2688,8 +2681,7 @@ static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 						  HNS3_RXD_GRO_COUNT_M,
 						  HNS3_RXD_GRO_COUNT_S);
 
-	l3_type = hnae3_get_field(l234info, HNS3_RXD_L3ID_M,
-				  HNS3_RXD_L3ID_S);
+	l3_type = hnae3_get_field(l234info, HNS3_RXD_L3ID_M, HNS3_RXD_L3ID_S);
 	if (l3_type == HNS3_L3_TYPE_IPV4)
 		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
 	else if (l3_type == HNS3_L3_TYPE_IPV6)
@@ -2877,9 +2869,8 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring,
 	return 0;
 }
 
-int hns3_clean_rx_ring(
-		struct hns3_enet_ring *ring, int budget,
-		void (*rx_fn)(struct hns3_enet_ring *, struct sk_buff *))
+int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
+		       void (*rx_fn)(struct hns3_enet_ring *, struct sk_buff *))
 {
 #define RCB_NOF_ALLOC_RX_BUFF_ONCE 16
 	int recv_pkts, recv_bds, clean_count, err;
@@ -2931,8 +2922,7 @@ int hns3_clean_rx_ring(
 out:
 	/* Make all data has been write before submit */
 	if (clean_count + unused_count > 0)
-		hns3_nic_alloc_rx_buffers(ring,
-					  clean_count + unused_count);
+		hns3_nic_alloc_rx_buffers(ring, clean_count + unused_count);
 
 	return recv_pkts;
 }
@@ -3337,6 +3327,7 @@ static int hns3_nic_alloc_vector_data(struct hns3_nic_priv *priv)
 	if (!vector)
 		return -ENOMEM;
 
+	/* save the actual available vector number */
 	vector_num = h->ae_algo->ops->get_vector(h, vector_num, vector);
 
 	priv->vector_num = vector_num;
@@ -3605,8 +3596,7 @@ static void hns3_init_ring_hw(struct hns3_enet_ring *ring)
 	struct hnae3_queue *q = ring->tqp;
 
 	if (!HNAE3_IS_TX_RING(ring)) {
-		hns3_write_dev(q, HNS3_RING_RX_RING_BASEADDR_L_REG,
-			       (u32)dma);
+		hns3_write_dev(q, HNS3_RING_RX_RING_BASEADDR_L_REG, (u32)dma);
 		hns3_write_dev(q, HNS3_RING_RX_RING_BASEADDR_H_REG,
 			       (u32)((dma >> 31) >> 1));
 
@@ -4052,8 +4042,7 @@ static int hns3_clear_rx_ring(struct hns3_enet_ring *ring)
 					    ret);
 				return ret;
 			}
-			hns3_replace_buffer(ring, ring->next_to_use,
-					    &res_cbs);
+			hns3_replace_buffer(ring, ring->next_to_use, &res_cbs);
 		}
 		ring_ptr_move_fw(ring, next_to_use);
 	}
@@ -4228,7 +4217,7 @@ static int hns3_reset_notify_up_enet(struct hnae3_handle *handle)
 		if (ret) {
 			set_bit(HNS3_NIC_STATE_RESETTING, &priv->state);
 			netdev_err(kinfo->netdev,
-				   "hns net up fail, ret=%d!\n", ret);
+				   "net up fail, ret=%d!\n", ret);
 			return ret;
 		}
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 49b4072..6ce724d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -150,6 +150,12 @@ static void hns3_lp_setup_skb(struct sk_buff *skb)
 	packet = skb_put(skb, HNS3_NIC_LB_TEST_PACKET_SIZE);
 
 	memcpy(ethh->h_dest, ndev->dev_addr, ETH_ALEN);
+
+	/* The dst mac addr of loopback packet is the same as the host'
+	 * mac addr, the SSU component may loop back the packet to host
+	 * before the packet reaches mac or serdes, which will defect
+	 * the purpose of mac or serdes selftest.
+	 */
 	ethh->h_dest[5] += 0x1f;
 	eth_zero_addr(ethh->h_source);
 	ethh->h_proto = htons(ETH_P_ARP);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index c2844e1..95dc163 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -399,7 +399,7 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 	if (ret)
 		goto err_tm_pg_cmd_send;
 
-	dev_info(&hdev->pdev->dev, "PRI_SCH pg_id: %u\n", desc.data[0]);
+	dev_info(&hdev->pdev->dev, "PRI_SCH pri_id: %u\n", desc.data[0]);
 
 	cmd = HCLGE_OPC_TM_QS_SCH_MODE_CFG;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -407,7 +407,7 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 	if (ret)
 		goto err_tm_pg_cmd_send;
 
-	dev_info(&hdev->pdev->dev, "QS_SCH pg_id: %u\n", desc.data[0]);
+	dev_info(&hdev->pdev->dev, "QS_SCH qs_id: %u\n", desc.data[0]);
 
 	cmd = HCLGE_OPC_TM_BP_TO_QSET_MAPPING;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -416,9 +416,9 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 		goto err_tm_pg_cmd_send;
 
 	bp_to_qs_map_cmd = (struct hclge_bp_to_qs_map_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "BP_TO_QSET pg_id: %u\n",
+	dev_info(&hdev->pdev->dev, "BP_TO_QSET tc_id: %u\n",
 		 bp_to_qs_map_cmd->tc_id);
-	dev_info(&hdev->pdev->dev, "BP_TO_QSET pg_shapping: 0x%x\n",
+	dev_info(&hdev->pdev->dev, "BP_TO_QSET qs_group_id: 0x%x\n",
 		 bp_to_qs_map_cmd->qs_group_id);
 	dev_info(&hdev->pdev->dev, "BP_TO_QSET qs_bit_map: 0x%x\n",
 		 bp_to_qs_map_cmd->qs_bit_map);
@@ -477,7 +477,7 @@ static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
 
 	nq_to_qs_map = (struct hclge_nq_to_qs_link_cmd *)desc.data;
 	dev_info(&hdev->pdev->dev, "NQ_TO_QS nq_id: %u\n", nq_to_qs_map->nq_id);
-	dev_info(&hdev->pdev->dev, "NQ_TO_QS qset_id: %u\n",
+	dev_info(&hdev->pdev->dev, "NQ_TO_QS qset_id: 0x%x\n",
 		 nq_to_qs_map->qset_id);
 
 	cmd = HCLGE_OPC_TM_PG_WEIGHT;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index cb6ed8c..4126287 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -673,19 +673,19 @@ static int hclge_cmd_query_error(struct hclge_dev *hdev,
 				 enum hclge_err_int_type int_type)
 {
 	struct device *dev = &hdev->pdev->dev;
-	int num = 1;
+	int desc_num = 1;
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc[0], cmd, true);
 	if (flag) {
 		desc[0].flag |= cpu_to_le16(flag);
 		hclge_cmd_setup_basic_desc(&desc[1], cmd, true);
-		num = 2;
+		desc_num = 2;
 	}
 	if (w_num)
 		desc[0].data[w_num] = cpu_to_le32(int_type);
 
-	ret = hclge_cmd_send(&hdev->hw, &desc[0], num);
+	ret = hclge_cmd_send(&hdev->hw, &desc[0], desc_num);
 	if (ret)
 		dev_err(dev, "query error cmd failed (%d)\n", ret);
 
@@ -941,7 +941,7 @@ static int hclge_config_ppu_error_interrupts(struct hclge_dev *hdev, u32 cmd,
 {
 	struct device *dev = &hdev->pdev->dev;
 	struct hclge_desc desc[2];
-	int num = 1;
+	int desc_num = 1;
 	int ret;
 
 	/* configure PPU error interrupts */
@@ -960,7 +960,7 @@ static int hclge_config_ppu_error_interrupts(struct hclge_dev *hdev, u32 cmd,
 		desc[1].data[1] = HCLGE_PPU_MPF_ABNORMAL_INT1_EN_MASK;
 		desc[1].data[2] = HCLGE_PPU_MPF_ABNORMAL_INT2_EN_MASK;
 		desc[1].data[3] |= HCLGE_PPU_MPF_ABNORMAL_INT3_EN_MASK;
-		num = 2;
+		desc_num = 2;
 	} else if (cmd == HCLGE_PPU_MPF_OTHER_INT_CMD) {
 		hclge_cmd_setup_basic_desc(&desc[0], cmd, false);
 		if (en)
@@ -978,7 +978,7 @@ static int hclge_config_ppu_error_interrupts(struct hclge_dev *hdev, u32 cmd,
 		return -EINVAL;
 	}
 
-	ret = hclge_cmd_send(&hdev->hw, &desc[0], num);
+	ret = hclge_cmd_send(&hdev->hw, &desc[0], desc_num);
 
 	return ret;
 }
@@ -1455,8 +1455,7 @@ static int hclge_log_rocee_ovf_error(struct hclge_dev *hdev)
 	int ret;
 
 	/* read overflow error status */
-	ret = hclge_cmd_query_error(hdev, &desc[0],
-				    HCLGE_ROCEE_PF_RAS_INT_CMD,
+	ret = hclge_cmd_query_error(hdev, &desc[0], HCLGE_ROCEE_PF_RAS_INT_CMD,
 				    0, 0, 0);
 	if (ret) {
 		dev_err(dev, "failed(%d) to query ROCEE OVF error sts\n", ret);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 186a4fd..45038cf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -443,8 +443,7 @@ static int hclge_tqps_update_stats(struct hnae3_handle *handle)
 		queue = handle->kinfo.tqp[i];
 		tqp = container_of(queue, struct hclge_tqp, q);
 		/* command : HCLGE_OPC_QUERY_IGU_STAT */
-		hclge_cmd_setup_basic_desc(&desc[0],
-					   HCLGE_OPC_QUERY_RX_STATUS,
+		hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_QUERY_RX_STATUS,
 					   true);
 
 		desc[0].data[0] = cpu_to_le32((tqp->index & 0x1ff));
@@ -452,7 +451,7 @@ static int hclge_tqps_update_stats(struct hnae3_handle *handle)
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
 				"Query tqp stat fail, status = %d,queue = %d\n",
-				ret,	i);
+				ret, i);
 			return ret;
 		}
 		tqp->tqp_stats.rcb_rx_ring_pktnum_rcd +=
@@ -506,6 +505,7 @@ static int hclge_tqps_get_sset_count(struct hnae3_handle *handle, int stringset)
 {
 	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
 
+	/* each tqp has TX & RX two queues */
 	return kinfo->num_tqps * (2);
 }
 
@@ -650,8 +650,7 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 	return count;
 }
 
-static void hclge_get_strings(struct hnae3_handle *handle,
-			      u32 stringset,
+static void hclge_get_strings(struct hnae3_handle *handle, u32 stringset,
 			      u8 *data)
 {
 	u8 *p = (char *)data;
@@ -659,21 +658,17 @@ static void hclge_get_strings(struct hnae3_handle *handle,
 
 	if (stringset == ETH_SS_STATS) {
 		size = ARRAY_SIZE(g_mac_stats_string);
-		p = hclge_comm_get_strings(stringset,
-					   g_mac_stats_string,
-					   size,
-					   p);
+		p = hclge_comm_get_strings(stringset, g_mac_stats_string,
+					   size, p);
 		p = hclge_tqps_get_strings(handle, p);
 	} else if (stringset == ETH_SS_TEST) {
 		if (handle->flags & HNAE3_SUPPORT_APP_LOOPBACK) {
-			memcpy(p,
-			       hns3_nic_test_strs[HNAE3_LOOP_APP],
+			memcpy(p, hns3_nic_test_strs[HNAE3_LOOP_APP],
 			       ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
 		if (handle->flags & HNAE3_SUPPORT_SERDES_SERIAL_LOOPBACK) {
-			memcpy(p,
-			       hns3_nic_test_strs[HNAE3_LOOP_SERIAL_SERDES],
+			memcpy(p, hns3_nic_test_strs[HNAE3_LOOP_SERIAL_SERDES],
 			       ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
@@ -684,8 +679,7 @@ static void hclge_get_strings(struct hnae3_handle *handle,
 			p += ETH_GSTRING_LEN;
 		}
 		if (handle->flags & HNAE3_SUPPORT_PHY_LOOPBACK) {
-			memcpy(p,
-			       hns3_nic_test_strs[HNAE3_LOOP_PHY],
+			memcpy(p, hns3_nic_test_strs[HNAE3_LOOP_PHY],
 			       ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
@@ -698,10 +692,8 @@ static void hclge_get_stats(struct hnae3_handle *handle, u64 *data)
 	struct hclge_dev *hdev = vport->back;
 	u64 *p;
 
-	p = hclge_comm_get_stats(&hdev->hw_stats.mac_stats,
-				 g_mac_stats_string,
-				 ARRAY_SIZE(g_mac_stats_string),
-				 data);
+	p = hclge_comm_get_stats(&hdev->hw_stats.mac_stats, g_mac_stats_string,
+				 ARRAY_SIZE(g_mac_stats_string), data);
 	p = hclge_tqps_get_stats(handle, p);
 }
 
@@ -746,9 +738,7 @@ static int hclge_query_function_status(struct hclge_dev *hdev)
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
-				"query function status failed %d.\n",
-				ret);
-
+				"query function status failed %d.\n", ret);
 			return ret;
 		}
 
@@ -808,7 +798,7 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 		/* PF should have NIC vectors and Roce vectors,
 		 * NIC vectors are queued before Roce vectors.
 		 */
-		hdev->num_msi = hdev->num_roce_msi  +
+		hdev->num_msi = hdev->num_roce_msi +
 				hdev->roce_base_msix_offset;
 	} else {
 		hdev->num_msi =
@@ -2153,7 +2143,6 @@ static int hclge_init_msi(struct hclge_dev *hdev)
 
 static u8 hclge_check_speed_dup(u8 duplex, int speed)
 {
-
 	if (!(speed == HCLGE_MAC_SPEED_10M || speed == HCLGE_MAC_SPEED_100M))
 		duplex = HCLGE_MAC_FULL;
 
@@ -2862,8 +2851,7 @@ int hclge_notify_client(struct hclge_dev *hdev,
 	struct hnae3_client *client = hdev->nic_client;
 	u16 i;
 
-	if (!test_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state) ||
-	    !client)
+	if (!test_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state) || !client)
 		return 0;
 
 	if (!client->ops->reset_notify)
@@ -2891,8 +2879,7 @@ static int hclge_notify_roce_client(struct hclge_dev *hdev,
 	int ret = 0;
 	u16 i;
 
-	if (!test_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state) ||
-	    !client)
+	if (!test_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state) || !client)
 		return 0;
 
 	if (!client->ops->reset_notify)
@@ -4167,8 +4154,7 @@ int hclge_bind_ring_with_vector(struct hclge_vport *vport,
 	return 0;
 }
 
-static int hclge_map_ring_to_vector(struct hnae3_handle *handle,
-				    int vector,
+static int hclge_map_ring_to_vector(struct hnae3_handle *handle, int vector,
 				    struct hnae3_ring_chain_node *ring_chain)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -4185,8 +4171,7 @@ static int hclge_map_ring_to_vector(struct hnae3_handle *handle,
 	return hclge_bind_ring_with_vector(vport, vector_id, true, ring_chain);
 }
 
-static int hclge_unmap_ring_frm_vector(struct hnae3_handle *handle,
-				       int vector,
+static int hclge_unmap_ring_frm_vector(struct hnae3_handle *handle, int vector,
 				       struct hnae3_ring_chain_node *ring_chain)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -4207,8 +4192,7 @@ static int hclge_unmap_ring_frm_vector(struct hnae3_handle *handle,
 	if (ret)
 		dev_err(&handle->pdev->dev,
 			"Unmap ring from vector fail. vectorid=%d, ret =%d\n",
-			vector_id,
-			ret);
+			vector_id, ret);
 
 	return ret;
 }
@@ -5272,13 +5256,12 @@ static int hclge_del_fd_entry(struct hnae3_handle *handle,
 
 	if (!hclge_fd_rule_exist(hdev, fs->location)) {
 		dev_err(&hdev->pdev->dev,
-			"Delete fail, rule %d is inexistent\n",
-			fs->location);
+			"Delete fail, rule %d is inexistent\n", fs->location);
 		return -ENOENT;
 	}
 
-	ret = hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true,
-				   fs->location, NULL, false);
+	ret = hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true, fs->location,
+				   NULL, false);
 	if (ret)
 		return ret;
 
@@ -6549,8 +6532,7 @@ int hclge_add_uc_addr_common(struct hclge_vport *vport,
 	    is_multicast_ether_addr(addr)) {
 		dev_err(&hdev->pdev->dev,
 			"Set_uc mac err! invalid mac:%pM. is_zero:%d,is_br=%d,is_mul=%d\n",
-			 addr,
-			 is_zero_ether_addr(addr),
+			 addr, is_zero_ether_addr(addr),
 			 is_broadcast_ether_addr(addr),
 			 is_multicast_ether_addr(addr));
 		return -EINVAL;
@@ -6617,9 +6599,8 @@ int hclge_rm_uc_addr_common(struct hclge_vport *vport,
 	if (is_zero_ether_addr(addr) ||
 	    is_broadcast_ether_addr(addr) ||
 	    is_multicast_ether_addr(addr)) {
-		dev_dbg(&hdev->pdev->dev,
-			"Remove mac err! invalid mac:%pM.\n",
-			 addr);
+		dev_dbg(&hdev->pdev->dev, "Remove mac err! invalid mac:%pM.\n",
+			addr);
 		return -EINVAL;
 	}
 
@@ -8730,8 +8711,7 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	ret = hclge_init_fd_config(hdev);
 	if (ret) {
-		dev_err(&pdev->dev,
-			"fd table init fail, ret=%d\n", ret);
+		dev_err(&pdev->dev, "fd table init fail, ret=%d\n", ret);
 		return ret;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 5783582..fa28141 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -52,7 +52,8 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 		6 * 8,          /* Port level */
 		6 * 256         /* Qset level */
 	};
-	u8 ir_u_calc = 0, ir_s_calc = 0;
+	u8 ir_u_calc = 0;
+	u8 ir_s_calc = 0;
 	u32 ir_calc;
 	u32 tick;
 
@@ -222,8 +223,7 @@ int hclge_pause_addr_cfg(struct hclge_dev *hdev, const u8 *mac_addr)
 	trans_gap = pause_param->pause_trans_gap;
 	trans_time = le16_to_cpu(pause_param->pause_trans_time);
 
-	return hclge_pause_param_cfg(hdev, mac_addr, trans_gap,
-					 trans_time);
+	return hclge_pause_param_cfg(hdev, mac_addr, trans_gap, trans_time);
 }
 
 static int hclge_fill_pri_array(struct hclge_dev *hdev, u8 *pri, u8 pri_id)
@@ -387,7 +387,7 @@ static int hclge_tm_pg_shapping_cfg(struct hclge_dev *hdev,
 	struct hclge_desc desc;
 
 	opcode = bucket ? HCLGE_OPC_TM_PG_P_SHAPPING :
-		HCLGE_OPC_TM_PG_C_SHAPPING;
+		 HCLGE_OPC_TM_PG_C_SHAPPING;
 	hclge_cmd_setup_basic_desc(&desc, opcode, false);
 
 	shap_cfg_cmd = (struct hclge_pg_shapping_cmd *)desc.data;
@@ -434,7 +434,7 @@ static int hclge_tm_pri_shapping_cfg(struct hclge_dev *hdev,
 	struct hclge_desc desc;
 
 	opcode = bucket ? HCLGE_OPC_TM_PRI_P_SHAPPING :
-		HCLGE_OPC_TM_PRI_C_SHAPPING;
+		 HCLGE_OPC_TM_PRI_C_SHAPPING;
 
 	hclge_cmd_setup_basic_desc(&desc, opcode, false);
 
@@ -531,6 +531,7 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	max_rss_size = min_t(u16, hdev->rss_size_max,
 			     vport->alloc_tqps / kinfo->num_tc);
 
+	/* Set to user value, no larger than max_rss_size. */
 	if (kinfo->req_rss_size != kinfo->rss_size && kinfo->req_rss_size &&
 	    kinfo->req_rss_size <= max_rss_size) {
 		dev_info(&hdev->pdev->dev, "rss changes from %d to %d\n",
@@ -538,6 +539,7 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 		kinfo->rss_size = kinfo->req_rss_size;
 	} else if (kinfo->rss_size > max_rss_size ||
 		   (!kinfo->req_rss_size && kinfo->rss_size < max_rss_size)) {
+		/* Set to the maximum specification value (max_rss_size). */
 		dev_info(&hdev->pdev->dev, "rss changes from %d to %d\n",
 			 kinfo->rss_size, max_rss_size);
 		kinfo->rss_size = max_rss_size;
@@ -736,8 +738,7 @@ static int hclge_tm_pg_dwrr_cfg(struct hclge_dev *hdev)
 	/* pg to prio */
 	for (i = 0; i < hdev->tm_info.num_pg; i++) {
 		/* Cfg dwrr */
-		ret = hclge_tm_pg_weight_cfg(hdev, i,
-					     hdev->tm_info.pg_dwrr[i]);
+		ret = hclge_tm_pg_weight_cfg(hdev, i, hdev->tm_info.pg_dwrr[i]);
 		if (ret)
 			return ret;
 	}
@@ -1223,8 +1224,8 @@ static int hclge_pause_param_setup_hw(struct hclge_dev *hdev)
 	struct hclge_mac *mac = &hdev->hw.mac;
 
 	return hclge_pause_param_cfg(hdev, mac->mac_addr,
-					 HCLGE_DEFAULT_PAUSE_TRANS_GAP,
-					 HCLGE_DEFAULT_PAUSE_TRANS_TIME);
+				     HCLGE_DEFAULT_PAUSE_TRANS_GAP,
+				     HCLGE_DEFAULT_PAUSE_TRANS_TIME);
 }
 
 static int hclge_pfc_setup_hw(struct hclge_dev *hdev)
@@ -1369,7 +1370,8 @@ void hclge_tm_prio_tc_info_update(struct hclge_dev *hdev, u8 *prio_tc)
 
 void hclge_tm_schd_info_update(struct hclge_dev *hdev, u8 num_tc)
 {
-	u8 i, bit_map = 0;
+	u8 bit_map = 0;
+	u8 i;
 
 	hdev->tm_info.num_tc = num_tc;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 260546a..b98ab97 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -83,8 +83,7 @@ static const u32 tqp_intr_reg_addr_list[] = {HCLGEVF_TQP_INTR_CTRL_REG,
 					     HCLGEVF_TQP_INTR_GL2_REG,
 					     HCLGEVF_TQP_INTR_RL_REG};
 
-static inline struct hclgevf_dev *hclgevf_ae_get_hdev(
-	struct hnae3_handle *handle)
+static struct hclgevf_dev *hclgevf_ae_get_hdev(struct hnae3_handle *handle)
 {
 	if (!handle->client)
 		return container_of(handle, struct hclgevf_dev, nic);
@@ -1675,9 +1674,9 @@ static void hclgevf_reset_service_task(struct work_struct *work)
 	if (test_and_clear_bit(HCLGEVF_RESET_PENDING,
 			       &hdev->reset_state)) {
 		/* PF has initmated that it is about to reset the hardware.
-		 * We now have to poll & check if harware has actually completed
-		 * the reset sequence. On hardware reset completion, VF needs to
-		 * reset the client and ae device.
+		 * We now have to poll & check if hardware has actually
+		 * completed the reset sequence. On hardware reset completion,
+		 * VF needs to reset the client and ae device.
 		 */
 		hdev->reset_attempts = 0;
 
@@ -1693,7 +1692,7 @@ static void hclgevf_reset_service_task(struct work_struct *work)
 	} else if (test_and_clear_bit(HCLGEVF_RESET_REQUESTED,
 				      &hdev->reset_state)) {
 		/* we could be here when either of below happens:
-		 * 1. reset was initiated due to watchdog timeout due to
+		 * 1. reset was initiated due to watchdog timeout caused by
 		 *    a. IMP was earlier reset and our TX got choked down and
 		 *       which resulted in watchdog reacting and inducing VF
 		 *       reset. This also means our cmdq would be unreliable.
@@ -2003,7 +2002,7 @@ static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 
 	}
 
-	/* Initialize RSS indirect table for each vport */
+	/* Initialize RSS indirect table */
 	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
 		rss_cfg->rss_indirection_tbl[i] = i % hdev->rss_size_max;
 
@@ -2016,9 +2015,6 @@ static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 
 static int hclgevf_init_vlan_config(struct hclgevf_dev *hdev)
 {
-	/* other vlan config(like, VLAN TX/RX offload) would also be added
-	 * here later
-	 */
 	return hclgevf_set_vlan_filter(&hdev->nic, htons(ETH_P_8021Q), 0,
 				       false);
 }
@@ -2040,7 +2036,6 @@ static int hclgevf_ae_start(struct hnae3_handle *handle)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 
-	/* reset tqp stats */
 	hclgevf_reset_tqp_stats(handle);
 
 	hclgevf_request_link_info(hdev);
@@ -2064,7 +2059,6 @@ static void hclgevf_ae_stop(struct hnae3_handle *handle)
 			if (hclgevf_reset_tqp(handle, i))
 				break;
 
-	/* reset tqp stats */
 	hclgevf_reset_tqp_stats(handle);
 	hclgevf_update_link_status(hdev, 0);
 }
-- 
2.7.4

