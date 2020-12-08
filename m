Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F26B2D3356
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731396AbgLHUQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731145AbgLHUPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:15:07 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        YueHaibing <yuehaibing@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 11/15] net/mlx5e: Remove duplicated include
Date:   Tue,  8 Dec 2020 11:35:51 -0800
Message-Id: <20201208193555.674504-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 5c0015024f62..7f5851c61218 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -52,7 +52,6 @@
 #include "en/xsk/rx.h"
 #include "en/health.h"
 #include "en/params.h"
-#include "en/txrx.h"
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
-- 
2.26.2

