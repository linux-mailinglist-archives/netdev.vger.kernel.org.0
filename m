Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B89141E4B7
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350378AbhI3XWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348976AbhI3XWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 808E561A3D;
        Thu, 30 Sep 2021 23:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044057;
        bh=SPNtdrYxmAyTFEjPqKpP0PTZthMZMaWxlxULeKwkeaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5GYV9kSjYh5hidvzFakgCsJjXG2cLbRA2n3i/i3JpOrk+hdcP3jJYV4YqKMLgWn7
         BDiOPt8ubdowYm6pHlSiQhC+v1rXp6YIz2M48CyGP+6rI7lhEXK9u9tzYV65ONNH4s
         4zMu5lrzns+KDqFHrlJ1eeBwUgptOkkOs/sZ9QkBWIul75bO4Bd4flx54PLvVS+WY3
         sgpw6o71rmzonl7PwDenVwZSNngFKBmaUATNuD9rZuD3hoJmK2vjMxXae7+U6rR4Tg
         R3bW0TUSGjFuSoVqxc+xnbigyTADOyp4CiU6fBYhETx5gOMEsdg5ydHfVo6c7MIcD6
         n1of1Ak4cvDqg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5: DR, Fix typo 'offeset' to 'offset'
Date:   Thu, 30 Sep 2021 16:20:43 -0700
Message-Id: <20210930232050.41779-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 0179d386ee48..00199b3eae6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -632,7 +632,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			return -EOPNOTSUPP;
 		case DR_ACTION_TYP_CTR:
 			attr.ctr_id = action->ctr->ctr_id +
-				action->ctr->offeset;
+				action->ctr->offset;
 			break;
 		case DR_ACTION_TYP_TAG:
 			attr.flow_tag = action->flow_tag->flow_tag;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 01787b9d5a57..73fed94af09a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -941,7 +941,7 @@ struct mlx5dr_action_dest_tbl {
 
 struct mlx5dr_action_ctr {
 	u32 ctr_id;
-	u32 offeset;
+	u32 offset;
 };
 
 struct mlx5dr_action_vport {
-- 
2.31.1

