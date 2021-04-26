Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BED36B688
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 18:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhDZQNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 12:13:40 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:50418 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhDZQNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 12:13:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding;
        bh=xmlWVM44O8zlpDHgIdJrudJSD0CqrW0tK6mZWnNG71k=;
        b=hEypwacz2d/UVzSlUSRpD/+ZeIjDTdyPI7yUuWgzIgE796mSvOoR1B7zbuf0mErIvnmXFql/gXuon
         S63sF3PHsg6fE6YYXVzr04qtcdcjjyDp6ZbwoMH/8wImPsNJMCi8mKPrrvFDszv3vSbbJys4Bhmlal
         MnZUfqAH00ccQm7nVWab+6IcGe6fXUG9tInKaCfnQYIXlifONHhPOhY7hPGdWRLhsqXNGn6eMB0zwS
         AG1hwhcJLWFrAybvaV5MrZ+COkq2IvEfXcmJaVUwixS0P3LFV5nyyxzMxP3OmTL5v0igOM/xu7FndT
         LgrYma6FFZkLFN/ZF/CCFB6T0Ge2GOw==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW, TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([78.37.172.38])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Mon, 26 Apr 2021 19:12:40 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     i.bornyakov@metrotek.ru, system@metrotek.ru, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: phy: marvell-88x2222: enable autoneg by default
Date:   Mon, 26 Apr 2021 19:08:23 +0300
Message-Id: <20210426160823.4501-1-i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no real need for disabling autonigotiation in config_init().
Leave it enabled by default.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/marvell-88x2222.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
index 9b9ac3ef735d..d8b31d4d2a73 100644
--- a/drivers/net/phy/marvell-88x2222.c
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -473,8 +473,6 @@ static int mv2222_config_init(struct phy_device *phydev)
 	if (phydev->interface != PHY_INTERFACE_MODE_XAUI)
 		return -EINVAL;
 
-	phydev->autoneg = AUTONEG_DISABLE;
-
 	return 0;
 }
 
-- 
2.26.3


