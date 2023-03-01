Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415AF6A661F
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 04:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCADCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 22:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCADCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 22:02:19 -0500
Received: from inva020.nxp.com (inva020.nxp.com [92.121.34.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30251CAD8;
        Tue, 28 Feb 2023 19:01:56 -0800 (PST)
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 523891A1B45;
        Wed,  1 Mar 2023 04:01:55 +0100 (CET)
Received: from smtp.na-rdc02.nxp.com (usphx01srsp001v.us-phx01.nxp.com [134.27.49.11])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 118561A125C;
        Wed,  1 Mar 2023 04:01:55 +0100 (CET)
Received: from right.am.freescale.net (right.am.freescale.net [10.81.116.134])
        by usphx01srsp001v.us-phx01.nxp.com (Postfix) with ESMTP id B1DB74058C;
        Tue, 28 Feb 2023 20:01:53 -0700 (MST)
From:   Li Yang <leoyang.li@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Bauer <mail@david-bauer.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Yang <leoyang.li@nxp.com>
Subject: [PATCH RESEND v2 2/2] net: phy: at803x: remove set/get wol callbacks for AR8032
Date:   Tue, 28 Feb 2023 21:01:26 -0600
Message-Id: <20230301030126.18494-2-leoyang.li@nxp.com>
X-Mailer: git-send-email 2.25.1.377.g2d2118b
In-Reply-To: <20230301030126.18494-1-leoyang.li@nxp.com>
References: <20230301030126.18494-1-leoyang.li@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the AR8032 part does not support wol, remove related callbacks
from it.

Fixes: 5800091a2061 ("net: phy: at803x: add support for AR8032 PHY")
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Cc: David Bauer <mail@david-bauer.net>
---
 drivers/net/phy/at803x.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 2102279b3964..ac47a1d681b2 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -2079,8 +2079,6 @@ static struct phy_driver at803x_driver[] = {
 	.flags			= PHY_POLL_CABLE_TEST,
 	.config_init		= at803x_config_init,
 	.link_change_notify	= at803x_link_change_notify,
-	.set_wol		= at803x_set_wol,
-	.get_wol		= at803x_get_wol,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_BASIC_FEATURES */
-- 
2.38.0

