Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A973935AB
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhE0S6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235820AbhE0S6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10BEF610CB;
        Thu, 27 May 2021 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141795;
        bh=RL1HbuKRNBc4GQPJwtkbR+rG748OFg1tPDpJl1CSsOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jI9Afot29geYTYSzhdM4toncqWp3eoFR21eaX+PANEonM50tZsYumSqRoM9zIi2d2
         bm3QIF1yKdVSYBR1tJFJZHG4XjO0E5BYIY2L7goFyhs5umBxmWGocv0Y04c0vGmz7g
         M+kkCoEa4G1ZKVvuyE7wXkbEAjjlHzeL2LZbwhWgYGpztoyo+gnDv/SWAokHTJrbE/
         QIl0P2QSJj2eNIKuOc4Q4cDx4O64p5mtuLeTQ1DpNzLlSpkgBNR8EgQRpL5WUSgvE1
         TkhnR/EUkoYc+hLtHv5LgvEVxtmkW5hcL7wxurHrt1FUyF9xWEr23r4H6B4v9J+qbK
         FqbNvWy22lCXQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 01/15] net/mlx5e: CT, Remove newline from ct_dbg call
Date:   Thu, 27 May 2021 11:56:10 -0700
Message-Id: <20210527185624.694304-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527185624.694304-1-saeed@kernel.org>
References: <20210527185624.694304-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

ct_dbg() already adds a newline.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 5da5e5323a44..edf19f1c19ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -918,7 +918,7 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	}
 
 	if (rev_entry && refcount_inc_not_zero(&rev_entry->counter->refcount)) {
-		ct_dbg("Using shared counter entry=0x%p rev=0x%p\n", entry, rev_entry);
+		ct_dbg("Using shared counter entry=0x%p rev=0x%p", entry, rev_entry);
 		shared_counter = rev_entry->counter;
 		spin_unlock_bh(&ct_priv->ht_lock);
 
-- 
2.31.1

