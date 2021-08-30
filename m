Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1599B3FB758
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 15:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236993AbhH3N4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 09:56:01 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18989 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhH3Nz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 09:55:58 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GysDF2H3kzbkc0;
        Mon, 30 Aug 2021 21:51:09 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 21:55:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 30 Aug 2021 21:55:02 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/4] net: hns3: add some required spaces
Date:   Mon, 30 Aug 2021 21:51:08 +0800
Message-ID: <1630331469-13707-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630331469-13707-1-git-send-email-huangguangbin2@huawei.com>
References: <1630331469-13707-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Add some required spaces to improve readability.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 ++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 16 ++++++++--------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 22 +++++++++++-----------
 5 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 1d51fae49307..546a60530384 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -65,7 +65,7 @@
 #define HNAE3_UNIC_CLIENT_INITED_B		0x4
 #define HNAE3_ROCE_CLIENT_INITED_B		0x5
 
-#define HNAE3_DEV_SUPPORT_ROCE_DCB_BITS (BIT(HNAE3_DEV_SUPPORT_DCB_B) |\
+#define HNAE3_DEV_SUPPORT_ROCE_DCB_BITS (BIT(HNAE3_DEV_SUPPORT_DCB_B) | \
 		BIT(HNAE3_DEV_SUPPORT_ROCE_B))
 
 #define hnae3_dev_roce_supported(hdev) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 1ec91435d0b4..2b66c59f5eaf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -797,10 +797,10 @@ static const struct hns3_dbg_item tx_bd_info_items[] = {
 	{ "T_CS_VLAN_TSO", 2 },
 	{ "OT_VLAN_TAG", 3 },
 	{ "TV", 2 },
-	{ "OLT_VLAN_LEN", 2},
-	{ "PAYLEN_OL4CS", 2},
-	{ "BD_FE_SC_VLD", 2},
-	{ "MSS_HW_CSUM", 0},
+	{ "OLT_VLAN_LEN", 2 },
+	{ "PAYLEN_OL4CS", 2 },
+	{ "BD_FE_SC_VLD", 2 },
+	{ "MSS_HW_CSUM", 0 },
 };
 
 static void hns3_dump_tx_bd_info(struct hns3_nic_priv *priv,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 18dd962444d7..ffd92332893d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -63,7 +63,7 @@ MODULE_PARM_DESC(tx_sgl, "Minimum number of frags when using dma_map_sg() to opt
 
 #define HNS3_SGL_SIZE(nfrag)	(sizeof(struct scatterlist) * (nfrag) +	\
 				 sizeof(struct sg_table))
-#define HNS3_MAX_SGL_SIZE	ALIGN(HNS3_SGL_SIZE(HNS3_MAX_TSO_BD_NUM),\
+#define HNS3_MAX_SGL_SIZE	ALIGN(HNS3_SGL_SIZE(HNS3_MAX_TSO_BD_NUM), \
 				      dma_get_cache_alignment())
 
 #define DEFAULT_MSG_LEVEL (NETIF_MSG_PROBE | NETIF_MSG_LINK | \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 299802995091..6162d9f88e37 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -392,11 +392,11 @@ enum hns3_pkt_ol4type {
 };
 
 struct hns3_rx_ptype {
-	u32 ptype:8;
-	u32 csum_level:2;
-	u32 ip_summed:2;
-	u32 l3_type:4;
-	u32 valid:1;
+	u32 ptype : 8;
+	u32 csum_level : 2;
+	u32 ip_summed : 2;
+	u32 l3_type : 4;
+	u32 valid : 1;
 };
 
 struct ring_stats {
@@ -522,9 +522,9 @@ struct hns3_enet_coalesce {
 	u16 int_gl;
 	u16 int_ql;
 	u16 int_ql_max;
-	u8 adapt_enable:1;
-	u8 ql_enable:1;
-	u8 unit_1us:1;
+	u8 adapt_enable : 1;
+	u8 ql_enable : 1;
+	u8 unit_1us : 1;
 	enum hns3_flow_level_range flow_level;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fb1c33cac2a8..e11afb6f3843 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -375,14 +375,14 @@ static const enum hclge_opcode_type hclge_dfx_reg_opcode_list[] = {
 };
 
 static const struct key_info meta_data_key_info[] = {
-	{ PACKET_TYPE_ID, 6},
-	{ IP_FRAGEMENT, 1},
-	{ ROCE_TYPE, 1},
-	{ NEXT_KEY, 5},
-	{ VLAN_NUMBER, 2},
-	{ SRC_VPORT, 12},
-	{ DST_VPORT, 12},
-	{ TUNNEL_PACKET, 1},
+	{ PACKET_TYPE_ID, 6 },
+	{ IP_FRAGEMENT, 1 },
+	{ ROCE_TYPE, 1 },
+	{ NEXT_KEY, 5 },
+	{ VLAN_NUMBER, 2 },
+	{ SRC_VPORT, 12 },
+	{ DST_VPORT, 12 },
+	{ TUNNEL_PACKET, 1 },
 };
 
 static const struct key_info tuple_key_info[] = {
@@ -749,9 +749,9 @@ static void hclge_update_stats(struct hnae3_handle *handle,
 
 static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 {
-#define HCLGE_LOOPBACK_TEST_FLAGS (HNAE3_SUPPORT_APP_LOOPBACK |\
-		HNAE3_SUPPORT_PHY_LOOPBACK |\
-		HNAE3_SUPPORT_SERDES_SERIAL_LOOPBACK |\
+#define HCLGE_LOOPBACK_TEST_FLAGS (HNAE3_SUPPORT_APP_LOOPBACK | \
+		HNAE3_SUPPORT_PHY_LOOPBACK | \
+		HNAE3_SUPPORT_SERDES_SERIAL_LOOPBACK | \
 		HNAE3_SUPPORT_SERDES_PARALLEL_LOOPBACK)
 
 	struct hclge_vport *vport = hclge_get_vport(handle);
-- 
2.8.1

