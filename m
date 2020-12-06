Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9842D01A1
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 09:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgLFIZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 03:25:07 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:58965 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgLFIZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 03:25:06 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 44AF0C45;
        Sun,  6 Dec 2020 03:23:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Dec 2020 03:23:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=KMjeBuu1zkZDFOChrxs89CxtLl6MvHMqXYZysopzydc=; b=FOtYKXI1
        wadkl3sSM+RMTkIEatPNdxf/E1DNGaaD4R57WIHhCz/H+MHPwVBd6/mPkodVV8qr
        q4hLodjXod219LzAukQW+GEb0IeD9uCOtiwiq8B72AFEUaMUJA0sENT4g0/+I3cU
        LiCqmjfxGLxjmV1+0hvvjPHUwlLrOnF21D7KmB/McH5WJreCyURlr2yfbpIw2meJ
        3QmQbBSrG4lXEUxuaXcPKKgE7zkCDAz/9FB69zjUBSf+DscW/YHCclafcH8Fzi7X
        yP9JhrC1Muh4lck7NSIufGrYQC0CH2DPjoG38rB8pIiDhdYAwIyjYYaCckWffSk6
        l2prbKrFVsZXrw==
X-ME-Sender: <xms:5ZTMX2dB16CKahpJgCH9ZVODowEtpo2tpnXT2FAGqsRtP1tgIDjrkg>
    <xme:5ZTMXwN_U8XGD6zIJbNyfuIGHqKMc5NkZbOm7nXns29Pfzb3cEVzy62hryFLfZ9ZH
    xtwGf5nZm-bk9o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejuddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddv
    feegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:5ZTMX3gezrBEna8Qgzk6VF9u6Q2s4viXp8ZtZ0SxId5GSmE5SF6-pA>
    <xmx:5ZTMXz81puKWvMh2b_htoJpgASY2AUuGjcmJfjIc6TurKSSanGx7HQ>
    <xmx:5ZTMXysK88iyn-0KYPruCjXxozNkxN8Y69wqX70S5AfGNPgCEgFPkA>
    <xmx:5ZTMX2JLOgNwXqF8l-Hlbw7XvSd3RyDPd76M1xrbFHZtUJ3gR5YPdA>
Received: from shredder.lan (igld-84-229-154-234.inter.net.il [84.229.154.234])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8CF801080057;
        Sun,  6 Dec 2020 03:23:00 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/7] mlxsw: spectrum_router: Reduce mlxsw_sp_ipip_fib_entry_op_gre4()
Date:   Sun,  6 Dec 2020 10:22:27 +0200
Message-Id: <20201206082227.1857042-8-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201206082227.1857042-1-idosch@idosch.org>
References: <20201206082227.1857042-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Turned out that mlxsw_sp_ipip_fib_entry_op_gre4() does not need to
figure out the IP address and virtual router id. Those are exactly
the same as in the fib_entry it is called for. So just use that and
reduce mlxsw_sp_ipip_fib_entry_op_gre4() function to only call
mlxsw_sp_ipip_fib_entry_op_gre4_rtdp() make the ipip decap op
code similar to nve.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 45 ++-----------------
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |  8 +---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 18 +++++---
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  4 --
 4 files changed, 19 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 089d99535f9e..6ccca39bae84 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -142,9 +142,9 @@ mlxsw_sp_ipip_nexthop_update_gre4(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 }
 
 static int
-mlxsw_sp_ipip_fib_entry_op_gre4_rtdp(struct mlxsw_sp *mlxsw_sp,
-				     u32 tunnel_index,
-				     struct mlxsw_sp_ipip_entry *ipip_entry)
+mlxsw_sp_ipip_decap_config_gre4(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_ipip_entry *ipip_entry,
+				u32 tunnel_index)
 {
 	u16 rif_index = mlxsw_sp_ipip_lb_rif_index(ipip_entry->ol_lb);
 	u16 ul_rif_id = mlxsw_sp_ipip_lb_ul_rif_id(ipip_entry->ol_lb);
@@ -180,43 +180,6 @@ mlxsw_sp_ipip_fib_entry_op_gre4_rtdp(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rtdp), rtdp_pl);
 }
 
-static int
-mlxsw_sp_ipip_fib_entry_op_gre4_do(struct mlxsw_sp *mlxsw_sp,
-				   const struct mlxsw_sp_router_ll_ops *ll_ops,
-				   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				   u32 dip, u8 prefix_len, u16 ul_vr_id,
-				   enum mlxsw_sp_fib_entry_op op,
-				   u32 tunnel_index,
-				   struct mlxsw_sp_fib_entry_priv *priv)
-{
-	ll_ops->fib_entry_pack(op_ctx, MLXSW_SP_L3_PROTO_IPV4, op, ul_vr_id,
-			       prefix_len, (unsigned char *) &dip, priv);
-	ll_ops->fib_entry_act_ip2me_tun_pack(op_ctx, tunnel_index);
-	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
-}
-
-static int mlxsw_sp_ipip_fib_entry_op_gre4(struct mlxsw_sp *mlxsw_sp,
-					   const struct mlxsw_sp_router_ll_ops *ll_ops,
-					   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					   struct mlxsw_sp_ipip_entry *ipip_entry,
-					   enum mlxsw_sp_fib_entry_op op, u32 tunnel_index,
-					   struct mlxsw_sp_fib_entry_priv *priv)
-{
-	u16 ul_vr_id = mlxsw_sp_ipip_lb_ul_vr_id(ipip_entry->ol_lb);
-	__be32 dip;
-	int err;
-
-	err = mlxsw_sp_ipip_fib_entry_op_gre4_rtdp(mlxsw_sp, tunnel_index,
-						   ipip_entry);
-	if (err)
-		return err;
-
-	dip = mlxsw_sp_ipip_netdev_saddr(MLXSW_SP_L3_PROTO_IPV4,
-					 ipip_entry->ol_dev).addr4;
-	return mlxsw_sp_ipip_fib_entry_op_gre4_do(mlxsw_sp, ll_ops, op_ctx, be32_to_cpu(dip),
-						  32, ul_vr_id, op, tunnel_index, priv);
-}
-
 static bool mlxsw_sp_ipip_tunnel_complete(enum mlxsw_sp_l3proto proto,
 					  const struct net_device *ol_dev)
 {
@@ -332,7 +295,7 @@ static const struct mlxsw_sp_ipip_ops mlxsw_sp_ipip_gre4_ops = {
 	.dev_type = ARPHRD_IPGRE,
 	.ul_proto = MLXSW_SP_L3_PROTO_IPV4,
 	.nexthop_update = mlxsw_sp_ipip_nexthop_update_gre4,
-	.fib_entry_op = mlxsw_sp_ipip_fib_entry_op_gre4,
+	.decap_config = mlxsw_sp_ipip_decap_config_gre4,
 	.can_offload = mlxsw_sp_ipip_can_offload_gre4,
 	.ol_loopback_config = mlxsw_sp_ipip_ol_loopback_config_gre4,
 	.ol_netdev_change = mlxsw_sp_ipip_ol_netdev_change_gre4,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index d32702cb6ab4..87bef9880e5e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -50,13 +50,9 @@ struct mlxsw_sp_ipip_ops {
 	(*ol_loopback_config)(struct mlxsw_sp *mlxsw_sp,
 			      const struct net_device *ol_dev);
 
-	int (*fib_entry_op)(struct mlxsw_sp *mlxsw_sp,
-			    const struct mlxsw_sp_router_ll_ops *ll_ops,
-			    struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+	int (*decap_config)(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_ipip_entry *ipip_entry,
-			    enum mlxsw_sp_fib_entry_op op,
-			    u32 tunnel_index,
-			    struct mlxsw_sp_fib_entry_priv *priv);
+			    u32 tunnel_index);
 
 	int (*ol_netdev_change)(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_ipip_entry *ipip_entry,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 20b141f02145..d671d961fc33 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5142,9 +5142,9 @@ static void mlxsw_sp_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				    fib_entry->priv);
 }
 
-int mlxsw_sp_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
-			      struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-			      const struct mlxsw_sp_router_ll_ops *ll_ops)
+static int mlxsw_sp_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
+				     struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+				     const struct mlxsw_sp_router_ll_ops *ll_ops)
 {
 	bool postponed_for_bulk = false;
 	int err;
@@ -5307,13 +5307,21 @@ mlxsw_sp_fib_entry_op_ipip_decap(struct mlxsw_sp *mlxsw_sp,
 	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	struct mlxsw_sp_ipip_entry *ipip_entry = fib_entry->decap.ipip_entry;
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
+	int err;
 
 	if (WARN_ON(!ipip_entry))
 		return -EINVAL;
 
 	ipip_ops = mlxsw_sp->router->ipip_ops_arr[ipip_entry->ipipt];
-	return ipip_ops->fib_entry_op(mlxsw_sp, ll_ops, op_ctx, ipip_entry, op,
-				      fib_entry->decap.tunnel_index, fib_entry->priv);
+	err = ipip_ops->decap_config(mlxsw_sp, ipip_entry,
+				     fib_entry->decap.tunnel_index);
+	if (err)
+		return err;
+
+	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
+	ll_ops->fib_entry_act_ip2me_tun_pack(op_ctx,
+					     fib_entry->decap.tunnel_index);
+	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
 }
 
 static int mlxsw_sp_fib_entry_op_nve_decap(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 96d8bf7a9a67..d8aed866af21 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -118,10 +118,6 @@ struct mlxsw_sp_router_ll_ops {
 	bool (*fib_entry_is_committed)(struct mlxsw_sp_fib_entry_priv *priv);
 };
 
-int mlxsw_sp_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
-			      struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-			      const struct mlxsw_sp_router_ll_ops *ll_ops);
-
 struct mlxsw_sp_rif_ipip_lb;
 struct mlxsw_sp_rif_ipip_lb_config {
 	enum mlxsw_reg_ritr_loopback_ipip_type lb_ipipt;
-- 
2.28.0

