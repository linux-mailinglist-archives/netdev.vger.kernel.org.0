Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1E01AFFCE
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgDTCTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:19:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2799 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbgDTCSv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:18:51 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 31CE9CFF094A680F9F5B;
        Mon, 20 Apr 2020 10:18:45 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 20 Apr 2020 10:18:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 07/10] net: hns3: clean up some coding style issue
Date:   Mon, 20 Apr 2020 10:17:32 +0800
Message-ID: <1587349055-4403-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
References: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes some unnecessary blank lines, redundant
parentheses, and changes one tab to blank in
hclge_dbg_dump_reg_common().

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 10 +++-------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 1722828..cfc9300 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -143,7 +143,7 @@ static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 		return;
 	}
 
-	buf_len	= sizeof(struct hclge_desc) * bd_num;
+	buf_len = sizeof(struct hclge_desc) * bd_num;
 	desc_src = kzalloc(buf_len, GFP_KERNEL);
 	if (!desc_src)
 		return;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9edee7d..635aec2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5380,7 +5380,7 @@ static int hclge_fd_check_ext_tuple(struct hclge_dev *hdev,
 				    struct ethtool_rx_flow_spec *fs,
 				    u32 *unused_tuple)
 {
-	if ((fs->flow_type & FLOW_EXT)) {
+	if (fs->flow_type & FLOW_EXT) {
 		if (fs->h_ext.vlan_etype)
 			return -EOPNOTSUPP;
 		if (!fs->h_ext.vlan_tci)
@@ -5401,7 +5401,7 @@ static int hclge_fd_check_ext_tuple(struct hclge_dev *hdev,
 		if (is_zero_ether_addr(fs->h_ext.h_dest))
 			*unused_tuple |= BIT(INNER_DST_MAC);
 		else
-			*unused_tuple &= ~(BIT(INNER_DST_MAC));
+			*unused_tuple &= ~BIT(INNER_DST_MAC);
 	}
 
 	return 0;
@@ -5674,7 +5674,7 @@ static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 		break;
 	}
 
-	if ((fs->flow_type & FLOW_EXT)) {
+	if (fs->flow_type & FLOW_EXT) {
 		rule->tuples.vlan_tag1 = be16_to_cpu(fs->h_ext.vlan_tci);
 		rule->tuples_mask.vlan_tag1 = be16_to_cpu(fs->m_ext.vlan_tci);
 	}
@@ -5785,7 +5785,6 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	}
 
 	rule->flow_type = fs->flow_type;
-
 	rule->location = fs->location;
 	rule->unused_tuple = unused;
 	rule->vf_id = dst_vport_id;
@@ -6273,7 +6272,6 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 	 */
 	if (hdev->fd_active_type == HCLGE_FD_EP_ACTIVE) {
 		spin_unlock_bh(&hdev->fd_rule_lock);
-
 		return -EOPNOTSUPP;
 	}
 
@@ -6287,14 +6285,12 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 		bit_id = find_first_zero_bit(hdev->fd_bmap, MAX_FD_FILTER_NUM);
 		if (bit_id >= hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1]) {
 			spin_unlock_bh(&hdev->fd_rule_lock);
-
 			return -ENOSPC;
 		}
 
 		rule = kzalloc(sizeof(*rule), GFP_ATOMIC);
 		if (!rule) {
 			spin_unlock_bh(&hdev->fd_rule_lock);
-
 			return -ENOMEM;
 		}
 
-- 
2.7.4

