Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535476C8916
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjCXXOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbjCXXOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:14:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E877F1CAC3
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEA6B62CEC
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 23:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BD0C433EF;
        Fri, 24 Mar 2023 23:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679699634;
        bh=ZwYT33oY2PZvcgl5ylgF7SWiHmoKxVBDCswn9s2tJt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXTBSZuM9IEbrF2WHSctqKk7V6UbslaLpiMaVPAG4OX+3sS94nYRSGqBHc1mhdqPf
         bQiQL9sB8BodF5RW4EGUARdvNzTlt8Wtgod55MYtgjEMFn+hQMxcMh0gn0sGVxbKMw
         xR+Tkwe7xi0pijlT+SfSN2PL55h+jEMffyL4dXuRpKXP0tWIgrCCzPMBmgfUPaEokR
         zwWb8hdAiXQ5XGWIYty1xnXac14ujEodi2tMwbx3+DvCpAywBOgtr8A9dTKXoZCaLT
         tfBCyIxblsAjk6a/VJQM2RXSlKx6HqCWaYMx46oSeq06+IPNJeTNktFc1xIIm+zapq
         s0HR8+2KCLaCA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eli Cohen <elic@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next V2 04/15] net/mlx5e: Coding style fix, add empty line
Date:   Fri, 24 Mar 2023 16:13:30 -0700
Message-Id: <20230324231341.29808-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324231341.29808-1-saeed@kernel.org>
References: <20230324231341.29808-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Add empty line between two function defnititions.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 38b32e98f3bd..b43121f64a80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -637,6 +637,7 @@ static u16 async_eq_depth_devlink_param_get(struct mlx5_core_dev *dev)
 	mlx5_core_dbg(dev, "Failed to get param. using default. err = %d\n", err);
 	return MLX5_NUM_ASYNC_EQE;
 }
+
 static int create_async_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-- 
2.39.2

