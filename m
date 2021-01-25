Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE9D3022B7
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 09:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbhAYIQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 03:16:01 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:48243 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727221AbhAYHzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:55:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UMml0Q2_1611561039;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMml0Q2_1611561039)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 15:50:50 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     saeedm@nvidia.com
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] net/mlx5: Assign boolean values to a bool variable
Date:   Mon, 25 Jan 2021 15:50:37 +0800
Message-Id: <1611561037-8010-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:575:2-14: WARNING:
Assignment of 0/1 to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index b899539..c207f06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -572,7 +572,7 @@ static void del_hw_fte(struct fs_node *node)
 			mlx5_core_warn(dev,
 				       "flow steering can't delete fte in index %d of flow group id %d\n",
 				       fte->index, fg->id);
-		node->active = 0;
+		node->active = false;
 	}
 }
 
-- 
1.8.3.1

