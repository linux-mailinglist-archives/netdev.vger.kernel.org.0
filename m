Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACEC4822BB
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 09:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242793AbhLaIUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 03:20:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60642 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241159AbhLaIUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 03:20:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98571B81D5D
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 08:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B80BC36AF0;
        Fri, 31 Dec 2021 08:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640938844;
        bh=X6VrIesI/m4GqoJwzmr8n8ZYIUGOVIwA/EX93ACkTpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/YTcVlT0tbi7yzpqWmY9H64xwmnfXMcVSRMSrlebJ5eO2/xnf3LtwVMEPPEyt+FV
         BYH9V5ODD/Eajdz2zMGKKg0Ux6ozIHYpO4wOpU5NU7iAzWM1VWHPf4W4RQKttgA1hJ
         Lq7ZNYL7jpSc9QN6otVNoLeh2qKMs+YJB6i2QsFJTX/Ttp56BzByo4hunRkWgO7p5d
         LCumJGvjuIIwFodYVmxITwd4ps/t+u5p1MC2cmd0SGnHXZ/CEC4FRj+8uwlRx2rA8v
         /w2+PNFtIcjqZ0RUbzl1GWK/O7ZiUxLJ46gGPnUlnDGe4WLgUwFRqkagRNpNdESmQ+
         aKXWgJ6s73n3A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 02/16] net/mlx5: DR, Fix lower case macro prefix "mlx5_" to "MLX5_"
Date:   Fri, 31 Dec 2021 00:20:24 -0800
Message-Id: <20211231082038.106490-3-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211231082038.106490-1-saeed@kernel.org>
References: <20211231082038.106490-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Macros prefix should be capital letters - fix the prefix in
mlx5_FLEX_PARSER_MPLS_OVER_UDP_ENABLED.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c     | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c | 2 +-
 include/linux/mlx5/mlx5_ifc.h                                 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 1d8febed0d76..0d7575b64ca4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -152,7 +152,7 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 		caps->flex_parser_id_mpls_over_gre =
 			MLX5_CAP_GEN(mdev, flex_parser_id_outer_first_mpls_over_gre);
 
-	if (caps->flex_protocols & mlx5_FLEX_PARSER_MPLS_OVER_UDP_ENABLED)
+	if (caps->flex_protocols & MLX5_FLEX_PARSER_MPLS_OVER_UDP_ENABLED)
 		caps->flex_parser_id_mpls_over_udp =
 			MLX5_CAP_GEN(mdev, flex_parser_id_outer_first_mpls_over_udp_label);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 3d0cdc36a91a..613074d50212 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -359,7 +359,7 @@ static bool dr_mask_is_tnl_mpls_over_gre(struct mlx5dr_match_param *mask,
 
 static int dr_matcher_supp_tnl_mpls_over_udp(struct mlx5dr_cmd_caps *caps)
 {
-	return caps->flex_protocols & mlx5_FLEX_PARSER_MPLS_OVER_UDP_ENABLED;
+	return caps->flex_protocols & MLX5_FLEX_PARSER_MPLS_OVER_UDP_ENABLED;
 }
 
 static bool dr_mask_is_tnl_mpls_over_udp(struct mlx5dr_match_param *mask,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e9db12aae8f9..18b816b41545 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1291,7 +1291,7 @@ enum {
 enum {
 	MLX5_FLEX_PARSER_GENEVE_ENABLED		= 1 << 3,
 	MLX5_FLEX_PARSER_MPLS_OVER_GRE_ENABLED	= 1 << 4,
-	mlx5_FLEX_PARSER_MPLS_OVER_UDP_ENABLED	= 1 << 5,
+	MLX5_FLEX_PARSER_MPLS_OVER_UDP_ENABLED	= 1 << 5,
 	MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED	= 1 << 7,
 	MLX5_FLEX_PARSER_ICMP_V4_ENABLED	= 1 << 8,
 	MLX5_FLEX_PARSER_ICMP_V6_ENABLED	= 1 << 9,
-- 
2.33.1

