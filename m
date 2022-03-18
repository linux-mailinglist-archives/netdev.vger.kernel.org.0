Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6594DE2F7
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240915AbiCRUy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240878AbiCRUym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83DE13E2E
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D6D0B8257E
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005FCC340EF;
        Fri, 18 Mar 2022 20:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636797;
        bh=QnoMYRrvfTzxFiV4EcFLNJO5D+TqfjgLW6giPyzJsnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pItPBLtku3N9fAYbGz35NN8t/MSb81h6Nl2G/WUxkkHhlXAzRQii9cPSo2PRo1ReG
         kDPG5+tn9OUg0uP47W/ned52NphaWitsX0EmskhwsnKPIwKIZr2fY9LAwxnM7BNdjM
         bBjzqXR4t6xARgSjIhcYy0kX2ex4ADJffyDdwnp5H/LDVeQUb4PVjvqY13f+Yrq07x
         FTxRHPnHdN82NGWOhWefW8ZOKmKKfpnXUhybuT8GsQ2kPFTzCclgU/nGrs/8C6GTTx
         pUcTex8Vyer7OSrI0b6jWSxyXGiZCrDpFgnzURLMU6+BPX8XLqm1UiOU2OcteVD0Ux
         FOeo0YZuQq9QQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: HTB, remove unused function declaration
Date:   Fri, 18 Mar 2022 13:52:48 -0700
Message-Id: <20220318205248.33367-16-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318205248.33367-1-saeed@kernel.org>
References: <20220318205248.33367-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

There is no function mlx5e_get_sq(), remove the declaration.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
index b7558907ba20..5d9bd91d86c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
@@ -18,7 +18,6 @@ int mlx5e_qos_cur_leaf_nodes(struct mlx5e_priv *priv);
 
 /* TX datapath API */
 int mlx5e_get_txq_by_classid(struct mlx5e_priv *priv, u16 classid);
-struct mlx5e_txqsq *mlx5e_get_sq(struct mlx5e_priv *priv, int qid);
 
 /* SQ lifecycle */
 int mlx5e_qos_open_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs);
-- 
2.35.1

