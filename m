Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B49D314699
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhBICnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:43:50 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11706 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhBICnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 21:43:40 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZRwT0wkJzlHtR;
        Tue,  9 Feb 2021 10:41:13 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 10:42:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 10/11] net: hns3: remove unused macro definition
Date:   Tue, 9 Feb 2021 10:42:00 +0800
Message-ID: <1612838521-59915-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
References: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Some macros are defined but unused, so remove them.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h  | 3 ---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 0d86c4d..19d7f28 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -46,15 +46,12 @@
 #define HCLGE_CMDQ_RX_DEPTH_REG		0x27020
 #define HCLGE_CMDQ_RX_TAIL_REG		0x27024
 #define HCLGE_CMDQ_RX_HEAD_REG		0x27028
-#define HCLGE_CMDQ_INTR_SRC_REG		0x27100
 #define HCLGE_CMDQ_INTR_STS_REG		0x27104
 #define HCLGE_CMDQ_INTR_EN_REG		0x27108
 #define HCLGE_CMDQ_INTR_GEN_REG		0x2710C
 
 /* bar registers for common func */
 #define HCLGE_VECTOR0_OTER_EN_REG	0x20600
-#define HCLGE_RAS_OTHER_STS_REG		0x20B00
-#define HCLGE_FUNC_RESET_STS_REG	0x20C00
 #define HCLGE_GRO_EN_REG		0x28000
 
 /* bar registers for rcb */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index cb619cc..2a6aaff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -278,7 +278,6 @@ struct hclgevf_cfg_tx_queue_pointer_cmd {
 
 #define HCLGEVF_NIC_CMQ_DESC_NUM	1024
 #define HCLGEVF_NIC_CMQ_DESC_NUM_S	3
-#define HCLGEVF_NIC_CMDQ_INT_SRC_REG	0x27100
 
 #define HCLGEVF_QUERY_DEV_SPECS_BD_NUM		4
 
-- 
2.7.4

