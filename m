Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A52D184048
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 06:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCMFXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 01:23:19 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39217 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgCMFXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 01:23:06 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jCcmf-00005M-2x; Fri, 13 Mar 2020 06:22:57 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jCcmc-0006cO-HQ; Fri, 13 Mar 2020 06:22:54 +0100
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
Subject: [PATCH v4 0/4] add TJA1102 support
Date:   Fri, 13 Mar 2020 06:22:48 +0100
Message-Id: <20200313052252.25389-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.25.1
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
2.25.1

