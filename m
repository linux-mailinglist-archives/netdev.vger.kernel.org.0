Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DAA59031C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237654AbiHKQTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbiHKQSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:18:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4B8C1E;
        Thu, 11 Aug 2022 09:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A00056133D;
        Thu, 11 Aug 2022 16:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E190BC433C1;
        Thu, 11 Aug 2022 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233628;
        bh=sFTFDibpydkF/MOnBN3M6xeEhb02hZQJCYZlhwBpMgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6snkc2FSJ/s3U6O0OR+fozzxnyKihZxc5tnqpaeOv35UnvW3eUIj8xJ+ksveGE/4
         8eQdoiJoy99rzN7sDzPp2rfLMCWLE5NuQnkZ3d0N7243vKDs1xO52Z650xm3DYGe+F
         sjXtXAPHXnrs2bp0WnASjWXUqQ9wYTyJAqHmsRDh50q7YapdiaMLLzUeNBlF/VOqvV
         rg/yYGXurXGoH4UARpzDLjXuO+ZcViIAfScnOqDEbkIoGDGQW2xB7Z4250BFSYU5rR
         O5hk03JA4m4iPJxsPiPP8EuoIqABTn9vc69VEY2iu3SHTkcvk9GS8Z3sGfAmxKJtDm
         Gg2SsXodkIf7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Cohen <amcohen@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, petrm@nvidia.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 35/69] mlxsw: cmd: Increase 'config_profile.flood_mode' length
Date:   Thu, 11 Aug 2022 11:55:44 -0400
Message-Id: <20220811155632.1536867-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 89df3c6261f271c550f120b5ccf4d9c5132e870c ]

Currently, the length of 'config_profile.flood_mode' is defined as 2
bits, while the correct length is 3 bits.

As preparation for unified bridge model, which will use the whole field
length, fix it and increase the field to the correct size.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 51b260d54237..0abd69040ba0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -745,7 +745,7 @@ MLXSW_ITEM32(cmd_mbox, config_profile, max_vid_flood_tables, 0x30, 8, 4);
  * max_fid_offset_flood_tables indicates the number of FID-offset tables.
  * max_fid_flood_tables indicates the number of per-FID tables.
  */
-MLXSW_ITEM32(cmd_mbox, config_profile, flood_mode, 0x30, 0, 2);
+MLXSW_ITEM32(cmd_mbox, config_profile, flood_mode, 0x30, 0, 3);
 
 /* cmd_mbox_config_profile_max_fid_offset_flood_tables
  * Maximum number of FID-offset flooding tables.
-- 
2.35.1

