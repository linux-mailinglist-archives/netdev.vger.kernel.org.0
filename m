Return-Path: <netdev+bounces-2666-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC632702EB1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 720961C20B84
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACBFD52C;
	Mon, 15 May 2023 13:48:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A30D507
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:48:41 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B893410F1
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:48:38 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QKgcQ6ktCzLq0W;
	Mon, 15 May 2023 21:45:42 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 21:48:35 +0800
From: Hao Lan <lanhao@huawei.com>
To: <netdev@vger.kernel.org>
CC: <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <lanhao@huawei.com>,
	<wangpeiyang1@huawei.com>, <shenjian15@huawei.com>, <chenhao418@huawei.com>,
	<simon.horman@corigine.com>, <wangjie125@huawei.com>, <yuanjilin@cdjrlc.com>,
	<cai.huoqing@linux.dev>, <xiujianfeng@huawei.com>
Subject: [PATCH net-next 4/4] net: hns3: clear hns unused parameter alarm
Date: Mon, 15 May 2023 21:46:43 +0800
Message-ID: <20230515134643.48314-5-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230515134643.48314-1-lanhao@huawei.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Peiyang Wang <wangpeiyang1@huawei.com>

Several functions in the hns3 driver have unused parameters.
The compiler will warn about them when building
with -Wunused-parameter option of hns3.

Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  3 +-
 .../hns3/hns3_common/hclge_comm_rss.c         |  3 +-
 .../hns3/hns3_common/hclge_comm_rss.h         |  3 +-
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  5 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  2 +-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  7 ++-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 47 ++++++++-----------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 14 ++----
 9 files changed, 34 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 9c9c72dc57e0..b99d75260d59 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -647,8 +647,7 @@ struct hnae3_ae_ops {
 	int (*rm_mc_addr)(struct hnae3_handle *handle,
 			  const unsigned char *addr);
 	void (*set_tso_stats)(struct hnae3_handle *handle, int enable);
-	void (*update_stats)(struct hnae3_handle *handle,
-			     struct net_device_stats *net_stats);
+	void (*update_stats)(struct hnae3_handle *handle);
 	void (*get_stats)(struct hnae3_handle *handle, u64 *data);
 	void (*get_mac_stats)(struct hnae3_handle *handle,
 			      struct hns3_mac_stats *mac_stats);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
index ae2736549526..b4ae2160aff4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
@@ -305,8 +305,7 @@ int hclge_comm_set_rss_indir_table(struct hnae3_ae_dev *ae_dev,
 	return 0;
 }
 
-int hclge_comm_set_rss_input_tuple(struct hnae3_handle *nic,
-				   struct hclge_comm_hw *hw, bool is_pf,
+int hclge_comm_set_rss_input_tuple(struct hclge_comm_hw *hw,
 				   struct hclge_comm_rss_cfg *rss_cfg)
 {
 	struct hclge_comm_rss_input_tuple_cmd *req;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
index 92af3d2980d3..cdafa63fe38b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
@@ -112,8 +112,7 @@ int hclge_comm_init_rss_tuple_cmd(struct hclge_comm_rss_cfg *rss_cfg,
 				  struct hnae3_ae_dev *ae_dev,
 				  struct hclge_comm_rss_input_tuple_cmd *req);
 u64 hclge_comm_convert_rss_tuple(u8 tuple_sets);
-int hclge_comm_set_rss_input_tuple(struct hnae3_handle *nic,
-				   struct hclge_comm_hw *hw, bool is_pf,
+int hclge_comm_set_rss_input_tuple(struct hclge_comm_hw *hw,
 				   struct hclge_comm_rss_cfg *rss_cfg);
 int hclge_comm_set_rss_indir_table(struct hnae3_ae_dev *ae_dev,
 				   struct hclge_comm_hw *hw, const u16 *indir);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index cf415cb37685..8679dd91a8a2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -958,8 +958,7 @@ static const struct hns3_dbg_item tx_bd_info_items[] = {
 	{ "MSS_HW_CSUM", 0 },
 };
 
-static void hns3_dump_tx_bd_info(struct hns3_nic_priv *priv,
-				 struct hns3_desc *desc, char **result, int idx)
+static void hns3_dump_tx_bd_info(struct hns3_desc *desc, char **result, int idx)
 {
 	unsigned int j = 0;
 
@@ -1008,7 +1007,7 @@ static int hns3_dbg_tx_bd_info(struct hns3_dbg_data *d, char *buf, int len)
 	for (i = 0; i < ring->desc_num; i++) {
 		desc = &ring->desc[i];
 
-		hns3_dump_tx_bd_info(priv, desc, result, i);
+		hns3_dump_tx_bd_info(desc, result, i);
 		hns3_dbg_fill_content(content, sizeof(content),
 				      tx_bd_info_items, (const char **)result,
 				      ARRAY_SIZE(tx_bd_info_items));
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b676496ec6d7..9f6890059666 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2538,7 +2538,7 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 	if (test_bit(HNS3_NIC_STATE_DOWN, &priv->state))
 		return;
 
-	handle->ae_algo->ops->update_stats(handle, &netdev->stats);
+	handle->ae_algo->ops->update_stats(handle);
 
 	memset(&ring_total_stats, 0, sizeof(ring_total_stats));
 	for (idx = 0; idx < queue_num; idx++) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 1b360aa52e5d..8c0016b359b7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -693,7 +693,7 @@ static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
 
 /* iterator for handling rings in ring group */
 #define hns3_for_each_ring(pos, head) \
-	for (pos = (head).ring; (pos); pos = (pos)->next)
+	for ((pos) = (head).ring; (pos); (pos) = (pos)->next)
 
 #define hns3_get_handle(ndev) \
 	(((struct hns3_nic_priv *)netdev_priv(ndev))->ae_handle)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 51d1278b18f6..407d30ee55d2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -228,7 +228,7 @@ static u32 hns3_lb_check_rx_ring(struct hns3_nic_priv *priv, u32 budget)
 }
 
 static void hns3_lb_clear_tx_ring(struct hns3_nic_priv *priv, u32 start_ringid,
-				  u32 end_ringid, u32 budget)
+				  u32 end_ringid)
 {
 	u32 i;
 
@@ -295,8 +295,7 @@ static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
 
 out:
 	hns3_lb_clear_tx_ring(priv, HNS3_NIC_LB_TEST_RING_ID,
-			      HNS3_NIC_LB_TEST_RING_ID,
-			      HNS3_NIC_LB_TEST_PKT_NUM);
+			      HNS3_NIC_LB_TEST_RING_ID);
 
 	kfree_skb(skb);
 	return ret_val;
@@ -618,7 +617,7 @@ static void hns3_get_stats(struct net_device *netdev,
 		return;
 	}
 
-	h->ae_algo->ops->update_stats(h, &netdev->stats);
+	h->ae_algo->ops->update_stats(h);
 
 	/* get per-queue stats */
 	p = hns3_get_stats_tqps(h, p);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4fb5406c1951..1bbf18a96bf1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -689,8 +689,7 @@ static void hclge_update_stats_for_all(struct hclge_dev *hdev)
 			"Update MAC stats fail, status = %d.\n", status);
 }
 
-static void hclge_update_stats(struct hnae3_handle *handle,
-			       struct net_device_stats *net_stats)
+static void hclge_update_stats(struct hnae3_handle *handle)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
@@ -824,7 +823,7 @@ static void hclge_get_mac_stat(struct hnae3_handle *handle,
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	hclge_update_stats(handle, NULL);
+	hclge_update_stats(handle);
 
 	mac_stats->tx_pause_cnt = hdev->mac_stats.mac_tx_mac_pause_num;
 	mac_stats->rx_pause_cnt = hdev->mac_stats.mac_rx_mac_pause_num;
@@ -4965,9 +4964,7 @@ int hclge_rss_init_hw(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
-	ret = hclge_comm_set_rss_input_tuple(&hdev->vport[0].nic,
-					     &hdev->hw.hw, true,
-					     &hdev->rss_cfg);
+	ret = hclge_comm_set_rss_input_tuple(&hdev->hw.hw, &hdev->rss_cfg);
 	if (ret)
 		return ret;
 
@@ -6243,8 +6240,7 @@ static int hclge_fd_check_spec(struct hclge_dev *hdev,
 	return hclge_fd_check_ext_tuple(hdev, fs, unused_tuple);
 }
 
-static void hclge_fd_get_tcpip4_tuple(struct hclge_dev *hdev,
-				      struct ethtool_rx_flow_spec *fs,
+static void hclge_fd_get_tcpip4_tuple(struct ethtool_rx_flow_spec *fs,
 				      struct hclge_fd_rule *rule, u8 ip_proto)
 {
 	rule->tuples.src_ip[IPV4_INDEX] =
@@ -6273,8 +6269,7 @@ static void hclge_fd_get_tcpip4_tuple(struct hclge_dev *hdev,
 	rule->tuples_mask.ip_proto = 0xFF;
 }
 
-static void hclge_fd_get_ip4_tuple(struct hclge_dev *hdev,
-				   struct ethtool_rx_flow_spec *fs,
+static void hclge_fd_get_ip4_tuple(struct ethtool_rx_flow_spec *fs,
 				   struct hclge_fd_rule *rule)
 {
 	rule->tuples.src_ip[IPV4_INDEX] =
@@ -6297,8 +6292,7 @@ static void hclge_fd_get_ip4_tuple(struct hclge_dev *hdev,
 	rule->tuples_mask.ether_proto = 0xFFFF;
 }
 
-static void hclge_fd_get_tcpip6_tuple(struct hclge_dev *hdev,
-				      struct ethtool_rx_flow_spec *fs,
+static void hclge_fd_get_tcpip6_tuple(struct ethtool_rx_flow_spec *fs,
 				      struct hclge_fd_rule *rule, u8 ip_proto)
 {
 	be32_to_cpu_array(rule->tuples.src_ip, fs->h_u.tcp_ip6_spec.ip6src,
@@ -6327,8 +6321,7 @@ static void hclge_fd_get_tcpip6_tuple(struct hclge_dev *hdev,
 	rule->tuples_mask.ip_proto = 0xFF;
 }
 
-static void hclge_fd_get_ip6_tuple(struct hclge_dev *hdev,
-				   struct ethtool_rx_flow_spec *fs,
+static void hclge_fd_get_ip6_tuple(struct ethtool_rx_flow_spec *fs,
 				   struct hclge_fd_rule *rule)
 {
 	be32_to_cpu_array(rule->tuples.src_ip, fs->h_u.usr_ip6_spec.ip6src,
@@ -6351,8 +6344,7 @@ static void hclge_fd_get_ip6_tuple(struct hclge_dev *hdev,
 	rule->tuples_mask.ether_proto = 0xFFFF;
 }
 
-static void hclge_fd_get_ether_tuple(struct hclge_dev *hdev,
-				     struct ethtool_rx_flow_spec *fs,
+static void hclge_fd_get_ether_tuple(struct ethtool_rx_flow_spec *fs,
 				     struct hclge_fd_rule *rule)
 {
 	ether_addr_copy(rule->tuples.src_mac, fs->h_u.ether_spec.h_source);
@@ -6388,8 +6380,7 @@ static void hclge_fd_get_user_def_tuple(struct hclge_fd_user_def_info *info,
 	rule->ep.user_def = *info;
 }
 
-static int hclge_fd_get_tuple(struct hclge_dev *hdev,
-			      struct ethtool_rx_flow_spec *fs,
+static int hclge_fd_get_tuple(struct ethtool_rx_flow_spec *fs,
 			      struct hclge_fd_rule *rule,
 			      struct hclge_fd_user_def_info *info)
 {
@@ -6397,31 +6388,31 @@ static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 
 	switch (flow_type) {
 	case SCTP_V4_FLOW:
-		hclge_fd_get_tcpip4_tuple(hdev, fs, rule, IPPROTO_SCTP);
+		hclge_fd_get_tcpip4_tuple(fs, rule, IPPROTO_SCTP);
 		break;
 	case TCP_V4_FLOW:
-		hclge_fd_get_tcpip4_tuple(hdev, fs, rule, IPPROTO_TCP);
+		hclge_fd_get_tcpip4_tuple(fs, rule, IPPROTO_TCP);
 		break;
 	case UDP_V4_FLOW:
-		hclge_fd_get_tcpip4_tuple(hdev, fs, rule, IPPROTO_UDP);
+		hclge_fd_get_tcpip4_tuple(fs, rule, IPPROTO_UDP);
 		break;
 	case IP_USER_FLOW:
-		hclge_fd_get_ip4_tuple(hdev, fs, rule);
+		hclge_fd_get_ip4_tuple(fs, rule);
 		break;
 	case SCTP_V6_FLOW:
-		hclge_fd_get_tcpip6_tuple(hdev, fs, rule, IPPROTO_SCTP);
+		hclge_fd_get_tcpip6_tuple(fs, rule, IPPROTO_SCTP);
 		break;
 	case TCP_V6_FLOW:
-		hclge_fd_get_tcpip6_tuple(hdev, fs, rule, IPPROTO_TCP);
+		hclge_fd_get_tcpip6_tuple(fs, rule, IPPROTO_TCP);
 		break;
 	case UDP_V6_FLOW:
-		hclge_fd_get_tcpip6_tuple(hdev, fs, rule, IPPROTO_UDP);
+		hclge_fd_get_tcpip6_tuple(fs, rule, IPPROTO_UDP);
 		break;
 	case IPV6_USER_FLOW:
-		hclge_fd_get_ip6_tuple(hdev, fs, rule);
+		hclge_fd_get_ip6_tuple(fs, rule);
 		break;
 	case ETHER_FLOW:
-		hclge_fd_get_ether_tuple(hdev, fs, rule);
+		hclge_fd_get_ether_tuple(fs, rule);
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -6578,7 +6569,7 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	if (!rule)
 		return -ENOMEM;
 
-	ret = hclge_fd_get_tuple(hdev, fs, rule, &info);
+	ret = hclge_fd_get_tuple(fs, rule, &info);
 	if (ret) {
 		kfree(rule);
 		return ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index f24046250341..a84a15b7f645 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -121,8 +121,7 @@ static struct hclgevf_dev *hclgevf_ae_get_hdev(struct hnae3_handle *handle)
 		return container_of(handle, struct hclgevf_dev, nic);
 }
 
-static void hclgevf_update_stats(struct hnae3_handle *handle,
-				 struct net_device_stats *net_stats)
+static void hclgevf_update_stats(struct hnae3_handle *handle)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	int status;
@@ -1642,8 +1641,7 @@ static void hclgevf_reset(struct hclgevf_dev *hdev)
 	hclgevf_reset_err_handle(hdev);
 }
 
-static enum hnae3_reset_type hclgevf_get_reset_level(struct hclgevf_dev *hdev,
-						     unsigned long *addr)
+static enum hnae3_reset_type hclgevf_get_reset_level(unsigned long *addr)
 {
 	enum hnae3_reset_type rst_level = HNAE3_NONE_RESET;
 
@@ -1682,8 +1680,7 @@ static void hclgevf_reset_event(struct pci_dev *pdev,
 
 	if (hdev->default_reset_request)
 		hdev->reset_level =
-			hclgevf_get_reset_level(hdev,
-						&hdev->default_reset_request);
+			hclgevf_get_reset_level(&hdev->default_reset_request);
 	else
 		hdev->reset_level = HNAE3_VF_FUNC_RESET;
 
@@ -1825,7 +1822,7 @@ static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 
 		hdev->last_reset_time = jiffies;
 		hdev->reset_type =
-			hclgevf_get_reset_level(hdev, &hdev->reset_pending);
+			hclgevf_get_reset_level(&hdev->reset_pending);
 		if (hdev->reset_type != HNAE3_NONE_RESET)
 			hclgevf_reset(hdev);
 	} else if (test_and_clear_bit(HCLGEVF_RESET_REQUESTED,
@@ -2157,8 +2154,7 @@ static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 		if (ret)
 			return ret;
 
-		ret = hclge_comm_set_rss_input_tuple(&hdev->nic, &hdev->hw.hw,
-						     false, rss_cfg);
+		ret = hclge_comm_set_rss_input_tuple(&hdev->hw.hw, rss_cfg);
 		if (ret)
 			return ret;
 	}
-- 
2.30.0


