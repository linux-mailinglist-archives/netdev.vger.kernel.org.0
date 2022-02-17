Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F574B9A46
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbiBQH4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:56:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236737AbiBQH4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F9465B9
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A07B761AA8
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF116C340ED;
        Thu, 17 Feb 2022 07:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084595;
        bh=2vgij5LG+rBqw+jCr1fAT1/vrtscYTVH2r0TSQoRAv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8m4G0C712wwlXFrZhFjtJTXM0px+DWI7QyjiWrvPzL/8HzTCV/YOqV0oPz4baq4L
         ks99nqfgARs5BZR+TUmr2Mn3GNlfmR27RO20a2I0N+k7EwPXUX8Hg3pZKVtiC+Iju4
         Zj5rhVILZkaxE+a/gT9TBYa65ut2pe61sLKBVhd4sQRIVnwHab8R4Fr5CN/FBIBWrW
         RaCoAaOTVZFoDxqLLoONAwiRBPb2/TXP07tsF8aGTZeS1jFVwUYlVIVoJanXs3AMSu
         wFea1RZZsQsu7GzQpO4BRGLm/QDXOYDJ4FwFOsjvl9S2YfQXa7uhTciLqCLAl0Ekpy
         IClJRCRWzKDLQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Fix spelling mistake "supoported" -> "supported"
Date:   Wed, 16 Feb 2022 23:56:18 -0800
Message-Id: <20220217075632.831542-2-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217075632.831542-1-saeed@kernel.org>
References: <20220217075632.831542-1-saeed@kernel.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

There is a spelling mistake in a NL_SET_ERR_MSG_MOD error
message.  Fix it.

Fixes: 3b49a7edec1d ("net/mlx5e: TC, Reject rules with multiple CT actions")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index 85f0cb88127f..9fb1a9a8bc02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -21,7 +21,7 @@ tc_act_can_offload_ct(struct mlx5e_tc_act_parse_state *parse_state,
 	}
 
 	if (parse_state->ct && !clear_action) {
-		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supoported");
+		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supported");
 		return false;
 	}
 
-- 
2.34.1

