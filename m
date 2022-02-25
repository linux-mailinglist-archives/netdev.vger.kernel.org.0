Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC844C4A28
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242628AbiBYQHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242632AbiBYQH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:07:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34E9211325
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gOC06Gbz3KU5GMm8NBYQtmYGszj+N9RQO7CTA1odO/I=; b=lzkZwXODgeX0vQytOwVXiC4POV
        A1Iv84hYxfdQKKIP4SlZa1d4dtMds+ehJJGt3LDwRU2O0K6R2PzwzZOBkXdwYWTRme2Yk4ZXJg87g
        boa241R7kRyHUX+kgwEs1J0YsBGpWSqnL07NqDNghcAJa9rL4PP/+F82UhAoRk4ydugvcvpUV8QCT
        6r0ajPr/v5cvIYJbArQXQAJYl0y3xoqiq4CKyChguqTSfm6CoB+BF2OsJc0jSGnO224s0CK12csMp
        7k2hX/HepJ5Bzt5WF1JNcAwiLjo96EdaEccDilfzTuyBpNYHbhbH1jaJxX2QfytCi/A3rQr93Dypu
        XH6zdDOQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47526 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNd7M-0005fo-FY; Fri, 25 Feb 2022 16:06:52 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNd7L-00Ao0D-T7; Fri, 25 Feb 2022 16:06:51 +0000
In-Reply-To: <Yhj+NnrggVRPmlT8@shell.armlinux.org.uk>
References: <Yhj+NnrggVRPmlT8@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: dsa: ocelot: mark as non-legacy
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNd7L-00Ao0D-T7@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 25 Feb 2022 16:06:51 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot DSA driver does not make use of the speed, duplex, pause or
advertisement in its phylink_mac_config() implementation, so it can be
marked as a non-legacy driver.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/ocelot/felix.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index bd0ac1ca3b4c..3e0579ed9776 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -783,6 +783,12 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 
+	/* This driver does not make use of the speed, duplex, pause or the
+	 * advertisement in its mac_config, so it is safe to mark this driver
+	 * as non-legacy.
+	 */
+	config->legacy_pre_march2020 = false;
+
 	__set_bit(ocelot->ports[port].phy_mode,
 		  config->supported_interfaces);
 }
-- 
2.30.2

