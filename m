Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8B3ECCA7
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 02:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfKBBOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 21:14:15 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:40031 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfKBBOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 21:14:15 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 676BC22EE4;
        Sat,  2 Nov 2019 02:14:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572657253;
        bh=9jBTRlgT0tA/JEQgM/JP3C7ZF4qFmUkZTYW+fX9iAik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/uZlNxJgtfiIuUuvwHsDubGyBJWiz44BmGk3uuwKtcKxU6Ou9av+FyogsT/xhcg0
         wp5uGtLQTETtpESAcXKbsRJZM27OlQT3bUWKKDCKYL3SoM36LoBSD776+139R2QF+F
         Qfy6Yr73Ueud8UO8981kvD4Haiq943iga8J/Ir10=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>
Subject: [PATCH 1/5] net: phy: at803x: fix Kconfig description
Date:   Sat,  2 Nov 2019 02:13:47 +0100
Message-Id: <20191102011351.6467-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191102011351.6467-1-michael@walle.cc>
References: <20191102011351.6467-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The name of the PHY is actually AR803x not AT803x. Additionally, add the
name of the vendor and mention the AR8031 support.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index fe602648b99f..1b884ebb4e48 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -282,11 +282,6 @@ config AX88796B_PHY
 	  Currently supports the Asix Electronics PHY found in the X-Surf 100
 	  AX88796B package.
 
-config AT803X_PHY
-	tristate "AT803X PHYs"
-	---help---
-	  Currently supports the AT8030 and AT8035 model
-
 config BCM63XX_PHY
 	tristate "Broadcom 63xx SOCs internal PHY"
 	depends on BCM63XX || COMPILE_TEST
@@ -444,6 +439,11 @@ config NXP_TJA11XX_PHY
 	---help---
 	  Currently supports the NXP TJA1100 and TJA1101 PHY.
 
+config AT803X_PHY
+	tristate "Qualcomm Atheros AR803X PHYs"
+	help
+	  Currently supports the AR8030, AR8031 and AR8035 model
+
 config QSEMI_PHY
 	tristate "Quality Semiconductor PHYs"
 	---help---
-- 
2.20.1

