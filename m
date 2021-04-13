Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C389035E719
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348084AbhDMTbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346433AbhDMTa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DEC4613CD;
        Tue, 13 Apr 2021 19:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342236;
        bh=c1W430y3vEc78pdXjuwMlbqxjBGt89WrwrRqfW9uZHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DECwsCNmVsJoOd9yHWhv52/X08nhO3/vvrpXZR8GJK/1eI+q22+snPsV7/aJfqThY
         498618AIlnG2/h5wrSHypSs1Trtk3jP/+ZfaMEPRnWjU2/DmC2ubHMc5+T+AVZ74po
         psnuJDPuDL0TMSRDsrI8ahZu2OxYfOQHKzkC+KDs0mmOYOuLMMxwvTO0cB+rIRcWWW
         OdeHj3olYi8N/ByzbGJoUd7lfxhKcmR4/I5lpSOImF06edDjdpjL/056pA28GBfK2F
         1CpCqxxQuz8Idm+vPv+A8+KgxuuF9Gj73L/Pba2pVTiEiSkGLmoMN09vq1BRQ+SxCi
         78niYJWua4tNw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/16] net/mlx5: Add a blank line after declarations
Date:   Tue, 13 Apr 2021 12:30:03 -0700
Message-Id: <20210413193006.21650-14-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

There should be a blank lines after declarations.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c    | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index d5b1eb74d5e5..5cd466ec6492 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -392,11 +392,11 @@ static void arfs_may_expire_flow(struct mlx5e_priv *priv)
 {
 	struct arfs_rule *arfs_rule;
 	struct hlist_node *htmp;
+	HLIST_HEAD(del_list);
 	int quota = 0;
 	int i;
 	int j;
 
-	HLIST_HEAD(del_list);
 	spin_lock_bh(&priv->fs.arfs->arfs_lock);
 	mlx5e_for_each_arfs_rule(arfs_rule, htmp, priv->fs.arfs->arfs_tables, i, j) {
 		if (!work_pending(&arfs_rule->arfs_work) &&
@@ -422,10 +422,10 @@ static void arfs_del_rules(struct mlx5e_priv *priv)
 {
 	struct hlist_node *htmp;
 	struct arfs_rule *rule;
+	HLIST_HEAD(del_list);
 	int i;
 	int j;
 
-	HLIST_HEAD(del_list);
 	spin_lock_bh(&priv->fs.arfs->arfs_lock);
 	mlx5e_for_each_arfs_rule(rule, htmp, priv->fs.arfs->arfs_tables, i, j) {
 		hlist_del_init(&rule->hlist);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index 0b19293cdd74..0bba92cf5dc0 100644
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
2.30.2

