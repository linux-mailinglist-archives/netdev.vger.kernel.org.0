Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3664550D4
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241468AbhKQWyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:54:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241484AbhKQWyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 17:54:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EC726101C;
        Wed, 17 Nov 2021 22:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637189466;
        bh=w8cQj8Xef1Oh87M1Z22c1qsxYss2IbmH3JBYGxMtkMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZImEU3InvHwzczuJnkExTBECRvl+PtQxlBd9KnSHZWBTGusVj8Tw2NxG367P9kHe
         3+2+FxqwZfK5S/hVwyQHEClQ5BVpgFAG1jwr5NDTnF/hVN8X/AnwzSSBBMYrguSaZX
         7MRC0cccVWrisHxucuHQDZAMSzvmBhUmDjIRdYbJEzNXkJIgF230ZbZhrvtvJmFMXp
         /SUwB8nwug1924uICC0H1SoO6JGrLkQ2PmORK+9U9LqKAXHgygdP0bAhO5KNHeezlc
         ldb9pVN+BpnrQTjbv7bgQKn+nC6hZDCWIP+yQthcE1/2pJdNhF410JUIudCSjHGOb8
         Aife3Sehr+0xg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 6/8] net: phy: marvell10g: Use generic macro for supported interfaces
Date:   Wed, 17 Nov 2021 23:50:48 +0100
Message-Id: <20211117225050.18395-7-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117225050.18395-1-kabel@kernel.org>
References: <20211117225050.18395-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that phy.h defines macro DECLARE_PHY_INTERFACE_MASK(), use it
instead of DECLARE_BITMAP().

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index b6fea119fe13..d289641190db 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -148,7 +148,7 @@ struct mv3310_chip {
 };
 
 struct mv3310_priv {
-	DECLARE_BITMAP(supported_interfaces, PHY_INTERFACE_MODE_MAX);
+	DECLARE_PHY_INTERFACE_MASK(supported_interfaces);
 
 	u32 firmware_ver;
 	bool has_downshift;
-- 
2.32.0

