Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F689344A17
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhCVQAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:41 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57777 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231332AbhCVQAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:00:09 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id C415F5C01D5;
        Mon, 22 Mar 2021 12:00:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Mon, 22 Mar 2021 12:00:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=JzFjqFo8mhd6OuSGazoQnLESfLvYkq6/nylvUxJ69m0=; b=oqVbsgv1
        bootbPn3ow8njHxyGuWVbCjP7sDfMH/cUxpuVNfp9k9amqili9qAhJ+Hexvhshai
        HMRCg0KO/ID9N1jr7H16j+M4UGY+iVzA1mHPt0iqO1NBS0A582Qt73HLbjhHsEyD
        kMwE78c9bFOlb1NeCma4AjQ2PM+GGaaXZM/M4oD8lmyNjggrlAoCS0Vj9+ERLlEX
        4mT/6ODoY78589R+HMkKgsu3OvZAWhv24wL+CdS6v/QjDt6f6AdHriiPmiNOoPBM
        fLN1aEqV2nisJuOhNGD4I5QumdMCrewTkpIu7XrP1ZqDlqbXulPF4aZ0zncgJK8e
        SgfovBzc7ACnAw==
X-ME-Sender: <xms:CL9YYDAwDq-mQeg33turBUJHxFQMclBGbciSbt78jSyP1Mwr7VhWNw>
    <xme:CL9YYEGyf8LmQ-SUsz5B5-N33zJVe0Tqu66F_Ba7giAEfz4xTw9iljrlBzO085Ec-
    d5o7aj5JRgn1dA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:CL9YYLJZkRXfsvPgCuCN-sUV3ke3O9H8R_Mj4vq8E1FOmQr4BtKoEQ>
    <xmx:CL9YYIlS0n4Bp_6zu9NrvV-3XXi2rC1Wmnaeu-mNhtDENy8ynVldQg>
    <xmx:CL9YYDSIlijDfQ01t56zPBJLrvuOGvgfx90mxA_CBOSy98P-FZ5v-A>
    <xmx:CL9YYLdJ2KfCQB8G4PA9tL2duWYZLWp3wYsSbuzoi5daAWemAkddPg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B5E01080077;
        Mon, 22 Mar 2021 12:00:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 14/14] mlxsw: spectrum_router: Add Spectrum-{2, 3} adjacency group size ranges
Date:   Mon, 22 Mar 2021 17:58:55 +0200
Message-Id: <20210322155855.3164151-15-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Spectrum-{2,3} support different adjacency group size ranges compared to
Spectrum-1. Add an array describing these ranges and change the common
code to use the array which was set during the per-ASIC initialization.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 40 ++++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  2 +
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a142d6d3e77d..75c9fc47cd69 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3566,7 +3566,7 @@ struct mlxsw_sp_adj_grp_size_range {
 
 /* Ordered by range start value */
 static const struct mlxsw_sp_adj_grp_size_range
-mlxsw_sp_adj_grp_size_ranges[] = {
+mlxsw_sp1_adj_grp_size_ranges[] = {
 	{ .start = 1, .end = 64 },
 	{ .start = 512, .end = 512 },
 	{ .start = 1024, .end = 1024 },
@@ -3574,14 +3574,26 @@ mlxsw_sp_adj_grp_size_ranges[] = {
 	{ .start = 4096, .end = 4096 },
 };
 
-static void mlxsw_sp_adj_grp_size_round_up(u16 *p_adj_grp_size)
+/* Ordered by range start value */
+static const struct mlxsw_sp_adj_grp_size_range
+mlxsw_sp2_adj_grp_size_ranges[] = {
+	{ .start = 1, .end = 128 },
+	{ .start = 256, .end = 256 },
+	{ .start = 512, .end = 512 },
+	{ .start = 1024, .end = 1024 },
+	{ .start = 2048, .end = 2048 },
+	{ .start = 4096, .end = 4096 },
+};
+
+static void mlxsw_sp_adj_grp_size_round_up(const struct mlxsw_sp *mlxsw_sp,
+					   u16 *p_adj_grp_size)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_adj_grp_size_ranges); i++) {
+	for (i = 0; i < mlxsw_sp->router->adj_grp_size_ranges_count; i++) {
 		const struct mlxsw_sp_adj_grp_size_range *size_range;
 
-		size_range = &mlxsw_sp_adj_grp_size_ranges[i];
+		size_range = &mlxsw_sp->router->adj_grp_size_ranges[i];
 
 		if (*p_adj_grp_size >= size_range->start &&
 		    *p_adj_grp_size <= size_range->end)
@@ -3594,16 +3606,16 @@ static void mlxsw_sp_adj_grp_size_round_up(u16 *p_adj_grp_size)
 	}
 }
 
-static void mlxsw_sp_adj_grp_size_round_down(u16 *p_adj_grp_size,
+static void mlxsw_sp_adj_grp_size_round_down(const struct mlxsw_sp *mlxsw_sp,
+					     u16 *p_adj_grp_size,
 					     unsigned int alloc_size)
 {
-	size_t arr_size = ARRAY_SIZE(mlxsw_sp_adj_grp_size_ranges);
 	int i;
 
-	for (i = arr_size - 1; i >= 0; i--) {
+	for (i = mlxsw_sp->router->adj_grp_size_ranges_count - 1; i >= 0; i--) {
 		const struct mlxsw_sp_adj_grp_size_range *size_range;
 
-		size_range = &mlxsw_sp_adj_grp_size_ranges[i];
+		size_range = &mlxsw_sp->router->adj_grp_size_ranges[i];
 
 		if (alloc_size >= size_range->end) {
 			*p_adj_grp_size = size_range->end;
@@ -3621,7 +3633,7 @@ static int mlxsw_sp_fix_adj_grp_size(struct mlxsw_sp *mlxsw_sp,
 	/* Round up the requested group size to the next size supported
 	 * by the device and make sure the request can be satisfied.
 	 */
-	mlxsw_sp_adj_grp_size_round_up(p_adj_grp_size);
+	mlxsw_sp_adj_grp_size_round_up(mlxsw_sp, p_adj_grp_size);
 	err = mlxsw_sp_kvdl_alloc_count_query(mlxsw_sp,
 					      MLXSW_SP_KVDL_ENTRY_TYPE_ADJ,
 					      *p_adj_grp_size, &alloc_size);
@@ -3631,7 +3643,7 @@ static int mlxsw_sp_fix_adj_grp_size(struct mlxsw_sp *mlxsw_sp,
 	 * entries than requested. Try to use as much of them as
 	 * possible.
 	 */
-	mlxsw_sp_adj_grp_size_round_down(p_adj_grp_size, alloc_size);
+	mlxsw_sp_adj_grp_size_round_down(mlxsw_sp, p_adj_grp_size, alloc_size);
 
 	return 0;
 }
@@ -9376,7 +9388,11 @@ static void mlxsw_sp_lb_rif_fini(struct mlxsw_sp *mlxsw_sp)
 
 static int mlxsw_sp1_router_init(struct mlxsw_sp *mlxsw_sp)
 {
+	size_t size_ranges_count = ARRAY_SIZE(mlxsw_sp1_adj_grp_size_ranges);
+
 	mlxsw_sp->router->rif_ops_arr = mlxsw_sp1_rif_ops_arr;
+	mlxsw_sp->router->adj_grp_size_ranges = mlxsw_sp1_adj_grp_size_ranges;
+	mlxsw_sp->router->adj_grp_size_ranges_count = size_ranges_count;
 
 	return 0;
 }
@@ -9387,7 +9403,11 @@ const struct mlxsw_sp_router_ops mlxsw_sp1_router_ops = {
 
 static int mlxsw_sp2_router_init(struct mlxsw_sp *mlxsw_sp)
 {
+	size_t size_ranges_count = ARRAY_SIZE(mlxsw_sp2_adj_grp_size_ranges);
+
 	mlxsw_sp->router->rif_ops_arr = mlxsw_sp2_rif_ops_arr;
+	mlxsw_sp->router->adj_grp_size_ranges = mlxsw_sp2_adj_grp_size_ranges;
+	mlxsw_sp->router->adj_grp_size_ranges_count = size_ranges_count;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 3d90d4eaba05..01fd9a3d5944 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -78,6 +78,8 @@ struct mlxsw_sp_router {
 	struct mlxsw_sp_fib_entry_op_ctx *ll_op_ctx;
 	u16 lb_rif_index;
 	struct mlxsw_sp_router_xm *xm;
+	const struct mlxsw_sp_adj_grp_size_range *adj_grp_size_ranges;
+	size_t adj_grp_size_ranges_count;
 };
 
 struct mlxsw_sp_fib_entry_priv {
-- 
2.29.2

