Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47014C4418
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240380AbiBYMA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240378AbiBYMAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:00:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBF0275792
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uvhs9fhX23cM/sDgnl7rgyPj5r9UN3+gZSin4/3k5A0=; b=vscK6uIczp1amMCouRQprB+Bay
        AL6cz5JFVvysVR1LEBVHznaozqieztvAVWDAUSIi6JTqoMHBsD3nEpY7IzkAm15xRjAA9pAD3RYWE
        B0LiEc8+M4i3QthQqkc8RX0RTDruJsoEK64+YYsnMEEjGg+XhR+OOLjfe+RGP5kibaC4k/g7Lz3oc
        YJFJ6bhfzoyenFOVhc4nHQB6yVfT9lSzC4Zd2HzuVN7OcNi67oHbOc9gZZXFnpdy0cg+iUcQcQdl0
        n2oCBmC3TKL94rSRYIqnYnl6O3wuTcHDw39bRE73/uzsmKQEF9zrXWSH6EqPvSuTMiwNTWXa67zGg
        lRH02MaA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46080 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNZGj-0005JM-Ve; Fri, 25 Feb 2022 12:00:17 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNZGj-00AbGz-D4; Fri, 25 Feb 2022 12:00:17 +0000
In-Reply-To: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
References: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/6] net: dsa: sja1105: mark as non-legacy
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNZGj-00AbGz-D4@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 25 Feb 2022 12:00:17 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 DSA driver does not have a phylink_mac_config() method
implementation, it is safe to mark this as a non-legacy driver.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b5c36f808df1..8f061cce77f0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1396,6 +1396,12 @@ static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
+	/* This driver does not make use of the speed, duplex, pause or the
+	 * advertisement in its mac_config, so it is safe to mark this driver
+	 * as non-legacy.
+	 */
+	config->legacy_pre_march2020 = false;
+
 	/* The SJA1105 MAC programming model is through the static config
 	 * (the xMII Mode table cannot be dynamically reconfigured), and
 	 * we have to program that early.
-- 
2.30.2

