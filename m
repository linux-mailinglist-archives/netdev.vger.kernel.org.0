Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90615ECEB2
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiI0UhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbiI0Ugs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E678307F
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C82C61B80
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAC4C433C1;
        Tue, 27 Sep 2022 20:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311006;
        bh=4RpxXg7lHUF8Mxf/ixtJ9UUgj3wwDcQXLVROGM1ff6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2ULxwBE6iikwQU+eVu1CqchM7hn+KGD2urh3lHL+lkZrAIDxSi8oZcTDveP6EhD4
         2YPL+YKYP+5neSVJ7wT+p8ssfZlEBH3lrGiWwgp2g6lWc4imr5Z+HhYkmbU0wxJtPH
         hMY3xJuQQpq4K02VO9uyOd6lD1PVPx3rM3eF38KlVxxUlpf43mDA0NF7fqoIjOXwzl
         FdLcYMfAOyrNAkhZ1fh7QQhTzA0tNjSnzW85HzmNpy7eopDfBWbC4Md3xXAEQ5GFjd
         ssT2w6vrQAHKfKS2qa/GlXzpWJUXUrImonXRUuc3X+w9h3qwpguuDCnLIr1c2Ug6/Y
         xkmEBQLqC/1rA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 08/16] net/mlx5e: Fix a typo in mlx5e_xdp_mpwqe_is_full
Date:   Tue, 27 Sep 2022 13:36:03 -0700
Message-Id: <20220927203611.244301-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Fix a typo in the function name: mpqwe -> mpwqe (stands for multi-packet
work queue element).

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 8f321a6c0809..4685c652c97e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -333,7 +333,7 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptx
 
 	mlx5e_xdp_mpwqe_add_dseg(sq, xdptxd, stats);
 
-	if (unlikely(mlx5e_xdp_mpqwe_is_full(session, sq->max_sq_mpw_wqebbs)))
+	if (unlikely(mlx5e_xdp_mpwqe_is_full(session, sq->max_sq_mpw_wqebbs)))
 		mlx5e_xdp_mpwqe_complete(sq);
 
 	stats->xmit++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 287e17911251..bc2d9034af5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -122,7 +122,7 @@ static inline bool mlx5e_xdp_get_inline_state(struct mlx5e_xdpsq *sq, bool cur)
 	return cur;
 }
 
-static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_tx_mpwqe *session, u8 max_sq_mpw_wqebbs)
+static inline bool mlx5e_xdp_mpwqe_is_full(struct mlx5e_tx_mpwqe *session, u8 max_sq_mpw_wqebbs)
 {
 	if (session->inline_on)
 		return session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT >
-- 
2.37.3

