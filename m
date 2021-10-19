Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21FE432C34
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhJSDXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232203AbhJSDXJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40F1F6128B;
        Tue, 19 Oct 2021 03:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613655;
        bh=aKmbOMlBaPj1Km0LfLYHb10PwntlbzFE7KkUixm5sag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIehChKS+xdrCyBy6CYxAe1RLI/wZ9KuZdPwY3Gt0gLfw69y7kNVhwt8b40dkXsFL
         rlerA80OkT/jhNPGPTnHm4g0TYXEpT11ZTrzuHEoAVZn+adc0vjpjoKUYQoZ+85QmO
         UW0lSx0JD/3LZXw+0onNw4PD9iUZEcn9bDai95zPsnZ5pQoOShKqQc/HJj0Ur939hU
         MYf+xhGtMLmUrbajDjn8CmBJ4TZQCxswjmBzgcyITePrJhweHP41UQwjG6vu+U6ELu
         Km3NCM6ZPo5Rym5Hs3kUJio3IOtPHc0ATOQ1En2DbdePI4SpWBlnhFPueO1SqKqBLp
         zbvsxBbHMepNw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/13] net/mlx5: E-Switch, Increase supported number of forward destinations to 32
Date:   Mon, 18 Oct 2021 20:20:47 -0700
Message-Id: <20211019032047.55660-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Increase supported number of forward destinations in the same rule, local
and remote, from 2 to 32.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 7461aafb321e..28467f11f04b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -433,7 +433,7 @@ enum mlx5_flow_match_level {
 };
 
 /* current maximum for flow based vport multicasting */
-#define MLX5_MAX_FLOW_FWD_VPORTS 2
+#define MLX5_MAX_FLOW_FWD_VPORTS 32
 
 enum {
 	MLX5_ESW_DEST_ENCAP         = BIT(0),
-- 
2.31.1

