Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EBE349ECB
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhCZBhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:37:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14606 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhCZBgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 21:36:25 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F64JW6cfnz19JDY;
        Fri, 26 Mar 2021 09:34:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 09:36:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/9] net: hns3: remove redundant blank lines
Date:   Fri, 26 Mar 2021 09:36:21 +0800
Message-ID: <1616722588-58967-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616722588-58967-1-git-send-email-tanhuazhong@huawei.com>
References: <1616722588-58967-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Remove some redundant blank lines.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           | 7 -------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c    | 1 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c    | 2 --
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 5 -----
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c  | 1 -
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 --
 6 files changed, 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 44b775e..c73de36 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -210,7 +210,6 @@ void hns3_set_vector_coalesce_rl(struct hns3_enet_tqp_vector *tqp_vector,
 	 * Rl defines rate of interrupts i.e. number of interrupts-per-second
 	 * GL and RL(Rate Limiter) are 2 ways to acheive interrupt coalescing
 	 */
-
 	if (rl_reg > 0 && !tqp_vector->tx_group.coal.adapt_enable &&
 	    !tqp_vector->rx_group.coal.adapt_enable)
 		/* According to the hardware, the range of rl_reg is
@@ -883,7 +882,6 @@ static void hns3_set_outer_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 			hns3_set_field(*ol_type_vlan_len_msec,
 				       HNS3_TXD_OL3T_S,
 				       HNS3_OL3T_IPV4_NO_CSUM);
-
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
 		hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_OL3T_S,
 			       HNS3_OL3T_IPV6);
@@ -1296,7 +1294,6 @@ static unsigned int hns3_tx_bd_num(struct sk_buff *skb, unsigned int *bd_size,
 		return HNS3_MAX_TSO_BD_NUM + 1U;
 
 	bd_num = hns3_skb_bd_num(skb, bd_size, bd_num);
-
 	if (!skb_has_frag_list(skb) || bd_num > HNS3_MAX_TSO_BD_NUM)
 		return bd_num;
 
@@ -2965,7 +2962,6 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 					  HNS3_RXD_L3ID_S);
 		l4_type = hnae3_get_field(l234info, HNS3_RXD_L4ID_M,
 					  HNS3_RXD_L4ID_S);
-
 		/* Can checksum ipv4 or ipv6 + UDP/TCP/SCTP packets */
 		if ((l3_type == HNS3_L3_TYPE_IPV4 ||
 		     l3_type == HNS3_L3_TYPE_IPV6) &&
@@ -3295,7 +3291,6 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring)
 
 	if (!skb) {
 		bd_base_info = le32_to_cpu(desc->rx.bd_base_info);
-
 		/* Check valid BD */
 		if (unlikely(!(bd_base_info & BIT(HNS3_RXD_VLD_B))))
 			return -ENXIO;
@@ -3557,7 +3552,6 @@ static int hns3_nic_common_poll(struct napi_struct *napi, int budget)
 	hns3_for_each_ring(ring, tqp_vector->rx_group) {
 		int rx_cleaned = hns3_clean_rx_ring(ring, rx_budget,
 						    hns3_rx_skb);
-
 		if (rx_cleaned >= rx_budget)
 			clean_complete = false;
 
@@ -4024,7 +4018,6 @@ static void hns3_init_ring_hw(struct hns3_enet_ring *ring)
 			       hns3_buf_size2type(ring->buf_size));
 		hns3_write_dev(q, HNS3_RING_RX_RING_BD_NUM_REG,
 			       ring->desc_num / 8 - 1);
-
 	} else {
 		hns3_write_dev(q, HNS3_RING_TX_RING_BASEADDR_L_REG,
 			       (u32)dma);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 3284a2c..76a4824 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -366,7 +366,6 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 	u32 caps;
 
 	caps = __le32_to_cpu(cmd->caps[0]);
-
 	if (hnae3_get_bit(caps, HCLGE_CAP_UDP_GSO_B))
 		set_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_PTP_B))
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 0ca7f1b..7389fe9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1497,7 +1497,6 @@ hclge_log_and_clear_rocee_ras_error(struct hclge_dev *hdev)
 	}
 
 	status = le32_to_cpu(desc[0].data[0]);
-
 	if (status & HCLGE_ROCEE_AXI_ERR_INT_MASK) {
 		if (status & HCLGE_ROCEE_RERR_INT_MASK)
 			dev_err(dev, "ROCEE RAS AXI rresp error\n");
@@ -1647,7 +1646,6 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 	}
 
 	status = hclge_read_dev(&hdev->hw, HCLGE_RAS_PF_OTHER_INT_STS_REG);
-
 	if (status & HCLGE_RAS_REG_NFE_MASK ||
 	    status & HCLGE_RAS_REG_ROCEE_ERR_MASK)
 		ae_dev->hw_err_reset_req = 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4967e72..fbbc2a7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -553,7 +553,6 @@ static int hclge_mac_update_stats(struct hclge_dev *hdev)
 	int ret;
 
 	ret = hclge_mac_query_reg_num(hdev, &desc_num);
-
 	/* The firmware supports the new statistics acquisition method */
 	if (!ret)
 		ret = hclge_mac_update_stats_complete(hdev, desc_num);
@@ -784,7 +783,6 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 			count += 1;
 			handle->flags |= HNAE3_SUPPORT_PHY_LOOPBACK;
 		}
-
 	} else if (stringset == ETH_SS_STATS) {
 		count = ARRAY_SIZE(g_mac_stats_string) +
 			hclge_tqps_get_sset_count(handle, stringset);
@@ -2191,7 +2189,6 @@ static int hclge_only_alloc_priv_buff(struct hclge_dev *hdev,
 			COMPENSATE_HALF_MPS_NUM * half_mps;
 	min_rx_priv = round_up(min_rx_priv, HCLGE_BUF_SIZE_UNIT);
 	rx_priv = round_down(rx_priv, HCLGE_BUF_SIZE_UNIT);
-
 	if (rx_priv < min_rx_priv)
 		return false;
 
@@ -8608,7 +8605,6 @@ int hclge_add_mc_addr_common(struct hclge_vport *vport,
 	if (status)
 		return status;
 	status = hclge_add_mac_vlan_tbl(vport, &req, desc);
-
 	/* if already overflow, not to print each time */
 	if (status == -ENOSPC &&
 	    !(vport->overflow_promisc_flags & HNAE3_OVERFLOW_MPE))
@@ -8657,7 +8653,6 @@ int hclge_rm_mc_addr_common(struct hclge_vport *vport,
 		else
 			/* Not all the vfid is zero, update the vfid */
 			status = hclge_add_mac_vlan_tbl(vport, &req, desc);
-
 	} else if (status == -ENOENT) {
 		status = 0;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 46700c4..d8c5c58 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -349,7 +349,6 @@ static void hclgevf_parse_capability(struct hclgevf_dev *hdev,
 	u32 caps;
 
 	caps = __le32_to_cpu(cmd->caps[0]);
-
 	if (hnae3_get_bit(caps, HCLGEVF_CAP_UDP_GSO_B))
 		set_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGEVF_CAP_INT_QL_B))
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 700e068..5e512cd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -497,7 +497,6 @@ void hclgevf_update_link_status(struct hclgevf_dev *hdev, int link_state)
 
 	link_state =
 		test_bit(HCLGEVF_STATE_DOWN, &hdev->state) ? 0 : link_state;
-
 	if (link_state != hdev->hw.mac.link) {
 		client->ops->link_status_change(handle, !!link_state);
 		if (rclient && rclient->ops->link_status_change)
@@ -2356,7 +2355,6 @@ static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 	/* fetch the events from their corresponding regs */
 	cmdq_stat_reg = hclgevf_read_dev(&hdev->hw,
 					 HCLGEVF_VECTOR0_CMDQ_STATE_REG);
-
 	if (BIT(HCLGEVF_VECTOR0_RST_INT_B) & cmdq_stat_reg) {
 		rst_ing_reg = hclgevf_read_dev(&hdev->hw, HCLGEVF_RST_ING);
 		dev_info(&hdev->pdev->dev,
-- 
2.7.4

