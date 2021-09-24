Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E35417B43
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239330AbhIXStw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236323AbhIXStu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4634861261;
        Fri, 24 Sep 2021 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509297;
        bh=jVKvImGC3RcNvbWbNANJAFracW7rf6pfiQyuoXvr/Ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/2MtJsm68d9hZCZGd0pL3KUcQ9s33fl1NVnPiOENcKKVfcFDuP/0PRacbIYaru8T
         FA+vdYwtDl+hmYTI68w4mY5zA2k7tlHxP7sFSSjM7VzUr+wp6bWL0Iy4z9kn6+RMRP
         Z+ILOo3V6gjhYYgrtnmt5xA78XO0rErxKekhpxkUaE4fgdcTY4dxv8grSFB/WHZKBn
         rfda+6MS58K1447I0b5/v0ErPV/4a0fqh881ubQbn5aNkyEZ8a/nZaA/nhxEmJXf0c
         MERiPQjp9ogB1AKG26byp8dVpKSu8Yfrr6fnhaHNKWQajf1zD2lWc3z7rm5z8d80Gk
         pys0FxFApHdPQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/12] net/mlx5: DR, Fix code indentation in dr_ste_v1
Date:   Fri, 24 Sep 2021 11:47:57 -0700
Message-Id: <20210924184808.796968-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index b2481c99da79..33e6299026f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1791,7 +1791,7 @@ static int dr_ste_v1_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 		else
 			return -EINVAL;
 
-		 misc->source_eswitch_owner_vhca_id = 0;
+		misc->source_eswitch_owner_vhca_id = 0;
 	} else {
 		caps = &dmn->info.caps;
 	}
-- 
2.31.1

