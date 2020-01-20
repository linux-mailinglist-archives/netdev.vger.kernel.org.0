Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67AE1142AC7
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 13:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgATM1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 07:27:23 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:33812 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726942AbgATM1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 07:27:19 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A44575CA724095EC7D30;
        Mon, 20 Jan 2020 20:27:15 +0800 (CST)
Received: from euler.huawei.com (10.175.104.193) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Mon, 20 Jan 2020 20:27:05 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <paulb@mellanox.com>, <ozsh@mellanox.com>, <markb@mellanox.com>,
        <saeedm@mellanox.com>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH next] net/mlx5: make the symbol 'ESW_POOLS' static
Date:   Mon, 20 Jan 2020 20:41:53 +0800
Message-ID: <20200120124153.32354-1-chenwandun@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.193]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:
drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c:35:20: warning: symbol 'ESW_POOLS' was not declared. Should it be static?

Fixes: 39ac237ce009 ("net/mlx5: E-Switch, Refactor chains and priorities")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index 3a60eb5360bd..c5a446e295aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -32,10 +32,10 @@
  * pools.
  */
 #define ESW_SIZE (16 * 1024 * 1024)
-const unsigned int ESW_POOLS[] = { 4 * 1024 * 1024,
-				   1 * 1024 * 1024,
-				   64 * 1024,
-				   4 * 1024, };
+static const unsigned int ESW_POOLS[] = { 4 * 1024 * 1024,
+					  1 * 1024 * 1024,
+					  64 * 1024,
+					  4 * 1024, };
 
 struct mlx5_esw_chains_priv {
 	struct rhashtable chains_ht;
-- 
2.17.1

