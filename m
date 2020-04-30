Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CB61C0372
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgD3RCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:02:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43897 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727804AbgD3RCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:02:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A24D25C010E;
        Thu, 30 Apr 2020 13:01:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 13:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=63rNcnCzWnsq02l1IIm+EfFrD245zqUt9iMY2dDBiak=; b=NVHklYU+
        BO5gYpbYWv/9iLP9g163qdYoUHt0NpoATN4SAMyGTeoo4ZvjtWY4k0iz24i9RNIp
        NO76c2UaG0kq4Fnkt5CNs0jpNd+ZeZ2tMcuxR+oFQjpgcWj8yf38IyE1ybVXS8t8
        /udg+Wy2KyCPX0XflcVtjcVWelkkNj6GO7k0QRTPMzbMttCSkjPU40Bkqk5i9Z83
        PNd8SI9vYTksWy5t5MXfQP85i+wSzu6mHLw1lsFKziRI0KfhHtmPtU5uVY6rczqE
        jx1sI8x9Rb15/caEm58K8yOpIAzvahWEnKqBBycHc111rjtontNq+e8rISA1EnJ6
        f6AVSd5CWOvu+Q==
X-ME-Sender: <xms:hwSrXm8TmSRvWdsFSriK0oEU07vkhk9knzjsplsV2CdTBx_U7k1qFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudektddrheegrdduudei
    necuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:hwSrXuTfbwTSZPXk8pTj4prz18suq-TakVlE0NLRHiibBob6wDjqOQ>
    <xmx:hwSrXjlJMSm4Ihx4xzzMHNPricptGsg2HdgL-vAJa82XBIWVTKtmBg>
    <xmx:hwSrXubqg01SPflApCuOv-nkDGSluLTEIGOhn7c2QBE2s6986xQLvQ>
    <xmx:hwSrXsi3Zyh-0JSXYCOInPO3us9NRl52frlIBChN7T_k1psnAoyADw>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 509413065F39;
        Thu, 30 Apr 2020 13:01:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 9/9] mlxsw: spectrum_span: Remove old SPAN API
Date:   Thu, 30 Apr 2020 20:01:16 +0300
Message-Id: <20200430170116.4081677-10-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200430170116.4081677-1-idosch@idosch.org>
References: <20200430170116.4081677-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Remove the old SPAN API now that matchall-based and flower-based
mirroring were converted to use the new API.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 190 +-----------------
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  21 --
 2 files changed, 2 insertions(+), 209 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 9cb8b509b849..304eb8c3d8bd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -74,12 +74,8 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 	span->mlxsw_sp = mlxsw_sp;
 	mlxsw_sp->span = span;
 
-	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
-		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
-
-		INIT_LIST_HEAD(&curr->bound_ports_list);
-		curr->id = i;
-	}
+	for (i = 0; i < mlxsw_sp->span->entries_count; i++)
+		mlxsw_sp->span->entries[i].id = i;
 
 	devlink_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_SPAN,
 					  mlxsw_sp_span_occ_get, mlxsw_sp);
@@ -91,16 +87,10 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
-	int i;
 
 	cancel_work_sync(&mlxsw_sp->span->work);
 	devlink_resource_occ_get_unregister(devlink, MLXSW_SP_RESOURCE_SPAN);
 
-	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
-		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
-
-		WARN_ON_ONCE(!list_empty(&curr->bound_ports_list));
-	}
 	WARN_ON_ONCE(!list_empty(&mlxsw_sp->span->trigger_entries_list));
 	WARN_ON_ONCE(!list_empty(&mlxsw_sp->span->analyzed_ports_list));
 	mutex_destroy(&mlxsw_sp->span->analyzed_ports_lock);
@@ -862,131 +852,6 @@ void mlxsw_sp_span_speed_update_work(struct work_struct *work)
 	mutex_unlock(&mlxsw_sp->span->analyzed_ports_lock);
 }
 
-static struct mlxsw_sp_span_inspected_port *
-mlxsw_sp_span_entry_bound_port_find(struct mlxsw_sp_span_entry *span_entry,
-				    enum mlxsw_sp_span_type type,
-				    struct mlxsw_sp_port *port,
-				    bool bind)
-{
-	struct mlxsw_sp_span_inspected_port *p;
-
-	list_for_each_entry(p, &span_entry->bound_ports_list, list)
-		if (type == p->type &&
-		    port->local_port == p->local_port &&
-		    bind == p->bound)
-			return p;
-	return NULL;
-}
-
-static int
-mlxsw_sp_span_inspected_port_bind(struct mlxsw_sp_port *port,
-				  struct mlxsw_sp_span_entry *span_entry,
-				  enum mlxsw_sp_span_type type,
-				  bool bind)
-{
-	struct mlxsw_sp *mlxsw_sp = port->mlxsw_sp;
-	char mpar_pl[MLXSW_REG_MPAR_LEN];
-	int pa_id = span_entry->id;
-
-	/* bind the port to the SPAN entry */
-	mlxsw_reg_mpar_pack(mpar_pl, port->local_port,
-			    (enum mlxsw_reg_mpar_i_e)type, bind, pa_id);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mpar), mpar_pl);
-}
-
-static int
-mlxsw_sp_span_inspected_port_add(struct mlxsw_sp_port *port,
-				 struct mlxsw_sp_span_entry *span_entry,
-				 enum mlxsw_sp_span_type type,
-				 bool bind)
-{
-	struct mlxsw_sp_span_inspected_port *inspected_port;
-	struct mlxsw_sp *mlxsw_sp = port->mlxsw_sp;
-	char sbib_pl[MLXSW_REG_SBIB_LEN];
-	int i;
-	int err;
-
-	/* A given (source port, direction) can only be bound to one analyzer,
-	 * so if a binding is requested, check for conflicts.
-	 */
-	if (bind)
-		for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
-			struct mlxsw_sp_span_entry *curr =
-				&mlxsw_sp->span->entries[i];
-
-			if (mlxsw_sp_span_entry_bound_port_find(curr, type,
-								port, bind))
-				return -EEXIST;
-		}
-
-	/* if it is an egress SPAN, bind a shared buffer to it */
-	if (type == MLXSW_SP_SPAN_EGRESS) {
-		err = mlxsw_sp_span_port_buffer_update(port, port->dev->mtu);
-		if (err)
-			return err;
-	}
-
-	if (bind) {
-		err = mlxsw_sp_span_inspected_port_bind(port, span_entry, type,
-							true);
-		if (err)
-			goto err_port_bind;
-	}
-
-	inspected_port = kzalloc(sizeof(*inspected_port), GFP_KERNEL);
-	if (!inspected_port) {
-		err = -ENOMEM;
-		goto err_inspected_port_alloc;
-	}
-	inspected_port->local_port = port->local_port;
-	inspected_port->type = type;
-	inspected_port->bound = bind;
-	list_add_tail(&inspected_port->list, &span_entry->bound_ports_list);
-
-	return 0;
-
-err_inspected_port_alloc:
-	if (bind)
-		mlxsw_sp_span_inspected_port_bind(port, span_entry, type,
-						  false);
-err_port_bind:
-	if (type == MLXSW_SP_SPAN_EGRESS) {
-		mlxsw_reg_sbib_pack(sbib_pl, port->local_port, 0);
-		mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
-	}
-	return err;
-}
-
-static void
-mlxsw_sp_span_inspected_port_del(struct mlxsw_sp_port *port,
-				 struct mlxsw_sp_span_entry *span_entry,
-				 enum mlxsw_sp_span_type type,
-				 bool bind)
-{
-	struct mlxsw_sp_span_inspected_port *inspected_port;
-	struct mlxsw_sp *mlxsw_sp = port->mlxsw_sp;
-	char sbib_pl[MLXSW_REG_SBIB_LEN];
-
-	inspected_port = mlxsw_sp_span_entry_bound_port_find(span_entry, type,
-							     port, bind);
-	if (!inspected_port)
-		return;
-
-	if (bind)
-		mlxsw_sp_span_inspected_port_bind(port, span_entry, type,
-						  false);
-	/* remove the SBIB buffer if it was egress SPAN */
-	if (type == MLXSW_SP_SPAN_EGRESS) {
-		mlxsw_reg_sbib_pack(sbib_pl, port->local_port, 0);
-		mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
-	}
-
-	mlxsw_sp_span_entry_put(mlxsw_sp, span_entry);
-
-	list_del(&inspected_port->list);
-	kfree(inspected_port);
-}
-
 static const struct mlxsw_sp_span_entry_ops *
 mlxsw_sp_span_entry_ops(struct mlxsw_sp *mlxsw_sp,
 			const struct net_device *to_dev)
@@ -1000,57 +865,6 @@ mlxsw_sp_span_entry_ops(struct mlxsw_sp *mlxsw_sp,
 	return NULL;
 }
 
-int mlxsw_sp_span_mirror_add(struct mlxsw_sp_port *from,
-			     const struct net_device *to_dev,
-			     enum mlxsw_sp_span_type type, bool bind,
-			     int *p_span_id)
-{
-	struct mlxsw_sp *mlxsw_sp = from->mlxsw_sp;
-	const struct mlxsw_sp_span_entry_ops *ops;
-	struct mlxsw_sp_span_parms sparms = {NULL};
-	struct mlxsw_sp_span_entry *span_entry;
-	int err;
-
-	ops = mlxsw_sp_span_entry_ops(mlxsw_sp, to_dev);
-	if (!ops) {
-		netdev_err(to_dev, "Cannot mirror to %s", to_dev->name);
-		return -EOPNOTSUPP;
-	}
-
-	err = ops->parms_set(to_dev, &sparms);
-	if (err)
-		return err;
-
-	span_entry = mlxsw_sp_span_entry_get(mlxsw_sp, to_dev, ops, sparms);
-	if (!span_entry)
-		return -ENOBUFS;
-
-	err = mlxsw_sp_span_inspected_port_add(from, span_entry, type, bind);
-	if (err)
-		goto err_port_bind;
-
-	*p_span_id = span_entry->id;
-	return 0;
-
-err_port_bind:
-	mlxsw_sp_span_entry_put(mlxsw_sp, span_entry);
-	return err;
-}
-
-void mlxsw_sp_span_mirror_del(struct mlxsw_sp_port *from, int span_id,
-			      enum mlxsw_sp_span_type type, bool bind)
-{
-	struct mlxsw_sp_span_entry *span_entry;
-
-	span_entry = mlxsw_sp_span_entry_find_by_id(from->mlxsw_sp, span_id);
-	if (!span_entry) {
-		netdev_err(from->dev, "no span entry found\n");
-		return;
-	}
-
-	mlxsw_sp_span_inspected_port_del(from, span_entry, type, bind);
-}
-
 static void mlxsw_sp_span_respin_work(struct work_struct *work)
 {
 	struct mlxsw_sp_span *span;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 6821eeb3906b..9f6dd2d0f4e6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -13,20 +13,6 @@
 struct mlxsw_sp;
 struct mlxsw_sp_port;
 
-enum mlxsw_sp_span_type {
-	MLXSW_SP_SPAN_EGRESS,
-	MLXSW_SP_SPAN_INGRESS
-};
-
-struct mlxsw_sp_span_inspected_port {
-	struct list_head list;
-	enum mlxsw_sp_span_type type;
-	u8 local_port;
-
-	/* Whether this is a directly bound mirror (port-to-port) or an ACL. */
-	bool bound;
-};
-
 struct mlxsw_sp_span_parms {
 	struct mlxsw_sp_port *dest_port; /* NULL for unoffloaded SPAN. */
 	unsigned int ttl;
@@ -52,7 +38,6 @@ struct mlxsw_sp_span_entry {
 	const struct net_device *to_dev;
 	const struct mlxsw_sp_span_entry_ops *ops;
 	struct mlxsw_sp_span_parms parms;
-	struct list_head bound_ports_list;
 	refcount_t ref_count;
 	int id;
 };
@@ -70,12 +55,6 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_span_respin(struct mlxsw_sp *mlxsw_sp);
 
-int mlxsw_sp_span_mirror_add(struct mlxsw_sp_port *from,
-			     const struct net_device *to_dev,
-			     enum mlxsw_sp_span_type type,
-			     bool bind, int *p_span_id);
-void mlxsw_sp_span_mirror_del(struct mlxsw_sp_port *from, int span_id,
-			      enum mlxsw_sp_span_type type, bool bind);
 struct mlxsw_sp_span_entry *
 mlxsw_sp_span_entry_find_by_port(struct mlxsw_sp *mlxsw_sp,
 				 const struct net_device *to_dev);
-- 
2.24.1

