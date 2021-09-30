Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB4E41E4B5
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350230AbhI3XWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348841AbhI3XWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06EE561262;
        Thu, 30 Sep 2021 23:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044057;
        bh=ptsstX3vez41RN8JXjkBGBf3AlmIQvMX9ZdLrEac32Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2j/449pZHWBfQN0i2tjGSV/Ii/9KDBkhcLv2hd4wfzuD9SafMgBf9KW2TuYQYdHm
         GJ6uso/Qyr4M8qCSD3d83onQsEKWo0w9dqUtkJxjBSdohmOgLK685NsAd+AGWKojYK
         rTOMyVbIQ94lI++cUoARt1+w+h34+O3PtmE3fFTun8nuUC3Rg0cVT9Pf12NGtmXsCd
         2Iltk36Lzb5pdLxHQsEFYnBTHifD7/l/3Yf5zVB6XTLHeDbVtF8z1Gyu5MkQWmeRBb
         StxUIWOQ1DxgoP8vzWlDnIKqznuk5AkLddMR6AjrvcQTzroN8veVztdRuMkffXfXHn
         83F89L0PCBZxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Hamdan Igbaria <hamdani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5: DR, Increase supported num of actions to 32
Date:   Thu, 30 Sep 2021 16:20:42 -0700
Message-Id: <20210930232050.41779-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Increase max supported number of actions in the same rule.

Signed-off-by: Hamdan Igbaria <hamdani@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 7e58f4e594b7..230e920e3845 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -222,7 +222,7 @@ static bool contain_vport_reformat_action(struct mlx5_flow_rule *dst)
 		dst->dest_attr.vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
 }
 
-#define MLX5_FLOW_CONTEXT_ACTION_MAX  20
+#define MLX5_FLOW_CONTEXT_ACTION_MAX  32
 static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 				  struct mlx5_flow_table *ft,
 				  struct mlx5_flow_group *group,
-- 
2.31.1

