Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF8839ABA4
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFCUNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:13:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhFCUNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:13:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E82E561408;
        Thu,  3 Jun 2021 20:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622751122;
        bh=p2umgfitaKj7kQzJsvRiSicjwyWV7fgW7qjaRyHo8kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWDFnditDSoJy5v6cf+fG9bYmMx17DKeQUNDTDOo5/gELuGS8cG/GAqkbkoMdSuoz
         yItTtVfDU/KAmzmu75XYp6+sosxxvKngrsECohRRWYLN011g9rCnN5Qd1IxcSHNT1D
         ii2KX5COmOErqbHA6TMRpyTkiLGorEcmlFtBaO3KZpK4wPivlUhTKa9aHefAoSxPEG
         SIeBpA8ftq9ZjOyrFSw+/coQpkc/Moo37FH9rAMrUgPd0xQViC7BwEIH9EmJVB+Iwr
         lKOKyzpzbpvtXr33mEL8atoXbfQhnYrLh+gyLqImF7Ktj5abgTga02xOaq2kCZujwk
         nIRtdy1+2GS1Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Meir Lichtinger <meirl@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/10] net/mlx5e: IPoIB, Add support for NDR speed
Date:   Thu,  3 Jun 2021 13:11:50 -0700
Message-Id: <20210603201155.109184-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603201155.109184-1-saeed@kernel.org>
References: <20210603201155.109184-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meir Lichtinger <meirl@nvidia.com>

Add NDR IB PTYS coding and NDR speed 100GHz.

Fixes: 235b6ac30695 ("RDMA/ipoib: Add 50Gb and 100Gb link speeds to ethtool")
Signed-off-by: Meir Lichtinger <meirl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 97d96fc38a65..0e487ec57d5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -150,6 +150,7 @@ enum mlx5_ptys_rate {
 	MLX5_PTYS_RATE_FDR	= 1 << 4,
 	MLX5_PTYS_RATE_EDR	= 1 << 5,
 	MLX5_PTYS_RATE_HDR	= 1 << 6,
+	MLX5_PTYS_RATE_NDR	= 1 << 7,
 };
 
 static inline int mlx5_ptys_rate_enum_to_int(enum mlx5_ptys_rate rate)
@@ -162,6 +163,7 @@ static inline int mlx5_ptys_rate_enum_to_int(enum mlx5_ptys_rate rate)
 	case MLX5_PTYS_RATE_FDR:   return 14000;
 	case MLX5_PTYS_RATE_EDR:   return 25000;
 	case MLX5_PTYS_RATE_HDR:   return 50000;
+	case MLX5_PTYS_RATE_NDR:   return 100000;
 	default:		   return -1;
 	}
 }
-- 
2.31.1

