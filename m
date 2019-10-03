Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEAA6C99B1
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 10:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbfJCIVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 04:21:23 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51005 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbfJCIVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 04:21:22 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFwMR-00031A-PP; Thu, 03 Oct 2019 10:21:19 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFwMO-0003ej-4E; Thu, 03 Oct 2019 10:21:16 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] net: phy: at803x: add ar9331 support
Date:   Thu,  3 Oct 2019 10:21:11 +0200
Message-Id: <20191003082113.13993-1-o.rempel@pengutronix.de>
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

changes v3:
- use PHY_ID_MATCH_EXACT only for ATH9331 PHY

changes v2:
- use PHY_ID_MATCH_EXACT instead of leaky masking
- remove probe and struct at803x_priv

Oleksij Rempel (2):
  net: phy: at803x: add ar9331 support
  net: phy: at803x: remove probe and struct at803x_priv

 drivers/net/phy/at803x.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

-- 
2.23.0

