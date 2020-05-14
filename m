Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441CB1D3018
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgENMnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 08:43:05 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59384 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbgENMnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 08:43:02 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4997AD3214A5F11C61A7;
        Thu, 14 May 2020 20:42:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 14 May 2020 20:42:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/5] net: hns3: modify some incorrect spelling
Date:   Thu, 14 May 2020 20:41:22 +0800
Message-ID: <1589460086-61130-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589460086-61130-1-git-send-email-tanhuazhong@huawei.com>
References: <1589460086-61130-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch modifies some incorrect spelling.

Reported-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h            |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 21a7361..1ffe8fa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -24,7 +24,7 @@ enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_GET_RETA,		/* (VF -> PF) get RETA */
 	HCLGE_MBX_GET_RSS_KEY,		/* (VF -> PF) get RSS key */
 	HCLGE_MBX_GET_MAC_ADDR,		/* (VF -> PF) get MAC addr */
-	HCLGE_MBX_PF_VF_RESP,		/* (PF -> VF) generate respone to VF */
+	HCLGE_MBX_PF_VF_RESP,		/* (PF -> VF) generate response to VF */
 	HCLGE_MBX_GET_BDNUM,		/* (VF -> PF) get BD num */
 	HCLGE_MBX_GET_BUFSIZE,		/* (VF -> PF) get buffer size */
 	HCLGE_MBX_GET_STREAMID,		/* (VF -> PF) get stream id */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 48c115c..26f6f06 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -691,7 +691,7 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 	enum hclge_opcode_type cmd;
 	struct hclge_desc desc;
 	int queue_id, group_id;
-	u32 qset_maping[32];
+	u32 qset_mapping[32];
 	int tc_id, qset_id;
 	int pri_id, ret;
 	u32 i;
@@ -746,7 +746,7 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 		if (ret)
 			goto err_tm_map_cmd_send;
 
-		qset_maping[group_id] =
+		qset_mapping[group_id] =
 			le32_to_cpu(bp_to_qs_map_cmd->qs_bit_map);
 	}
 
@@ -756,11 +756,11 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 	for (group_id = 0; group_id < 4; group_id++) {
 		dev_info(&hdev->pdev->dev,
 			 "%04d  | %08x:%08x:%08x:%08x:%08x:%08x:%08x:%08x\n",
-			 group_id * 256, qset_maping[(u32)(i + 7)],
-			 qset_maping[(u32)(i + 6)], qset_maping[(u32)(i + 5)],
-			 qset_maping[(u32)(i + 4)], qset_maping[(u32)(i + 3)],
-			 qset_maping[(u32)(i + 2)], qset_maping[(u32)(i + 1)],
-			 qset_maping[i]);
+			 group_id * 256, qset_mapping[(u32)(i + 7)],
+			 qset_mapping[(u32)(i + 6)], qset_mapping[(u32)(i + 5)],
+			 qset_mapping[(u32)(i + 4)], qset_mapping[(u32)(i + 3)],
+			 qset_mapping[(u32)(i + 2)], qset_mapping[(u32)(i + 1)],
+			 qset_mapping[i]);
 		i += 8;
 	}
 
-- 
2.7.4

