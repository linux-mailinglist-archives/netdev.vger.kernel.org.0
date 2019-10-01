Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F85C2D14
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 08:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732037AbfJAGIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 02:08:17 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42101 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfJAGIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 02:08:17 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFBKY-0005n1-S5; Tue, 01 Oct 2019 08:08:14 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFBKW-0006NC-O1; Tue, 01 Oct 2019 08:08:12 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] net: phy: at803x: add ar9331 support
Date:   Tue,  1 Oct 2019 08:08:08 +0200
Message-Id: <20191001060811.24291-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.23.0
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
- use PHY_ID_MATCH_EXACT instead of leaky masking
- remove probe and struct at803x_priv

Oleksij Rempel (3):
  net: phy: at803x: use PHY_ID_MATCH_EXACT for IDs
  net: phy: at803x: add ar9331 support
  net: phy: at803x: remove probe and struct at803x_priv

 drivers/net/phy/at803x.c | 45 ++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 30 deletions(-)

-- 
2.23.0

