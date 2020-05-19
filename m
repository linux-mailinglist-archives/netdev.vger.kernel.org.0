Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF83A1D9762
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgESNOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729024AbgESNOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:14:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA328C08C5C2
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 06:14:49 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jb24v-0007Jw-Kj; Tue, 19 May 2020 15:14:41 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jb24p-000170-T8; Tue, 19 May 2020 15:14:35 +0200
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
Subject: [PATCH net-next v2 0/2] provide KAPI for SQI 
Date:   Tue, 19 May 2020 15:14:31 +0200
Message-Id: <20200519131433.4224-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
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
- use u32 instead of u8 for SQI
- add SQI_MAX field and callbacks
- some style fixes in the rst.
- do not convert index to shifted index.

Oleksij Rempel (2):
  ethtool: provide UAPI for PHY Signal Quality Index (SQI)
  net: phy: tja11xx: add SQI support

 Documentation/networking/ethtool-netlink.rst |  6 ++--
 drivers/net/phy/nxp-tja11xx.c                | 26 ++++++++++++++
 include/linux/phy.h                          |  2 ++
 include/uapi/linux/ethtool_netlink.h         |  2 ++
 net/ethtool/common.c                         | 20 +++++++++++
 net/ethtool/common.h                         |  2 ++
 net/ethtool/linkstate.c                      | 38 +++++++++++++++++++-
 7 files changed, 93 insertions(+), 3 deletions(-)

-- 
2.26.2

