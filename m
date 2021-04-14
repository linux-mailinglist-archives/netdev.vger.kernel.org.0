Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D10735FA4A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352355AbhDNSHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352081AbhDNSGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F250C6120E;
        Wed, 14 Apr 2021 18:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423579;
        bh=wyPT1DMlG+mT48SaCjIYfr2nQn11qqqgaBQ+QlSO6co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIvFCc47T7aUMMfyroIy4mJbCG2WIWL51WztQRb7BEygTPumXPkieb+3RkJyjpPy2
         CNxwjmE9kvzI3y8PGJntR0Zn1oq61nmx4Cb42YJRkzyGSqybUOT/QR2sxipEYHop0c
         xbzGDgxindHsVbgnH6jiUhckM5VlXaNijGfRD4dF2p/y3TEXYTshXVcmiCZfd+ecmK
         x8Qf79QrzsjWiRVQXMfxRqv9DdqlgyQFpzcJnRP1m9V5Yn6Fa8kfHjCRx7sKwSBqH8
         xjmys1hXmKxYndrCZURFAk+prV21xOIPkVRcSs7IOZEaZT3+MysN09g8zcHKYJLzC8
         MgDc9QhvFQuBQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 14/16] net/mlx5: Remove return statement exist at the end of void function
Date:   Wed, 14 Apr 2021 11:06:03 -0700
Message-Id: <20210414180605.111070-15-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414180605.111070-1-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
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

