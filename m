Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD43577856
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 23:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiGQVf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 17:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiGQVft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 17:35:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4698310FDC
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 14:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03219B80B63
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 21:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D837C341C0;
        Sun, 17 Jul 2022 21:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658093746;
        bh=LR70iE9fNxOfc0UN3hnUke98rc/gQ9zgymLPTk5ltiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOoa3gdiB0/go2vEumpsIh9yBcBrYpRJoigvGVtLaKMuJQB++JN1g42mLKCY1z0Xo
         m1tz/WOA/Xqib0dQRLs0Ix2kXUXqvOSnodfhXE+AwbvdvWLH+cOTEjkOT7mhE9im0K
         sEbjMo5UBqaBiniSNfEv+ZiXeA0Q/SdYheR8DXeenicIxwnkf9kWP8MDL1Jsaphnx/
         Q4bQhIB8xCY73gPSQ242ILylaf738avAPQwp9v1gdkKM9I67ZzPNBVscLy/eNHIoEU
         YbrbmEQS7Wczy/b3pcVNI6d8KGWNm/7b/4zLGo0EKSOk/UJYfrDP5sGwaH+JEdwPoB
         jscQL4wCJeCTw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 06/14] net/mlx5e: HTB, move section comment to the right place
Date:   Sun, 17 Jul 2022 14:33:44 -0700
Message-Id: <20220717213352.89838-7-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220717213352.89838-1-saeed@kernel.org>
References: <20220717213352.89838-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

