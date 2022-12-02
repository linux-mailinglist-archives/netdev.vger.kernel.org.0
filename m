Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D316640EFF
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbiLBUPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbiLBUPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:15:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34CFF231F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 825ED622CB
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AA6C433D6;
        Fri,  2 Dec 2022 20:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012138;
        bh=TK+qMtxgcWdt6+u1drEYW1EvJXx92l4NyLtu1EITX7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzIesLZZiz9viuZ7EfBDF3uLuO/Uav0YZrmy1iL3XH58AJihZt2fP2Tjr33zd7p+n
         YXE3wV7yVvPYEkIYqo3npeoDvmaJc0GR1XabsiDnj3KeZjMTnUjrdSsmGXucwv5q9L
         BNxsy/7DwfAydSsDY1d3bI4nrFYDsWiEUjn4fgHnorh6ZLHgLOaVmQx8f/9ol3QmJD
         cy6BC6WeHvHrdWAwRAOUnG9ZYZpDxjYZo560Hvg/6rEaQpPGT4m/Z9JD/yyWhRr6rH
         0iyqyOWrvBOZusImt4ahKJhrVNNfhS09BdBMYZMxCeGghbIYKihdq0urpO13StTQaL
         O2QPHTG47Ib5g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 08/13] net/mlx5e: Provide intermediate pointer to access IPsec struct
Date:   Fri,  2 Dec 2022 22:14:52 +0200
Message-Id: <344c855c23ad578357851ad2ec8c22dde4ef3d21.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
References: <cover.1670011885.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Improve readability by providing direct pointer to struct mlx5e_ipsec.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c         | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 6859f1c1a831..9f07e58f7737 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -312,23 +312,23 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 				       struct mlx5_cqe64 *cqe)
 {
 	u32 ipsec_meta_data = be32_to_cpu(cqe->ft_metadata);
-	struct mlx5e_priv *priv;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_ipsec *ipsec = priv->ipsec;
 	struct xfrm_offload *xo;
 	struct xfrm_state *xs;
 	struct sec_path *sp;
 	u32  sa_handle;
 
 	sa_handle = MLX5_IPSEC_METADATA_HANDLE(ipsec_meta_data);
-	priv = netdev_priv(netdev);
 	sp = secpath_set(skb);
 	if (unlikely(!sp)) {
-		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_sp_alloc);
+		atomic64_inc(&ipsec->sw_stats.ipsec_rx_drop_sp_alloc);
 		return;
 	}
 
-	xs = mlx5e_ipsec_sadb_rx_lookup(priv->ipsec, sa_handle);
+	xs = mlx5e_ipsec_sadb_rx_lookup(ipsec, sa_handle);
 	if (unlikely(!xs)) {
-		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_sadb_miss);
+		atomic64_inc(&ipsec->sw_stats.ipsec_rx_drop_sadb_miss);
 		return;
 	}
 
@@ -349,6 +349,6 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 		xo->status = CRYPTO_INVALID_PACKET_SYNTAX;
 		break;
 	default:
-		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_syndrome);
+		atomic64_inc(&ipsec->sw_stats.ipsec_rx_drop_syndrome);
 	}
 }
-- 
2.38.1

