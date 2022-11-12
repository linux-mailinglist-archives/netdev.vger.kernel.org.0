Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA0C6268D3
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiKLKWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiKLKWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:22:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455D827DF8
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:22:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED79FB80735
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAE6C433D6;
        Sat, 12 Nov 2022 10:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248523;
        bh=br7fWzG45DQ7fw552M/WaGUCCqxkOUabKvC6TDZ8L8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERwpnxRFqP2MOhUFpLatLZhXP9SZVVYGNyOYmsXw4pjXRP9f/91EO/pD9XPaRCNT6
         xI6YsnKNdAbY9V/33mWD/LifY6Gu3KPDk7Dl8clwZwZ4ttlEps5edIeY5EK6CH2w6s
         7niR5Owid87t+YrF+BKYTrCi6MZ2P4R5vl0aNUj2+qkjxUT/lwgUUqH6LDVuJkhWei
         ll7yPSiu2yQ15UvKGfjywclR17UkaJbOatmdPUMgK2KVZPaiVwwFVZ60s3WAgsxy3X
         hGtuQEfjiUkf/BI/oUx9hAOlJ6F7zAIwmeAG1dDl1fiIsBgV/znxNFbvrjpsUTHEp9
         t9GqL9g4Dyj3g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: kTLS, Remove unused work field
Date:   Sat, 12 Nov 2022 02:21:43 -0800
Message-Id: <20221112102147.496378-12-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

Work field in struct mlx5e_async_ctx is not used. Remove it.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 2e0335246967..f8d9708feb7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -126,7 +126,6 @@ mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
 struct mlx5e_async_ctx {
 	struct mlx5_async_work context;
 	struct mlx5_async_ctx async_ctx;
-	struct work_struct work;
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
 	struct completion complete;
 	int err;
-- 
2.38.1

