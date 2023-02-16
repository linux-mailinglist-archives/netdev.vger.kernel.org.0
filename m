Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7277469891F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBPAJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjBPAJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:09:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48C038E95
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 16:09:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FCDE61E11
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB384C433A7;
        Thu, 16 Feb 2023 00:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676506166;
        bh=BRy0nhEZuT8OQ6UeWCTU51bVy7qv0jrNmGNJmg6mcRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTCKaoTkIpXETT03waRS7FzWWGt37vWfzx/7V/bfP5y3vGlIoX7pQsWCxKs1Zq4xD
         jawX/X5CqPATgLtm1yPfQO8qjh14B2lDBKECbNxhtSycGidSJB9XDC15SZEqS1v5r4
         r4gEvAJwRUWTxiJGJs4CNlPsId9Cs2tXb25q6TmMYBXX8DRNqwOiN1J/qxCmPcEkmW
         Ajl+wRqRbaZRVCS8VokOd5YTUP/AyX5+CyRjlrDoxr8WCzqnSMIEUJdlLKy5SnG9RP
         6dMSCLa8Qsrqp4zUuq7ix/3U+jiFjEBcN0nTCTl2o1ZfwcHda7bGoKy6l524gXJ658
         vYgzsuqteMX3A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 7/9] net/mlx5e: Remove unused function mlx5e_sq_xmit_simple
Date:   Wed, 15 Feb 2023 16:09:16 -0800
Message-Id: <20230216000918.235103-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216000918.235103-1-saeed@kernel.org>
References: <20230216000918.235103-1-saeed@kernel.org>
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

The last usage was removed as part of
commit 40379a0084c2 ("net/mlx5_fpga: Drop INNOVA TLS support").

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   | 15 ---------------
 2 files changed, 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index c10c6ab2e7bc..c067d2efab51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -320,7 +320,6 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 	}
 }
 
-void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, bool xmit_more);
 void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq);
 
 static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_tx_mpwqe *session, u8 max_sq_mpw_wqebbs)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index f7897ddb29c5..df5e780e8e6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -720,21 +720,6 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, bool xmit_more)
-{
-	struct mlx5e_tx_wqe_attr wqe_attr;
-	struct mlx5e_tx_attr attr;
-	struct mlx5e_tx_wqe *wqe;
-	u16 pi;
-
-	mlx5e_sq_xmit_prepare(sq, skb, NULL, &attr);
-	mlx5e_sq_calc_wqe_attr(skb, &attr, &wqe_attr);
-	pi = mlx5e_txqsq_get_next_pi(sq, wqe_attr.num_wqebbs);
-	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
-	mlx5e_txwqe_build_eseg_csum(sq, skb, NULL, &wqe->eth);
-	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, xmit_more);
-}
-
 static void mlx5e_tx_wi_dma_unmap(struct mlx5e_txqsq *sq, struct mlx5e_tx_wqe_info *wi,
 				  u32 *dma_fifo_cc)
 {
-- 
2.39.1

