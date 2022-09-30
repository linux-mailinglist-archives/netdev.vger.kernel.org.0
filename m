Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF5E5F0D6D
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbiI3OWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiI3OVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661FF1A1EBE
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0B9B62360
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A849DC43470;
        Fri, 30 Sep 2022 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547686;
        bh=hhhGQBgIalvklCK2+Veytlv4/a8IIYlKHN1I0KU0mNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afvh2MpTskPHbqtp1K7oBFmIqNVp4B96839qjfnRw6fgzRD6glK/VHYXFH1YFQ2XP
         PhKKUziuBO6OcEtOEF6n1vCTsRsRvsM1tTF36u54wEDPuBO4fQHcLxq2P5GvMFbDxn
         WGXCJQZmU72WxeXXoa7IxUD3sKxNC5HO1t6tniYWpsa8YBWW1oR1ARbOuzQ29eNoIR
         L2NTkPOb5exrj+FFdsLOuuL+GCdjkhThgk8lBB29p4Mw6FsVjNSqGSxyqaspnz83ip
         o3rnW9efAwdMOBa3d4Mg7e2H/akwf4QZ4YjufG7SHfESBRaBINIuyBdnKAS96RvwcI
         nvrXDc9QWrcOg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 06/12] net: phy: marvell10g: Use tabs instead of spaces for indentation
Date:   Fri, 30 Sep 2022 16:21:04 +0200
Message-Id: <20220930142110.15372-7-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930142110.15372-1-kabel@kernel.org>
References: <20220930142110.15372-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some register definitions were defined with spaces used for indentation.
Change them to tabs.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 05a5ed089965..06d0fe4b76c3 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -117,16 +117,16 @@ enum {
 	MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN	= 0x5,
 	MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH	= 0x6,
 	MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII			= 0x7,
-	MV_V2_PORT_INTR_STS     = 0xf040,
-	MV_V2_PORT_INTR_MASK    = 0xf043,
-	MV_V2_PORT_INTR_STS_WOL_EN      = BIT(8),
-	MV_V2_MAGIC_PKT_WORD0   = 0xf06b,
-	MV_V2_MAGIC_PKT_WORD1   = 0xf06c,
-	MV_V2_MAGIC_PKT_WORD2   = 0xf06d,
+	MV_V2_PORT_INTR_STS		= 0xf040,
+	MV_V2_PORT_INTR_MASK		= 0xf043,
+	MV_V2_PORT_INTR_STS_WOL_EN	= BIT(8),
+	MV_V2_MAGIC_PKT_WORD0		= 0xf06b,
+	MV_V2_MAGIC_PKT_WORD1		= 0xf06c,
+	MV_V2_MAGIC_PKT_WORD2		= 0xf06d,
 	/* Wake on LAN registers */
-	MV_V2_WOL_CTRL          = 0xf06e,
-	MV_V2_WOL_CTRL_CLEAR_STS        = BIT(15),
-	MV_V2_WOL_CTRL_MAGIC_PKT_EN     = BIT(0),
+	MV_V2_WOL_CTRL			= 0xf06e,
+	MV_V2_WOL_CTRL_CLEAR_STS	= BIT(15),
+	MV_V2_WOL_CTRL_MAGIC_PKT_EN	= BIT(0),
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
-- 
2.35.1

