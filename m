Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84000339A0D
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbhCLXj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:32798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235814AbhCLXi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:38:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9399164F21;
        Fri, 12 Mar 2021 23:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592338;
        bh=ir5A6iMeWvrGnZN8aXiWlvJ6pbmlIpImHCSv6ytHqEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1f1WcaACJQt1yYFkAargZMlfn1eBxlCVokdyaHs5vd5/E8sVauT9DJQHByLRsHu5
         AdHyVa8at5RZNpjz50SWQRYl4lFjF8OHMPpK3f+EvD5akKsgPev40/8LqCERbxwyrM
         xVuBCeMxwpsIyGonUXCTIcApgKzsrssFlxh9xRSCvwnQiEbcKdJiI4VbCn16yWd7Wj
         NbNZegcs1Xhz4EdbvkRaOKZV17naQml7PNdzA+K71L13UV6wtMvyp+mK/BFCqIZCs6
         GOzkiKW2zf358EdJBBhPN50lUY3yz7x44KZ1KXUBaCuyG+8+2Ao2yLp1dP/0wg+/5V
         DNMXkbsNRZM3Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/13] net/mlx5e: Remove redundant newline in NL_SET_ERR_MSG_MOD
Date:   Fri, 12 Mar 2021 15:38:45 -0800
Message-Id: <20210312233851.494832-8-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312233851.494832-1-saeed@kernel.org>
References: <20210312233851.494832-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Fix the following coccicheck warnings:

drivers/net/ethernet/mellanox/mlx5/core/devlink.c:145:29-66: WARNING
avoid newline at end of message in NL_SET_ERR_MSG_MOD
drivers/net/ethernet/mellanox/mlx5/core/devlink.c:140:29-77: WARNING
avoid newline at end of message in NL_SET_ERR_MSG_MOD

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 6729720e1ab7..38c7c44fe883 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -137,12 +137,12 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		 * unregistering devlink instance while holding devlink_mutext.
 		 * Hence, do not support reload.
 		 */
-		NL_SET_ERR_MSG_MOD(extack, "reload is unsupported when SFs are allocated\n");
+		NL_SET_ERR_MSG_MOD(extack, "reload is unsupported when SFs are allocated");
 		return -EOPNOTSUPP;
 	}
 
 	if (mlx5_lag_is_active(dev)) {
-		NL_SET_ERR_MSG_MOD(extack, "reload is unsupported in Lag mode\n");
+		NL_SET_ERR_MSG_MOD(extack, "reload is unsupported in Lag mode");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.29.2

