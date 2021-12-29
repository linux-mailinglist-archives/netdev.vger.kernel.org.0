Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B7B48104C
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbhL2GZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60596 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238939AbhL2GZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA1D06142E
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53070C36AF0;
        Wed, 29 Dec 2021 06:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759106;
        bh=cNRdpJBfEeCG4QUiMqhbBKvx5q0vo+JrVCipt/3MwYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsYSy4sj6MZzWdv5Gx4xhFAgXnpk3XE9Zs7OeTJ3iBjRTJa19maISiMPZX53pGm9B
         1fcgsfpiEiYVSMD6L0MS1rNtu8UV9RA80siZGLM8VK19hBwSKaJ8A/UQeLDdJh95un
         uqb4xw/aVd0PdEIjO4sXCXbs5D2dtUtgc+f3R+36ZeMJCJrK5xPrIEvPYl/U48tx9s
         gIHz+cm8+Si74xha6IkEI7QgzzQqBemTUX2B7IaWr4XF5DxDN0dGBrMtGMGkieHsvL
         ClOQshAY5yz5q80xDwUju1KZLNlmV6flH3n0tqeEzDqNOHr9enM6D1JEvVakv1J5oA
         KITfaDV0Xfpyw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  03/16] net/mlx5: DR, Remove unused struct member in matcher
Date:   Tue, 28 Dec 2021 22:24:49 -0800
Message-Id: <20211229062502.24111-4-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 2333c2439c28..75bfdd7890da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -886,7 +886,6 @@ struct mlx5dr_matcher {
 	struct mlx5dr_match_param mask;
 	u8 match_criteria;
 	refcount_t refcount;
-	struct mlx5dv_flow_matcher *dv_matcher;
 };
 
 struct mlx5dr_ste_action_modify_field {
-- 
2.33.1

