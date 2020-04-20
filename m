Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D251B0C5E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgDTNP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTNP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 09:15:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5FAC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 06:15:27 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jQWGb-0002xz-IM; Mon, 20 Apr 2020 15:15:17 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jQWGX-0002NM-BJ; Mon, 20 Apr 2020 15:15:13 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: [PATCH v2 0/2] provide support for PHY master/slave configuration
Date:   Mon, 20 Apr 2020 15:15:05 +0200
Message-Id: <20200420131508.1539-1-o.rempel@pengutronix.de>
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

changes v2:
- change names. Use MASTER_PREFERRED instead of MULTIPORT
- configure master/slave only on request. Default configuration can be
  provided by PHY or eeprom
- status and configuration to the user space.

Oleksij Rempel (2):
  ethtool: provide UAPI for PHY master/slave configuration.
  net: phy: tja11xx: add support for master-slave configuration

 Documentation/networking/ethtool-netlink.rst |  2 +
 drivers/net/phy/nxp-tja11xx.c                | 56 ++++++++++++-
 drivers/net/phy/phy.c                        |  3 +-
 drivers/net/phy/phy_device.c                 | 88 ++++++++++++++++++++
 include/linux/phy.h                          |  2 +
 include/uapi/linux/ethtool.h                 | 17 +++-
 include/uapi/linux/ethtool_netlink.h         |  1 +
 include/uapi/linux/mii.h                     |  2 +
 net/ethtool/linkmodes.c                      |  9 +-
 9 files changed, 176 insertions(+), 4 deletions(-)

-- 
2.26.1

