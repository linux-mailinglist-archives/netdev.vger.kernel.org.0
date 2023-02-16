Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E838C698921
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjBPAJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjBPAJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:09:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90B942BD9
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 16:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 718FB61E15
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E0AC433D2;
        Thu, 16 Feb 2023 00:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676506167;
        bh=CAiCxio6Eq1mnjR+sn1lBGCpia4Me4tJZTAoB+MaYjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNDVf/Eb6yDIXcns+HVbJDIQtbxHmytV0kw+Y01dDwsuX9RjXKqMA5By0iRW5jrCK
         /4hsfLskaOoweQcnGNlmBfu+/Z+CIVP2TuLpPloJ4odZC6Lh6id8u2SlmrOUE2OEEb
         MVR+hjJwOi6NrW8Zn1PdBIA2ukcDPX9RFvkc7Mg5cj87MsjajFtwrt2fqn4oM8pQpv
         Mo3UVwr3aDAhx42/b5n9QaSNVN2NRXLMrY4Jx0fuewwwlsOQcwIxEqWsJQGm0zidIw
         P6+3GNSzUF07Hlzb6+SMSmrWWSQS+l83Upzbn4KxhXaW3u9A/KglWs6KAGEI0a7qfD
         PwvRY2SaRDglg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 8/9] net/mlx5e: Fix outdated TLS comment
Date:   Wed, 15 Feb 2023 16:09:17 -0800
Message-Id: <20230216000918.235103-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216000918.235103-1-saeed@kernel.org>
References: <20230216000918.235103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Comment is outdated since
commit 40379a0084c2 ("net/mlx5_fpga: Drop INNOVA TLS support").

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 07187028f0d3..c964644ee866 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -124,7 +124,7 @@ static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
 		mlx5e_udp_gso_handle_tx_skb(skb);
 
 #ifdef CONFIG_MLX5_EN_TLS
-	/* May send SKBs and WQEs. */
+	/* May send WQEs. */
 	if (mlx5e_ktls_skb_offloaded(skb))
 		if (unlikely(!mlx5e_ktls_handle_tx_skb(dev, sq, skb,
 						       &state->tls)))
-- 
2.39.1

