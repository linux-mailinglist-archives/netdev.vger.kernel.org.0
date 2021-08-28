Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0A43FA41B
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 09:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbhH1HAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 03:00:22 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14431 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbhH1HAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 03:00:08 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GxS5Q29tmzbf11;
        Sat, 28 Aug 2021 14:55:22 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 7/7] net: hns3: add required space in comment
Date:   Sat, 28 Aug 2021 14:55:21 +0800
Message-ID: <1630133721-9260-8-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630133721-9260-1-git-send-email-huangguangbin2@huawei.com>
References: <1630133721-9260-1-git-send-email-huangguangbin2@huawei.com>
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

Add some required spaces in comment for cleanup.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h         | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h         | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index aa86a81c8f4a..c2bd2584201f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -9,7 +9,7 @@
 
 enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_RESET = 0x01,		/* (VF -> PF) assert reset */
-	HCLGE_MBX_ASSERTING_RESET,	/* (PF -> VF) PF is asserting reset*/
+	HCLGE_MBX_ASSERTING_RESET,	/* (PF -> VF) PF is asserting reset */
 	HCLGE_MBX_SET_UNICAST,		/* (VF -> PF) set UC addr */
 	HCLGE_MBX_SET_MULTICAST,	/* (VF -> PF) set MC addr */
 	HCLGE_MBX_SET_VLAN,		/* (VF -> PF) set VLAN */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index dfad9060c284..299802995091 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -348,7 +348,7 @@ enum hns3_pkt_l3type {
 	HNS3_L3_TYPE_LLDP,
 	HNS3_L3_TYPE_BPDU,
 	HNS3_L3_TYPE_MAC_PAUSE,
-	HNS3_L3_TYPE_PFC_PAUSE,/* 0x9*/
+	HNS3_L3_TYPE_PFC_PAUSE, /* 0x9 */
 
 	/* reserved for 0xA~0xB */
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 0583e88d31d3..33244472e0d0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -453,7 +453,7 @@ struct hclge_tc_thrd {
 };
 
 struct hclge_priv_buf {
-	struct hclge_waterline wl;	/* Waterline for low and high*/
+	struct hclge_waterline wl;	/* Waterline for low and high */
 	u32 buf_size;	/* TC private buffer size */
 	u32 tx_buf_size;
 	u32 enable;	/* Enable TC private buffer or not */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a1dcdf76fdfe..fb1c33cac2a8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3421,7 +3421,7 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 	hclge_enable_vector(&hdev->misc_vector, false);
 	event_cause = hclge_check_event_cause(hdev, &clearval);
 
-	/* vector 0 interrupt is shared with reset and mailbox source events.*/
+	/* vector 0 interrupt is shared with reset and mailbox source events. */
 	switch (event_cause) {
 	case HCLGE_VECTOR0_EVENT_ERR:
 		hclge_errhand_task_schedule(hdev);
-- 
2.8.1

