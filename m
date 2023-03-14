Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446976B8AC0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjCNFni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjCNFnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A60429162
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00DEBB8188D
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95868C4339B;
        Tue, 14 Mar 2023 05:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772569;
        bh=aZp1yKR19RV/wnJWuTML8r/o57tW5kg9Ayl/l7d6xGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cdp8iNeqTVrQdt5EAxRmECmP6EVnB61vErwCQES8G+s5sIiVEJDAhkCOwFg6fofFM
         pYn+kG/1TVmn9PrpdhNYqqv8qT0lkbQ2Ns8agFWXypJ+RyGH83M0rJULYY6v3F7EoV
         yAasnJPxPwWdvguXgsJTg913oJTEvAIwoQqamJ8mbWRGXSM7RaFFKthoRxDUrLNAuB
         SGa+thzTLzjrTZXFgCwh+z23Qv0fDR66CaSr1DxEFjISkKvJjZJlG4wBXffW/9k/qL
         yFlTfNOgw3jFD84e1IxHzcEcajX9/NaPKl8iDVKRP3UEic0DDSDIJMrxw6bC42o+w1
         wkw2BTPPb5ozA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Rename RQ/SQ adaptive moderation state flag
Date:   Mon, 13 Mar 2023 22:42:25 -0700
Message-Id: <20230314054234.267365-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
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

From: Adham Faris <afaris@nvidia.com>

Dynamic interrupt moderation RQ and SQ feature represented by
MLX5E_RQ_STATE_AM and MLX5E_SQ_STATE_AM enums respectively, is not
consistent with the feature naming in the driver, and with the formal
feature and library names.

Hence, change MLX5E_RQ_STATE_AM and MLX5E_SQ_STATE_AM enum type names in
core/en.h to MLX5E_RQ_STATE_DIM and MLX5E_SQ_STATE_DIM respectively.

Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 88460b7796e5..66bca3a6a057 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -339,7 +339,7 @@ static inline u8 mlx5e_get_dcb_num_tc(struct mlx5e_params *params)
 enum {
 	MLX5E_RQ_STATE_ENABLED,
 	MLX5E_RQ_STATE_RECOVERING,
-	MLX5E_RQ_STATE_AM,
+	MLX5E_RQ_STATE_DIM,
 	MLX5E_RQ_STATE_NO_CSUM_COMPLETE,
 	MLX5E_RQ_STATE_CSUM_FULL, /* cqe_csum_full hw bit is set */
 	MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX, /* set when mini_cqe_resp_stride_index cap is used */
@@ -390,7 +390,7 @@ enum {
 	MLX5E_SQ_STATE_MPWQE,
 	MLX5E_SQ_STATE_RECOVERING,
 	MLX5E_SQ_STATE_IPSEC,
-	MLX5E_SQ_STATE_AM,
+	MLX5E_SQ_STATE_DIM,
 	MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE,
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 	MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 76a9c5194a70..5ca9fcf84586 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1188,7 +1188,7 @@ int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 		__set_bit(MLX5E_RQ_STATE_CSUM_FULL, &rq->state);
 
 	if (params->rx_dim_enabled)
-		__set_bit(MLX5E_RQ_STATE_AM, &rq->state);
+		__set_bit(MLX5E_RQ_STATE_DIM, &rq->state);
 
 	/* We disable csum_complete when XDP is enabled since
 	 * XDP programs might manipulate packets which will render
@@ -1664,7 +1664,7 @@ int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 		mlx5e_set_sq_maxrate(c->netdev, sq, tx_rate);
 
 	if (params->tx_dim_enabled)
-		sq->state |= BIT(MLX5E_SQ_STATE_AM);
+		sq->state |= BIT(MLX5E_SQ_STATE_DIM);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 9a458a5d9853..a50bfda18e96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -51,7 +51,7 @@ static void mlx5e_handle_tx_dim(struct mlx5e_txqsq *sq)
 	struct mlx5e_sq_stats *stats = sq->stats;
 	struct dim_sample dim_sample = {};
 
-	if (unlikely(!test_bit(MLX5E_SQ_STATE_AM, &sq->state)))
+	if (unlikely(!test_bit(MLX5E_SQ_STATE_DIM, &sq->state)))
 		return;
 
 	dim_update_sample(sq->cq.event_ctr, stats->packets, stats->bytes, &dim_sample);
@@ -63,7 +63,7 @@ static void mlx5e_handle_rx_dim(struct mlx5e_rq *rq)
 	struct mlx5e_rq_stats *stats = rq->stats;
 	struct dim_sample dim_sample = {};
 
-	if (unlikely(!test_bit(MLX5E_RQ_STATE_AM, &rq->state)))
+	if (unlikely(!test_bit(MLX5E_RQ_STATE_DIM, &rq->state)))
 		return;
 
 	dim_update_sample(rq->cq.event_ctr, stats->packets, stats->bytes, &dim_sample);
-- 
2.39.2

