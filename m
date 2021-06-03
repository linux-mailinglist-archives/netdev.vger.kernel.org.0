Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F01D39ABA3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhFCUNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230036AbhFCUNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B86A61407;
        Thu,  3 Jun 2021 20:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622751121;
        bh=vjPmpmd+a5DKlMnaV4+F4lduRBGywX+zW3ensRpDfC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNPIYaxb69fmFQHqHizuRFa+WklM+Z3UR8C5xnEraHnHvHC/SpPWjYZ+CywqD2tsq
         vHG4DhjoTs/ZWKkLepdTpx0yoTCGuAI6n9Gdqlv3Ul1xtzXEETQDdk6+PSCVxCrK1U
         WF4xxQJ95RoRG+15Jv4tmt121tuI6/OkA9ryggFoAlVPgPSJT1X70xrJMAntWvo+R8
         ZNJmlI2svByfenFrEDldydmGPQimytHVPJMTYtcBZ3cDljwnif+W1RyvBMfOF6MRPH
         x8zolls1uzwhMv9fnZ6HG7MOvZJQhbLpHeuW2MzI50YcdV9MliCJFdxsARmngnHU0s
         XaUB+dZtSLj8Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [net-next 04/10] net/mlx5e: Remove the repeated declaration
Date:   Thu,  3 Jun 2021 13:11:49 -0700
Message-Id: <20210603201155.109184-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603201155.109184-1-saeed@kernel.org>
References: <20210603201155.109184-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>

Function 'mlx5e_deactivate_rq' is declared twice, so remove the
repeated declaration.

Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b636d63358d2..d966d5f40e78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -974,7 +974,6 @@ int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 		  struct mlx5e_xsk_param *xsk, int node,
 		  struct mlx5e_rq *rq);
 int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time);
-void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_close_rq(struct mlx5e_rq *rq);
 int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param *param);
 void mlx5e_destroy_rq(struct mlx5e_rq *rq);
-- 
2.31.1

