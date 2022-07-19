Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA98657A84D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbiGSUfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239453AbiGSUfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:35:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BFB45F4F
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF3D261961
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09B0C341CA;
        Tue, 19 Jul 2022 20:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262939;
        bh=LR70iE9fNxOfc0UN3hnUke98rc/gQ9zgymLPTk5ltiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umj9Urqw1akBzvwNSaBr0hJI0O1Ki0cHvMaXlwOf+8NPT7m8PhpPHz6WIXKA5i84v
         3Lk0qXc6CVBO3uO76ZQplMIO78OijvwdwKWjUh41K8aoLtSLtvh1sBDc1fR1WZd67l
         BHbDT992Z4BEvLnIFSGsH5w54ZkQXyluv2/7NseyAcoKCP09Q1i95H/cYLhIzrlKyF
         lZSFVUMiyAacOYDvpgrKfPyQubutalzCVAiQ34InrGoFayroTUu+Voer3l0Zs5qOs2
         rTYZXwgRoBGj0kJAoqSW4ORWJHNdh+DpH1B8FnhmkvpHcAijhIBBRd3Hhwy6DR5VB6
         1A49Gdi9Ih55g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next V2 05/13] net/mlx5e: HTB, move section comment to the right place
Date:   Tue, 19 Jul 2022 13:35:21 -0700
Message-Id: <20220719203529.51151-6-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719203529.51151-1-saeed@kernel.org>
References: <20220719203529.51151-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

mlx5e_get_qos_sq is a part of the SQ lifecycle, so need be under the
title.

Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 75df55850954..9a61c44e7f72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -180,6 +180,8 @@ int mlx5e_get_txq_by_classid(struct mlx5e_priv *priv, u16 classid)
 	return res;
 }
 
+/* SQ lifecycle */
+
 static struct mlx5e_txqsq *mlx5e_get_qos_sq(struct mlx5e_priv *priv, int qid)
 {
 	struct mlx5e_params *params = &priv->channels.params;
@@ -195,8 +197,6 @@ static struct mlx5e_txqsq *mlx5e_get_qos_sq(struct mlx5e_priv *priv, int qid)
 	return mlx5e_state_dereference(priv, qos_sqs[qid]);
 }
 
-/* SQ lifecycle */
-
 static int mlx5e_open_qos_sq(struct mlx5e_priv *priv, struct mlx5e_channels *chs,
 			     struct mlx5e_qos_node *node)
 {
-- 
2.36.1

