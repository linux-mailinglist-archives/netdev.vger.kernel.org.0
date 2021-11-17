Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81C8453F8E
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhKQEhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233105AbhKQEhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345CD615E6;
        Wed, 17 Nov 2021 04:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123650;
        bh=a8pFSV0H0TTbtm+KVo1dvE//T7pp5jOJBAraMnDjpNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmI+U0NYKRTN1sNWkjL07X5gMlnzth6eheNyZEfm9muMjp4Z5UHCZqNHe7mbwb+VN
         uN3w3um3nRwIEv8oP9qnG6u/hh6tfylFjjDas98cO2g7Wawz+eAzO+cGurAAw2XAc2
         2Ml3O6pOjvKqS846yVFOiiqK3FHWfgpMM7+l45q0rxqXDAtjXn10FhSJBfdyzQMQZ6
         iKIZZwlXYvcNvGkVMbD7ySLeddd655+ri2LzAhVVjJ1BkbvduuLX3016zwmLpVkJ0N
         IkwPR8CafnMXALPFVkoJVYqKtltpFjP0CkA2vwyWx+oGVNSpiZ8PSQZR/puERvZhqH
         8X00mXoPfxO1g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 09/15] net/mlx5e: TC, Move comment about mod header flag to correct place
Date:   Tue, 16 Nov 2021 20:33:51 -0800
Message-Id: <20211117043357.345072-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Move the comment to the correct place where the driver actually
removes the flag and not in the check that maybe pedit actions exists.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index aa4da8d1e252..686bb2e08e9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3424,10 +3424,10 @@ actions_prepare_mod_hdr_actions(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	/* In case all pedit actions are skipped, remove the MOD_HDR flag. */
 	if (parse_attr->mod_hdr_acts.num_actions > 0)
 		return 0;
 
+	/* In case all pedit actions are skipped, remove the MOD_HDR flag. */
 	attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 	mlx5e_mod_hdr_dealloc(&parse_attr->mod_hdr_acts);
 
-- 
2.31.1

