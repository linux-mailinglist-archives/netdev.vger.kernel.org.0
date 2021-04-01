Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EC2351B43
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbhDASHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:07:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15459 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237431AbhDASAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:00:02 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FB3QT0Hc1zqSVL;
        Thu,  1 Apr 2021 21:08:17 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 1 Apr 2021 21:10:13 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <linuxarm@huawei.com>, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 1/3] net/mlx5: Add a blank line after declarations.
Date:   Thu, 1 Apr 2021 21:07:41 +0800
Message-ID: <1617282463-47124-2-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617282463-47124-1-git-send-email-liweihang@huawei.com>
References: <1617282463-47124-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

There should be a blank lines after declarations.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c    | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 39475f6..254d4d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -358,6 +358,7 @@ static void arfs_may_expire_flow(struct mlx5e_priv *priv)
 	int j;
 
 	HLIST_HEAD(del_list);
+
 	spin_lock_bh(&priv->fs.arfs.arfs_lock);
 	mlx5e_for_each_arfs_rule(arfs_rule, htmp, priv->fs.arfs.arfs_tables, i, j) {
 		if (!work_pending(&arfs_rule->arfs_work) &&
@@ -387,6 +388,7 @@ static void arfs_del_rules(struct mlx5e_priv *priv)
 	int j;
 
 	HLIST_HEAD(del_list);
+
 	spin_lock_bh(&priv->fs.arfs.arfs_lock);
 	mlx5e_for_each_arfs_rule(rule, htmp, priv->fs.arfs.arfs_tables, i, j) {
 		hlist_del_init(&rule->hlist);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index 22bee49..771114a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -1085,6 +1085,7 @@ static int fpga_ipsec_fs_create_fte(struct mlx5_flow_root_namespace *ns,
 	rule->ctx = mlx5_fpga_ipsec_fs_create_sa_ctx(dev, fte, is_egress);
 	if (IS_ERR(rule->ctx)) {
 		int err = PTR_ERR(rule->ctx);
+
 		kfree(rule);
 		return err;
 	}
-- 
2.8.1

