Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D50C8FD59
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfHPIMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:12:08 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726867AbfHPIMI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:12:08 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7251CFEF520C800561DF;
        Fri, 16 Aug 2019 16:11:58 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 16 Aug 2019 16:11:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/6] net: hns3: add phy_attached_info() to the hns3 driver
Date:   Fri, 16 Aug 2019 16:09:42 +0800
Message-ID: <1565942982-12105-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
References: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

This patch adds the call to phy_attached_info() to the hns3 driver
to identify which exact PHY drivers and models is in use.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index abb1b43..dc4dfd4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -231,6 +231,8 @@ int hclge_mac_connect_phy(struct hnae3_handle *handle)
 	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
 			   phydev->advertising);
 
+	phy_attached_info(phydev);
+
 	return 0;
 }
 
-- 
2.7.4

