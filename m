Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FCF1B3B34
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 11:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgDVJZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 05:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726414AbgDVJZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 05:25:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2340CC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 02:25:09 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jRBcr-0007Rg-36; Wed, 22 Apr 2020 11:25:01 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jRBco-0006Kj-HT; Wed, 22 Apr 2020 11:24:58 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v5 0/4] add TJA1102 support
Date:   Wed, 22 Apr 2020 11:24:52 +0200
Message-Id: <20200422092456.24281-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v5:
- rename __of_mdiobus_register_phy() to of_mdiobus_phy_device_register()

changes v4:
- remove unused phy_id variable

changes v3:
- export part of of_mdiobus_register_phy() and reuse it in tja11xx
  driver
- coding style fixes

changes v2:
- use .match_phy_device
- add irq support
- add add delayed registration for PHY1

Oleksij Rempel (4):
  dt-bindings: net: phy: Add support for NXP TJA11xx
  net: phy: tja11xx: add initial TJA1102 support
  net: mdio: of: export part of of_mdiobus_register_phy()
  net: phy: tja11xx: add delayed registration of TJA1102 PHY1

 .../devicetree/bindings/net/nxp,tja11xx.yaml  |  61 ++++++
 drivers/net/phy/nxp-tja11xx.c                 | 201 +++++++++++++++++-
 drivers/of/of_mdio.c                          |  73 ++++---
 include/linux/of_mdio.h                       |  11 +-
 4 files changed, 308 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nxp,tja11xx.yaml

-- 
2.26.1

