Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB96D26327F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbgIIQoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730983AbgIIQMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:12:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60785C061386
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 06:45:19 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kG0PO-0007FX-Fr; Wed, 09 Sep 2020 15:45:10 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kG0PI-0000f7-Sq; Wed, 09 Sep 2020 15:45:04 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: [PATCH v3 0/5] SMSC: Cleanups and clock setup
Date:   Wed,  9 Sep 2020 15:44:56 +0200
Message-Id: <20200909134501.32529-1-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this small series cleans the smsc-phy code a bit and adds the support to
specify the phy clock source. Adding the phy clock source support is
also the main purpose of this series.

Each file has its own changelog.

Thanks a lot to Florian and Andrew for reviewing it.

Regards,
  Marco

Marco Felsch (5):
  net: phy: smsc: skip ENERGYON interrupt if disabled
  net: phy: smsc: simplify config_init callback
  dt-bindings: net: phy: smsc: document reference clock
  net: phy: smsc: LAN8710/20: add phy refclk in support
  net: phy: smsc: LAN8710/20: remove PHY_RST_AFTER_CLK_EN flag

 .../devicetree/bindings/net/smsc-lan87xx.txt  |  4 ++
 drivers/net/phy/smsc.c                        | 59 +++++++++++++++----
 2 files changed, 50 insertions(+), 13 deletions(-)

-- 
2.20.1

