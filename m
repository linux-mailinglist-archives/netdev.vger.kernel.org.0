Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D2C2EED0C
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbhAHFbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbhAHFbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:31:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5480233FC;
        Fri,  8 Jan 2021 05:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083857;
        bh=pMgOJOYy0PZ/+2EahATIrfbrm0OG5TontQ7SQUkPMDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SumcxvvRI6q+iMFM5A52oaDQW+xCC4t/UJs/M0UnNzoHRvyJLThs/5jfGuIWKajRW
         LHcL4cdfQIoT7412Q6SaXrOIoIy6du4Zl2YsWdQv7f4RYADXbu8yMKX6kUuJJBkQWV
         +DyXzjAgHmfwM5l6zy39CS5oLc6ephbCxllLO1zcuDdbquEf1zCG6Yqne/THdxA/3B
         vwsggP/QfQ4TOVEwupjKBUj9bDxFwUFE01LbbYfKVDAi0mQAMuIwQBid8ZYgZdYX8s
         pXDyX3zLwkXZ+7AKf8RddPtY1PzmgQ9DewB/8wD0QIHwTZIpyRHg3G3LhYEDnpkMTU
         G+ONkZogH7Oeg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Add HW definition of reg_c_preserve
Date:   Thu,  7 Jan 2021 21:30:40 -0800
Message-Id: <20210108053054.660499-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Add capability bit to test whether reg_c value is preserved on
recirculation.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8fbddec26eb8..ec0d01e26b3e 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1278,7 +1278,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_a0[0x3];
 	u8	   ece_support[0x1];
-	u8	   reserved_at_a4[0x7];
+	u8	   reserved_at_a4[0x5];
+	u8         reg_c_preserve[0x1];
+	u8         reserved_at_aa[0x1];
 	u8         log_max_srq[0x5];
 	u8         reserved_at_b0[0x2];
 	u8         ts_cqe_to_dest_cqn[0x1];
-- 
2.26.2

