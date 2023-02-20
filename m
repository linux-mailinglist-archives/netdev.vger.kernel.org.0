Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E9569C53B
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjBTGRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjBTGRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:17:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DA6EF94
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 22:16:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC68060CE8
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 06:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F1DC433EF;
        Mon, 20 Feb 2023 06:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676873817;
        bh=t5z2UOGMxxUK5HqYuBkIrgVic6FbwytPSFdDF5bqwEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XzbwWGhkrZ5ElKwkLAwkyfBG/k8zWLo0A7VYms3FJLyB3oj2hF0I5z/kRi0ltif3W
         BPLNcq7iFLmhbzdwO1/yCboawzLYbHIMARQqRIUtyfpp28gV3aKUVPplxSkHdVh9Zh
         2K5HAqoK4a7hrNQujutqZSr5s7dg8cIHdEBmVRR/ZpyB/RR/9NpzghjdvTbO7QZEvK
         ZumLI6KWK4FdOsThb6EpuR9ve27mlrzSLVnhZk2aTifj5LQuPZJvtQ264R+X9uN4so
         kWNDwUPqIKJOWEOlX8eNbLUcoj+n68eqNUInb58gl5Tz5rEpmysR4mlZO6FbBulLqg
         vG095RzhxZRXg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 04/14] net/mlx5e: Coding style fix, add empty line
Date:   Sun, 19 Feb 2023 22:14:32 -0800
Message-Id: <20230220061442.403092-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230220061442.403092-1-saeed@kernel.org>
References: <20230220061442.403092-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 66ec7932f008..452f2b2612c6 100644
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
2.39.1

