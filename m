Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE1936F827
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 11:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhD3JyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 05:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhD3JyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 05:54:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BA2C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 02:53:14 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lcPpe-0000x1-LB; Fri, 30 Apr 2021 11:53:10 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lcPpd-0003mC-26; Fri, 30 Apr 2021 11:53:09 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v1 1/1] net: selftest: provide option to disable generic selftests
Date:   Fri, 30 Apr 2021 11:53:08 +0200
Message-Id: <20210430095308.14465-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some systems may need to disable selftests to reduce kernel size or for
some policy reasons. This patch provide option to disable generic selftests.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: 3e1e58d64c3d ("net: add generic selftest support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/Kconfig b/net/Kconfig
index f5ee7c65e6b4..dac98c73fcd8 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -431,7 +431,12 @@ config SOCK_VALIDATE_XMIT
 
 config NET_SELFTESTS
 	def_tristate PHYLIB
+	prompt "Support for generic selftests"
 	depends on PHYLIB && INET
+	help
+	  These selftests are build automatically if any driver with generic
+	  selftests support is enabled. This option can be used to disable
+	  selftests to reduce kernel size.
 
 config NET_SOCK_MSG
 	bool
-- 
2.29.2

