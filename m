Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377294D3C3D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbiCIVjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238427AbiCIVjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D36D6C953
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21784B823D6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A93DC36AE2;
        Wed,  9 Mar 2022 21:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861893;
        bh=TAF5dELiNuKujxB6OaO9ZRXNt4qhx4wQCiG7Vfk8MLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p13K/eKcO4gyDgp0mSfw/laIzpQins+ZA5y+xuU/ScCvs64X6CCtfhibZCFPpXeKu
         6kDTlTI3Bm73jqwm2Vu2SPM8Xe5/6moWqzwoivRpD1eqPAHKPK2Rm506N3Bx00Vg+c
         xP8SONGsplWar7HMmHfsmvL4Yc2PGrTtfLnHGv0mKMGr8nscgiEPJJGUS32IGT/y4y
         5EtyBJHtpXJbi02zqM7xDX5hZ+4orBvAtGCQOLmh8EqQKaWqnw3tUArXN/S/+71GVN
         5mx7+XDTIVjolQWt+tKHjbO8OEaAQnJmNnh0MR1DfjsXK90fEb9iy4nbtGF/T+U/FU
         y71qBv84xdzdw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/16] net/mlx5: DR, Rename action modify fields to reflect naming in HW spec
Date:   Wed,  9 Mar 2022 13:37:53 -0800
Message-Id: <20220309213755.610202-15-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309213755.610202-1-saeed@kernel.org>
References: <20220309213755.610202-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

As preparation for supporting ConnectX-7, rename action modify fields
steering registers from arbitrary names to the names that reflect the
corresponding naming and location of the steering registers in HW.
These registers mapping has changed in ConnectX-7, so the renaming allows
to keep track of their mapping better.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index d273d3b4fb1a..4a7b038dd15d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -121,12 +121,12 @@ enum {
 	DR_STE_V1_ACTION_MDFY_FLD_CFG_HDR_0_1		= 0x70,
 	DR_STE_V1_ACTION_MDFY_FLD_METADATA_2_CQE	= 0x7b,
 	DR_STE_V1_ACTION_MDFY_FLD_GNRL_PURPOSE		= 0x7c,
-	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_2		= 0x8c,
-	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_3		= 0x8d,
-	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_4		= 0x8e,
-	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_5		= 0x8f,
-	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_6		= 0x90,
-	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_7		= 0x91,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_2_0		= 0x8c,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_2_1		= 0x8d,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_1_0		= 0x8e,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_1_1		= 0x8f,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_0_0		= 0x90,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_0_1		= 0x91,
 };
 
 static const struct mlx5dr_ste_action_modify_field dr_ste_v1_action_modify_field_arr[] = {
@@ -223,22 +223,22 @@ static const struct mlx5dr_ste_action_modify_field dr_ste_v1_action_modify_field
 		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_METADATA_2_CQE, .start = 0, .end = 31,
 	},
 	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_0] = {
-		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_6, .start = 0, .end = 31,
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_0_0, .start = 0, .end = 31,
 	},
 	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_1] = {
-		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_7, .start = 0, .end = 31,
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_0_1, .start = 0, .end = 31,
 	},
 	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_2] = {
-		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_4, .start = 0, .end = 31,
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_1_0, .start = 0, .end = 31,
 	},
 	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_3] = {
-		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_5, .start = 0, .end = 31,
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_1_1, .start = 0, .end = 31,
 	},
 	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_4] = {
-		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_2, .start = 0, .end = 31,
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_2_0, .start = 0, .end = 31,
 	},
 	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_5] = {
-		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_3, .start = 0, .end = 31,
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_2_1, .start = 0, .end = 31,
 	},
 	[MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM] = {
 		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_TCP_MISC_0, .start = 0, .end = 31,
-- 
2.35.1

