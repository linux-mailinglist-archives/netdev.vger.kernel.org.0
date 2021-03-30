Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2F734E9AD
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhC3Nyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbhC3Nya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 09:54:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076C7C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:54:30 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lREos-0006Q1-3h; Tue, 30 Mar 2021 15:54:10 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lREoq-0004RJ-Ml; Tue, 30 Mar 2021 15:54:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v1 0/3] provide basic selftest support for the ethernet FEC driver
Date:   Tue, 30 Mar 2021 15:54:04 +0200
Message-Id: <20210330135407.17010-1-o.rempel@pengutronix.de>
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

This patch set provides diagnostic capabilities for some iMX based
boards.
So far I add only initial infrastructure with basic tests and fixed some
PHY drivers. To validate this tests, I made some common
missconfigurations like wrong RGMII type, not configured clock providers
and so on.

Oleksij Rempel (3):
  net: phy: micrel: KSZ8081: add loopback support
  net: phy: at803x: AR8085: add loopback support
  net: fec: add basic selftest support

 drivers/net/ethernet/freescale/Makefile       |   2 +-
 drivers/net/ethernet/freescale/fec.h          |   6 +
 drivers/net/ethernet/freescale/fec_main.c     |   6 +
 .../net/ethernet/freescale/fec_selftests.c    | 425 ++++++++++++++++++
 drivers/net/phy/at803x.c                      |  25 ++
 drivers/net/phy/micrel.c                      |   1 +
 6 files changed, 464 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/freescale/fec_selftests.c

-- 
2.29.2

