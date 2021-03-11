Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DE3336CEA
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhCKHKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:10:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231959AbhCKHJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:09:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F3066501D;
        Thu, 11 Mar 2021 07:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615446579;
        bh=Xm9xbUhHIhf+RmdaKGMVIgr+4TGOVDiIsRbMIzxu0uU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qgXNKflKCjR6jVEbzqx8zCCqmM+qN1vke6oHAE4m+aXfJq6atlX/2F4iPZ7zAdqBw
         oi29c4fL1nLgz1/1ojsEDix7a+Ep7Yy9gec5dWRj7fD45d4L76o4sZwpAlsIaSuC2d
         RHyl3A1BQepPifXXVAuKeZdxtnHEkJZbatetX7X68Zi0M3hTpqd/whZpjm/WgiyyUY
         kXSe3TdakIRy1mCAxH1A0a2Mm3RBPJOhdvLdRLdduCrbDIoIx+EIo/ghhScmIt7LY8
         TDOjB3JPRCMJeFeR6rrEfFOdarAYWwPEpumFdBZkZF3GVy2Hgq+9FIKWjGXrzhotKy
         TGkNi7aK/KPbQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 1/9] net/mlx5: Cleanup prototype warning
Date:   Wed, 10 Mar 2021 23:09:07 -0800
Message-Id: <20210311070915.321814-2-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311070915.321814-1-saeed@kernel.org>
References: <20210311070915.321814-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Cleanup W=1 warning:

drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c:49:
   warning: expecting prototype for Set lag port affinity().
   Prototype was for mlx5_lag_set_port_affinity() instead

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 88e58ac902de..2c41a6920264 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -35,7 +35,7 @@ bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev)
 }
 
 /**
- * Set lag port affinity
+ * mlx5_lag_set_port_affinity
  *
  * @ldev: lag device
  * @port:
-- 
2.29.2

