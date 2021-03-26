Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E98C349EC6
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhCZBg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:36:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14602 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhCZBgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 21:36:22 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F64JX1988z19JFk;
        Fri, 26 Mar 2021 09:34:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 09:36:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/9] net: hns3: fix some typos in hclge_main.c
Date:   Fri, 26 Mar 2021 09:36:26 +0800
Message-ID: <1616722588-58967-8-git-send-email-tanhuazhong@huawei.com>
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

s/sucessful/successful/
s/serivce/service/
and remove a redundant new.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 449ea9e..6bfaf14 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2217,7 +2217,7 @@ static int hclge_only_alloc_priv_buff(struct hclge_dev *hdev,
 /* hclge_rx_buffer_calc: calculate the rx private buffer size for all TCs
  * @hdev: pointer to struct hclge_dev
  * @buf_alloc: pointer to buffer calculation data
- * @return: 0: calculate sucessful, negative: fail
+ * @return: 0: calculate successful, negative: fail
  */
 static int hclge_rx_buffer_calc(struct hclge_dev *hdev,
 				struct hclge_pkt_buf_alloc *buf_alloc)
@@ -3358,7 +3358,7 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 		 * caused this event. Therefore, we will do below for now:
 		 * 1. Assert HNAE3_UNKNOWN_RESET type of reset. This means we
 		 *    have defered type of reset to be used.
-		 * 2. Schedule the reset serivce task.
+		 * 2. Schedule the reset service task.
 		 * 3. When service task receives  HNAE3_UNKNOWN_RESET type it
 		 *    will fetch the correct type of reset.  This would be done
 		 *    by first decoding the types of errors.
@@ -8416,7 +8416,7 @@ int hclge_update_mac_list(struct hclge_vport *vport,
 
 	/* if the mac addr is already in the mac list, no need to add a new
 	 * one into it, just check the mac addr state, convert it to a new
-	 * new state, or just remove it, or do nothing.
+	 * state, or just remove it, or do nothing.
 	 */
 	mac_node = hclge_find_mac_node(list, addr);
 	if (mac_node) {
-- 
2.7.4

