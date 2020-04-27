Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5117D1BA78B
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgD0PNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:39 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42301 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727961AbgD0PNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DBD485C0098;
        Mon, 27 Apr 2020 11:13:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=C87+j/yhM27diOLX2W+HqibC08X+KFmUS/WCFJQ6v/0=; b=nKVAebqa
        uqQGfEhvI3DXRLxtC/M9+jfsrxm6108OSHuRvb7VlcGjVG5ABC0qsIYXgeRdpckl
        6eJU5E7FjU1CBGaAAK1b8OaHG/6lCDA59gXuNuhl5SyThGhD1WRpgo5nWV4p5oCG
        aAKYLlzukgP3GIy/dGMWaTvpONhBSrSAN2Hq9AR8dy4MIy7S1ZR93cG9OzbJAzkd
        pvYkRFZp66yJG6okXUCq9TNL6zCEp6XZ2tzvU9Z/6CadeOv5Dvmsp2pRn84d8jIc
        m9xUPKb0yo5uu5BV2lxXp2AD3r3XbFrUlecdG+w6WlMi1toVlV16QduENj5OeY/w
        EviMNCTjTRI8hA==
X-ME-Sender: <xms:nfamXnCxOxsq8BGJYqCC3bdtdYZF4Ffd1HPDoSQskrC1OPSkCly1og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:nfamXm2cAtGcIM1mpB39IDmEeAtyvl1j5Q5TU0Ml-9MH_3euQ6unyQ>
    <xmx:nfamXp1XmHclJ7z_Z2oRno_EbxHWPJO5VOdFBRv-gvkt4SXhBZ1KqA>
    <xmx:nfamXrB6gERKBk3lNbR8-gEvHTbNXwkNtZKryMfoLKSuEGkl4D4BRQ>
    <xmx:nfamXv4nRV7J18mBiSFOLuNTQHHl4LxZ-eYQic3rl3iq0LSMV0uZOw>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 709893280059;
        Mon, 27 Apr 2020 11:13:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/13] mlxsw: spectrum: Rename acl_block to flow_block
Date:   Mon, 27 Apr 2020 18:12:59 +0300
Message-Id: <20200427151310.3950411-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427151310.3950411-1-idosch@idosch.org>
References: <20200427151310.3950411-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The acl_block structure is going to be used for non-acl case - matchall
offload. So rename it accordingly.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 71 ++++++++--------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 64 +++++++--------
 .../mellanox/mlxsw/spectrum2_mr_tcam.c        | 14 ++--
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 82 +++++++++----------
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 24 +++---
 5 files changed, 128 insertions(+), 127 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 24ca8d5bc564..f64e8da21d4a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1544,23 +1544,23 @@ static int mlxsw_sp_setup_tc_cls_matchall(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int
-mlxsw_sp_setup_tc_cls_flower(struct mlxsw_sp_acl_block *acl_block,
+mlxsw_sp_setup_tc_cls_flower(struct mlxsw_sp_flow_block *flow_block,
 			     struct flow_cls_offload *f)
 {
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_acl_block_mlxsw_sp(acl_block);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_flow_block_mlxsw_sp(flow_block);
 
 	switch (f->command) {
 	case FLOW_CLS_REPLACE:
-		return mlxsw_sp_flower_replace(mlxsw_sp, acl_block, f);
+		return mlxsw_sp_flower_replace(mlxsw_sp, flow_block, f);
 	case FLOW_CLS_DESTROY:
-		mlxsw_sp_flower_destroy(mlxsw_sp, acl_block, f);
+		mlxsw_sp_flower_destroy(mlxsw_sp, flow_block, f);
 		return 0;
 	case FLOW_CLS_STATS:
-		return mlxsw_sp_flower_stats(mlxsw_sp, acl_block, f);
+		return mlxsw_sp_flower_stats(mlxsw_sp, flow_block, f);
 	case FLOW_CLS_TMPLT_CREATE:
-		return mlxsw_sp_flower_tmplt_create(mlxsw_sp, acl_block, f);
+		return mlxsw_sp_flower_tmplt_create(mlxsw_sp, flow_block, f);
 	case FLOW_CLS_TMPLT_DESTROY:
-		mlxsw_sp_flower_tmplt_destroy(mlxsw_sp, acl_block, f);
+		mlxsw_sp_flower_tmplt_destroy(mlxsw_sp, flow_block, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -1607,16 +1607,16 @@ static int mlxsw_sp_setup_tc_block_cb_matchall_eg(enum tc_setup_type type,
 static int mlxsw_sp_setup_tc_block_cb_flower(enum tc_setup_type type,
 					     void *type_data, void *cb_priv)
 {
-	struct mlxsw_sp_acl_block *acl_block = cb_priv;
+	struct mlxsw_sp_flow_block *flow_block = cb_priv;
 
 	switch (type) {
 	case TC_SETUP_CLSMATCHALL:
 		return 0;
 	case TC_SETUP_CLSFLOWER:
-		if (mlxsw_sp_acl_block_disabled(acl_block))
+		if (mlxsw_sp_flow_block_disabled(flow_block))
 			return -EOPNOTSUPP;
 
-		return mlxsw_sp_setup_tc_cls_flower(acl_block, type_data);
+		return mlxsw_sp_setup_tc_cls_flower(flow_block, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1624,9 +1624,9 @@ static int mlxsw_sp_setup_tc_block_cb_flower(enum tc_setup_type type,
 
 static void mlxsw_sp_tc_block_flower_release(void *cb_priv)
 {
-	struct mlxsw_sp_acl_block *acl_block = cb_priv;
+	struct mlxsw_sp_flow_block *flow_block = cb_priv;
 
-	mlxsw_sp_acl_block_destroy(acl_block);
+	mlxsw_sp_flow_block_destroy(flow_block);
 }
 
 static LIST_HEAD(mlxsw_sp_block_cb_list);
@@ -1636,7 +1636,7 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 			            struct flow_block_offload *f, bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	struct mlxsw_sp_acl_block *acl_block;
+	struct mlxsw_sp_flow_block *flow_block;
 	struct flow_block_cb *block_cb;
 	bool register_block = false;
 	int err;
@@ -1645,31 +1645,31 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 					mlxsw_sp_setup_tc_block_cb_flower,
 					mlxsw_sp);
 	if (!block_cb) {
-		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, f->net);
-		if (!acl_block)
+		flow_block = mlxsw_sp_flow_block_create(mlxsw_sp, f->net);
+		if (!flow_block)
 			return -ENOMEM;
 		block_cb = flow_block_cb_alloc(mlxsw_sp_setup_tc_block_cb_flower,
-					       mlxsw_sp, acl_block,
+					       mlxsw_sp, flow_block,
 					       mlxsw_sp_tc_block_flower_release);
 		if (IS_ERR(block_cb)) {
-			mlxsw_sp_acl_block_destroy(acl_block);
+			mlxsw_sp_flow_block_destroy(flow_block);
 			err = PTR_ERR(block_cb);
 			goto err_cb_register;
 		}
 		register_block = true;
 	} else {
-		acl_block = flow_block_cb_priv(block_cb);
+		flow_block = flow_block_cb_priv(block_cb);
 	}
 	flow_block_cb_incref(block_cb);
-	err = mlxsw_sp_acl_block_bind(mlxsw_sp, acl_block,
-				      mlxsw_sp_port, ingress, f->extack);
+	err = mlxsw_sp_flow_block_bind(mlxsw_sp, flow_block,
+				       mlxsw_sp_port, ingress, f->extack);
 	if (err)
 		goto err_block_bind;
 
 	if (ingress)
-		mlxsw_sp_port->ing_acl_block = acl_block;
+		mlxsw_sp_port->ing_flow_block = flow_block;
 	else
-		mlxsw_sp_port->eg_acl_block = acl_block;
+		mlxsw_sp_port->eg_flow_block = flow_block;
 
 	if (register_block) {
 		flow_block_cb_add(block_cb, f);
@@ -1687,10 +1687,11 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static void
 mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct flow_block_offload *f, bool ingress)
+				      struct flow_block_offload *f,
+				      bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	struct mlxsw_sp_acl_block *acl_block;
+	struct mlxsw_sp_flow_block *flow_block;
 	struct flow_block_cb *block_cb;
 	int err;
 
@@ -1701,13 +1702,13 @@ mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 		return;
 
 	if (ingress)
-		mlxsw_sp_port->ing_acl_block = NULL;
+		mlxsw_sp_port->ing_flow_block = NULL;
 	else
-		mlxsw_sp_port->eg_acl_block = NULL;
+		mlxsw_sp_port->eg_flow_block = NULL;
 
-	acl_block = flow_block_cb_priv(block_cb);
-	err = mlxsw_sp_acl_block_unbind(mlxsw_sp, acl_block,
-					mlxsw_sp_port, ingress);
+	flow_block = flow_block_cb_priv(block_cb);
+	err = mlxsw_sp_flow_block_unbind(mlxsw_sp, flow_block,
+					 mlxsw_sp_port, ingress);
 	if (!err && !flow_block_cb_decref(block_cb)) {
 		flow_block_cb_remove(block_cb, f);
 		list_del(&block_cb->driver_list);
@@ -1797,17 +1798,17 @@ static int mlxsw_sp_feature_hw_tc(struct net_device *dev, bool enable)
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 
 	if (!enable) {
-		if (mlxsw_sp_acl_block_rule_count(mlxsw_sp_port->ing_acl_block) ||
-		    mlxsw_sp_acl_block_rule_count(mlxsw_sp_port->eg_acl_block) ||
+		if (mlxsw_sp_flow_block_rule_count(mlxsw_sp_port->ing_flow_block) ||
+		    mlxsw_sp_flow_block_rule_count(mlxsw_sp_port->eg_flow_block) ||
 		    !list_empty(&mlxsw_sp_port->mall_tc_list)) {
 			netdev_err(dev, "Active offloaded tc filters, can't turn hw_tc_offload off\n");
 			return -EINVAL;
 		}
-		mlxsw_sp_acl_block_disable_inc(mlxsw_sp_port->ing_acl_block);
-		mlxsw_sp_acl_block_disable_inc(mlxsw_sp_port->eg_acl_block);
+		mlxsw_sp_flow_block_disable_inc(mlxsw_sp_port->ing_flow_block);
+		mlxsw_sp_flow_block_disable_inc(mlxsw_sp_port->eg_flow_block);
 	} else {
-		mlxsw_sp_acl_block_disable_dec(mlxsw_sp_port->ing_acl_block);
-		mlxsw_sp_acl_block_disable_dec(mlxsw_sp_port->eg_acl_block);
+		mlxsw_sp_flow_block_disable_dec(mlxsw_sp_port->ing_flow_block);
+		mlxsw_sp_flow_block_disable_dec(mlxsw_sp_port->eg_flow_block);
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index f158cd98f8d8..65b1a2d87c2d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -287,8 +287,8 @@ struct mlxsw_sp_port {
 	struct mlxsw_sp_port_vlan *default_vlan;
 	struct mlxsw_sp_qdisc_state *qdisc;
 	unsigned acl_rule_count;
-	struct mlxsw_sp_acl_block *ing_acl_block;
-	struct mlxsw_sp_acl_block *eg_acl_block;
+	struct mlxsw_sp_flow_block *ing_flow_block;
+	struct mlxsw_sp_flow_block *eg_flow_block;
 	struct {
 		struct delayed_work shaper_dw;
 		struct hwtstamp_config hwtstamp_config;
@@ -654,7 +654,7 @@ struct mlxsw_sp_acl_rule_info {
 	unsigned int counter_index;
 };
 
-struct mlxsw_sp_acl_block;
+struct mlxsw_sp_flow_block;
 struct mlxsw_sp_acl_ruleset;
 
 /* spectrum_acl.c */
@@ -663,7 +663,7 @@ enum mlxsw_sp_acl_profile {
 	MLXSW_SP_ACL_PROFILE_MR,
 };
 
-struct mlxsw_sp_acl_block {
+struct mlxsw_sp_flow_block {
 	struct list_head binding_list;
 	struct mlxsw_sp_acl_ruleset *ruleset_zero;
 	struct mlxsw_sp *mlxsw_sp;
@@ -679,74 +679,74 @@ struct mlxsw_sp_acl_block {
 struct mlxsw_afk *mlxsw_sp_acl_afk(struct mlxsw_sp_acl *acl);
 
 static inline struct mlxsw_sp *
-mlxsw_sp_acl_block_mlxsw_sp(struct mlxsw_sp_acl_block *block)
+mlxsw_sp_flow_block_mlxsw_sp(struct mlxsw_sp_flow_block *block)
 {
 	return block->mlxsw_sp;
 }
 
 static inline unsigned int
-mlxsw_sp_acl_block_rule_count(const struct mlxsw_sp_acl_block *block)
+mlxsw_sp_flow_block_rule_count(const struct mlxsw_sp_flow_block *block)
 {
 	return block ? block->rule_count : 0;
 }
 
 static inline void
-mlxsw_sp_acl_block_disable_inc(struct mlxsw_sp_acl_block *block)
+mlxsw_sp_flow_block_disable_inc(struct mlxsw_sp_flow_block *block)
 {
 	if (block)
 		block->disable_count++;
 }
 
 static inline void
-mlxsw_sp_acl_block_disable_dec(struct mlxsw_sp_acl_block *block)
+mlxsw_sp_flow_block_disable_dec(struct mlxsw_sp_flow_block *block)
 {
 	if (block)
 		block->disable_count--;
 }
 
 static inline bool
-mlxsw_sp_acl_block_disabled(const struct mlxsw_sp_acl_block *block)
+mlxsw_sp_flow_block_disabled(const struct mlxsw_sp_flow_block *block)
 {
 	return block->disable_count;
 }
 
 static inline bool
-mlxsw_sp_acl_block_is_egress_bound(const struct mlxsw_sp_acl_block *block)
+mlxsw_sp_flow_block_is_egress_bound(const struct mlxsw_sp_flow_block *block)
 {
 	return block->egress_binding_count;
 }
 
 static inline bool
-mlxsw_sp_acl_block_is_ingress_bound(const struct mlxsw_sp_acl_block *block)
+mlxsw_sp_flow_block_is_ingress_bound(const struct mlxsw_sp_flow_block *block)
 {
 	return block->ingress_binding_count;
 }
 
 static inline bool
-mlxsw_sp_acl_block_is_mixed_bound(const struct mlxsw_sp_acl_block *block)
+mlxsw_sp_flow_block_is_mixed_bound(const struct mlxsw_sp_flow_block *block)
 {
 	return block->ingress_binding_count && block->egress_binding_count;
 }
 
-struct mlxsw_sp_acl_block *mlxsw_sp_acl_block_create(struct mlxsw_sp *mlxsw_sp,
-						     struct net *net);
-void mlxsw_sp_acl_block_destroy(struct mlxsw_sp_acl_block *block);
-int mlxsw_sp_acl_block_bind(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_acl_block *block,
-			    struct mlxsw_sp_port *mlxsw_sp_port,
-			    bool ingress,
-			    struct netlink_ext_ack *extack);
-int mlxsw_sp_acl_block_unbind(struct mlxsw_sp *mlxsw_sp,
-			      struct mlxsw_sp_acl_block *block,
-			      struct mlxsw_sp_port *mlxsw_sp_port,
-			      bool ingress);
+struct mlxsw_sp_flow_block *mlxsw_sp_flow_block_create(struct mlxsw_sp *mlxsw_sp,
+						       struct net *net);
+void mlxsw_sp_flow_block_destroy(struct mlxsw_sp_flow_block *block);
+int mlxsw_sp_flow_block_bind(struct mlxsw_sp *mlxsw_sp,
+			     struct mlxsw_sp_flow_block *block,
+			     struct mlxsw_sp_port *mlxsw_sp_port,
+			     bool ingress,
+			     struct netlink_ext_ack *extack);
+int mlxsw_sp_flow_block_unbind(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_flow_block *block,
+			       struct mlxsw_sp_port *mlxsw_sp_port,
+			       bool ingress);
 struct mlxsw_sp_acl_ruleset *
 mlxsw_sp_acl_ruleset_lookup(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_acl_block *block, u32 chain_index,
+			    struct mlxsw_sp_flow_block *block, u32 chain_index,
 			    enum mlxsw_sp_acl_profile profile);
 struct mlxsw_sp_acl_ruleset *
 mlxsw_sp_acl_ruleset_get(struct mlxsw_sp *mlxsw_sp,
-			 struct mlxsw_sp_acl_block *block, u32 chain_index,
+			 struct mlxsw_sp_flow_block *block, u32 chain_index,
 			 enum mlxsw_sp_acl_profile profile,
 			 struct mlxsw_afk_element_usage *tmplt_elusage);
 void mlxsw_sp_acl_ruleset_put(struct mlxsw_sp *mlxsw_sp,
@@ -778,7 +778,7 @@ int mlxsw_sp_acl_rulei_act_drop(struct mlxsw_sp_acl_rule_info *rulei,
 int mlxsw_sp_acl_rulei_act_trap(struct mlxsw_sp_acl_rule_info *rulei);
 int mlxsw_sp_acl_rulei_act_mirror(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_acl_rule_info *rulei,
-				  struct mlxsw_sp_acl_block *block,
+				  struct mlxsw_sp_flow_block *block,
 				  struct net_device *out_dev,
 				  struct netlink_ext_ack *extack);
 int mlxsw_sp_acl_rulei_act_fwd(struct mlxsw_sp *mlxsw_sp,
@@ -901,19 +901,19 @@ extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 
 /* spectrum_flower.c */
 int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_acl_block *block,
+			    struct mlxsw_sp_flow_block *block,
 			    struct flow_cls_offload *f);
 void mlxsw_sp_flower_destroy(struct mlxsw_sp *mlxsw_sp,
-			     struct mlxsw_sp_acl_block *block,
+			     struct mlxsw_sp_flow_block *block,
 			     struct flow_cls_offload *f);
 int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
-			  struct mlxsw_sp_acl_block *block,
+			  struct mlxsw_sp_flow_block *block,
 			  struct flow_cls_offload *f);
 int mlxsw_sp_flower_tmplt_create(struct mlxsw_sp *mlxsw_sp,
-				 struct mlxsw_sp_acl_block *block,
+				 struct mlxsw_sp_flow_block *block,
 				 struct flow_cls_offload *f);
 void mlxsw_sp_flower_tmplt_destroy(struct mlxsw_sp *mlxsw_sp,
-				   struct mlxsw_sp_acl_block *block,
+				   struct mlxsw_sp_flow_block *block,
 				   struct flow_cls_offload *f);
 
 /* spectrum_qdisc.c */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
index e31ec75ac035..a11d911302f1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
@@ -9,7 +9,7 @@
 
 struct mlxsw_sp2_mr_tcam {
 	struct mlxsw_sp *mlxsw_sp;
-	struct mlxsw_sp_acl_block *acl_block;
+	struct mlxsw_sp_flow_block *flow_block;
 	struct mlxsw_sp_acl_ruleset *ruleset4;
 	struct mlxsw_sp_acl_ruleset *ruleset6;
 };
@@ -61,7 +61,7 @@ static int mlxsw_sp2_mr_tcam_ipv4_init(struct mlxsw_sp2_mr_tcam *mr_tcam)
 				     mlxsw_sp2_mr_tcam_usage_ipv4,
 				     ARRAY_SIZE(mlxsw_sp2_mr_tcam_usage_ipv4));
 	mr_tcam->ruleset4 = mlxsw_sp_acl_ruleset_get(mr_tcam->mlxsw_sp,
-						     mr_tcam->acl_block,
+						     mr_tcam->flow_block,
 						     MLXSW_SP_L3_PROTO_IPV4,
 						     MLXSW_SP_ACL_PROFILE_MR,
 						     &elusage);
@@ -111,7 +111,7 @@ static int mlxsw_sp2_mr_tcam_ipv6_init(struct mlxsw_sp2_mr_tcam *mr_tcam)
 				     mlxsw_sp2_mr_tcam_usage_ipv6,
 				     ARRAY_SIZE(mlxsw_sp2_mr_tcam_usage_ipv6));
 	mr_tcam->ruleset6 = mlxsw_sp_acl_ruleset_get(mr_tcam->mlxsw_sp,
-						     mr_tcam->acl_block,
+						     mr_tcam->flow_block,
 						     MLXSW_SP_L3_PROTO_IPV6,
 						     MLXSW_SP_ACL_PROFILE_MR,
 						     &elusage);
@@ -289,8 +289,8 @@ static int mlxsw_sp2_mr_tcam_init(struct mlxsw_sp *mlxsw_sp, void *priv)
 	int err;
 
 	mr_tcam->mlxsw_sp = mlxsw_sp;
-	mr_tcam->acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, NULL);
-	if (!mr_tcam->acl_block)
+	mr_tcam->flow_block = mlxsw_sp_flow_block_create(mlxsw_sp, NULL);
+	if (!mr_tcam->flow_block)
 		return -ENOMEM;
 
 	err = mlxsw_sp2_mr_tcam_ipv4_init(mr_tcam);
@@ -306,7 +306,7 @@ static int mlxsw_sp2_mr_tcam_init(struct mlxsw_sp *mlxsw_sp, void *priv)
 err_ipv6_init:
 	mlxsw_sp2_mr_tcam_ipv4_fini(mr_tcam);
 err_ipv4_init:
-	mlxsw_sp_acl_block_destroy(mr_tcam->acl_block);
+	mlxsw_sp_flow_block_destroy(mr_tcam->flow_block);
 	return err;
 }
 
@@ -316,7 +316,7 @@ static void mlxsw_sp2_mr_tcam_fini(void *priv)
 
 	mlxsw_sp2_mr_tcam_ipv6_fini(mr_tcam);
 	mlxsw_sp2_mr_tcam_ipv4_fini(mr_tcam);
-	mlxsw_sp_acl_block_destroy(mr_tcam->acl_block);
+	mlxsw_sp_flow_block_destroy(mr_tcam->flow_block);
 }
 
 const struct mlxsw_sp_mr_tcam_ops mlxsw_sp2_mr_tcam_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index bb06c007b3f2..f9524cb95e9f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -40,7 +40,7 @@ struct mlxsw_afk *mlxsw_sp_acl_afk(struct mlxsw_sp_acl *acl)
 	return acl->afk;
 }
 
-struct mlxsw_sp_acl_block_binding {
+struct mlxsw_sp_flow_block_binding {
 	struct list_head list;
 	struct net_device *dev;
 	struct mlxsw_sp_port *mlxsw_sp_port;
@@ -48,7 +48,7 @@ struct mlxsw_sp_acl_block_binding {
 };
 
 struct mlxsw_sp_acl_ruleset_ht_key {
-	struct mlxsw_sp_acl_block *block;
+	struct mlxsw_sp_flow_block *block;
 	u32 chain_index;
 	const struct mlxsw_sp_acl_profile_ops *ops;
 };
@@ -103,8 +103,8 @@ mlxsw_sp_acl_ruleset_is_singular(const struct mlxsw_sp_acl_ruleset *ruleset)
 
 static int
 mlxsw_sp_acl_ruleset_bind(struct mlxsw_sp *mlxsw_sp,
-			  struct mlxsw_sp_acl_block *block,
-			  struct mlxsw_sp_acl_block_binding *binding)
+			  struct mlxsw_sp_flow_block *block,
+			  struct mlxsw_sp_flow_block_binding *binding)
 {
 	struct mlxsw_sp_acl_ruleset *ruleset = block->ruleset_zero;
 	const struct mlxsw_sp_acl_profile_ops *ops = ruleset->ht_key.ops;
@@ -115,8 +115,8 @@ mlxsw_sp_acl_ruleset_bind(struct mlxsw_sp *mlxsw_sp,
 
 static void
 mlxsw_sp_acl_ruleset_unbind(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_acl_block *block,
-			    struct mlxsw_sp_acl_block_binding *binding)
+			    struct mlxsw_sp_flow_block *block,
+			    struct mlxsw_sp_flow_block_binding *binding)
 {
 	struct mlxsw_sp_acl_ruleset *ruleset = block->ruleset_zero;
 	const struct mlxsw_sp_acl_profile_ops *ops = ruleset->ht_key.ops;
@@ -126,7 +126,7 @@ mlxsw_sp_acl_ruleset_unbind(struct mlxsw_sp *mlxsw_sp,
 }
 
 static bool
-mlxsw_sp_acl_ruleset_block_bound(const struct mlxsw_sp_acl_block *block)
+mlxsw_sp_acl_ruleset_block_bound(const struct mlxsw_sp_flow_block *block)
 {
 	return block->ruleset_zero;
 }
@@ -134,9 +134,9 @@ mlxsw_sp_acl_ruleset_block_bound(const struct mlxsw_sp_acl_block *block)
 static int
 mlxsw_sp_acl_ruleset_block_bind(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_acl_ruleset *ruleset,
-				struct mlxsw_sp_acl_block *block)
+				struct mlxsw_sp_flow_block *block)
 {
-	struct mlxsw_sp_acl_block_binding *binding;
+	struct mlxsw_sp_flow_block_binding *binding;
 	int err;
 
 	block->ruleset_zero = ruleset;
@@ -159,19 +159,19 @@ mlxsw_sp_acl_ruleset_block_bind(struct mlxsw_sp *mlxsw_sp,
 static void
 mlxsw_sp_acl_ruleset_block_unbind(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_acl_ruleset *ruleset,
-				  struct mlxsw_sp_acl_block *block)
+				  struct mlxsw_sp_flow_block *block)
 {
-	struct mlxsw_sp_acl_block_binding *binding;
+	struct mlxsw_sp_flow_block_binding *binding;
 
 	list_for_each_entry(binding, &block->binding_list, list)
 		mlxsw_sp_acl_ruleset_unbind(mlxsw_sp, block, binding);
 	block->ruleset_zero = NULL;
 }
 
-struct mlxsw_sp_acl_block *mlxsw_sp_acl_block_create(struct mlxsw_sp *mlxsw_sp,
-						     struct net *net)
+struct mlxsw_sp_flow_block *
+mlxsw_sp_flow_block_create(struct mlxsw_sp *mlxsw_sp, struct net *net)
 {
-	struct mlxsw_sp_acl_block *block;
+	struct mlxsw_sp_flow_block *block;
 
 	block = kzalloc(sizeof(*block), GFP_KERNEL);
 	if (!block)
@@ -182,17 +182,17 @@ struct mlxsw_sp_acl_block *mlxsw_sp_acl_block_create(struct mlxsw_sp *mlxsw_sp,
 	return block;
 }
 
-void mlxsw_sp_acl_block_destroy(struct mlxsw_sp_acl_block *block)
+void mlxsw_sp_flow_block_destroy(struct mlxsw_sp_flow_block *block)
 {
 	WARN_ON(!list_empty(&block->binding_list));
 	kfree(block);
 }
 
-static struct mlxsw_sp_acl_block_binding *
-mlxsw_sp_acl_block_lookup(struct mlxsw_sp_acl_block *block,
-			  struct mlxsw_sp_port *mlxsw_sp_port, bool ingress)
+static struct mlxsw_sp_flow_block_binding *
+mlxsw_sp_flow_block_lookup(struct mlxsw_sp_flow_block *block,
+			   struct mlxsw_sp_port *mlxsw_sp_port, bool ingress)
 {
-	struct mlxsw_sp_acl_block_binding *binding;
+	struct mlxsw_sp_flow_block_binding *binding;
 
 	list_for_each_entry(binding, &block->binding_list, list)
 		if (binding->mlxsw_sp_port == mlxsw_sp_port &&
@@ -201,16 +201,16 @@ mlxsw_sp_acl_block_lookup(struct mlxsw_sp_acl_block *block,
 	return NULL;
 }
 
-int mlxsw_sp_acl_block_bind(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_acl_block *block,
-			    struct mlxsw_sp_port *mlxsw_sp_port,
-			    bool ingress,
-			    struct netlink_ext_ack *extack)
+int mlxsw_sp_flow_block_bind(struct mlxsw_sp *mlxsw_sp,
+			     struct mlxsw_sp_flow_block *block,
+			     struct mlxsw_sp_port *mlxsw_sp_port,
+			     bool ingress,
+			     struct netlink_ext_ack *extack)
 {
-	struct mlxsw_sp_acl_block_binding *binding;
+	struct mlxsw_sp_flow_block_binding *binding;
 	int err;
 
-	if (WARN_ON(mlxsw_sp_acl_block_lookup(block, mlxsw_sp_port, ingress)))
+	if (WARN_ON(mlxsw_sp_flow_block_lookup(block, mlxsw_sp_port, ingress)))
 		return -EEXIST;
 
 	if (ingress && block->ingress_blocker_rule_count) {
@@ -247,14 +247,14 @@ int mlxsw_sp_acl_block_bind(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-int mlxsw_sp_acl_block_unbind(struct mlxsw_sp *mlxsw_sp,
-			      struct mlxsw_sp_acl_block *block,
-			      struct mlxsw_sp_port *mlxsw_sp_port,
-			      bool ingress)
+int mlxsw_sp_flow_block_unbind(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_flow_block *block,
+			       struct mlxsw_sp_port *mlxsw_sp_port,
+			       bool ingress)
 {
-	struct mlxsw_sp_acl_block_binding *binding;
+	struct mlxsw_sp_flow_block_binding *binding;
 
-	binding = mlxsw_sp_acl_block_lookup(block, mlxsw_sp_port, ingress);
+	binding = mlxsw_sp_flow_block_lookup(block, mlxsw_sp_port, ingress);
 	if (!binding)
 		return -ENOENT;
 
@@ -274,7 +274,7 @@ int mlxsw_sp_acl_block_unbind(struct mlxsw_sp *mlxsw_sp,
 
 static struct mlxsw_sp_acl_ruleset *
 mlxsw_sp_acl_ruleset_create(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_acl_block *block, u32 chain_index,
+			    struct mlxsw_sp_flow_block *block, u32 chain_index,
 			    const struct mlxsw_sp_acl_profile_ops *ops,
 			    struct mlxsw_afk_element_usage *tmplt_elusage)
 {
@@ -345,7 +345,7 @@ static void mlxsw_sp_acl_ruleset_ref_dec(struct mlxsw_sp *mlxsw_sp,
 
 static struct mlxsw_sp_acl_ruleset *
 __mlxsw_sp_acl_ruleset_lookup(struct mlxsw_sp_acl *acl,
-			      struct mlxsw_sp_acl_block *block, u32 chain_index,
+			      struct mlxsw_sp_flow_block *block, u32 chain_index,
 			      const struct mlxsw_sp_acl_profile_ops *ops)
 {
 	struct mlxsw_sp_acl_ruleset_ht_key ht_key;
@@ -360,7 +360,7 @@ __mlxsw_sp_acl_ruleset_lookup(struct mlxsw_sp_acl *acl,
 
 struct mlxsw_sp_acl_ruleset *
 mlxsw_sp_acl_ruleset_lookup(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_acl_block *block, u32 chain_index,
+			    struct mlxsw_sp_flow_block *block, u32 chain_index,
 			    enum mlxsw_sp_acl_profile profile)
 {
 	const struct mlxsw_sp_acl_profile_ops *ops;
@@ -378,7 +378,7 @@ mlxsw_sp_acl_ruleset_lookup(struct mlxsw_sp *mlxsw_sp,
 
 struct mlxsw_sp_acl_ruleset *
 mlxsw_sp_acl_ruleset_get(struct mlxsw_sp *mlxsw_sp,
-			 struct mlxsw_sp_acl_block *block, u32 chain_index,
+			 struct mlxsw_sp_flow_block *block, u32 chain_index,
 			 enum mlxsw_sp_acl_profile profile,
 			 struct mlxsw_afk_element_usage *tmplt_elusage)
 {
@@ -541,11 +541,11 @@ int mlxsw_sp_acl_rulei_act_fwd(struct mlxsw_sp *mlxsw_sp,
 
 int mlxsw_sp_acl_rulei_act_mirror(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_acl_rule_info *rulei,
-				  struct mlxsw_sp_acl_block *block,
+				  struct mlxsw_sp_flow_block *block,
 				  struct net_device *out_dev,
 				  struct netlink_ext_ack *extack)
 {
-	struct mlxsw_sp_acl_block_binding *binding;
+	struct mlxsw_sp_flow_block_binding *binding;
 	struct mlxsw_sp_port *in_port;
 
 	if (!list_is_singular(&block->binding_list)) {
@@ -553,7 +553,7 @@ int mlxsw_sp_acl_rulei_act_mirror(struct mlxsw_sp *mlxsw_sp,
 		return -EOPNOTSUPP;
 	}
 	binding = list_first_entry(&block->binding_list,
-				   struct mlxsw_sp_acl_block_binding, list);
+				   struct mlxsw_sp_flow_block_binding, list);
 	in_port = binding->mlxsw_sp_port;
 
 	return mlxsw_afa_block_append_mirror(rulei->act_block,
@@ -775,7 +775,7 @@ int mlxsw_sp_acl_rule_add(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_acl_ruleset *ruleset = rule->ruleset;
 	const struct mlxsw_sp_acl_profile_ops *ops = ruleset->ht_key.ops;
-	struct mlxsw_sp_acl_block *block = ruleset->ht_key.block;
+	struct mlxsw_sp_flow_block *block = ruleset->ht_key.block;
 	int err;
 
 	err = ops->rule_add(mlxsw_sp, ruleset->priv, rule->priv, rule->rulei);
@@ -819,7 +819,7 @@ void mlxsw_sp_acl_rule_del(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_acl_ruleset *ruleset = rule->ruleset;
 	const struct mlxsw_sp_acl_profile_ops *ops = ruleset->ht_key.ops;
-	struct mlxsw_sp_acl_block *block = ruleset->ht_key.block;
+	struct mlxsw_sp_flow_block *block = ruleset->ht_key.block;
 
 	block->egress_blocker_rule_count -= rule->rulei->egress_bind_blocker;
 	block->ingress_blocker_rule_count -= rule->rulei->ingress_bind_blocker;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 51117a5a6bbf..89c2e9820e95 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -15,7 +15,7 @@
 #include "core_acl_flex_keys.h"
 
 static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
-					 struct mlxsw_sp_acl_block *block,
+					 struct mlxsw_sp_flow_block *block,
 					 struct mlxsw_sp_acl_rule_info *rulei,
 					 struct flow_action *flow_action,
 					 struct netlink_ext_ack *extack)
@@ -53,11 +53,11 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		case FLOW_ACTION_DROP: {
 			bool ingress;
 
-			if (mlxsw_sp_acl_block_is_mixed_bound(block)) {
+			if (mlxsw_sp_flow_block_is_mixed_bound(block)) {
 				NL_SET_ERR_MSG_MOD(extack, "Drop action is not supported when block is bound to ingress and egress");
 				return -EOPNOTSUPP;
 			}
-			ingress = mlxsw_sp_acl_block_is_ingress_bound(block);
+			ingress = mlxsw_sp_flow_block_is_ingress_bound(block);
 			err = mlxsw_sp_acl_rulei_act_drop(rulei, ingress,
 							  act->cookie, extack);
 			if (err) {
@@ -106,7 +106,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			struct mlxsw_sp_fid *fid;
 			u16 fid_index;
 
-			if (mlxsw_sp_acl_block_is_egress_bound(block)) {
+			if (mlxsw_sp_flow_block_is_egress_bound(block)) {
 				NL_SET_ERR_MSG_MOD(extack, "Redirect action is not supported on egress");
 				return -EOPNOTSUPP;
 			}
@@ -190,7 +190,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_flower_parse_meta(struct mlxsw_sp_acl_rule_info *rulei,
 				      struct flow_cls_offload *f,
-				      struct mlxsw_sp_acl_block *block)
+				      struct mlxsw_sp_flow_block *block)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct mlxsw_sp_port *mlxsw_sp_port;
@@ -371,7 +371,7 @@ static int mlxsw_sp_flower_parse_ip(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
-				 struct mlxsw_sp_acl_block *block,
+				 struct mlxsw_sp_flow_block *block,
 				 struct mlxsw_sp_acl_rule_info *rulei,
 				 struct flow_cls_offload *f)
 {
@@ -460,7 +460,7 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 		struct flow_match_vlan match;
 
 		flow_rule_match_vlan(rule, &match);
-		if (mlxsw_sp_acl_block_is_egress_bound(block)) {
+		if (mlxsw_sp_flow_block_is_egress_bound(block)) {
 			NL_SET_ERR_MSG_MOD(f->common.extack, "vlan_id key is not supported on egress");
 			return -EOPNOTSUPP;
 		}
@@ -505,7 +505,7 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 }
 
 int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_acl_block *block,
+			    struct mlxsw_sp_flow_block *block,
 			    struct flow_cls_offload *f)
 {
 	struct mlxsw_sp_acl_rule_info *rulei;
@@ -552,7 +552,7 @@ int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
 }
 
 void mlxsw_sp_flower_destroy(struct mlxsw_sp *mlxsw_sp,
-			     struct mlxsw_sp_acl_block *block,
+			     struct mlxsw_sp_flow_block *block,
 			     struct flow_cls_offload *f)
 {
 	struct mlxsw_sp_acl_ruleset *ruleset;
@@ -574,7 +574,7 @@ void mlxsw_sp_flower_destroy(struct mlxsw_sp *mlxsw_sp,
 }
 
 int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
-			  struct mlxsw_sp_acl_block *block,
+			  struct mlxsw_sp_flow_block *block,
 			  struct flow_cls_offload *f)
 {
 	enum flow_action_hw_stats used_hw_stats = FLOW_ACTION_HW_STATS_DISABLED;
@@ -611,7 +611,7 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 }
 
 int mlxsw_sp_flower_tmplt_create(struct mlxsw_sp *mlxsw_sp,
-				 struct mlxsw_sp_acl_block *block,
+				 struct mlxsw_sp_flow_block *block,
 				 struct flow_cls_offload *f)
 {
 	struct mlxsw_sp_acl_ruleset *ruleset;
@@ -632,7 +632,7 @@ int mlxsw_sp_flower_tmplt_create(struct mlxsw_sp *mlxsw_sp,
 }
 
 void mlxsw_sp_flower_tmplt_destroy(struct mlxsw_sp *mlxsw_sp,
-				   struct mlxsw_sp_acl_block *block,
+				   struct mlxsw_sp_flow_block *block,
 				   struct flow_cls_offload *f)
 {
 	struct mlxsw_sp_acl_ruleset *ruleset;
-- 
2.24.1

