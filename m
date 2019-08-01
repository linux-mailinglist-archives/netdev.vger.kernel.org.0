Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744DD7D42D
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbfHAD62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:58:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3687 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729818AbfHAD57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:57:59 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7E517C27B436A05023F9;
        Thu,  1 Aug 2019 11:57:56 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Guojia Liao <liaoguojia@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 09/12] net: hns3: rename a member in struct hclge_mac_ethertype_idx_rd_cmd
Date:   Thu, 1 Aug 2019 11:55:42 +0800
Message-ID: <1564631745-36733-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
References: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

The member 'mac_add' defined in hclge_mac_ethertype_idx_rd_cmd
means MAC address, so 'mac_addr' is a better name for it.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h     | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 070b9dd..cfa77dd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -828,7 +828,7 @@ struct hclge_mac_ethertype_idx_rd_cmd {
 	u8	flags;
 	u8	resp_code;
 	__le16  vlan_tag;
-	u8      mac_add[6];
+	u8      mac_addr[6];
 	__le16  index;
 	__le16	ethter_type;
 	__le16  egress_port;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index e987d18..f16bfc6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -847,9 +847,9 @@ static void hclge_dbg_dump_mng_table(struct hclge_dev *hdev)
 		memset(printf_buf, 0, HCLGE_DBG_BUF_LEN);
 		snprintf(printf_buf, HCLGE_DBG_BUF_LEN,
 			 "%02u   |%02x:%02x:%02x:%02x:%02x:%02x|",
-			 req0->index, req0->mac_add[0], req0->mac_add[1],
-			 req0->mac_add[2], req0->mac_add[3], req0->mac_add[4],
-			 req0->mac_add[5]);
+			 req0->index, req0->mac_addr[0], req0->mac_addr[1],
+			 req0->mac_addr[2], req0->mac_addr[3],
+			 req0->mac_addr[4], req0->mac_addr[5]);
 
 		snprintf(printf_buf + strlen(printf_buf),
 			 HCLGE_DBG_BUF_LEN - strlen(printf_buf),
-- 
2.7.4

