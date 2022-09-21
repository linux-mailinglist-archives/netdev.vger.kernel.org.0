Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA375BFDE7
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiIUMck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiIUMcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:32:31 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81647F124;
        Wed, 21 Sep 2022 05:32:29 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MXd4J0WgdzmVZn;
        Wed, 21 Sep 2022 20:28:32 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 20:32:27 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH -next, v3 04/10] net: hinic: remove unused macro
Date:   Wed, 21 Sep 2022 20:33:52 +0800
Message-ID: <20220921123358.63442-5-shaozhengchao@huawei.com>
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

remove unused macro.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_debugfs.h | 1 -
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c | 1 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_csr.h  | 1 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c  | 1 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c | 5 -----
 5 files changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
index e9e00cfa1329..e10f739d8339 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
@@ -12,7 +12,6 @@
 #define    TBL_ID_FUNC_CFG_SM_INST                      1
 
 #define HINIC_FUNCTION_CONFIGURE_TABLE_SIZE             64
-#define HINIC_FUNCTION_CONFIGURE_TABLE			1
 
 struct hinic_cmd_lt_rd {
 	u8	status;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 93192f58ac88..f4b680286911 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -55,7 +55,6 @@
 #define COALESCE_ALL_QUEUE		0xFFFF
 #define COALESCE_MAX_PENDING_LIMIT	(255 * COALESCE_PENDING_LIMIT_UNIT)
 #define COALESCE_MAX_TIMER_CFG		(255 * COALESCE_TIMER_CFG_UNIT)
-#define OBJ_STR_MAX_LEN			32
 
 struct hw2ethtool_link_mode {
 	enum ethtool_link_mode_bit_indices link_mode_bit;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_csr.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_csr.h
index 7e84e4e33fff..d56e7413ace0 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_csr.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_csr.h
@@ -22,7 +22,6 @@
 	(HINIC_DMA_ATTR_BASE + (idx) * HINIC_DMA_ATTR_STRIDE)
 
 #define HINIC_PPF_ELECTION_STRIDE                       0x4
-#define HINIC_CSR_MAX_PORTS                             4
 
 #define HINIC_CSR_PPF_ELECTION_ADDR(idx)                \
 	(HINIC_ELECTION_BASE +  (idx) * HINIC_PPF_ELECTION_STRIDE)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 4239013a3817..8d5c02905d9d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -29,7 +29,6 @@
 #include "hinic_hw_io.h"
 #include "hinic_hw_dev.h"
 
-#define IO_STATUS_TIMEOUT               100
 #define OUTBOUND_STATE_TIMEOUT          100
 #define DB_STATE_TIMEOUT                100
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
index b1edff5cab62..3f9c31d29215 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -117,7 +117,6 @@ enum hinic_mbox_tx_status {
 #define MBOX_WB_STATUS_MASK			0xFF
 #define MBOX_WB_ERROR_CODE_MASK			0xFF00
 #define MBOX_WB_STATUS_FINISHED_SUCCESS		0xFF
-#define MBOX_WB_STATUS_FINISHED_WITH_ERR	0xFE
 #define MBOX_WB_STATUS_NOT_FINISHED		0x00
 
 #define MBOX_STATUS_FINISHED(wb)	\
@@ -130,11 +129,8 @@ enum hinic_mbox_tx_status {
 #define SEQ_ID_START_VAL			0
 #define SEQ_ID_MAX_VAL				42
 
-#define DST_AEQ_IDX_DEFAULT_VAL			0
-#define SRC_AEQ_IDX_DEFAULT_VAL			0
 #define NO_DMA_ATTRIBUTE_VAL			0
 
-#define HINIC_MGMT_RSP_AEQN			0
 #define HINIC_MBOX_RSP_AEQN			2
 #define HINIC_MBOX_RECV_AEQN			0
 
@@ -146,7 +142,6 @@ enum hinic_mbox_tx_status {
 
 #define IS_PF_OR_PPF_SRC(src_func_idx)	((src_func_idx) < HINIC_MAX_PF_FUNCS)
 
-#define MBOX_RESPONSE_ERROR		0x1
 #define MBOX_MSG_ID_MASK		0xFF
 #define MBOX_MSG_ID(func_to_func)	((func_to_func)->send_msg_id)
 #define MBOX_MSG_ID_INC(func_to_func_mbox) (MBOX_MSG_ID(func_to_func_mbox) = \
-- 
2.17.1

