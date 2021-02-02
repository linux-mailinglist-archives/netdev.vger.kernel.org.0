Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3458B30B82D
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhBBG57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:57:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232289AbhBBG4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:56:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EDE164EEF;
        Tue,  2 Feb 2021 06:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248922;
        bh=zJQPTuDX9s9jI8uyIh77mqBhDKIKGCHGjobKb8LYnqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Czlvcp96UXLl03NjLKGkho1F0JRY8wLlzHBXI9M+7/iCOO/QpC4HcFxXN9EHKzJ5S
         c6ulh9L0JNBL7qD8NH4BldS1/tLK0lgJhzlWkpUvkOeuObPIFmAGCv+JQxZl4tYkpU
         AkcUzg5yWXdPUDi2i9rUf5lL+h4DlZnp3CkrgVqMK3APTzO/CXp+EY5wDsZbXE3xNE
         QvnV1uG5LUg5fWflbpfhNe48RmQbozAUEx0xt5xzrMGcRb4qmjsjXE7WqgTX25ekql
         tFn9NFfVNLpe/0SuZr33wgr9iZM6rtkFccotfrFEI1Eiv9t3IHajHgXOfp7htqiMb2
         opjtjwdvV/cIw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/14] net/mlx5e: accel, remove redundant space
Date:   Mon,  1 Feb 2021 22:54:55 -0800
Message-Id: <20210202065457.613312-13-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 6488098d2700..959bb6cd7203 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -85,7 +85,7 @@ mlx5e_tx_tunnel_accel(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg, u16 ih
 	}
 
 	mlx5e_set_eseg_swp(skb, eseg, &swp_spec);
-	if (skb_vlan_tag_present(skb) &&  ihs)
+	if (skb_vlan_tag_present(skb) && ihs)
 		mlx5e_eseg_swp_offsets_add_vlan(eseg);
 }
 
-- 
2.29.2

