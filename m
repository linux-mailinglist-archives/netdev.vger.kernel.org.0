Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D05869B8E7
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 10:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjBRJFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 04:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBRJFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 04:05:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09B948E04
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 01:05:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62E92B8227E
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031EDC433EF;
        Sat, 18 Feb 2023 09:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676711131;
        bh=CAiCxio6Eq1mnjR+sn1lBGCpia4Me4tJZTAoB+MaYjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOmy1JWl6s7qimUz53/hY3OW21fkvkGl41dNYXVGPUYyoI96nOCVLIiUGnjRpkPbm
         kdxf7+Nlh8qSr7t5feUztNsMNFcwmP5EHIIPtaTMSIkIee7B4R+7nnmzxcfqwb6m2G
         1NilRbwHaFJwoFvUHBBpclYZriqgNKKtxJfBvO+QQ9X3E7eJnvTcav08E7x4pqwpb8
         rrepADcYql86W8bsvMSenspoFmOuE5I3/f6f7A1Z+tUSVHGw7vbceANKAcxEOrkTaP
         HRHCFAIR10t+EE9dxa95c6ugGhZDayMdU+IHNhCYAvVJNwVf7pmr5+ZwcslLjfM1p3
         3C125z6JHOFaw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next V2 8/9] net/mlx5e: Fix outdated TLS comment
Date:   Sat, 18 Feb 2023 01:05:12 -0800
Message-Id: <20230218090513.284718-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230218090513.284718-1-saeed@kernel.org>
References: <20230218090513.284718-1-saeed@kernel.org>
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

