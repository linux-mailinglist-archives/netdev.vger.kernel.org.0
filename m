Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3468FD5C
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfHPIMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:12:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50874 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726801AbfHPIMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:12:09 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 84F126F33102C77B1A7F;
        Fri, 16 Aug 2019 16:11:58 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 16 Aug 2019 16:11:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        "Zhongzhu Liu" <liuzhongzhu@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        "Guangbin Huang" <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/6] net: hns3: add or modify comments
Date:   Fri, 16 Aug 2019 16:09:37 +0800
Message-ID: <1565942982-12105-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
References: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

To explain some code, this patch adds some comments, and modifies or
merges some comments to make them more neat.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Zhongzhu Liu <liuzhongzhu@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                | 12 ++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c            |  8 ++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h            |  8 ++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c         |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  8 ++++----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c     |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  9 ++++-----
 8 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 6c9fd58..3e21533 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -85,10 +85,10 @@ struct hnae3_queue {
 	void __iomem *io_base;
 	struct hnae3_ae_algo *ae_algo;
 	struct hnae3_handle *handle;
-	int tqp_index;	/* index in a handle */
-	u32 buf_size;	/* size for hnae_desc->addr, preset by AE */
-	u16 tx_desc_num;/* total number of tx desc */
-	u16 rx_desc_num;/* total number of rx desc */
+	int tqp_index;		/* index in a handle */
+	u32 buf_size;		/* size for hnae_desc->addr, preset by AE */
+	u16 tx_desc_num;	/* total number of tx desc */
+	u16 rx_desc_num;	/* total number of rx desc */
 };
 
 struct hns3_mac_stats {
@@ -96,7 +96,7 @@ struct hns3_mac_stats {
 	u64 rx_pause_cnt;
 };
 
-/*hnae3 loop mode*/
+/* hnae3 loop mode */
 enum hnae3_loop {
 	HNAE3_LOOP_APP,
 	HNAE3_LOOP_SERIAL_SERDES,
@@ -621,7 +621,7 @@ struct hnae3_handle {
 	struct pci_dev *pdev;
 	void *priv;
 	struct hnae3_ae_algo *ae_algo;  /* the class who provides this handle */
-	u64 flags; /* Indicate the capabilities for this handle*/
+	u64 flags; /* Indicate the capabilities for this handle */
 
 	union {
 		struct net_device *netdev; /* first member */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1750f80..a11d514 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -229,9 +229,9 @@ static void hns3_vector_gl_rl_init(struct hns3_enet_tqp_vector *tqp_vector,
 	/* initialize the configuration for interrupt coalescing.
 	 * 1. GL (Interrupt Gap Limiter)
 	 * 2. RL (Interrupt Rate Limiter)
+	 *
+	 * Default: enable interrupt coalescing self-adaptive and GL
 	 */
-
-	/* Default: enable interrupt coalescing self-adaptive and GL */
 	tqp_vector->tx_group.coal.gl_adapt_enable = 1;
 	tqp_vector->rx_group.coal.gl_adapt_enable = 1;
 
@@ -4207,8 +4207,8 @@ int hns3_nic_reset_all_ring(struct hnae3_handle *h)
 static void hns3_store_coal(struct hns3_nic_priv *priv)
 {
 	/* ethtool only support setting and querying one coal
-	 * configuation for now, so save the vector 0' coal
-	 * configuation here in order to restore it.
+	 * configuration for now, so save the vector 0' coal
+	 * configuration here in order to restore it.
 	 */
 	memcpy(&priv->tx_coal, &priv->tqp_vector[0].tx_group.coal,
 	       sizeof(struct hns3_enet_coalesce));
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 5b0ee1f..e37e64e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -302,7 +302,7 @@ struct hns3_desc_cb {
 	dma_addr_t dma; /* dma address of this desc */
 	void *buf;      /* cpu addr for a desc */
 
-	/* priv data for the desc, e.g. skb when use with ip stack*/
+	/* priv data for the desc, e.g. skb when use with ip stack */
 	void *priv;
 	u32 page_offset;
 	u32 length;     /* length of the buffer */
@@ -325,11 +325,11 @@ enum hns3_pkt_l3type {
 	HNS3_L3_TYPE_MAC_PAUSE,
 	HNS3_L3_TYPE_PFC_PAUSE,/* 0x9*/
 
-	/* reserved for 0xA~0xB*/
+	/* reserved for 0xA~0xB */
 
 	HNS3_L3_TYPE_CNM = 0xc,
 
-	/* reserved for 0xD~0xE*/
+	/* reserved for 0xD~0xE */
 
 	HNS3_L3_TYPE_PARSE_FAIL	= 0xf /* must be last */
 };
@@ -354,7 +354,7 @@ enum hns3_pkt_ol3type {
 	HNS3_OL3_TYPE_IPV4_OPT = 4,
 	HNS3_OL3_TYPE_IPV6_EXT,
 
-	/* reserved for 0x6~0xE*/
+	/* reserved for 0x6~0xE */
 
 	HNS3_OL3_TYPE_PARSE_FAIL = 0xf	/* must be last */
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 185ff32..677bfe06 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -635,7 +635,7 @@ static void hns3_get_ksettings(struct hnae3_handle *h,
 					     &cmd->base.speed,
 					     &cmd->base.duplex);
 
-	/* 2.get link mode*/
+	/* 2.get link mode */
 	if (ops->get_link_mode)
 		ops->get_link_mode(h,
 				   cmd->link_modes.supported,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index f0295d1..025184a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -897,14 +897,17 @@ static void hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
 	dev_info(&hdev->pdev->dev, " read result tcam key %s(%u):\n",
 		 sel_x ? "x" : "y", loc);
 
+	/* tcam_data0 ~ tcam_data1 */
 	req = (u32 *)req1->tcam_data;
 	for (i = 0; i < 2; i++)
 		dev_info(&hdev->pdev->dev, "%08x\n", *req++);
 
+	/* tcam_data2 ~ tcam_data7 */
 	req = (u32 *)req2->tcam_data;
 	for (i = 0; i < 6; i++)
 		dev_info(&hdev->pdev->dev, "%08x\n", *req++);
 
+	/* tcam_data8 ~ tcam_data12 */
 	req = (u32 *)req3->tcam_data;
 	for (i = 0; i < 5; i++)
 		dev_info(&hdev->pdev->dev, "%08x\n", *req++);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a3ca0e6..1d8dee1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2810,9 +2810,9 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 	 * defer the processing of the mailbox events. Since, we would have not
 	 * cleared RX CMDQ event this time we would receive again another
 	 * interrupt from H/W just for the mailbox.
+	 *
+	 * check for vector0 reset event sources
 	 */
-
-	/* check for vector0 reset event sources */
 	if (BIT(HCLGE_VECTOR0_IMPRESET_INT_B) & rst_src_reg) {
 		dev_info(&hdev->pdev->dev, "IMP reset interrupt\n");
 		set_bit(HNAE3_IMP_RESET, &hdev->reset_pending);
@@ -8000,7 +8000,7 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 		return -EBUSY;
 	}
 
-	/* When port base vlan enabled, we use port base vlan as the vlan
+	/* when port base vlan enabled, we use port base vlan as the vlan
 	 * filter entry. In this case, we don't update vlan filter table
 	 * when user add new vlan or remove exist vlan, just update the vport
 	 * vlan list. The vlan id in vlan list will be writen in vlan filter
@@ -8019,7 +8019,7 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 			hclge_add_vport_vlan_table(vport, vlan_id,
 						   writen_to_tbl);
 	} else if (is_kill) {
-		/* When remove hw vlan filter failed, record the vlan id,
+		/* when remove hw vlan filter failed, record the vlan id,
 		 * and try to remove it from hw later, to be consistence
 		 * with stack
 		 */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 5a7221e..f5da28a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -479,7 +479,7 @@ static void hclge_mbx_reset_vf_queue(struct hclge_vport *vport,
 
 	hclge_reset_vf_queue(vport, queue_id);
 
-	/* send response msg to VF after queue reset complete*/
+	/* send response msg to VF after queue reset complete */
 	hclge_gen_resp_to_vf(vport, mbx_req, 0, NULL, 0);
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index d8b8281..defc905 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1269,7 +1269,7 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 				   HCLGE_MBX_VLAN_FILTER, msg_data,
 				   HCLGEVF_VLAN_MBX_MSG_LEN, false, NULL, 0);
 
-	/* When remove hw vlan filter failed, record the vlan id,
+	/* when remove hw vlan filter failed, record the vlan id,
 	 * and try to remove it from hw later, to be consistence
 	 * with stack.
 	 */
@@ -1561,7 +1561,7 @@ static int hclgevf_reset(struct hclgevf_dev *hdev)
 
 	rtnl_lock();
 
-	/* now, re-initialize the nic client and ae device*/
+	/* now, re-initialize the nic client and ae device */
 	ret = hclgevf_reset_stack(hdev);
 	if (ret) {
 		dev_err(&hdev->pdev->dev, "failed to reset VF stack\n");
@@ -1784,9 +1784,8 @@ static void hclgevf_reset_service_task(struct work_struct *work)
 		 * 1b and 2. cases but we will not get any intimation about 1a
 		 * from PF as cmdq would be in unreliable state i.e. mailbox
 		 * communication between PF and VF would be broken.
-		 */
-
-		/* if we are never geting into pending state it means either:
+		 *
+		 * if we are never geting into pending state it means either:
 		 * 1. PF is not receiving our request which could be due to IMP
 		 *    reset
 		 * 2. PF is screwed
-- 
2.7.4

