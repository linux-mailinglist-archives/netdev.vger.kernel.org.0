Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36885F693C
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfKJOEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:04:22 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45558 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:04:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SjgTVzWFH5EUvPHg3C1kJUccxpfvrvK8v4lXgQCY0Aw=; b=VCZ9y8wzjMUupfFUS1zZM7300P
        nqB+pARw3fN90cABMHfESpsjhuNTx6OZ1S3BRs71OpYY8V8gXGETWZtCxzJhZ8ldynZ97Y4bcByAd
        vdhTx/RUH/DA4aViCglvsrSilLLKfj1uYwci3sqrr5CaHsK7Z6w+FnHRK3ERSju1fwwXXJY50pGMo
        Ygiv2vN555I4T/XFm+CDUu1kPge3389d3WKnR7HoRd4WO0FpIZXuRmt15PGVYks1KMTomGEFd3v/S
        de+yvk5ltL+4tcysRaDurD9TEarQW2zRWwY8mgSwQ9MBObcwHGfw9cFnfKMHc5Bkxiz1ISlfJPAtQ
        TPoVUHiQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54010 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnp5-0007cQ-SB; Sun, 10 Nov 2019 14:04:11 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnp5-0004rn-Ah; Sun, 10 Nov 2019 14:04:11 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] net: sfp: fix sfp_bus_put() kernel documentation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnp5-0004rn-Ah@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:04:11 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kbuild test robot found a problem with htmldocs with the recent
change to the SFP interfaces.  Fix the kernel documentation for
sfp_bus_put() which was missing an '@' before the argument name
description.

Fixes: 727b3668b730 ("net: sfp: rework upstream interface")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 715d45214e18..c5398a023440 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -331,7 +331,7 @@ static void sfp_bus_release(struct kref *kref)
 
 /**
  * sfp_bus_put() - put a reference on the &struct sfp_bus
- * bus: the &struct sfp_bus found via sfp_bus_find_fwnode()
+ * @bus: the &struct sfp_bus found via sfp_bus_find_fwnode()
  *
  * Put a reference on the &struct sfp_bus and free the underlying structure
  * if this was the last reference.
-- 
2.20.1

