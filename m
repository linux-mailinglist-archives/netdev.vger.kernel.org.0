Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6D82D2C64
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 14:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgLHN4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 08:56:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9038 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729025AbgLHN4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 08:56:48 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cr1sf6wYQzhp1j;
        Tue,  8 Dec 2020 21:55:34 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 21:55:57 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net/mlx5: simplify the return expression of mlx5_esw_offloads_pair()
Date:   Tue, 8 Dec 2020 21:56:25 +0800
Message-ID: <20201208135625.11872-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c9c2962ad49f..786d2fc4b403 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1893,13 +1893,8 @@ void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num)
 static int mlx5_esw_offloads_pair(struct mlx5_eswitch *esw,
 				  struct mlx5_eswitch *peer_esw)
 {
-	int err;
 
-	err = esw_add_fdb_peer_miss_rules(esw, peer_esw->dev);
-	if (err)
-		return err;
-
-	return 0;
+	return esw_add_fdb_peer_miss_rules(esw, peer_esw->dev);
 }
 
 static void mlx5_esw_offloads_unpair(struct mlx5_eswitch *esw)
-- 
2.22.0

