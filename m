Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA22549050
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245454AbiFMP3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 11:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbiFMP2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 11:28:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F3213CA22
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n7PpJY1bf8I5at8LbKqbnc0ScOt7seldp+wBBZPVcKI=; b=SRTIBVEBHwp1Y0qmS4fKm2gi9W
        KCvfpPL3gy8K4AeDOGbM16AiC5yzeB6Af4gHzhMoWv+UPAMPkfvD7PCwlTjqJQNb0tLRFsUptf8gv
        0AENcZSGx8IdfqnTNFoOrCtm9mph2+yqfqr7kPjMT1uLGqV8HJKqgOuWiQjemRL/NogWp8OeKaFVG
        i6/ltYzd7zDx0AtST2A5clldCRxkWBS+sdCULWAZ5N1yshVey7XRgxUojpF0M8F/OPaTzRvCTzQ/m
        gn4HvGBvc5omQU5IK0ET1FCRYgsr/5wj5Odb7HNESBcM9Yw67uoLTHgyI8zVglYM3Holl+aFvoRh0
        LbL4M2mQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52098 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jgz-0001sa-QS; Mon, 13 Jun 2022 14:01:17 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jgz-000JZB-72; Mon, 13 Jun 2022 14:01:17 +0100
In-Reply-To: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 11/15] net: dsa: mv88e6xxx: export
 mv88e6xxx_pcs_decode_state()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jgz-000JZB-72@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:01:17 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename and export the PCS state decoding function so our PCS can
make use of the functionality provided by this.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 11 +++++------
 drivers/net/dsa/mv88e6xxx/serdes.h |  5 +++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index d94150d8f3f4..28831118e551 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -49,9 +49,8 @@ static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_phy_write(chip, lane, reg_c45, val);
 }
 
-static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
-					  u16 bmsr, u16 lpa, u16 status,
-					  struct phylink_link_state *state)
+int mv88e6xxx_pcs_decode_state(struct device *dev, u16 bmsr, u16 lpa,
+			       u16 status, struct phylink_link_state *state)
 {
 	state->link = false;
 
@@ -92,7 +91,7 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
 			state->speed = SPEED_10;
 			break;
 		default:
-			dev_err(chip->dev, "invalid PHY speed\n");
+			dev_err(dev, "invalid PHY speed\n");
 			return -EINVAL;
 		}
 	} else if (state->link &&
@@ -215,7 +214,7 @@ int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, bmsr, lpa, status, state);
+	return mv88e6xxx_pcs_decode_state(chip->dev, bmsr, lpa, status, state);
 }
 
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
@@ -945,7 +944,7 @@ static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, bmsr, lpa, status, state);
+	return mv88e6xxx_pcs_decode_state(chip->dev, bmsr, lpa, status, state);
 }
 
 static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 29bb4e91e2f6..918306c2e287 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -12,6 +12,8 @@
 
 #include "chip.h"
 
+struct phylink_link_state;
+
 #define MV88E6352_ADDR_SERDES		0x0f
 #define MV88E6352_SERDES_PAGE_FIBER	0x01
 #define MV88E6352_SERDES_IRQ		0x0b
@@ -103,6 +105,9 @@
 #define MV88E6393X_ERRATA_4_8_REG		0xF074
 #define MV88E6393X_ERRATA_4_8_BIT		BIT(14)
 
+int mv88e6xxx_pcs_decode_state(struct device *dev, u16 bmsr, u16 lpa,
+			       u16 status, struct phylink_link_state *state);
+
 int mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-- 
2.30.2

