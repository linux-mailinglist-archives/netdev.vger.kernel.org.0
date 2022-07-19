Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E887C57A850
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239576AbiGSUfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239709AbiGSUfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:35:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B5D474DF
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 619E461961
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA21C341C6;
        Tue, 19 Jul 2022 20:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262942;
        bh=J9aYQkmJJ676dSw1uj/xcGfkf86rwR3sGXM/zx4Z+78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AS3lWoF2Jp1Tea07Lkrsm+MlSrG0RwWWQmlEDFayt3WsFY0N+pQXVknClRRxwvejY
         5O1NkrB6IonEyQ+nL2n8zFXoj9qLQ1yQkY8T9vTcVKd0pp0aEtDEVhfTvuGOwzAx0v
         RSf3k0W60mRjfpCHBNlx536v0mMVqiMeqcfd3ccm4gMMNMVvUEiUzZqXWSHWVE6A5c
         Tzkui7Up6O7HtslYGjK2PDOG4s4mofw3ijcJl2HwgSZtBx2GZLYdO0BlQX0fYE0FIN
         1mKzFfYsRy7y7OF/PhOkyZBSLKnT9UP6PqMCf8uVJ7dRK2d4hC99dMUC75itG67e7d
         f3GML2Q7MMfJA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next V2 09/13] net/mlx5e: HTB, change functions name to follow convention
Date:   Tue, 19 Jul 2022 13:35:25 -0700
Message-Id: <20220719203529.51151-10-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719203529.51151-1-saeed@kernel.org>
References: <20220719203529.51151-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

Following the change of the functions to be object like, change also
the names.

Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 64 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en/selq.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 4 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 3eb4a741d75b..4428bbad3381 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -38,7 +38,7 @@ int mlx5e_qos_max_leaf_nodes(struct mlx5_core_dev *mdev)
 	return min(MLX5E_QOS_MAX_LEAF_NODES, mlx5_qos_max_leaf_nodes(mdev));
 }
 
-int mlx5e_qos_cur_leaf_nodes(struct mlx5e_htb *htb)
+int mlx5e_htb_cur_leaf_nodes(struct mlx5e_htb *htb)
 {
 	int last;
 
@@ -75,8 +75,8 @@ struct mlx5e_qos_node {
 #define MLX5E_HTB_CLASSID_ROOT 0xffffffff
 
 static struct mlx5e_qos_node *
-mlx5e_sw_node_create_leaf(struct mlx5e_htb *htb, u16 classid, u16 qid,
-			  struct mlx5e_qos_node *parent)
+mlx5e_htb_node_create_leaf(struct mlx5e_htb *htb, u16 classid, u16 qid,
+			   struct mlx5e_qos_node *parent)
 {
 	struct mlx5e_qos_node *node;
 
@@ -97,7 +97,7 @@ mlx5e_sw_node_create_leaf(struct mlx5e_htb *htb, u16 classid, u16 qid,
 	return node;
 }
 
-static struct mlx5e_qos_node *mlx5e_sw_node_create_root(struct mlx5e_htb *htb)
+static struct mlx5e_qos_node *mlx5e_htb_node_create_root(struct mlx5e_htb *htb)
 {
 	struct mlx5e_qos_node *node;
 
@@ -112,7 +112,7 @@ static struct mlx5e_qos_node *mlx5e_sw_node_create_root(struct mlx5e_htb *htb)
 	return node;
 }
 
-static struct mlx5e_qos_node *mlx5e_sw_node_find(struct mlx5e_htb *htb, u32 classid)
+static struct mlx5e_qos_node *mlx5e_htb_node_find(struct mlx5e_htb *htb, u32 classid)
 {
 	struct mlx5e_qos_node *node = NULL;
 
@@ -124,7 +124,7 @@ static struct mlx5e_qos_node *mlx5e_sw_node_find(struct mlx5e_htb *htb, u32 clas
 	return node;
 }
 
-static struct mlx5e_qos_node *mlx5e_sw_node_find_rcu(struct mlx5e_htb *htb, u32 classid)
+static struct mlx5e_qos_node *mlx5e_htb_node_find_rcu(struct mlx5e_htb *htb, u32 classid)
 {
 	struct mlx5e_qos_node *node = NULL;
 
@@ -136,7 +136,7 @@ static struct mlx5e_qos_node *mlx5e_sw_node_find_rcu(struct mlx5e_htb *htb, u32
 	return node;
 }
 
-static void mlx5e_sw_node_delete(struct mlx5e_htb *htb, struct mlx5e_qos_node *node)
+static void mlx5e_htb_node_delete(struct mlx5e_htb *htb, struct mlx5e_qos_node *node)
 {
 	hash_del_rcu(&node->hnode);
 	if (node->qid != MLX5E_QOS_QID_INNER) {
@@ -166,7 +166,7 @@ static u16 mlx5e_qid_from_qos(struct mlx5e_channels *chs, u16 qid)
 	return (chs->params.num_channels + is_ptp) * mlx5e_get_dcb_num_tc(&chs->params) + qid;
 }
 
-int mlx5e_get_txq_by_classid(struct mlx5e_htb *htb, u16 classid)
+int mlx5e_htb_get_txq_by_classid(struct mlx5e_htb *htb, u16 classid)
 {
 	struct mlx5e_qos_node *node;
 	u16 qid;
@@ -174,7 +174,7 @@ int mlx5e_get_txq_by_classid(struct mlx5e_htb *htb, u16 classid)
 
 	rcu_read_lock();
 
-	node = mlx5e_sw_node_find_rcu(htb, classid);
+	node = mlx5e_htb_node_find_rcu(htb, classid);
 	if (!node) {
 		res = -ENOENT;
 		goto out;
@@ -513,7 +513,7 @@ mlx5e_htb_root_add(struct mlx5e_htb *htb, u16 htb_maj_id, u16 htb_defcls,
 			goto err_cancel_selq;
 	}
 
-	root = mlx5e_sw_node_create_root(htb);
+	root = mlx5e_htb_node_create_root(htb);
 	if (IS_ERR(root)) {
 		err = PTR_ERR(root);
 		goto err_free_queues;
@@ -530,7 +530,7 @@ mlx5e_htb_root_add(struct mlx5e_htb *htb, u16 htb_maj_id, u16 htb_defcls,
 	return 0;
 
 err_sw_node_delete:
-	mlx5e_sw_node_delete(htb, root);
+	mlx5e_htb_node_delete(htb, root);
 
 err_free_queues:
 	if (opened)
@@ -556,7 +556,7 @@ static int mlx5e_htb_root_del(struct mlx5e_htb *htb)
 	mlx5e_selq_prepare_htb(htb->selq, 0, 0);
 	mlx5e_selq_apply(htb->selq);
 
-	root = mlx5e_sw_node_find(htb, MLX5E_HTB_CLASSID_ROOT);
+	root = mlx5e_htb_node_find(htb, MLX5E_HTB_CLASSID_ROOT);
 	if (!root) {
 		qos_err(htb->mdev, "Failed to find the root node in the QoS tree\n");
 		return -ENOENT;
@@ -565,7 +565,7 @@ static int mlx5e_htb_root_del(struct mlx5e_htb *htb)
 	if (err)
 		qos_err(htb->mdev, "Failed to destroy root node %u, err = %d\n",
 			root->hw_id, err);
-	mlx5e_sw_node_delete(htb, root);
+	mlx5e_htb_node_delete(htb, root);
 
 	mlx5e_qos_deactivate_all_queues(&priv->channels);
 	mlx5e_qos_close_all_queues(&priv->channels);
@@ -623,11 +623,11 @@ mlx5e_htb_leaf_alloc_queue(struct mlx5e_htb *htb, u16 classid,
 		return qid;
 	}
 
-	parent = mlx5e_sw_node_find(htb, parent_classid);
+	parent = mlx5e_htb_node_find(htb, parent_classid);
 	if (!parent)
 		return -EINVAL;
 
-	node = mlx5e_sw_node_create_leaf(htb, classid, qid, parent);
+	node = mlx5e_htb_node_create_leaf(htb, classid, qid, parent);
 	if (IS_ERR(node))
 		return PTR_ERR(node);
 
@@ -642,7 +642,7 @@ mlx5e_htb_leaf_alloc_queue(struct mlx5e_htb *htb, u16 classid,
 		NL_SET_ERR_MSG_MOD(extack, "Firmware error when creating a leaf node.");
 		qos_err(htb->mdev, "Failed to create a leaf node (class %04x), err = %d\n",
 			classid, err);
-		mlx5e_sw_node_delete(htb, node);
+		mlx5e_htb_node_delete(htb, node);
 		return err;
 	}
 
@@ -673,7 +673,7 @@ mlx5e_htb_leaf_to_inner(struct mlx5e_htb *htb, u16 classid, u16 child_classid,
 	qos_dbg(htb->mdev, "TC_HTB_LEAF_TO_INNER classid %04x, upcoming child %04x, rate %llu, ceil %llu\n",
 		classid, child_classid, rate, ceil);
 
-	node = mlx5e_sw_node_find(htb, classid);
+	node = mlx5e_htb_node_find(htb, classid);
 	if (!node)
 		return -ENOENT;
 
@@ -688,7 +688,7 @@ mlx5e_htb_leaf_to_inner(struct mlx5e_htb *htb, u16 classid, u16 child_classid,
 	}
 
 	/* Intentionally reuse the qid for the upcoming first child. */
-	child = mlx5e_sw_node_create_leaf(htb, child_classid, node->qid, node);
+	child = mlx5e_htb_node_create_leaf(htb, child_classid, node->qid, node);
 	if (IS_ERR(child)) {
 		err = PTR_ERR(child);
 		goto err_destroy_hw_node;
@@ -710,7 +710,7 @@ mlx5e_htb_leaf_to_inner(struct mlx5e_htb *htb, u16 classid, u16 child_classid,
 	/* No fail point. */
 
 	qid = node->qid;
-	/* Pairs with mlx5e_get_txq_by_classid. */
+	/* Pairs with mlx5e_htb_get_txq_by_classid. */
 	WRITE_ONCE(node->qid, MLX5E_QOS_QID_INNER);
 
 	if (test_bit(MLX5E_STATE_OPENED, &priv->state)) {
@@ -740,7 +740,7 @@ mlx5e_htb_leaf_to_inner(struct mlx5e_htb *htb, u16 classid, u16 child_classid,
 
 err_delete_sw_node:
 	child->qid = MLX5E_QOS_QID_INNER;
-	mlx5e_sw_node_delete(htb, child);
+	mlx5e_htb_node_delete(htb, child);
 
 err_destroy_hw_node:
 	tmp_err = mlx5_qos_destroy_node(htb->mdev, new_hw_id);
@@ -750,7 +750,7 @@ mlx5e_htb_leaf_to_inner(struct mlx5e_htb *htb, u16 classid, u16 child_classid,
 	return err;
 }
 
-static struct mlx5e_qos_node *mlx5e_sw_node_find_by_qid(struct mlx5e_htb *htb, u16 qid)
+static struct mlx5e_qos_node *mlx5e_htb_node_find_by_qid(struct mlx5e_htb *htb, u16 qid)
 {
 	struct mlx5e_qos_node *node = NULL;
 	int bkt;
@@ -794,7 +794,7 @@ static int mlx5e_htb_leaf_del(struct mlx5e_htb *htb, u16 *classid,
 
 	qos_dbg(htb->mdev, "TC_HTB_LEAF_DEL classid %04x\n", *classid);
 
-	node = mlx5e_sw_node_find(htb, *classid);
+	node = mlx5e_htb_node_find(htb, *classid);
 	if (!node)
 		return -ENOENT;
 
@@ -814,9 +814,9 @@ static int mlx5e_htb_leaf_del(struct mlx5e_htb *htb, u16 *classid,
 		qos_warn(htb->mdev, "Failed to destroy leaf node %u (class %04x), err = %d\n",
 			 node->hw_id, *classid, err);
 
-	mlx5e_sw_node_delete(htb, node);
+	mlx5e_htb_node_delete(htb, node);
 
-	moved_qid = mlx5e_qos_cur_leaf_nodes(htb);
+	moved_qid = mlx5e_htb_cur_leaf_nodes(htb);
 
 	if (moved_qid == 0) {
 		/* The last QoS SQ was just destroyed. */
@@ -838,7 +838,7 @@ static int mlx5e_htb_leaf_del(struct mlx5e_htb *htb, u16 *classid,
 	WARN(moved_qid == qid, "Can't move node with qid %u to itself", qid);
 	qos_dbg(htb->mdev, "Moving QoS SQ %u to %u\n", moved_qid, qid);
 
-	node = mlx5e_sw_node_find_by_qid(htb, moved_qid);
+	node = mlx5e_htb_node_find_by_qid(htb, moved_qid);
 	WARN(!node, "Could not find a node with qid %u to move to queue %u",
 	     moved_qid, qid);
 
@@ -891,7 +891,7 @@ mlx5e_htb_leaf_del_last(struct mlx5e_htb *htb, u16 classid, bool force,
 	qos_dbg(htb->mdev, "TC_HTB_LEAF_DEL_LAST%s classid %04x\n",
 		force ? "_FORCE" : "", classid);
 
-	node = mlx5e_sw_node_find(htb, classid);
+	node = mlx5e_htb_node_find(htb, classid);
 	if (!node)
 		return -ENOENT;
 
@@ -910,7 +910,7 @@ mlx5e_htb_leaf_del_last(struct mlx5e_htb *htb, u16 classid, bool force,
 
 	/* Store qid for reuse and prevent clearing the bit. */
 	qid = node->qid;
-	/* Pairs with mlx5e_get_txq_by_classid. */
+	/* Pairs with mlx5e_htb_get_txq_by_classid. */
 	WRITE_ONCE(node->qid, MLX5E_QOS_QID_INNER);
 
 	if (test_bit(MLX5E_STATE_OPENED, &priv->state)) {
@@ -927,7 +927,7 @@ mlx5e_htb_leaf_del_last(struct mlx5e_htb *htb, u16 classid, bool force,
 			 node->hw_id, classid, err);
 
 	parent = node->parent;
-	mlx5e_sw_node_delete(htb, node);
+	mlx5e_htb_node_delete(htb, node);
 
 	node = parent;
 	WRITE_ONCE(node->qid, qid);
@@ -961,7 +961,7 @@ mlx5e_htb_leaf_del_last(struct mlx5e_htb *htb, u16 classid, bool force,
 }
 
 static int
-mlx5e_qos_update_children(struct mlx5e_htb *htb, struct mlx5e_qos_node *node,
+mlx5e_htb_update_children(struct mlx5e_htb *htb, struct mlx5e_qos_node *node,
 			  struct netlink_ext_ack *extack)
 {
 	struct mlx5e_qos_node *child;
@@ -1005,7 +1005,7 @@ mlx5e_htb_node_modify(struct mlx5e_htb *htb, u16 classid, u64 rate, u64 ceil,
 	qos_dbg(htb->mdev, "TC_HTB_LEAF_MODIFY classid %04x, rate %llu, ceil %llu\n",
 		classid, rate, ceil);
 
-	node = mlx5e_sw_node_find(htb, classid);
+	node = mlx5e_htb_node_find(htb, classid);
 	if (!node)
 		return -ENOENT;
 
@@ -1029,7 +1029,7 @@ mlx5e_htb_node_modify(struct mlx5e_htb *htb, u16 classid, u64 rate, u64 ceil,
 	node->max_average_bw = max_average_bw;
 
 	if (ceil_changed)
-		err = mlx5e_qos_update_children(htb, node, extack);
+		err = mlx5e_htb_update_children(htb, node, extack);
 
 	return err;
 }
@@ -1117,7 +1117,7 @@ int mlx5e_htb_setup_tc(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb_
 		return mlx5e_htb_node_modify(htb, htb_qopt->classid, htb_qopt->rate, htb_qopt->ceil,
 					     htb_qopt->extack);
 	case TC_HTB_LEAF_QUERY_QUEUE:
-		res = mlx5e_get_txq_by_classid(htb, htb_qopt->classid);
+		res = mlx5e_htb_get_txq_by_classid(htb, htb_qopt->classid);
 		if (res < 0)
 			return res;
 		htb_qopt->qid = res;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
index f2c043dfaedd..c54eb6c50332 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
@@ -16,10 +16,9 @@ struct tc_htb_qopt_offload;
 
 int mlx5e_qos_bytes_rate_check(struct mlx5_core_dev *mdev, u64 nbytes);
 int mlx5e_qos_max_leaf_nodes(struct mlx5_core_dev *mdev);
-int mlx5e_qos_cur_leaf_nodes(struct mlx5e_htb *htb);
 
 /* TX datapath API */
-int mlx5e_get_txq_by_classid(struct mlx5e_htb *htb, u16 classid);
+int mlx5e_htb_get_txq_by_classid(struct mlx5e_htb *htb, u16 classid);
 
 /* SQ lifecycle */
 int mlx5e_qos_open_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs);
@@ -28,6 +27,7 @@ void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c);
 void mlx5e_qos_close_queues(struct mlx5e_channel *c);
 
 /* HTB API */
+int mlx5e_htb_cur_leaf_nodes(struct mlx5e_htb *htb);
 int mlx5e_htb_setup_tc(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb);
 
 /* MQPRIO TX rate limit */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index b8e6236c7678..e721f59fd79b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -184,7 +184,7 @@ static int mlx5e_select_htb_queue(struct mlx5e_priv *priv, struct sk_buff *skb,
 	if (!classid)
 		return 0;
 
-	return mlx5e_get_txq_by_classid(priv->htb, classid);
+	return mlx5e_htb_get_txq_by_classid(priv->htb, classid);
 }
 
 u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index baa71fbae973..992672fa53c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2578,7 +2578,7 @@ int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv)
 	int qos_queues = 0;
 
 	if (priv->htb)
-		qos_queues = mlx5e_qos_cur_leaf_nodes(priv->htb);
+		qos_queues = mlx5e_htb_cur_leaf_nodes(priv->htb);
 
 	nch = priv->channels.params.num_channels;
 	ntc = mlx5e_get_dcb_num_tc(&priv->channels.params);
-- 
2.36.1

