Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B8547CB9E
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242124AbhLVDQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58318 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242096AbhLVDQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3BA3B81A63
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10542C36AED;
        Wed, 22 Dec 2021 03:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142974;
        bh=V5/8cIUH+0ZmQ3SiZk0PHbX00bABjAn6DMf9D6mShdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxIAncn4LzaIUxUgq+7PdFGg6QLH4liIO8MSGjOKU3pbcBuFh42fo0ZQWUCLEIaCK
         UzqVhltpXhEj3qGepNeGAUc4FiwOKUf8Zpqx0WIlS13bnSXfTvqoTqzuD7Ltmrpg+l
         CT/GRNKWftVg1zIc+6zVxuhq03b231Ts5Kq7kXMBoaejKvTq1Tj0zoDtzrTDoeF53Z
         1SRfhlVk1h2RVLkW9tsU9AFeAeCHbenpTI6dCeh7JaVKJAsTXXCo7xFylODgZLKYSY
         gDyHD2eIjoFlxFK404qkF5NJ2IOqgZiuvip+aAJ1Pl+t7lWdLfNk1lLqn9N0R2fmsT
         BQRVUITqR+1ug==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next v0 07/14] net/mlx5: Remove the repeated declaration
Date:   Tue, 21 Dec 2021 19:15:57 -0800
Message-Id: <20211222031604.14540-8-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222031604.14540-1-saeed@kernel.org>
References: <20211222031604.14540-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>

Function 'mlx5_esw_vport_match_metadata_supported' and
'mlx5_esw_offloads_vport_metadata_set' are declared twice, so remove
the repeated declaration and blank line.

Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 513f741d16c7..ead5e8acc8be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -343,9 +343,6 @@ void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata);
 
 int mlx5_esw_qos_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num, u32 rate_mbps);
 
-bool mlx5_esw_vport_match_metadata_supported(const struct mlx5_eswitch *esw);
-int mlx5_esw_offloads_vport_metadata_set(struct mlx5_eswitch *esw, bool enable);
-
 /* E-Switch API */
 int mlx5_eswitch_init(struct mlx5_core_dev *dev);
 void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw);
-- 
2.33.1

