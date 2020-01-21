Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A92214388F
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgAUIm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:42:59 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10112 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729030AbgAUImc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 03:42:32 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C19211142CC74662878F;
        Tue, 21 Jan 2020 16:42:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 21 Jan 2020 16:42:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/9] net: hns3: delete unnecessary blank line and space for cleanup
Date:   Tue, 21 Jan 2020 16:42:11 +0800
Message-ID: <1579596133-54842-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
References: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

This patch deletes some unnecessary blank lines and spaces to clean up
code, and in hclgevf_set_vlan_filter() moves the comment to the front
of hclgevf_send_mbx_msg().

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c        | 6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 7 +++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 6b328a2..b3cb7cb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -176,7 +176,7 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 		return -EINVAL;
 	}
 
-	ring  = &priv->ring[q_num];
+	ring = &priv->ring[q_num];
 	value = readl_relaxed(ring->tqp->io_base + HNS3_RING_TX_RING_TAIL_REG);
 	tx_index = (cnt == 1) ? value : tx_index;
 
@@ -209,10 +209,10 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 		 le16_to_cpu(tx_desc->tx.bdtp_fe_sc_vld_ra_ri));
 	dev_info(dev, "(TX)mss: %u\n", le16_to_cpu(tx_desc->tx.mss));
 
-	ring  = &priv->ring[q_num + h->kinfo.num_tqps];
+	ring = &priv->ring[q_num + h->kinfo.num_tqps];
 	value = readl_relaxed(ring->tqp->io_base + HNS3_RING_RX_RING_TAIL_REG);
 	rx_index = (cnt == 1) ? value : tx_index;
-	rx_desc	 = &ring->desc[rx_index];
+	rx_desc = &ring->desc[rx_index];
 
 	addr = le64_to_cpu(rx_desc->addr);
 	dev_info(dev, "RX Queue Num: %u, BD Index: %u\n", q_num, rx_index);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 2a472b0..4b87513 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1316,14 +1316,13 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 	msg_data[0] = is_kill;
 	memcpy(&msg_data[1], &vlan_id, sizeof(vlan_id));
 	memcpy(&msg_data[3], &proto, sizeof(proto));
-	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_VLAN,
-				   HCLGE_MBX_VLAN_FILTER, msg_data,
-				   HCLGEVF_VLAN_MBX_MSG_LEN, true, NULL, 0);
-
 	/* when remove hw vlan filter failed, record the vlan id,
 	 * and try to remove it from hw later, to be consistence
 	 * with stack.
 	 */
+	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_VLAN,
+				   HCLGE_MBX_VLAN_FILTER, msg_data,
+				   HCLGEVF_VLAN_MBX_MSG_LEN, true, NULL, 0);
 	if (is_kill && ret)
 		set_bit(vlan_id, hdev->vlan_del_fail_bmap);
 
-- 
2.7.4

