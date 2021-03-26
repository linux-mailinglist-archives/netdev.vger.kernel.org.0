Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC1034A002
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhCZCy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231179AbhCZCxz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1015461A43;
        Fri, 26 Mar 2021 02:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616727235;
        bh=HE/QZFdqS671tqHl5nlwxCKvdp++TU0y/bfIoDjsvEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trr0TvGlOzyNxlhG8KvjcnUb5dr2lsou5ljmCfp/YUEDww8ErYJoW0kP/+5C7avdN
         nLuQ6aoIx2EdqVYEqIWdrt/RQeTZPq0FOp2bxFdZbibOEaz+XuO4EldpkitfQ1d4eq
         446XnQyqK9u5b4olqFf8i52jFdCUnqIV8hragGeUaIjfKX39NyqQAUznvCyk8b5SZr
         PvvqzN/JNC4rIL6MwzmZq5u5S4TdZyrqmwQY3CPAZ6uCmzEQPB1DKnbORmoD7Fgsyb
         7AaTbwY9ixboW+p9xxmG5WKBL8D7hhx/uWIzd2kB314DYkLJNH2qw5NHGGENM7vGue
         BFU3Vwi2l+29g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 13/13] net/mlx5: Fix spelling mistakes in mlx5_core_info message
Date:   Thu, 25 Mar 2021 19:53:45 -0700
Message-Id: <20210326025345.456475-14-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326025345.456475-1-saeed@kernel.org>
References: <20210326025345.456475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two spelling mistakes in a mlx5_core_info message. Fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index a0a851640804..9ff163c5bcde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -340,7 +340,7 @@ static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
 		return -EIO;
 	}
 
-	mlx5_core_info(dev, "health revovery succeded\n");
+	mlx5_core_info(dev, "health recovery succeeded\n");
 	return 0;
 }
 
-- 
2.30.2

