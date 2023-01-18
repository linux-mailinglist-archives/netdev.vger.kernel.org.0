Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB65672727
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjARSgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjARSgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334AD5AA4B
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD7B46199D
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE08C433D2;
        Wed, 18 Jan 2023 18:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066979;
        bh=xaFPgF+EDYaVUCkb+makL1vMJQ6xCJatF5bo8JsSWgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wm+ITvzZOH7gPDJA6U61hr87LVZlO3nItXAAGetgFh93lViKU16fmvQibydu4wo3D
         Kah1rMp9ewiI5wG9RuU/YzJB8JHTrdS8m2m4C9WsbbWVULA29PyJ6qMLIchYfHPFp6
         2fcK7rioraL2+KWpq5CBIpUrA4h91n35iGT/gGdrKkkXYhKJ1Wwqlr4c1LXI7jBOWS
         9/wRKgusbC3g44tauqDadKVovy7iAtJRxlob7UTxuN8c2v5ZbthBWAdh90DCU1PgQ/
         IN0xRjkGyh9AVD4n7qsCbQjxbRx9U4XT3g8NGR8jojT9L/FAWrmKVsudqfwL2tVrKT
         Ahi/oJSYqCEGw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 12/15] net/mlx5: E-Switch, Fix typo for egress
Date:   Wed, 18 Jan 2023 10:35:59 -0800
Message-Id: <20230118183602.124323-13-saeed@kernel.org>
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

Fix engress to egress.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 05a352d8d13f..6f11b46ee79a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1250,7 +1250,7 @@ static int mlx5_esw_acls_ns_init(struct mlx5_eswitch *esw)
 		if (err)
 			return err;
 	} else {
-		esw_warn(dev, "engress ACL is not supported by FW\n");
+		esw_warn(dev, "egress ACL is not supported by FW\n");
 	}
 
 	if (MLX5_CAP_ESW_INGRESS_ACL(dev, ft_support)) {
-- 
2.39.0

