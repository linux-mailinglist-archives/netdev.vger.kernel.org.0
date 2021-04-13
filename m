Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387CD35E71C
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348123AbhDMTb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346495AbhDMTa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FAD8613CE;
        Tue, 13 Apr 2021 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342237;
        bh=p3uO0guYgeQkCCSe2nsrxiDdg7AFwZrwRF0wYByzg3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+P5KjPwdCAMfv0+2ZM9Kh05QUpGndhOFuQleXbsruT34jriI3a0z6LUXzpCGHIBP
         DvHa008Q/7jW12Vxs6iuG5thppj0BwHqS+S5sG/epnq3KgARXl8nXerWUYUL/Yu9Gi
         tqwaskttQz9bMYVjRHwrhQ9MrM1Rqaj3so32s459iN5bL/3ElltqqinY3ZLpia0OW2
         LbTF0IrVDY6iamFk1t5q8KKDCyj/+WHYOztmqCHcs3+6hha+cf5S/fjciJaZ//aJzH
         EoMOVf36GkjM6aM8tR6Andy09t3VA5WXyku2eA4GvvBb9g7bQ7cpNZE5QMNop29TD/
         1ePRckg/SugtA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/16] net/mlx5: Replace spaces with tab at the start of a line
Date:   Tue, 13 Apr 2021 12:30:05 -0700
Message-Id: <20210413193006.21650-16-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
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

