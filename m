Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1325C344A0F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhCVQAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:33 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45387 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230163AbhCVP7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:59:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 49A4F5C01A9;
        Mon, 22 Mar 2021 11:59:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 22 Mar 2021 11:59:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=oPxLmmSoxJT776RI/lGbn4V0ha9Vj593ar0Fi1EgsOE=; b=DDPt5OAR
        lkHf9x4R5Wvj9Q3E+97hft2NGsZhBG+q0VMd5dfGzUkxmv+8C/dLMSRS8riEh98z
        tuz4sB1Fe64XVAlt6jcvKkKYscS3EWKhPuGQjg/BNLFzUZfYB3S3SDknm9+2vklu
        qi9EY2a3wARlBdabNxxDhwEndfdprECFSJ9CNVjUojqflcQ/qtd3nTsTbX8okwnf
        6qXxC7H63t8bwqANWqmsAJzwumoRQCkTsqH+zuN9uGI2s7OLbPX9/U1NCogyf7tX
        AFJqj+Y2KNO88bckXWjMw7Vk09wcPZV2tmDfbWpP3DqJSFI0OBjFIsrW38SoeSOJ
        ininT2qgkf7ZMg==
X-ME-Sender: <xms:-75YYF9G6Li7TFyw3ZVCTuYTr_KD_kjrK_TWXGM_iUOB-HjJHMkrFA>
    <xme:-75YYKa-Yjq3V12LyCtuIZ1bw17tdmvmbKgdPodtKOeluLuJx7vdBfY6w9C-Eu7ih
    lmRwp3JRH3M7Hg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-75YYBMlEZAiZeqFXxZ6yWC9Lz3kWxOidXg8YFq4Vg4-Oxxu01NzBQ>
    <xmx:-75YYOA6bbiJoZ57O7SVSZnR6iy9eWBfpb_3O8jrhroDHoZ8VKjPQQ>
    <xmx:-75YYAKtwaP9ySDo7wfgqXlqQm2IWWYZViVLPI23JS-QCscWwrVuLw>
    <xmx:-75YYH2cnaEEOQYQFvy0K39eM-2ZiuFheMh4Sy1pp6FuYU58r3l0zA>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11033108005C;
        Mon, 22 Mar 2021 11:59:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/14] mlxsw: spectrum_router: Rename nexthop update function to reflect its type
Date:   Mon, 22 Mar 2021 17:58:49 +0200
Message-Id: <20210322155855.3164151-9-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

mlxsw_sp_nexthop_update() is used to update the configuration of
Ethernet-type nexthops, as opposed to mlxsw_sp_nexthop_ipip_update(),
which is used to update IPinIP-type nexthops.

Rename the function to mlxsw_sp_nexthop_eth_update(), so that it is
consistent with mlxsw_sp_nexthop_ipip_update().

It will allow us to introduce mlxsw_sp_nexthop_update() in a follow-up
patch, which calls either of above mentioned function based on the
nexthop's type.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c    |  4 ++--
 .../ethernet/mellanox/mlxsw/spectrum_router.c   | 17 ++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_router.h   |  4 ++--
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index 936224d8c2ea..af2093fc5025 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -1195,8 +1195,8 @@ static int mlxsw_sp_dpipe_table_adj_counters_update(void *priv, bool enable)
 			mlxsw_sp_nexthop_counter_alloc(mlxsw_sp, nh);
 		else
 			mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
-		mlxsw_sp_nexthop_update(mlxsw_sp,
-					adj_index + adj_hash_index, nh);
+		mlxsw_sp_nexthop_eth_update(mlxsw_sp,
+					    adj_index + adj_hash_index, nh);
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 50286c6d0a8a..1f1f8af63ef7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3408,8 +3408,9 @@ static int mlxsw_sp_adj_index_mass_update(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static int __mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-				     struct mlxsw_sp_nexthop *nh)
+static int __mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp,
+					 u32 adj_index,
+					 struct mlxsw_sp_nexthop *nh)
 {
 	struct mlxsw_sp_neigh_entry *neigh_entry = nh->neigh_entry;
 	char ratr_pl[MLXSW_REG_RATR_LEN];
@@ -3445,15 +3446,16 @@ static int __mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ratr), ratr_pl);
 }
 
-int mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-			    struct mlxsw_sp_nexthop *nh)
+int mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
+				struct mlxsw_sp_nexthop *nh)
 {
 	int i;
 
 	for (i = 0; i < nh->num_adj_entries; i++) {
 		int err;
 
-		err = __mlxsw_sp_nexthop_update(mlxsw_sp, adj_index + i, nh);
+		err = __mlxsw_sp_nexthop_eth_update(mlxsw_sp, adj_index + i,
+						    nh);
 		if (err)
 			return err;
 	}
@@ -3515,8 +3517,9 @@ mlxsw_sp_nexthop_group_update(struct mlxsw_sp *mlxsw_sp,
 			if (nh->type == MLXSW_SP_NEXTHOP_TYPE_ETH ||
 			    nh->action == MLXSW_SP_NEXTHOP_ACTION_DISCARD ||
 			    nh->action == MLXSW_SP_NEXTHOP_ACTION_TRAP)
-				err = mlxsw_sp_nexthop_update(mlxsw_sp,
-							      adj_index, nh);
+				err = mlxsw_sp_nexthop_eth_update(mlxsw_sp,
+								  adj_index,
+								  nh);
 			else
 				err = mlxsw_sp_nexthop_ipip_update(mlxsw_sp,
 								   adj_index,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 8ecd090a5d8a..3d90d4eaba05 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -206,8 +206,8 @@ bool mlxsw_sp_nexthop_group_has_ipip(struct mlxsw_sp_nexthop *nh);
 	     nh = mlxsw_sp_nexthop_next(router, nh))
 int mlxsw_sp_nexthop_counter_get(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_nexthop *nh, u64 *p_counter);
-int mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-			    struct mlxsw_sp_nexthop *nh);
+int mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
+				struct mlxsw_sp_nexthop *nh);
 void mlxsw_sp_nexthop_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp_nexthop *nh);
 void mlxsw_sp_nexthop_counter_free(struct mlxsw_sp *mlxsw_sp,
-- 
2.29.2

