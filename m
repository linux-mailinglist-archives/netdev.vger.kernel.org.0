Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2B92F28BC
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391887AbhALHOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:14:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391826AbhALHOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:14:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FEEF22CB2;
        Tue, 12 Jan 2021 07:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435623;
        bh=DIYi1pTi4ziIO3htASEwKM7n+G9PhZdNTtI7pRdFk0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXSv3k+nOqlH1kre2I9AA6eSZZP+fgPbmtbkJp4IUb1tBTCV0v2nVaJm+MbgwOg8i
         +0jkOEz0HscyfHS/BMLxxzACi9+vAIXH0NdXyl0XyhLgx/VISBOukRqc7eml3KiXl3
         rZJ/AmhZyGiGWHkIUy7DXzpEcVgtA1Ow/lHXuujPP9wrkoNzdxOJSRjLmiDAZfQxbe
         aR2LZYWJ2BOB9M9HBog9+uzrnfdpj3vn2QkFWmkamf+R44tUD8SrmMlVy7XeJ4CMVg
         cbQHSjlki3M6SxSazXMXga3B+0vUf98E764tyTM0IoWS0iHLXTcgfv+xZXJIixwWX8
         3Ohe1xnm4SnbQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 01/11] net/mlx5: Add HW definition of reg_c_preserve
Date:   Mon, 11 Jan 2021 23:05:24 -0800
Message-Id: <20210112070534.136841-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
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
index 442c0160caab..823411e288c0 100644
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
 	u8         reserved_at_b0[0x1];
 	u8         uplink_follow[0x1];
-- 
2.26.2

