Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B5C271BC5
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 09:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIUH3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 03:29:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13739 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726211AbgIUH3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 03:29:46 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E1E5BA8E2F36750E7470;
        Mon, 21 Sep 2020 15:29:40 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 15:29:34 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>,
        <zengweiliang.zengweiliang@huawei.com>
Subject: [PATCH net-next] hinic: improve the comments of function header
Date:   Mon, 21 Sep 2020 15:31:03 +0800
Message-ID: <20200921073103.10693-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the warnings about function header comments when building hinic
driver with "W=1" option.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c  | 6 +++++-
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c  | 3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c   | 1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 1 +
 drivers/net/ethernet/huawei/hinic/hinic_main.c    | 2 +-
 6 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index e0eb294779ec..5a6bbee819cd 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -784,7 +784,7 @@ static void free_cmdq(struct hinic_cmdq *cmdq)
  * init_cmdqs_ctxt - write the cmdq ctxt to HW after init all cmdq
  * @hwdev: the NIC HW device
  * @cmdqs: cmdqs to write the ctxts for
- * &db_area: db_area for all the cmdqs
+ * @db_area: db_area for all the cmdqs
  *
  * Return 0 - Success, negative - Failure
  **/
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 239685152f6e..0c74f6674634 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -437,6 +437,8 @@ static int get_base_qpn(struct hinic_hwdev *hwdev, u16 *base_qpn)
 /**
  * hinic_hwdev_ifup - Preparing the HW for passing IO
  * @hwdev: the NIC HW device
+ * @sq_depth: the send queue depth
+ * @rq_depth: the receive queue depth
  *
  * Return 0 - Success, negative - Failure
  **/
@@ -582,6 +584,7 @@ void hinic_hwdev_cb_unregister(struct hinic_hwdev *hwdev,
 /**
  * nic_mgmt_msg_handler - nic mgmt event handler
  * @handle: private data for the handler
+ * @cmd: message command
  * @buf_in: input buffer
  * @in_size: input size
  * @buf_out: output buffer
@@ -909,6 +912,7 @@ int hinic_set_interrupt_cfg(struct hinic_hwdev *hwdev,
 /**
  * hinic_init_hwdev - Initialize the NIC HW
  * @pdev: the NIC pci device
+ * @devlink: the poniter of hinic devlink
  *
  * Return initialized NIC HW device
  *
@@ -1121,7 +1125,7 @@ int hinic_hwdev_msix_cnt_set(struct hinic_hwdev *hwdev, u16 msix_index)
  * @msix_index: msix_index
  * @pending_limit: the maximum pending interrupt events (unit 8)
  * @coalesc_timer: coalesc period for interrupt (unit 8 us)
- * @lli_timer: replenishing period for low latency credit (unit 8 us)
+ * @lli_timer_cfg: replenishing period for low latency credit (unit 8 us)
  * @lli_credit_limit: maximum credits for low latency msix messages (unit 8)
  * @resend_timer: maximum wait for resending msix (unit coalesc period)
  *
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index f108b0c9228e..19942fef99d9 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -188,6 +188,7 @@ static u8 eq_cons_idx_checksum_set(u32 val)
 /**
  * eq_update_ci - update the HW cons idx of event queue
  * @eq: the event queue to update the cons idx for
+ * @arm_state: the arm bit value of eq's interrupt
  **/
 static void eq_update_ci(struct hinic_eq *eq, u32 arm_state)
 {
@@ -368,7 +369,7 @@ static void eq_irq_work(struct work_struct *work)
 
 /**
  * ceq_tasklet - the tasklet of the EQ that received the event
- * @ceq_data: the eq
+ * @t: the tasklet struct pointer
  **/
 static void ceq_tasklet(struct tasklet_struct *t)
 {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
index bc8925c0c982..efbaed389440 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
@@ -230,6 +230,7 @@ static int wait_hwif_ready(struct hinic_hwif *hwif)
  * @hwif: the HW interface of a pci function device
  * @attr0: the first attribute that was read from the hw
  * @attr1: the second attribute that was read from the hw
+ * @attr2: the third attribute that was read from the hw
  **/
 static void set_hwif_attr(struct hinic_hwif *hwif, u32 attr0, u32 attr1,
 			  u32 attr2)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index c6ce5966284c..039731380579 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -234,6 +234,7 @@ static int send_msg_to_mgmt(struct hinic_pf_to_mgmt *pf_to_mgmt,
  * @out_size: response length
  * @direction: the direction of the original message
  * @resp_msg_id: msg id to response for
+ * @timeout: time-out period of waiting for response
  *
  * Return 0 - Success, negative - Failure
  **/
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 2c63e3a690cd..7245aa0dcec9 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -966,7 +966,7 @@ static void hinic_refresh_nic_cfg(struct hinic_dev *nic_dev)
  * @handle: nic device for the handler
  * @buf_in: input buffer
  * @in_size: input size
- * @buf_in: output buffer
+ * @buf_out: output buffer
  * @out_size: returned output size
  *
  * Return 0 - Success, negative - Failure
-- 
2.17.1

