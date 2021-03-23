Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCB53458F2
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhCWHle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:41:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14009 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhCWHk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 03:40:59 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F4NXg3T2MzrX2D;
        Tue, 23 Mar 2021 15:38:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Mar 2021 15:40:51 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/8] net: hns: remove unused NIC_LB_TEST_RX_PKG_ERR
Date:   Tue, 23 Mar 2021 15:41:06 +0800
Message-ID: <1616485269-57044-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616485269-57044-1-git-send-email-tanhuazhong@huawei.com>
References: <1616485269-57044-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NIC_LB_TEST_RX_PKG_ERR is not used and can be removed.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 1af6647..177ce06 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -480,7 +480,7 @@ static int __lb_run_test(struct net_device *ndev,
 #define NIC_LB_TEST_NO_MEM_ERR 1
 #define NIC_LB_TEST_TX_CNT_ERR 2
 #define NIC_LB_TEST_RX_CNT_ERR 3
-#define NIC_LB_TEST_RX_PKG_ERR 4
+
 	struct hns_nic_priv *priv = netdev_priv(ndev);
 	struct hnae_handle *h = priv->ae_handle;
 	int i, j, lc, good_cnt, ret_val = 0;
-- 
2.7.4

