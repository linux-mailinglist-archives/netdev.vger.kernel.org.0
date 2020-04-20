Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FEF1AFFCC
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgDTCSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:18:50 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2802 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbgDTCSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:18:48 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 47B3A8E84D34B30889E9;
        Mon, 20 Apr 2020 10:18:45 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 20 Apr 2020 10:18:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 05/10] net: hns3: remove two unused structures in hclge_cmd.h
Date:   Mon, 20 Apr 2020 10:17:30 +0800
Message-ID: <1587349055-4403-6-git-send-email-tanhuazhong@huawei.com>
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

From: Guojia Liao <liaoguojia@huawei.com>

struct hclge_mac_vlan_remove_cmd and hclge_mac_vlan_add_cmd are unused.
So removes them from hclge_cmd.h.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 25 ----------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 96498d9..90e422ef 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -733,31 +733,6 @@ struct hclge_mac_mgr_tbl_entry_cmd {
 	u8      rsv3[2];
 };
 
-struct hclge_mac_vlan_add_cmd {
-	__le16  flags;
-	__le16  mac_addr_hi16;
-	__le32  mac_addr_lo32;
-	__le32  mac_addr_msk_hi32;
-	__le16  mac_addr_msk_lo16;
-	__le16  vlan_tag;
-	__le16  ingress_port;
-	__le16  egress_port;
-	u8      rsv[4];
-};
-
-#define HNS3_MAC_VLAN_CFG_FLAG_BIT 0
-struct hclge_mac_vlan_remove_cmd {
-	__le16  flags;
-	__le16  mac_addr_hi16;
-	__le32  mac_addr_lo32;
-	__le32  mac_addr_msk_hi32;
-	__le16  mac_addr_msk_lo16;
-	__le16  vlan_tag;
-	__le16  ingress_port;
-	__le16  egress_port;
-	u8      rsv[4];
-};
-
 struct hclge_vlan_filter_ctrl_cmd {
 	u8 vlan_type;
 	u8 vlan_fe;
-- 
2.7.4

