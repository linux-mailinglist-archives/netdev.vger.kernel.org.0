Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A56A379E98
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 06:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhEKEcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 00:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhEKEcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 00:32:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B218EC0613ED
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 21:31:02 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lgK2d-0004hb-Co; Tue, 11 May 2021 06:30:43 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lgK2b-0005EQ-2c; Tue, 11 May 2021 06:30:41 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH v3 0/2] remove different PHY fixups - dts part 
Date:   Tue, 11 May 2021 06:30:37 +0200
Message-Id: <20210511043039.20056-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v3:
- split arch and dts changes

changes v2:
- rebase against latest kernel
- fix networking on RIoTBoard

This patch series tries to remove most of the imx6 and imx7 board
specific PHY configuration via fixup, as this breaks the PHYs when
connected to switch chips or USB Ethernet MACs.

Each patch has the possibility to break boards, but contains a
recommendation to fix the problem in a more portable and future-proof
way.

Oleksij Rempel (2):
  ARM: dts: imx6: edmqmx6: set phy-mode to RGMII-ID
  ARM: dts: imx6dl-riotboard: configure PHY clock and set proper EEE
    value

 arch/arm/boot/dts/imx6dl-riotboard.dts  | 2 ++
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

-- 
2.29.2

