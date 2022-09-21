Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47BA5BFDF2
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiIUMcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiIUMcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:32:33 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA3183BE8;
        Wed, 21 Sep 2022 05:32:31 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MXd4L2KZFzmVQG;
        Wed, 21 Sep 2022 20:28:34 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 20:32:29 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH -next, v3 08/10] net: hinic: remove unused enumerated value
Date:   Wed, 21 Sep 2022 20:33:56 +0800
Message-ID: <20220921123358.63442-9-shaozhengchao@huawei.com>
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

remove unused enumerated value.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c |  5 ----
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  5 ----
 .../net/ethernet/huawei/hinic/hinic_hw_wqe.h  | 25 -------------------
 3 files changed, 35 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index 6bd06602deee..78190e88cd75 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -82,11 +82,6 @@
 						     struct hinic_func_to_io, \
 						     cmdqs)
 
-enum cmdq_wqe_type {
-	WQE_LCMD_TYPE = 0,
-	WQE_SCMD_TYPE = 1,
-};
-
 enum completion_format {
 	COMPLETE_DIRECT = 0,
 	COMPLETE_SGE    = 1,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 8d5c02905d9d..94f470556295 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -41,11 +41,6 @@ enum intr_type {
 	INTR_MSIX_TYPE,
 };
 
-enum io_status {
-	IO_STOPPED = 0,
-	IO_RUNNING = 1,
-};
-
 /**
  * parse_capability - convert device capabilities to NIC capabilities
  * @hwdev: the HW device to set and convert device capabilities for
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
index f4b6d2c1061f..c6bdeed5606e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
@@ -261,23 +261,6 @@
 #define HINIC_RSS_TYPE_GET(val, member)                        \
 		(((u32)(val) >> HINIC_RSS_TYPE_##member##_SHIFT) & 0x1)
 
-enum hinic_l4offload_type {
-	HINIC_L4_OFF_DISABLE            = 0,
-	HINIC_TCP_OFFLOAD_ENABLE        = 1,
-	HINIC_SCTP_OFFLOAD_ENABLE       = 2,
-	HINIC_UDP_OFFLOAD_ENABLE        = 3,
-};
-
-enum hinic_vlan_offload {
-	HINIC_VLAN_OFF_DISABLE = 0,
-	HINIC_VLAN_OFF_ENABLE  = 1,
-};
-
-enum hinic_pkt_parsed {
-	HINIC_PKT_NOT_PARSED = 0,
-	HINIC_PKT_PARSED     = 1,
-};
-
 enum hinic_l3_offload_type {
 	L3TYPE_UNKNOWN = 0,
 	IPV6_PKT = 1,
@@ -305,18 +288,10 @@ enum hinic_outer_l3type {
 	HINIC_OUTER_L3TYPE_IPV4_CHKSUM          = 3,
 };
 
-enum hinic_media_type {
-	HINIC_MEDIA_UNKNOWN = 0,
-};
-
 enum hinic_l2type {
 	HINIC_L2TYPE_ETH = 0,
 };
 
-enum hinc_tunnel_l4type {
-	HINIC_TUNNEL_L4TYPE_UNKNOWN = 0,
-};
-
 struct hinic_cmdq_header {
 	u32     header_info;
 	u32     saved_data;
-- 
2.17.1

