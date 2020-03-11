Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC14180F27
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgCKFGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:06:49 -0400
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:44528 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725813AbgCKFGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 01:06:47 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 2B8C61800455B;
        Wed, 11 Mar 2020 05:06:46 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:355:379:541:800:960:967:973:982:988:989:1260:1311:1314:1345:1359:1437:1515:1535:1606:1730:1747:1777:1792:2194:2199:2393:2525:2560:2563:2682:2685:2859:2897:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3865:3866:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4117:4321:4605:5007:6261:9025:10004:10848:11026:11473:11657:11658:11914:12043:12048:12296:12297:12438:12555:12679:12895:12986:13894:14093:14096:14394:21080:21433:21627:21740:21811:21939:21990:30054:30075,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: screw25_1dbccd6ba8e10
X-Filterd-Recvd-Size: 6296
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Mar 2020 05:06:44 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH -next 003/491] MELLANOX MLX5 core VPI driver: Use fallthrough;
Date:   Tue, 10 Mar 2020 21:51:17 -0700
Message-Id: <3ce4519315294b9738abe6a78e2737f49af9a653.1583896347.git.joe@perches.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583896344.git.joe@perches.com>
References: <cover.1583896344.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the various uses of fallthrough comments to fallthrough;

Done via script
Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h         | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c          | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c      | 2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c          | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/vport.c           | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index a226277..2a1cc2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -223,7 +223,7 @@ mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
 	switch (swp_spec->tun_l4_proto) {
 	case IPPROTO_UDP:
 		eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
-		/* fall through */
+		fallthrough;
 	case IPPROTO_TCP:
 		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f049e0a..f74e50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -167,11 +167,11 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		return true;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* fall through */
+		fallthrough;
 	case XDP_ABORTED:
 xdp_abort:
 		trace_xdp_exception(rq->netdev, prog, act);
-		/* fall through */
+		fallthrough;
 	case XDP_DROP:
 		rq->stats->xdp_drop++;
 		return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 01539b8..8a3376a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -225,7 +225,7 @@ int mlx5e_ethtool_get_sset_count(struct mlx5e_priv *priv, int sset)
 		return MLX5E_NUM_PFLAGS;
 	case ETH_SS_TEST:
 		return mlx5e_self_test_num(priv);
-	/* fallthrough */
+		fallthrough;
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4b5b661..033454 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2426,7 +2426,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
 		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
 			return 0;
-		/* fall through */
+		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be set");
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 416676..a40e43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -199,13 +199,13 @@ static void mlx5_lag_fib_update(struct work_struct *work)
 	/* Protect internal structures from changes */
 	rtnl_lock();
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		mlx5_lag_fib_route_event(ldev, fib_work->event,
 					 fib_work->fen_info.fi);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_NH_ADD: /* fall through */
+	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
 		fib_nh = fib_work->fnh_info.fib_nh;
 		mlx5_lag_fib_nexthop_event(ldev,
@@ -256,7 +256,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		return NOTIFY_DONE;
 
 	switch (event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
@@ -279,7 +279,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		 */
 		fib_info_hold(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_NH_ADD: /* fall through */
+	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
 		fnh_info = container_of(info, struct fib_nh_notifier_info,
 					info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 1faac31f..aea1065 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -125,7 +125,7 @@ void mlx5_query_min_inline(struct mlx5_core_dev *mdev,
 	case MLX5_CAP_INLINE_MODE_VPORT_CONTEXT:
 		if (!mlx5_query_nic_vport_min_inline(mdev, 0, min_inline_mode))
 			break;
-		/* fall through */
+		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		*min_inline_mode = MLX5_INLINE_MODE_L2;
 		break;
-- 
2.24.0

