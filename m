Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C223216EAC6
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731024AbgBYQDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:03:54 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33177 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730872AbgBYQDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 11:03:53 -0500
Received: by mail-pl1-f193.google.com with SMTP id ay11so5678592plb.0
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 08:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SVTHmskfptTcx6L5z+RLvaUmHHGKce2hgDNK+livW10=;
        b=XhWc7B1yMAmVk5MuNFLHxyxqbZUzfUyyKwU/IEWtK+e/pETggi22vYBadzRdWji/ud
         st8kbIAZy6OqAK8W3YzhloOwr2qb1TN4AuAhrzD+hsDsCbHW+ZT3iusz2IwicZlushnL
         d4+PlFeAtEWVxDFrY6it9GeL1lPrC8pdNTIj8ZYOj1dqFasPx8d/lJaEa+tFK0DIwGpQ
         /ZErVfz7uyoJbcA5mmbIokw/QPdGop7fjIRb+3yghihqb+jUZoueNJvz5d4lioTTdAPC
         yEOM4q8MveMuKzgnVbE3Z0prLCSO0cw7X7UJz8HSUKWw4LwByCgknLvaHh23yyQZrp2l
         /FIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SVTHmskfptTcx6L5z+RLvaUmHHGKce2hgDNK+livW10=;
        b=BvG5OX615b2DEyBDFSJyMgJ6mam3zV/WbwXPkdJMs9rZSjNxEL1WdyT7HZO4QL2GaP
         Fm06xY8vOqhL1q4ANWOUyIrbgpS1piMwtfTdhM7R9hy8SkSCOU3cBCo6XEW0fuG6GVLd
         JWWdg5ygw6ElxGKuEsRYJJTXGbU0HDH59oonJiQGU2Gbyz8uZ8RQXZn6blotZvig7Wc8
         SXOsLlX4HzVhqWCJuylV0k1TtRWGkO2BfI9rZChx4DoJjU3s80aWCfgvY1zntdyH1fTp
         4HIfv8TO3Hq2LgPiiDLkIWyeIkgHkaKnMAJeR6Sh3cEZB9izhaldvaeYnT57oN3+zOkr
         qXoQ==
X-Gm-Message-State: APjAAAVCbTQ2QY44zwahHHophOoLh0uhGKd5lIgekDN2UU5GC2D2W4Xu
        aMdjMQHUkebqr4Uop/v9UIE=
X-Google-Smtp-Source: APXvYqy2f0WpeRZJ4+BI5k7AyVxogxgyGByYad+cZhXkEHaPghgXAsd1v5LxvbywLsbb2rc6TPqpSQ==
X-Received: by 2002:a17:90a:b106:: with SMTP id z6mr6048130pjq.91.1582646633013;
        Tue, 25 Feb 2020 08:03:53 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([219.143.129.147])
        by smtp.gmail.com with ESMTPSA id b24sm17366568pfo.84.2020.02.25.08.03.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 08:03:52 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     gerlitz.or@gmail.com, roid@mellanox.com, saeedm@dev.mellanox.co.il
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [net-next] net/mlx5e: Remove the unnecessary parameter
Date:   Wed, 26 Feb 2020 00:03:08 +0800
Message-Id: <1582646588-91471-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The parameter desired_size is always 0, and there is only one
function calling the mlx5_esw_chains_get_avail_sz_from_pool.
Deleting the parameter desired_size.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index c5a446e..ce5b7e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -134,19 +134,14 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
 	return FDB_TC_LEVELS_PER_PRIO;
 }
 
-#define POOL_NEXT_SIZE 0
 static int
-mlx5_esw_chains_get_avail_sz_from_pool(struct mlx5_eswitch *esw,
-				       int desired_size)
+mlx5_esw_chains_get_avail_sz_from_pool(struct mlx5_eswitch *esw)
 {
 	int i, found_i = -1;
 
 	for (i = ARRAY_SIZE(ESW_POOLS) - 1; i >= 0; i--) {
-		if (fdb_pool_left(esw)[i] && ESW_POOLS[i] > desired_size) {
+		if (fdb_pool_left(esw)[i])
 			found_i = i;
-			if (desired_size != POOL_NEXT_SIZE)
-				break;
-		}
 	}
 
 	if (found_i != -1) {
@@ -198,7 +193,7 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
 		ft_attr.flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
 				  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 
-	sz = mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);
+	sz = mlx5_esw_chains_get_avail_sz_from_pool(esw);
 	if (!sz)
 		return ERR_PTR(-ENOSPC);
 	ft_attr.max_fte = sz;
-- 
1.8.3.1

