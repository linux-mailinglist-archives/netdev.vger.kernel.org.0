Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD68B3F91B9
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244208AbhH0A74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244109AbhH0A72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13AA7610CA;
        Fri, 27 Aug 2021 00:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025900;
        bh=D6laW59MuBEJvXr4aGimx1Pm3RjYF4DtcMj1DLJOwmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVPHqj2uJ/+Hl9NbE+9zG0ngRot678t7vKDcZ+dODsOCt+sgre1PoALsSomQOMjRS
         pNooE58uV49OVGtMDlsUvdwF9OwmhKuvdJglvhgH4fAKpOjjk/2ilR6r6gfQxjNVw6
         teoDaJR12TpSHsc30cKRvPBSR90hR5WZhGoz0JZBITc7U+M8Drgk0saeblpWGGDHAP
         6zPNI/WHwVMANSl+w2foZT7hfmeQmwI2njctFMs57nCUBEcvyHAxY6/2hehnzkMsT2
         mT8KzrOdJkqVmNWphlsKzkdu9w7SJ44tKgnjzZADuipmRylyvtLCFOqFvfpzKg5LQp
         j8CNNZ8PSkQ6g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/17] net/mlx5: DR, replace uintN_t with kernel-style types
Date:   Thu, 26 Aug 2021 17:57:54 -0700
Message-Id: <20210827005802.236119-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c    | 6 +++---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c    | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 22902c32002c..bef90d2c56ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1778,7 +1778,7 @@ dr_ste_v0_build_flex_parser_tnl_geneve_tlv_opt_init(struct mlx5dr_ste_build *sb,
 
 static int dr_ste_v0_build_flex_parser_tnl_gtpu_tag(struct mlx5dr_match_param *value,
 						    struct mlx5dr_ste_build *sb,
-						    uint8_t *tag)
+						    u8 *tag)
 {
 	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
 
@@ -1808,7 +1808,7 @@ static void dr_ste_v0_build_flex_parser_tnl_gtpu_init(struct mlx5dr_ste_build *s
 static int
 dr_ste_v0_build_tnl_gtpu_flex_parser_0_tag(struct mlx5dr_match_param *value,
 					   struct mlx5dr_ste_build *sb,
-					   uint8_t *tag)
+					   u8 *tag)
 {
 	if (dr_is_flex_parser_0_id(sb->caps->flex_parser_id_gtpu_dw_0))
 		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_0, sb->caps, &value->misc3);
@@ -1835,7 +1835,7 @@ dr_ste_v0_build_tnl_gtpu_flex_parser_0_init(struct mlx5dr_ste_build *sb,
 static int
 dr_ste_v0_build_tnl_gtpu_flex_parser_1_tag(struct mlx5dr_match_param *value,
 					   struct mlx5dr_ste_build *sb,
-					   uint8_t *tag)
+					   u8 *tag)
 {
 	if (dr_is_flex_parser_1_id(sb->caps->flex_parser_id_gtpu_dw_0))
 		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_0, sb->caps, &value->misc3);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 2894d9fcc672..0e1a70596fd2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1921,7 +1921,7 @@ dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_init(struct mlx5dr_ste_build *sb,
 
 static int dr_ste_v1_build_flex_parser_tnl_gtpu_tag(struct mlx5dr_match_param *value,
 						    struct mlx5dr_ste_build *sb,
-						    uint8_t *tag)
+						    u8 *tag)
 {
 	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
 
@@ -1945,7 +1945,7 @@ static void dr_ste_v1_build_flex_parser_tnl_gtpu_init(struct mlx5dr_ste_build *s
 static int
 dr_ste_v1_build_tnl_gtpu_flex_parser_0_tag(struct mlx5dr_match_param *value,
 					   struct mlx5dr_ste_build *sb,
-					   uint8_t *tag)
+					   u8 *tag)
 {
 	if (dr_is_flex_parser_0_id(sb->caps->flex_parser_id_gtpu_dw_0))
 		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_0, sb->caps, &value->misc3);
@@ -1972,7 +1972,7 @@ dr_ste_v1_build_tnl_gtpu_flex_parser_0_init(struct mlx5dr_ste_build *sb,
 static int
 dr_ste_v1_build_tnl_gtpu_flex_parser_1_tag(struct mlx5dr_match_param *value,
 					   struct mlx5dr_ste_build *sb,
-					   uint8_t *tag)
+					   u8 *tag)
 {
 	if (dr_is_flex_parser_1_id(sb->caps->flex_parser_id_gtpu_dw_0))
 		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_0, sb->caps, &value->misc3);
-- 
2.31.1

