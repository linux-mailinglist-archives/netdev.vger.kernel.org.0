Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5AE35E71B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348121AbhDMTb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346492AbhDMTa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81D18613CC;
        Tue, 13 Apr 2021 19:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342237;
        bh=wyPT1DMlG+mT48SaCjIYfr2nQn11qqqgaBQ+QlSO6co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhsxH9Nq8iX9ZfNBrhB7/7rkIjSLXhzOpBWLrUiKUZ6gJzjryL2BV9z9yCTCWyFCd
         Fivg8lLl+nK7hQ54ELvXushDwUacGYA0LiKk9VtXBB1juUjal1NMQUr+YHmuPfiof3
         xK4TNp636PpmrvXHk+8MR7ZTO1rXH2wgAy3ZqU7n5pp50ACTePoXqjTeX09y1UDcsL
         rc8FP2xrmc2Nwdb9bXTq+y3j+OVw74yHlKg7qs8f8hMUDUyi0PTSvK5CF7u7dzpT0G
         Zo16uNgVIJmhnR9mBflhH0ohbkOwbbmYHBbw3abSW1aIUThRBuZub25FuX6hlW1sWX
         0Xf/dsnCd6arg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/16] net/mlx5: Remove return statement exist at the end of void function
Date:   Tue, 13 Apr 2021 12:30:04 -0700
Message-Id: <20210413193006.21650-15-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

void function return statements are not generally useful.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c     | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c    | 1 -
 3 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 127bb92da150..b8748390335f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -603,8 +603,6 @@ void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev)
 	if (err)
 		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
 			      err);
-
-	return;
 }
 
 /* Must be called with intf_mutex held */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 19e3e978267e..1f907df5b3a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -167,7 +167,6 @@ static void irq_set_name(char *name, int vecidx)
 
 	snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_comp%d",
 		 vecidx - MLX5_IRQ_VEC_COMP_BASE);
-	return;
 }
 
 static int request_irqs(struct mlx5_core_dev *dev, int nvec)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
index 8e0dddc6383f..441b5453acae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -180,5 +180,4 @@ void mlx5_rdma_enable_roce(struct mlx5_core_dev *dev)
 	mlx5_rdma_del_roce_addr(dev);
 disable_roce:
 	mlx5_nic_vport_disable_roce(dev);
-	return;
 }
-- 
2.30.2

