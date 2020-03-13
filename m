Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7CA41844CA
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 11:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgCMKZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 06:25:57 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45185 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgCMKZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 06:25:53 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jChVf-0006nH-Mn; Fri, 13 Mar 2020 11:25:43 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jChVf-0001Qp-0O; Fri, 13 Mar 2020 11:25:43 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 0/2] properly define some of PHYs 
Date:   Fri, 13 Mar 2020 11:25:32 +0100
Message-Id: <20200313102534.5438-1-o.rempel@pengutronix.de>
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

changes v3:
- add phy-handle on the marsboard

changes v2:
- remove spaces

Oleksij Rempel (2):
  ARM: dts: imx6dl-riotboard: properly define rgmii PHY
  ARM: dts: imx6q-marsboard: properly define rgmii PHY

 arch/arm/boot/dts/imx6dl-riotboard.dts | 16 +++++++++++++++-
 arch/arm/boot/dts/imx6q-marsboard.dts  | 16 +++++++++++++++-
 2 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.25.1

