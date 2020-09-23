Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EF8275161
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgIWGYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbgIWGYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:46 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62E1F23600;
        Wed, 23 Sep 2020 06:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842286;
        bh=5DvSxax/avYIsHZ2//iJ7MDb81etE47Yf1YRd/7cYaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDhkm8Rd2FbWgGS2GkPEkUv/sBMkMMJerbf7b3agY+A9TzmSCbzqgfX/W+KaHaNVA
         L0kwLqdyvjhqNuhyHCrhl/IiFDWLqgh6WyXFYPTs1TjCBFR21bml+p2ndrFjVJyco4
         rK8PRyqOtEWLQ07P18FZqSkokprH69m5tBmpxu8c=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: simplify the return expression of mlx5_ec_init()
Date:   Tue, 22 Sep 2020 23:24:37 -0700
Message-Id: <20200923062438.15997-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index a894ea98c95a..3dc9dd3f24dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -43,19 +43,13 @@ static void mlx5_peer_pf_cleanup(struct mlx5_core_dev *dev)
 
 int mlx5_ec_init(struct mlx5_core_dev *dev)
 {
-	int err = 0;
-
 	if (!mlx5_core_is_ecpf(dev))
 		return 0;
 
 	/* ECPF shall enable HCA for peer PF in the same way a PF
 	 * does this for its VFs.
 	 */
-	err = mlx5_peer_pf_init(dev);
-	if (err)
-		return err;
-
-	return 0;
+	return mlx5_peer_pf_init(dev);
 }
 
 void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
-- 
2.26.2

