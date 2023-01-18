Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBC9672720
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjARSgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjARSgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C6B59B78
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80782B81EA3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE69C433EF;
        Wed, 18 Jan 2023 18:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066972;
        bh=iciWamYEx51bIIBmT12SjZa1QRrcvfpOFsFLpzm+wpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOmtkDx8faJ5Y6DBDMnyquPvBXF1BnvcVJ1jEZ7h5s0D723YQ9n+eJtwoYDkz8RZX
         pt4yopZnGX6LC0fi1f6Mhhk+wmgleT8PmLEPZs4b2VJsUqWOFBUQ/mi/znxWUoM2ce
         TImycb54raxluC35yBAusMCOjvcY6DBYyMsw8VWjKDuonrBTWip8ewGQZ5cazKNOeA
         KDCJ19PmblDwxvNV63hEs++mvX+17lrcvgDCH1q/Qmnt90xH6EFFmLRoS70DDlhxrC
         +6FPJy19alv7PGXqpaXxelOeAfCWlSf8bth/7o3VyUJJbdjNWvk63cBd1Un0FgHc3x
         CAWQ41ruIjPFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 05/15] net/mlx5: E-switch, Remove redundant comment about meta rules
Date:   Wed, 18 Jan 2023 10:35:52 -0800
Message-Id: <20230118183602.124323-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

Meta rules are created/destroyed per vport and not in eswitch
init/destroy.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index bbb6dab3b21f..05a352d8d13f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1406,9 +1406,7 @@ void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
 	mlx5_eswitch_unload_vf_vports(esw, esw->esw_funcs.num_vfs);
 	if (clear_vf)
 		mlx5_eswitch_clear_vf_vports_info(esw);
-	/* If disabling sriov in switchdev mode, free meta rules here
-	 * because it depends on num_vfs.
-	 */
+
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS) {
 		struct devlink *devlink = priv_to_devlink(esw->dev);
 
-- 
2.39.0

