Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC5221B4BC
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgGJMJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbgGJMJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:09:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BB1C08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 05:09:07 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jtrpu-00080Z-8G; Fri, 10 Jul 2020 14:09:02 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jtrpq-0007YW-LG; Fri, 10 Jul 2020 14:08:58 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v1 0/5] add cable test support for ksz8081 and ksz8873 
Date:   Fri, 10 Jul 2020 14:08:46 +0200
Message-Id: <20200710120851.28984-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.27.0
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

This patch series provide support for cable testing on some of micrel PHYs.
Since this PHYs do not allow to switch between cable pairs within the
test register, I used MDI-X functionality to make it possible.

Oleksij Rempel (5):
  net: phy: micrel: use consistent indention after define
  net: phy: micrel: apply resume errata workaround for ksz8873 and
    ksz8863
  net: phy: micrel: ksz886x add MDI-X support
  net: phy: micrel: ksz8081 add MDI-X support
  net: phy: micrel: ksz886x/ksz8081: add cabletest support

 drivers/net/phy/micrel.c | 411 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 398 insertions(+), 13 deletions(-)

-- 
2.27.0

