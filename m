Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A28168E510
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjBHAht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjBHAhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EA13EFE6
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AE1C60F96
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF62C433D2;
        Wed,  8 Feb 2023 00:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816647;
        bh=dxlopem3t9CqOUJEQgWPA/9gna3MU1fOeGgC6NMlWB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZlFycT+obFFenuFIcHyXDLXZm7PVNP4l/rE/b9trImWZz0qCV2ApCRWEIqftjsGg
         26PiNAF39oup6bKMvfp4zDmocR39xpXwDcdup+2RB+XtWD76BWxHMQxZ4T4nPDbEGx
         X+KGYO1GfUGEw7Fssgh5n3JnJazGfaMLVsu7F9ZpVeXuCSui99XmaCB4cx86+8LJVe
         2JK7OdFer3Ss0ypa2X/6AkzTmdEsI7xd36HHESCrzUaPDlYyNLnnNtsnVTkpskZDpM
         SGCumDiI7g77/mhNhLhrKzFTivFelXkhKBSqm9mcEL0CuOYYtZC+5rfj0fjuvfqXeK
         KVJ3xaW/QWXpQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 10/15] net/mlx5: fs_core, Remove redundant variable err
Date:   Tue,  7 Feb 2023 16:37:07 -0800
Message-Id: <20230208003712.68386-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Local variable "err" is not used so it is safe to remove.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index dd43a940499b..fad479df12e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1776,7 +1776,6 @@ static int build_match_list(struct match_list *match_head,
 {
 	struct rhlist_head *tmp, *list;
 	struct mlx5_flow_group *g;
-	int err = 0;
 
 	rcu_read_lock();
 	INIT_LIST_HEAD(&match_head->list);
@@ -1802,7 +1801,7 @@ static int build_match_list(struct match_list *match_head,
 		list_add_tail(&curr_match->list, &match_head->list);
 	}
 	rcu_read_unlock();
-	return err;
+	return 0;
 }
 
 static u64 matched_fgs_get_version(struct list_head *match_head)
-- 
2.39.1

