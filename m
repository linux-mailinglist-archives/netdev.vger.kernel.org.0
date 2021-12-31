Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C7B4822BA
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 09:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242779AbhLaIUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 03:20:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60648 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242662AbhLaIUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 03:20:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A3C6B81D56
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 08:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B49C36AF1;
        Fri, 31 Dec 2021 08:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640938844;
        bh=sWd6VEfWVGa96+06zdBg4L6QvtZRSlx4TwOcJ245Dfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADj7EUYwUhAGdZh5+P3l6mW7lTrPD4/UtXptZvp6bCcCH48jPZEz/J4Y61xOBqkQa
         7dwSf6xisCp1x7TNk6JVfL2BdH1H3lGD588VqupKJY5oBMv6c09cvzg9X3z/NHLjki
         nsibp4xBKECjUMWBUZfiNdKfATUlEc/xGvspZAk81GMVfWTgMhadgNDeA6uykR+3VZ
         YFhbNmO7ucs+R8wXTvwwZ99dCK8zulHhnq8bBQCALXuwpXNQ4qM41MZIXkX4txa8gR
         XX7l1iaS99lGr9oCJnEsxq08E7GKetpYpHYWkW36XccTN1k/YW6rTbj2P6djvPqMIX
         Gx+IE1rjAqjVg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 03/16] net/mlx5: DR, Remove unused struct member in matcher
Date:   Fri, 31 Dec 2021 00:20:25 -0800
Message-Id: <20211231082038.106490-4-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211231082038.106490-1-saeed@kernel.org>
References: <20211231082038.106490-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 2333c2439c28..75bfdd7890da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -886,7 +886,6 @@ struct mlx5dr_matcher {
 	struct mlx5dr_match_param mask;
 	u8 match_criteria;
 	refcount_t refcount;
-	struct mlx5dv_flow_matcher *dv_matcher;
 };
 
 struct mlx5dr_ste_action_modify_field {
-- 
2.33.1

