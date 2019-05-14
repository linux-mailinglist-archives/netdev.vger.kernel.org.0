Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148B71C76D
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 13:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfENLDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 07:03:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7641 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfENLDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 07:03:47 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 236E5E71F5E1C101C2B3;
        Tue, 14 May 2019 19:03:45 +0800 (CST)
Received: from localhost (10.177.24.66) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 14 May 2019
 19:03:36 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <tariqt@mellanox.com>, <xudingke@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] net/mlx4_core: Change the error print to info print
Date:   Tue, 14 May 2019 19:03:19 +0800
Message-ID: <1557831799-15220-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The error print within mlx4_flow_steer_promisc_add() should
be a info print.

Fixes: 592e49dda812 ('net/mlx4: Implement promiscuous mode with device managed flow-steering')
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx4/mcg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index ffed2d4..9c48182 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -1492,7 +1492,7 @@ int mlx4_flow_steer_promisc_add(struct mlx4_dev *dev, u8 port,
 	rule.port = port;
 	rule.qpn = qpn;
 	INIT_LIST_HEAD(&rule.list);
-	mlx4_err(dev, "going promisc on %x\n", port);
+	mlx4_info(dev, "going promisc on %x\n", port);
 
 	return  mlx4_flow_attach(dev, &rule, regid_p);
 }
-- 
1.8.3.1


