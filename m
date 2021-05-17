Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26CC382610
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbhEQIAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2937 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbhEQIAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:12 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FkBK567z1zCtXJ;
        Mon, 17 May 2021 15:56:09 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:54 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:54 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>, Bin Luo <luobin9@huawei.com>
Subject: [PATCH v2 12/24] net: huawei: hinic: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:23 +0800
Message-ID: <20210517044535.21473-13-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:604: warning: expecting prototype for cmdq_arm_ceq_handler(). Prototype was for cmdq_sync_cmd_handler() instead
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c:59: warning: expecting prototype for get_capability(). Prototype was for parse_capability() instead
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c:101: warning: expecting prototype for get_cap_from_fw(). Prototype was for get_capability() instead
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c:355: warning: expecting prototype for clear_io_resource(). Prototype was for clear_io_resources() instead
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c:1100: warning: expecting prototype for hinic_hwdev_get_sq(). Prototype was for hinic_hwdev_get_rq() instead
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c:341: warning: expecting prototype for dma_attr_table_init(). Prototype was for dma_attr_init() instead
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c:904: warning: expecting prototype for hinic_put_wqe(). Prototype was for hinic_rq_put_wqe() instead
 drivers/net/ethernet/huawei/hinic/hinic_main.c:241: warning: expecting prototype for create_txqs(). Prototype was for create_rxqs() instead
 drivers/net/ethernet/huawei/hinic/hinic_main.c:295: warning: expecting prototype for free_txqs(). Prototype was for free_rxqs() instead
 drivers/net/ethernet/huawei/hinic/hinic_tx.c:667: warning: expecting prototype for free_all_rx_skbs(). Prototype was for free_all_tx_skbs() instead

Cc: Bin Luo <luobin9@huawei.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c  | 8 ++++----
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c   | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c   | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c    | 4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_tx.c      | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index 577cb2cffff2..307a6d4af993 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -594,7 +594,7 @@ static void cmdq_update_errcode(struct hinic_cmdq *cmdq, u16 prod_idx,
 }
 
 /**
- * cmdq_arm_ceq_handler - cmdq completion event handler for sync command
+ * cmdq_sync_cmd_handler - cmdq completion event handler for sync command
  * @cmdq: the cmdq of the command
  * @cons_idx: the consumer index to update the error code for
  * @errcode: the error code
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 19a91c0223a7..428108eb10d2 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -48,7 +48,7 @@ enum io_status {
 };
 
 /**
- * get_capability - convert device capabilities to NIC capabilities
+ * parse_capability - convert device capabilities to NIC capabilities
  * @hwdev: the HW device to set and convert device capabilities for
  * @dev_cap: device capabilities from FW
  *
@@ -92,7 +92,7 @@ static int parse_capability(struct hinic_hwdev *hwdev,
 }
 
 /**
- * get_cap_from_fw - get device capabilities from FW
+ * get_capability - get device capabilities from FW
  * @pfhwdev: the PF HW device to get capabilities for
  *
  * Return 0 - Success, negative - Failure
@@ -346,7 +346,7 @@ static int wait_for_db_state(struct hinic_hwdev *hwdev)
 }
 
 /**
- * clear_io_resource - set the IO resources as not active in the NIC
+ * clear_io_resources - set the IO resources as not active in the NIC
  * @hwdev: the NIC HW device
  *
  * Return 0 - Success, negative - Failure
@@ -1090,7 +1090,7 @@ struct hinic_sq *hinic_hwdev_get_sq(struct hinic_hwdev *hwdev, int i)
 }
 
 /**
- * hinic_hwdev_get_sq - get RQ
+ * hinic_hwdev_get_rq - get RQ
  * @hwdev: the NIC HW device
  * @i: the position of the RQ
  *
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
index 55b327eebe64..0428faa68e80 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
@@ -334,7 +334,7 @@ static void set_dma_attr(struct hinic_hwif *hwif, u32 entry_idx,
 }
 
 /**
- * dma_attr_table_init - initialize the default dma attributes
+ * dma_attr_init - initialize the default dma attributes
  * @hwif: the HW interface of a pci function device
  **/
 static void dma_attr_init(struct hinic_hwif *hwif)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
index dcba4d009bad..336248aa2e48 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
@@ -894,7 +894,7 @@ struct hinic_rq_wqe *hinic_rq_read_next_wqe(struct hinic_rq *rq,
 }
 
 /**
- * hinic_put_wqe - release the ci for new wqes
+ * hinic_rq_put_wqe - release the ci for new wqes
  * @rq: recv queue
  * @cons_idx: consumer index of the wqe
  * @wqe_size: the size of the wqe
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 1da5997f034c..405ee4d2d2b1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -232,7 +232,7 @@ static void free_txqs(struct hinic_dev *nic_dev)
 }
 
 /**
- * create_txqs - Create the Logical Rx Queues of specific NIC device
+ * create_rxqs - Create the Logical Rx Queues of specific NIC device
  * @nic_dev: the specific NIC device
  *
  * Return 0 - Success, negative - Failure
@@ -288,7 +288,7 @@ static int create_rxqs(struct hinic_dev *nic_dev)
 }
 
 /**
- * free_txqs - Free the Logical Rx Queues of specific NIC device
+ * free_rxqs - Free the Logical Rx Queues of specific NIC device
  * @nic_dev: the specific NIC device
  **/
 static void free_rxqs(struct hinic_dev *nic_dev)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 7bd414aed6ff..c5bdb0d374ef 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -660,7 +660,7 @@ static void tx_free_skb(struct hinic_dev *nic_dev, struct sk_buff *skb,
 }
 
 /**
- * free_all_rx_skbs - free all skbs in tx queue
+ * free_all_tx_skbs - free all skbs in tx queue
  * @txq: tx queue
  **/
 static void free_all_tx_skbs(struct hinic_txq *txq)
-- 
2.17.1

