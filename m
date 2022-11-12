Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE4D6268C9
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiKLKV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiKLKVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:21:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A210BC32
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:21:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3FF660B94
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAC5C433C1;
        Sat, 12 Nov 2022 10:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248514;
        bh=k5AkcfMfR2wdLaLpauKhhAq+Zc96p2slOK5EF71IQw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+FRa+AEb50zjh+MBUDAChel2u0jaR5Fsfo++bwRgzx0FNLqvNHerkPsVpuODn6rS
         5/edKWwCCNY0X2BCzayLJKYquFLcbqcQbvsG1Ee+RpHej+4kZeasqFknUl/V03buVC
         EU6WmkDuolgUD0KvDfAbpPuityEALg72uHwpxS4CCfE/VE6fBB9ZD0RrHty8YbIoyG
         2cqzVXOYI78idViz7U8yK5EKzSBmsZo+71Ov2tOEttHXai+UZskzyZ5pTbXiRDj1GO
         0IjJwv4xzgwRNOWHA+aX7LndBmgvdKDn2DeLzB+f4tMhmdUChpMVjfWk4R/i4vZ+Gn
         49nbEJcc7/wzQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Fix spelling mistake "destoy" -> "destroy"
Date:   Sat, 12 Nov 2022 02:21:34 -0800
Message-Id: <20221112102147.496378-3-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

There is a spelling mistake in an error message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index eb81759244d5..9c3dfd68f8df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -292,7 +292,7 @@ int mlx5dr_table_destroy(struct mlx5dr_table *tbl)
 	mlx5dr_dbg_tbl_del(tbl);
 	ret = dr_table_destroy_sw_owned_tbl(tbl);
 	if (ret)
-		mlx5dr_err(tbl->dmn, "Failed to destoy sw owned table\n");
+		mlx5dr_err(tbl->dmn, "Failed to destroy sw owned table\n");
 
 	dr_table_uninit(tbl);
 
-- 
2.38.1

