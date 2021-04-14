Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E2B35FA4C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352037AbhDNSHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352042AbhDNSGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 897B661222;
        Wed, 14 Apr 2021 18:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423580;
        bh=p3uO0guYgeQkCCSe2nsrxiDdg7AFwZrwRF0wYByzg3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoT9vCrY1S2wsZCULb8CCjhNMUi//vux85snkRb6DGPPxVXluzia3Pdedyi2wEzOV
         OfPDx8DptoGre0JDkgxm5pKq4F0rMNmKZQ5q721Xcv51npAo17oIqnu/qjqvXGkf0M
         g6y/R1QsDqzou9hdw38JgoRiPfWP/dG1TXePWHnmXrmzXaH18+ltvJxF5PXHklAxnJ
         xkTJipXukOtbthRKX9wH+8vH52dAeogbXs/vdVe0tXu6qym0LP8q8wVwgMREceK4cI
         SV55l3axMrb67TiGa7xg2Kd+DSnklxbFIdle4KznXo2ND6jLMUvZpxEsdKTGX1iiNU
         6UgmF5t08+oiA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 15/16] net/mlx5: Replace spaces with tab at the start of a line
Date:   Wed, 14 Apr 2021 11:06:04 -0700
Message-Id: <20210414180605.111070-16-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414180605.111070-1-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

There should be no spaces at the start of the line.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index e58ef8c713e4..34eb1118670f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -52,7 +52,7 @@
 #include "diag/en_rep_tracepoint.h"
 
 #define MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE \
-        max(0x7, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE)
+	max(0x7, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE)
 #define MLX5E_REP_PARAMS_DEF_NUM_CHANNELS 1
 
 static const char mlx5e_rep_driver_name[] = "mlx5e_rep";
-- 
2.30.2

