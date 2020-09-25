Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D982791DD
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgIYURb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727405AbgIYUPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:15:31 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FEAD2396D;
        Fri, 25 Sep 2020 19:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062704;
        bh=tEp0fLU7NVD6ITluxavvMWQfPzNJrpykZ9Y9IbPyE7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJcEaf1eO2sEhoMP2FeSm3LJtyFJD41/tMRSb0/53Zs1Aw7HOnJk7xsHwKTiIStLk
         yphMkLTeWSAzSu9mHcZId//0BBGCXbv+1bcSc4gMCZC2RtfOM10jKfW1dHDjyqeQ22
         G0SfeWWdDqnt0IlEnqhINAv8HecMOwSm2qLhLaJw=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: DR, Remove unused member of action struct
Date:   Fri, 25 Sep 2020 12:38:06 -0700
Message-Id: <20200925193809.463047-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Struct mlx5dr_action doesn't use this member

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index ce04a2019f90..77615f6d2fdf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -731,7 +731,6 @@ struct mlx5dr_action {
 			struct mlx5dr_domain *dmn;
 			struct mlx5dr_icm_chunk *chunk;
 			u8 *data;
-			u32 data_size;
 			u16 num_of_actions;
 			u32 index;
 			u8 allow_rx:1;
-- 
2.26.2

