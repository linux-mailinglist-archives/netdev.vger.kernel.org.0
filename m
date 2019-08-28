Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6921A04DF
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfH1O0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:26:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41714 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbfH1OZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:44 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4F62DF1709B426F24BEF;
        Wed, 28 Aug 2019 22:25:41 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:30 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Guojia Liao <liaoguojia@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/12] net: hns3: reduce the parameters of some functions
Date:   Wed, 28 Aug 2019 22:23:08 +0800
Message-ID: <1567002196-63242-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
References: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

This patch simplifies parameters of some functions by deleting
unused parameter.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 28 +++++++++++-----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dde17be..fa85d9e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7342,7 +7342,7 @@ static void hclge_enable_vlan_filter(struct hnae3_handle *handle, bool enable)
 }
 
 static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
-				    bool is_kill, u16 vlan, u8 qos,
+				    bool is_kill, u16 vlan,
 				    __be16 proto)
 {
 #define HCLGE_MAX_VF_BYTES  16
@@ -7453,7 +7453,7 @@ static int hclge_set_port_vlan_filter(struct hclge_dev *hdev, __be16 proto,
 }
 
 static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
-				    u16 vport_id, u16 vlan_id, u8 qos,
+				    u16 vport_id, u16 vlan_id,
 				    bool is_kill)
 {
 	u16 vport_idx, vport_num = 0;
@@ -7463,7 +7463,7 @@ static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 		return 0;
 
 	ret = hclge_set_vf_vlan_common(hdev, vport_id, is_kill, vlan_id,
-				       0, proto);
+				       proto);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"Set %d vport vlan filter config fail, ret =%d.\n",
@@ -7750,7 +7750,7 @@ static int hclge_add_vport_all_vlan_table(struct hclge_vport *vport)
 		if (!vlan->hd_tbl_status) {
 			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
 						       vport->vport_id,
-						       vlan->vlan_id, 0, false);
+						       vlan->vlan_id, false);
 			if (ret) {
 				dev_err(&hdev->pdev->dev,
 					"restore vport vlan list failed, ret=%d\n",
@@ -7776,7 +7776,7 @@ static void hclge_rm_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 				hclge_set_vlan_filter_hw(hdev,
 							 htons(ETH_P_8021Q),
 							 vport->vport_id,
-							 vlan_id, 0,
+							 vlan_id,
 							 true);
 
 			list_del(&vlan->node);
@@ -7796,7 +7796,7 @@ void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
 			hclge_set_vlan_filter_hw(hdev,
 						 htons(ETH_P_8021Q),
 						 vport->vport_id,
-						 vlan->vlan_id, 0,
+						 vlan->vlan_id,
 						 true);
 
 		vlan->hd_tbl_status = false;
@@ -7843,7 +7843,7 @@ static void hclge_restore_vlan_table(struct hnae3_handle *handle)
 
 		if (state != HNAE3_PORT_BASE_VLAN_DISABLE) {
 			hclge_set_vlan_filter_hw(hdev, htons(vlan_proto),
-						 vport->vport_id, vlan_id, qos,
+						 vport->vport_id, vlan_id,
 						 false);
 			continue;
 		}
@@ -7853,7 +7853,7 @@ static void hclge_restore_vlan_table(struct hnae3_handle *handle)
 				hclge_set_vlan_filter_hw(hdev,
 							 htons(ETH_P_8021Q),
 							 vport->vport_id,
-							 vlan->vlan_id, 0,
+							 vlan->vlan_id,
 							 false);
 		}
 	}
@@ -7893,12 +7893,12 @@ static int hclge_update_vlan_filter_entries(struct hclge_vport *vport,
 						 htons(new_info->vlan_proto),
 						 vport->vport_id,
 						 new_info->vlan_tag,
-						 new_info->qos, false);
+						 false);
 	}
 
 	ret = hclge_set_vlan_filter_hw(hdev, htons(old_info->vlan_proto),
 				       vport->vport_id, old_info->vlan_tag,
-				       old_info->qos, true);
+				       true);
 	if (ret)
 		return ret;
 
@@ -7925,7 +7925,7 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 					       htons(vlan_info->vlan_proto),
 					       vport->vport_id,
 					       vlan_info->vlan_tag,
-					       vlan_info->qos, false);
+					       false);
 		if (ret)
 			return ret;
 
@@ -7934,7 +7934,7 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 					       htons(old_vlan_info->vlan_proto),
 					       vport->vport_id,
 					       old_vlan_info->vlan_tag,
-					       old_vlan_info->qos, true);
+					       true);
 		if (ret)
 			return ret;
 
@@ -8055,7 +8055,7 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 	 */
 	if (handle->port_base_vlan_state == HNAE3_PORT_BASE_VLAN_DISABLE) {
 		ret = hclge_set_vlan_filter_hw(hdev, proto, vport->vport_id,
-					       vlan_id, 0, is_kill);
+					       vlan_id, is_kill);
 		writen_to_tbl = true;
 	}
 
@@ -8091,7 +8091,7 @@ static void hclge_sync_vlan_filter(struct hclge_dev *hdev)
 		while (vlan_id != VLAN_N_VID) {
 			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
 						       vport->vport_id, vlan_id,
-						       0, true);
+						       true);
 			if (ret && ret != -EINVAL)
 				return;
 
-- 
2.7.4

