Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0788259045C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238777AbiHKQhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239220AbiHKQgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:36:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9AA8982F;
        Thu, 11 Aug 2022 09:11:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 668D561481;
        Thu, 11 Aug 2022 16:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CD2C43470;
        Thu, 11 Aug 2022 16:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234314;
        bh=7ZBP70SIkwcvnNZY9xJxWBSIaZ1GuXGG5/2WtJDY+g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOIzmp5mla2PepHi5DlJguDtJmmPcWGSzdOQ4BI/Fc0X1vroDo/RMaha2XRYIB0vd
         yG6hOCgxRQoNYYzy1wBkI/WzLf7BUaXVUEG7Tb7P/+SpeZd6rywv8yAzuw2Csmjaz5
         GE5DlIysI/9D1WWWcifg/5lI2aBWua1XncY3e/RklXvWaqW7uhXuT1j4z6nRinuXUN
         pWCaIEMwInm+cb4lZLvxEICqVRavMNYswbtb4UXrpRFWWPAWwAKcYpXwvyzdD2fAHk
         gH4G5oaK1Gos/sviDfX3NwwUppCQsd16p8elzzn+grC4kS6BAjcvAKYmCHRzWx7atr
         8OEYC3LVawPBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Cohen <amcohen@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, petrm@nvidia.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/12] mlxsw: cmd: Increase 'config_profile.flood_mode' length
Date:   Thu, 11 Aug 2022 12:11:31 -0400
Message-Id: <20220811161144.1543598-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811161144.1543598-1-sashal@kernel.org>
References: <20220811161144.1543598-1-sashal@kernel.org>
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
index 28271bedd957..f126050389ee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -722,7 +722,7 @@ MLXSW_ITEM32(cmd_mbox, config_profile, max_vid_flood_tables, 0x30, 8, 4);
  * max_fid_offset_flood_tables indicates the number of FID-offset tables.
  * max_fid_flood_tables indicates the number of per-FID tables.
  */
-MLXSW_ITEM32(cmd_mbox, config_profile, flood_mode, 0x30, 0, 2);
+MLXSW_ITEM32(cmd_mbox, config_profile, flood_mode, 0x30, 0, 3);
 
 /* cmd_mbox_config_profile_max_fid_offset_flood_tables
  * Maximum number of FID-offset flooding tables.
-- 
2.35.1

