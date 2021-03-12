Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941AA339A0A
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbhCLXjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:32780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235809AbhCLXi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:38:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1AD264FA6;
        Fri, 12 Mar 2021 23:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592338;
        bh=4lqnQLGNMRJjdEbK4BaDdtz2ZVyv5pnkjgNd1dG75MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkFpcX+A9YqIcjVGzCPA6MLJFiL85lr1x/8aA+xEJL1pTY9i3bZFt0nr9OqrIz4Wc
         S/MFeha+S0UipO4ELepWfvsbJBq8eH057UW+TWzs0bSqp/GeqK73lT7/hIFQBxZNas
         0UMfV3ic5J0Pr1tu9btKb5zlPMAgBio2mCzvUrf1oQ9gpzZ6v2vzAWx1I9g27O8U6b
         tLgCHl6LxBRNYTN+6McnuNu7Fp+BZrVOIlN3MO4yM9KZevZRt1nIml3aff7lGjsSua
         KYVRSNadDh3upanP2u/uX1brPejl0BCaTkMGXqIOVmTdl46+A5wyWcAagYAuh2YFFM
         SK5NpBoh45cuQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/13] net/mlx5: remove unneeded semicolon
Date:   Fri, 12 Mar 2021 15:38:43 -0800
Message-Id: <20210312233851.494832-6-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312233851.494832-1-saeed@kernel.org>
References: <20210312233851.494832-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Fix the following coccicheck warnings:

./drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c:495:2-3: Unneeded
semicolon.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index c2ba41bb7a70..60a6328a9ca0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -492,7 +492,7 @@ static int mlx5_sf_esw_event(struct notifier_block *nb, unsigned long event, voi
 		break;
 	default:
 		break;
-	};
+	}
 
 	return 0;
 }
-- 
2.29.2

