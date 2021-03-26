Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B06349EC3
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhCZBgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:36:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14599 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhCZBgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 21:36:22 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F64JX0VLHz19JFd;
        Fri, 26 Mar 2021 09:34:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 09:36:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/9] net: hns3: remove unused parameter from hclge_dbg_dump_loopback()
Date:   Fri, 26 Mar 2021 09:36:24 +0800
Message-ID: <1616722588-58967-6-git-send-email-tanhuazhong@huawei.com>
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

Parameter cm_buf is never used, so remove it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 1c69913..85d3064 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1541,8 +1541,7 @@ static void hclge_dbg_dump_ncl_config(struct hclge_dev *hdev,
 	}
 }
 
-static void hclge_dbg_dump_loopback(struct hclge_dev *hdev,
-				    const char *cmd_buf)
+static void hclge_dbg_dump_loopback(struct hclge_dev *hdev)
 {
 	struct phy_device *phydev = hdev->hw.mac.phydev;
 	struct hclge_config_mac_mode_cmd *req_app;
@@ -1778,7 +1777,7 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_dump_mac_tnl_status(hdev);
 	} else if (strncmp(cmd_buf, DUMP_LOOPBACK,
 		   strlen(DUMP_LOOPBACK)) == 0) {
-		hclge_dbg_dump_loopback(hdev, &cmd_buf[sizeof(DUMP_LOOPBACK)]);
+		hclge_dbg_dump_loopback(hdev);
 	} else if (strncmp(cmd_buf, "dump qs shaper", 14) == 0) {
 		hclge_dbg_dump_qs_shaper(hdev,
 					 &cmd_buf[sizeof("dump qs shaper")]);
-- 
2.7.4

