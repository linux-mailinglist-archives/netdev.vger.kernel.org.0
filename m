Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CB15BFDDF
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiIUMcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiIUMca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:32:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5CF75CE7;
        Wed, 21 Sep 2022 05:32:27 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXd5Y1vggzpV29;
        Wed, 21 Sep 2022 20:29:37 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 20:32:25 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH -next, v3 01/10] net: hinic: modify kernel doc comments
Date:   Wed, 21 Sep 2022 20:33:49 +0800
Message-ID: <20220921123358.63442-2-shaozhengchao@huawei.com>
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

The type of cmdq_free_page() hinic_set_pf_action() and
link_status_event_handler() are void, modify the comments.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c | 2 --
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c | 2 --
 drivers/net/ethernet/huawei/hinic/hinic_main.c  | 2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
index 0428faa68e80..fe91942ff86a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
@@ -115,8 +115,6 @@ int hinic_msix_attr_cnt_clear(struct hinic_hwif *hwif, u16 msix_index)
  * hinic_set_pf_action - set action on pf channel
  * @hwif: the HW interface of a pci function device
  * @action: action on pf channel
- *
- * Return 0 - Success, negative - Failure
  **/
 void hinic_set_pf_action(struct hinic_hwif *hwif, enum hinic_pf_action action)
 {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
index 4daf6bf291ec..e1a1735c00c1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
@@ -175,8 +175,6 @@ static int cmdq_allocate_page(struct hinic_cmdq_pages *cmdq_pages)
 /**
  * cmdq_free_page - free page from cmdq
  * @cmdq_pages: the pages of the cmdq queue struct that hold the page
- *
- * Return 0 - Success, negative - Failure
  **/
 static void cmdq_free_page(struct hinic_cmdq_pages *cmdq_pages)
 {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index c23ee2ddbce3..037170c8f379 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -960,8 +960,6 @@ static void hinic_refresh_nic_cfg(struct hinic_dev *nic_dev)
  * @in_size: input size
  * @buf_out: output buffer
  * @out_size: returned output size
- *
- * Return 0 - Success, negative - Failure
  **/
 static void link_status_event_handler(void *handle, void *buf_in, u16 in_size,
 				      void *buf_out, u16 *out_size)
-- 
2.17.1

