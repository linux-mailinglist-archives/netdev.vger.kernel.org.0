Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761F652B2BD
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiERGuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbiERGuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25AC23160
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 479B960B8C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB14C385A5;
        Wed, 18 May 2022 06:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856596;
        bh=etAxJjs+MyxqUTjpS5KDXkV+0D/Z0bKShw7piMYrWHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtX5E2DaOvj9TsAQEzjo6hy6EsC0+TNNCXIO4NWIPcIHBDT32+dN4aTn0YwzMGkdL
         RD0N9AiwKptUrjqcY8tl1xBI9NcpYoXzEGlWV9sIj/o+CpWlR1ONZtqaNiilPVQLih
         VuNpd8H6a2/pCHskR4isTRw8dGFv0o5SRsWnuKwLPJg3VjjMSVwpwy5u10YdWbTpyU
         XiyKMlU3t2Zb60GB1hG042UZZAkBEi4W5zUvB7SUPHoEj6EnxZnfqxAnOqQ1wja8Gc
         Fe4x9D6X4IQ5yU81jVW6xvt+Yl2x6kTpt8aU+I3daxW3jhof+aRadDsTyuB8mtjrWn
         Fpq09fDXUeuTA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/16] net/mlx5: Remove unused argument
Date:   Tue, 17 May 2022 23:49:37 -0700
Message-Id: <20220518064938.128220-16-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Argument ndev is not used in mlx5_handle_changeupper_event()
Remove it.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 3eb195cba205..5c3900586d23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -850,7 +850,6 @@ static void mlx5_do_bond_work(struct work_struct *work)
 
 static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 					 struct lag_tracker *tracker,
-					 struct net_device *ndev,
 					 struct netdev_notifier_changeupper_info *info)
 {
 	struct net_device *upper = info->upper_dev, *ndev_tmp;
@@ -1006,8 +1005,7 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 
 	switch (event) {
 	case NETDEV_CHANGEUPPER:
-		changed = mlx5_handle_changeupper_event(ldev, &tracker, ndev,
-							ptr);
+		changed = mlx5_handle_changeupper_event(ldev, &tracker, ptr);
 		break;
 	case NETDEV_CHANGELOWERSTATE:
 		changed = mlx5_handle_changelowerstate_event(ldev, &tracker,
-- 
2.36.1

