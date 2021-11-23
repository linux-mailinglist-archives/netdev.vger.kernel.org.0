Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1A9459FAF
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 11:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhKWKDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 05:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbhKWKDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 05:03:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0795FC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 02:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vI3ymyYAKFYvel9BMTNK2PdmqBTT7h36ITGdk3iia7s=; b=KsWTN0MqPdM02Z77p402LRZG8X
        EWbuvDDUlK5CJtbC+XqIBTCkgbMDGYvNPZmP2D9dCnm1p2Eazb7H+q3SwXw6SnOONrFLzzcnd+w/T
        tSRGdCt6xC1TyCCIJLxZhV4kBjAaCiMyn+/FPbk86KND98TL454ZBOl9w4ArDZnBRC3ujiTfvqBR9
        bWkxVkB0xE446Fr7cI4st+Prd2em+xv6m+yYLkj64rJtkh4yQo7ksXxk5oRI/O9ITZy1pKBt4G3ci
        WbINXxSkNHwjciIJdRulNro28WTZNKOPmXqXJ6sXY+KWTocfj5Kwnw0tlXIsi9alueOvtOfnES5se
        C985pGyA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36048 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpSbQ-0007iy-H4; Tue, 23 Nov 2021 10:00:40 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpSbQ-00BXou-1d; Tue, 23 Nov 2021 10:00:40 +0000
In-Reply-To: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
References: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 6/8] net: axienet: mark as a legacy_pre_march2020
 phylink driver
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpSbQ-00BXou-1d@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 23 Nov 2021 10:00:40 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

axienet has a PCS, but does not make use of the phylink PCS support.
Mark it was a pre-March 2020 driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index e39356364f33..23ac353b35fe 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2051,6 +2051,7 @@ static int axienet_probe(struct platform_device *pdev)
 
 	lp->phylink_config.dev = &ndev->dev;
 	lp->phylink_config.type = PHYLINK_NETDEV;
+	lp->phylink_config.legacy_pre_march2020 = true;
 	lp->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
 		MAC_10FD | MAC_100FD | MAC_1000FD;
 
-- 
2.30.2

