Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433C55BFDEB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiIUMcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiIUMca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:32:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2756FA2B;
        Wed, 21 Sep 2022 05:32:28 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXd5Y5ytKzpV2P;
        Wed, 21 Sep 2022 20:29:37 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 20:32:26 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH -next, v3 02/10] net: hinic: change type of function to be static
Date:   Wed, 21 Sep 2022 20:33:50 +0800
Message-ID: <20220921123358.63442-3-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220921123358.63442-1-shaozhengchao@huawei.com>
References: <20220921123358.63442-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions are called only in one file, change their type to static.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h | 3 ---
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c  | 4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h  | 3 ---
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c | 4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h | 4 ----
 drivers/net/ethernet/huawei/hinic/hinic_rx.c      | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.h      | 2 --
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c   | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_sriov.h   | 2 --
 drivers/net/ethernet/huawei/hinic/hinic_tx.c      | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.h      | 2 --
 12 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index a627237f694b..6bd06602deee 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -509,8 +509,8 @@ int hinic_cmdq_direct_resp(struct hinic_cmdqs *cmdqs,
  *
  * Return 0 - Success, negative - Failure
  **/
-int hinic_set_arm_bit(struct hinic_cmdqs *cmdqs,
-		      enum hinic_set_arm_qtype q_type, u32 q_id)
+static int hinic_set_arm_bit(struct hinic_cmdqs *cmdqs,
+			     enum hinic_set_arm_qtype q_type, u32 q_id)
 {
 	struct hinic_cmdq *cmdq = &cmdqs->cmdq[HINIC_CMDQ_SYNC];
 	struct hinic_hwif *hwif = cmdqs->hwif;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
index 9c413e963a04..ff09cf0ed52b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
@@ -177,9 +177,6 @@ int hinic_cmdq_direct_resp(struct hinic_cmdqs *cmdqs,
 			   enum hinic_mod_type mod, u8 cmd,
 			   struct hinic_cmdq_buf *buf_in, u64 *out_param);
 
-int hinic_set_arm_bit(struct hinic_cmdqs *cmdqs,
-		      enum hinic_set_arm_qtype q_type, u32 q_id);
-
 int hinic_init_cmdqs(struct hinic_cmdqs *cmdqs, struct hinic_hwif *hwif,
 		     void __iomem **db_area);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 2127a48749a8..641a20da6bb8 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -837,8 +837,8 @@ static int hinic_l2nic_reset(struct hinic_hwdev *hwdev)
 	return 0;
 }
 
-int hinic_get_interrupt_cfg(struct hinic_hwdev *hwdev,
-			    struct hinic_msix_config *interrupt_info)
+static int hinic_get_interrupt_cfg(struct hinic_hwdev *hwdev,
+				   struct hinic_msix_config *interrupt_info)
 {
 	u16 out_size = sizeof(*interrupt_info);
 	struct hinic_pfhwdev *pfhwdev;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 416492e48274..afa7b5e9601c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -587,9 +587,6 @@ int hinic_hwdev_hw_ci_addr_set(struct hinic_hwdev *hwdev, struct hinic_sq *sq,
 void hinic_hwdev_set_msix_state(struct hinic_hwdev *hwdev, u16 msix_index,
 				enum hinic_msix_state flag);
 
-int hinic_get_interrupt_cfg(struct hinic_hwdev *hwdev,
-			    struct hinic_msix_config *interrupt_info);
-
 int hinic_set_interrupt_cfg(struct hinic_hwdev *hwdev,
 			    struct hinic_msix_config *interrupt_info);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
index 5078c0c73863..b1edff5cab62 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -621,7 +621,7 @@ static bool check_vf_mbox_random_id(struct hinic_mbox_func_to_func *func_to_func
 	return false;
 }
 
-void hinic_mbox_func_aeqe_handler(void *handle, void *header, u8 size)
+static void hinic_mbox_func_aeqe_handler(void *handle, void *header, u8 size)
 {
 	struct hinic_mbox_func_to_func *func_to_func;
 	u64 mbox_header = *((u64 *)header);
@@ -649,7 +649,7 @@ void hinic_mbox_func_aeqe_handler(void *handle, void *header, u8 size)
 	recv_mbox_handler(func_to_func, (u64 *)header, recv_mbox);
 }
 
-void hinic_mbox_self_aeqe_handler(void *handle, void *header, u8 size)
+static void hinic_mbox_self_aeqe_handler(void *handle, void *header, u8 size)
 {
 	struct hinic_mbox_func_to_func *func_to_func;
 	struct hinic_send_mbox *send_mbox;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
index 46953190d29e..33ac7814d3b3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
@@ -150,10 +150,6 @@ void hinic_unregister_pf_mbox_cb(struct hinic_hwdev *hwdev,
 void hinic_unregister_vf_mbox_cb(struct hinic_hwdev *hwdev,
 				 enum hinic_mod_type mod);
 
-void hinic_mbox_func_aeqe_handler(void *handle, void *header, u8 size);
-
-void hinic_mbox_self_aeqe_handler(void *handle, void *header, u8 size);
-
 int hinic_func_to_func_init(struct hinic_hwdev *hwdev);
 
 void hinic_func_to_func_free(struct hinic_hwdev *hwdev);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index e5828a658caf..d649c6e323c8 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -50,7 +50,7 @@
  * hinic_rxq_clean_stats - Clean the statistics of specific queue
  * @rxq: Logical Rx Queue
  **/
-void hinic_rxq_clean_stats(struct hinic_rxq *rxq)
+static void hinic_rxq_clean_stats(struct hinic_rxq *rxq)
 {
 	struct hinic_rxq_stats *rxq_stats = &rxq->rxq_stats;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.h b/drivers/net/ethernet/huawei/hinic/hinic_rx.h
index 507dcbae9085..8f7bd6a049bd 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.h
@@ -41,8 +41,6 @@ struct hinic_rxq {
 	struct napi_struct      napi;
 };
 
-void hinic_rxq_clean_stats(struct hinic_rxq *rxq);
-
 void hinic_rxq_get_stats(struct hinic_rxq *rxq, struct hinic_rxq_stats *stats);
 
 int hinic_init_rxq(struct hinic_rxq *rxq, struct hinic_rq *rq,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index df555847afb5..a8f71a69ddcc 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -1293,7 +1293,7 @@ int hinic_pci_sriov_disable(struct pci_dev *pdev)
 	return 0;
 }
 
-int hinic_pci_sriov_enable(struct pci_dev *pdev, int num_vfs)
+static int hinic_pci_sriov_enable(struct pci_dev *pdev, int num_vfs)
 {
 	struct hinic_sriov_info *sriov_info;
 	int err;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.h b/drivers/net/ethernet/huawei/hinic/hinic_sriov.h
index ba627a362f9a..d4d4e63d31ea 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.h
@@ -98,8 +98,6 @@ void hinic_notify_all_vfs_link_changed(struct hinic_hwdev *hwdev,
 
 int hinic_pci_sriov_disable(struct pci_dev *dev);
 
-int hinic_pci_sriov_enable(struct pci_dev *dev, int num_vfs);
-
 int hinic_vf_func_init(struct hinic_hwdev *hwdev);
 
 void hinic_vf_func_free(struct hinic_hwdev *hwdev);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 3b6c7b585737..7f9d32860895 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -74,7 +74,7 @@ enum hinic_offload_type {
  * hinic_txq_clean_stats - Clean the statistics of specific queue
  * @txq: Logical Tx Queue
  **/
-void hinic_txq_clean_stats(struct hinic_txq *txq)
+static void hinic_txq_clean_stats(struct hinic_txq *txq)
 {
 	struct hinic_txq_stats *txq_stats = &txq->txq_stats;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.h b/drivers/net/ethernet/huawei/hinic/hinic_tx.h
index b3c8657774a7..91dc778362f3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.h
@@ -40,8 +40,6 @@ struct hinic_txq {
 	struct napi_struct      napi;
 };
 
-void hinic_txq_clean_stats(struct hinic_txq *txq);
-
 void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats);
 
 netdev_tx_t hinic_lb_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
-- 
2.17.1

