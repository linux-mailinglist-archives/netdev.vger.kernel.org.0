Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF676268CC
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbiKLKWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiKLKV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:21:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B09183BF
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:21:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C48E60B91
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5981CC433D6;
        Sat, 12 Nov 2022 10:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248517;
        bh=DwWiONPXYwwl4zUnNkjWhAbNGvVLcN//dL753+vJu4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4Hj940exa5P1FOseUEWhhBlLTFX8wDyAQtDCGRS9B9rkiYq+QKSewJoK5dwsTGAS
         z4YExz8C1xCnBfA9p0x1VbnEUZjMwkrxxdi/ObCBN9e2DO5NmYIh5d/fIylWXYDtfX
         Thu7glVfq++T2Pcol/lgSjBFcc9v52P9lSg3iRex0Ga3kEI1HwGZcKpJ2KxKOMi16P
         6DkbjQ2ZNz2UJh0USb36I2qb5+w2afKO8DddEDzKv0Fng1FIp/zJjFhST49PxDd5PS
         x6H6oKMyhID8HNhGQzXxJWxvaJyXDBrM9dZbp1g/tsPG72uL8kvT0vtWb3t5hiQviQ
         HEXCy+sRK56bA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Anisse Astier <anisse@astier.eu>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: remove unused list in arfs
Date:   Sat, 12 Nov 2022 02:21:37 -0800
Message-Id: <20221112102147.496378-6-saeed@kernel.org>
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

From: Anisse Astier <anisse@astier.eu>

This is never used, and probably something that was intended to be used
before per-protocol hash tables were chosen instead.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 0ae1865086ff..bed0c2d043e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -57,7 +57,6 @@ struct mlx5e_arfs_tables {
 	struct arfs_table arfs_tables[ARFS_NUM_TYPES];
 	/* Protect aRFS rules list */
 	spinlock_t                     arfs_lock;
-	struct list_head               rules;
 	int                            last_filter_id;
 	struct workqueue_struct        *wq;
 };
@@ -376,7 +375,6 @@ int mlx5e_arfs_create_tables(struct mlx5e_flow_steering *fs,
 		return -ENOMEM;
 
 	spin_lock_init(&arfs->arfs_lock);
-	INIT_LIST_HEAD(&arfs->rules);
 	arfs->wq = create_singlethread_workqueue("mlx5e_arfs");
 	if (!arfs->wq)
 		goto err;
-- 
2.38.1

