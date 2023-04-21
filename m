Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF676EA123
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbjDUBkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbjDUBkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:40:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9630E6A60
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D4A964703
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98B7C433D2;
        Fri, 21 Apr 2023 01:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041198;
        bh=fBSBKdU/6X+NTlcmg8IXxU7+r6a0RYknMVUZj0JlUrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHIgrw1zrr26Dft5EHG+PxYsT38zu96TUPsOx5GCRbAB1lCe7IFktXzxBe66LHjDJ
         6U2Egy5yVMqYI0h7qzpEvnSvZ1Qx2zPXUq0seckdadQz5Duktw+pNpq4Tw8vMqBzks
         QQ/i2aGOj3ZzEquI0A25RwmgqZFnhYlHqlaKfJZSBOLkOPQ/KNB/L+TD0oBm7NG7rR
         kAQEnQ1SB4JqxVHVAG/iSxKxbDKuhyYBFImCjiyRDkiuIlZ0n499NL1Oy00Ut1Jmli
         RoHsjny3ggK3Sa3nJn4VNAV65ScxdLdqctNSoFl/5HEku8Pwgg/GwWGgqXNSRfozTN
         BQm0yc39eVfeg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 14/15] net/mlx5: E-Switch, Remove unused mlx5_esw_offloads_vport_metadata_set()
Date:   Thu, 20 Apr 2023 18:38:49 -0700
Message-Id: <20230421013850.349646-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Remove unused function which also seems a duplicate
of esw_port_metadata_set().

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 -
 .../mellanox/mlx5/core/eswitch_offloads.c     | 22 -------------------
 2 files changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index f8e25ddc066a..62f01d4600fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -354,7 +354,6 @@ mlx5_eswitch_add_send_to_vport_meta_rule(struct mlx5_eswitch *esw, u16 vport_num
 void mlx5_eswitch_del_send_to_vport_meta_rule(struct mlx5_flow_handle *rule);
 
 bool mlx5_esw_vport_match_metadata_supported(const struct mlx5_eswitch *esw);
-int mlx5_esw_offloads_vport_metadata_set(struct mlx5_eswitch *esw, bool enable);
 u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw);
 void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 93ece46a0041..12c07a44aa4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2939,28 +2939,6 @@ static int esw_offloads_metadata_init(struct mlx5_eswitch *esw)
 	return err;
 }
 
-int mlx5_esw_offloads_vport_metadata_set(struct mlx5_eswitch *esw, bool enable)
-{
-	int err = 0;
-
-	down_write(&esw->mode_lock);
-	if (mlx5_esw_is_fdb_created(esw)) {
-		err = -EBUSY;
-		goto done;
-	}
-	if (!mlx5_esw_vport_match_metadata_supported(esw)) {
-		err = -EOPNOTSUPP;
-		goto done;
-	}
-	if (enable)
-		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
-	else
-		esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
-done:
-	up_write(&esw->mode_lock);
-	return err;
-}
-
 int
 esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 				     struct mlx5_vport *vport)
-- 
2.39.2

