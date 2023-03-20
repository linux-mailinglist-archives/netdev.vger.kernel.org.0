Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AD66C1EEE
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjCTSDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjCTSDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:03:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3192449F3
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1348B8105F
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44355C4339B;
        Mon, 20 Mar 2023 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679334710;
        bh=xWJP3boVRbs3U6F0iEtarXZpeNDwpF2ldCB2C4/HBA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VeJxqYig9OWyVslE/gvuB/Zhzdpu2+atfoH7SLTeXYd2/et5hL5bjLvqb/YVKGVga
         C9lo5FnfOMm4rwWrXTXQSSEKFofi0eUsrmmBIFxh4LalWwBnpWu8/6SSzC/tDWdFKP
         ccmvxa5BQlCLFvmSP+5CbRGJzvHCgxKO9MWz5VyvTSVlQAqlOp3iUS4Cw4co+r/BrE
         UJisTMh/Ytfd7N82OtmS1F3odUPHLyZLsS+MW3KCGpSIVJXVZbQ3FrxJLhT8kwL1Gx
         4BqfGOjggmEr6E3ApTkTfR7IU/VdtLwvfmHBmpSes5w8dehrAJsn+5Dyfu4g/BJkL4
         UIGDOPPlc9Kgw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [net-next 04/14] net/mlx5e: Coding style fix, add empty line
Date:   Mon, 20 Mar 2023 10:51:34 -0700
Message-Id: <20230320175144.153187-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320175144.153187-1-saeed@kernel.org>
References: <20230320175144.153187-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Add empty line between two function defnititions.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 38b32e98f3bd..b43121f64a80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -637,6 +637,7 @@ static u16 async_eq_depth_devlink_param_get(struct mlx5_core_dev *dev)
 	mlx5_core_dbg(dev, "Failed to get param. using default. err = %d\n", err);
 	return MLX5_NUM_ASYNC_EQE;
 }
+
 static int create_async_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-- 
2.39.2

