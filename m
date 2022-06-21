Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279C2552E8C
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 11:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348328AbiFUJhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 05:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243785AbiFUJhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 05:37:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DBD2717B
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kN7NQHBUgUgMpcN3+WbkhNniKluQY/I57FIn2mENrNk=; b=pzymZgEZmvQ40K0QxCOUfkhE99
        9Wu79wKWJ/fBLvnaPFepFo/4O62ZcLY7YOwdq8xRQ6yCeDhQHV0afN1CsMDI4bnuomiyOSFZGy2/k
        2Mon19CEZ19gZpmPSPK7wnPS0rARjL2fUHDXCgWu0b+SYzSTgRJILGoSb9EJnKNlPD3ChN+9KPT4f
        Ner/o8OnY37y4NheLJWutRqnKcQaYaMpqK9LWb57xnRVjKkRP/sqKyWdO2CmmKTzgwidQ6V8xqQKG
        WlWFE/nLch+2bNf4+9pzKpPJ49x/NZVoO51txFSBC9/7pg+nWRUZJKzS60ywYMx1nJvNT/qJ8wOuV
        6D+wrxnQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56734 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o3aKG-00028a-Lu; Tue, 21 Jun 2022 10:37:36 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o3aKF-0031ZW-Ib; Tue, 21 Jun 2022 10:37:35 +0100
In-Reply-To: <YrGQBssOvQBZiDS4@shell.armlinux.org.uk>
References: <YrGQBssOvQBZiDS4@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: mv88e6xxx: remove mv88e6065 dead code
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o3aKF-0031ZW-Ib@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 21 Jun 2022 10:37:35 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove mv88e6065_port_set_speed_duplex() - this is never called, and
thus is completely redundant.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/port.c | 15 ---------------
 drivers/net/dsa/mv88e6xxx/port.h |  2 --
 2 files changed, 17 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 795b3128768f..3cdc985b79e2 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -294,21 +294,6 @@ static int mv88e6xxx_port_set_speed_duplex(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
-/* Support 10, 100, 200 Mbps (e.g. 88E6065 family) */
-int mv88e6065_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
-				    int speed, int duplex)
-{
-	if (speed == SPEED_MAX)
-		speed = 200;
-
-	if (speed > 200)
-		return -EOPNOTSUPP;
-
-	/* Setting 200 Mbps on port 0 to 3 selects 100 Mbps */
-	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, false, false,
-					       duplex);
-}
-
 /* Support 10, 100, 1000 Mbps (e.g. 88E6185 family) */
 int mv88e6185_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				    int speed, int duplex)
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index e0a705d82019..cb04243f37c1 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -342,8 +342,6 @@ int mv88e6xxx_port_set_link(struct mv88e6xxx_chip *chip, int port, int link);
 int mv88e6xxx_port_sync_link(struct mv88e6xxx_chip *chip, int port, unsigned int mode, bool isup);
 int mv88e6185_port_sync_link(struct mv88e6xxx_chip *chip, int port, unsigned int mode, bool isup);
 
-int mv88e6065_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
-				    int speed, int duplex);
 int mv88e6185_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				    int speed, int duplex);
 int mv88e6250_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
-- 
2.30.2

