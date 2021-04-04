Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F18B35366B
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhDDEUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhDDEUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AEBF61382;
        Sun,  4 Apr 2021 04:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510008;
        bh=jh9ecoBWbfGruoYhec3WVW0s5anP9YPv42rgoRCO+dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rgkst4uporkG//JO5hXEWg13wgEfP4Cq0VZFMamCdnI9+sAIXJcTL0HqVulL21LaL
         lSzgnTH4ckdEDt2R71adIc5yjriilFGGPIexBnUcI19jFwN0zZ1wvxEQIn+HxUliis
         9V1iSSrxXNsa3Gr0yAYQwN9D/ZFTJY2UvWcPskInenWdV61bU+jUtkJuHB8bMq6/YO
         GXiO4x3NQiTxFDhmhtxZTkTw9Kk64zCP4UoJEtu/5xXK8fjdqD2VdJd65DLra3CvfT
         rU0i0L8rQtem3gy52PHQbJdOCR9Zz6TRbkA6keUvYuybis8NUymGgXIaXLIKKWsUY9
         lywo0g7Hl/Riw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/16] net/mlx5: Use unsigned int for free_count
Date:   Sat,  3 Apr 2021 21:19:42 -0700
Message-Id: <20210404041954.146958-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Fix the warning due to missing int.

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
+       unsigned free_count;

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index c0656d4782e1..110c0837f95b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -61,7 +61,7 @@ struct fw_page {
 	u32			function;
 	unsigned long		bitmask;
 	struct list_head	list;
-	unsigned		free_count;
+	unsigned int free_count;
 };
 
 enum {
-- 
2.30.2

