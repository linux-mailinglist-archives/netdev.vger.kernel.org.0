Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D81F349ECA
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhCZBg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:36:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14605 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhCZBgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 21:36:25 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F64JX1NWqz19JFm;
        Fri, 26 Mar 2021 09:34:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 09:36:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/9] net: hns3: remove unused parameter from hclge_set_vf_vlan_common()
Date:   Fri, 26 Mar 2021 09:36:23 +0800
Message-ID: <1616722588-58967-5-git-send-email-tanhuazhong@huawei.com>
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

From: Peng Li <lipeng321@huawei.com>

Parameter vf in hclge_set_vf_vlan_common() is unused now,
so remove it.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fbbc2a7..449ea9e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9468,8 +9468,7 @@ static int hclge_check_vf_vlan_cmd_status(struct hclge_dev *hdev, u16 vfid,
 }
 
 static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
-				    bool is_kill, u16 vlan,
-				    __be16 proto)
+				    bool is_kill, u16 vlan)
 {
 	struct hclge_vport *vport = &hdev->vport[vfid];
 	struct hclge_desc desc[2];
@@ -9535,8 +9534,7 @@ static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 	if (is_kill && !vlan_id)
 		return 0;
 
-	ret = hclge_set_vf_vlan_common(hdev, vport_id, is_kill, vlan_id,
-				       proto);
+	ret = hclge_set_vf_vlan_common(hdev, vport_id, is_kill, vlan_id);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"Set %u vport vlan filter config fail, ret =%d.\n",
-- 
2.7.4

