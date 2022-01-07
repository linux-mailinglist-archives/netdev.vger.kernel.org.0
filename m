Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EDD486ED2
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343866AbiAGAad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344230AbiAGAaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D546FC06118A
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 732F661E59
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1644C36AE0;
        Fri,  7 Jan 2022 00:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515415;
        bh=9bakY9jy0qb9vuX8w7+Gfi6qmYsCp2UJWvdKgY6m0o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oF14oeJuWigsRK7rezv+Hclbu9hrwMROojudb8k752XjRuUphXmZ2b5IQHUdZIgU3
         ZBk81Ng28GS6pYaDMI2CAGs6E/3zxyoG7CjDI3+DF2TC5y8BHrHSlfvaxqPugfMx5N
         tmSjNXN3GsIlTwBc87kTy5qdAVrkpF9gUiG/uC5zvE8oi4Wb57NQ9Ej8IyuZVSSXq9
         8GMnqlddk7nnEuQc7Q/j5culFPD3BnyCdlYmIcTruC6clXZFQwWeazOngTzhPKheex
         zGk0TaSMjaoUaaWn/zfkJy+SZAZSVtzc3LO7MjmCrBF5Hui9d9J6x/Qb1OGKPI8g5t
         0I7jJhtJfH8rQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 10/15] net/mlx5e: Fix feature check per profile
Date:   Thu,  6 Jan 2022 16:29:51 -0800
Message-Id: <20220107002956.74849-11-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Remove redundant space when constructing the feature's enum. Validate
against the indented enum value.

Fixes: 6c72cb05d4b8 ("net/mlx5e: Use bitmap field for profile features")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c5f959a9e14b..812e6810cb3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -984,7 +984,7 @@ struct mlx5e_profile {
 };
 
 #define mlx5e_profile_feature_cap(profile, feature)	\
-	((profile)->features & (MLX5E_PROFILE_FEATURE_## feature))
+	((profile)->features & BIT(MLX5E_PROFILE_FEATURE_##feature))
 
 void mlx5e_build_ptys2ethtool_map(void);
 
-- 
2.33.1

