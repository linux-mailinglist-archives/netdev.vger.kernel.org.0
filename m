Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5897C1B6FDD
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgDXIhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:37:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2894 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726489AbgDXIhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 04:37:08 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 01BB9938CB2A2B5D3189;
        Fri, 24 Apr 2020 16:36:56 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 16:36:47 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <saeedm@mellanox.com>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH] net/mlx5e: Remove unneeded semicolon
Date:   Fri, 24 Apr 2020 16:43:57 +0800
Message-ID: <20200424084357.80679-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c:690:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index a172c5e39710..a673adb54307 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -687,7 +687,7 @@ mlx5_tc_ct_block_flow_offload(enum tc_setup_type type, void *type_data,
 		return mlx5_tc_ct_block_flow_offload_stats(ft, f);
 	default:
 		break;
-	};
+	}

 	return -EOPNOTSUPP;
 }
--
2.26.0.106.g9fadedd

