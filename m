Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46DA37F30B
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 08:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhEMGbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 02:31:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2466 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhEMGbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 02:31:02 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FghXD3zfwzBtwg;
        Thu, 13 May 2021 14:27:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 13 May 2021 14:29:47 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <luobin9@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/4] net: hinic: remove unnecessary blank line
Date:   Thu, 13 May 2021 14:26:50 +0800
Message-ID: <1620887213-49364-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620887213-49364-1-git-send-email-huangguangbin2@huawei.com>
References: <1620887213-49364-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two blank lines are unnecessary, this patch removes them.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c | 1 -
 drivers/net/ethernet/huawei/hinic/hinic_main.c    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index dc024ef521c0..162d3c330dec 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -1663,7 +1663,6 @@ static void hinic_diag_test(struct net_device *netdev,
 	err = hinic_port_link_state(nic_dev, &link_state);
 	if (!err && link_state == HINIC_LINK_STATE_UP)
 		netif_carrier_on(netdev);
-
 }
 
 static int hinic_set_phys_id(struct net_device *netdev,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 9a9b09401d01..1da5997f034c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -172,7 +172,6 @@ static int create_txqs(struct hinic_dev *nic_dev)
 				  "Failed to add SQ%d debug\n", i);
 			goto err_add_sq_dbg;
 		}
-
 	}
 
 	return 0;
-- 
2.8.1

