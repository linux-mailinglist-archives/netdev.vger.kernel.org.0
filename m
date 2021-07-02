Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A06A3B9EF4
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 12:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhGBKUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 06:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbhGBKUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 06:20:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5B5C0613DB
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 03:18:09 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lzGFH-0005B9-3u; Fri, 02 Jul 2021 12:18:03 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lzGFF-0003eO-Ck; Fri, 02 Jul 2021 12:18:01 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH net-next v2 0/6] ar9331: mainline some parts of switch functionality 
Date:   Fri,  2 Jul 2021 12:17:45 +0200
Message-Id: <20210702101751.13168-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Till now the ar9331 switch was supporting only port multiplexing mode.
With this patch set we should be able to bridging and VLAN

Oleksij Rempel (6):
  net: dsa: qca: ar9331: reorder MDIO write sequence
  net: dsa: qca: ar9331: make proper initial port defaults
  net: dsa: qca: ar9331: add forwarding database support
  net: dsa: qca: ar9331: add ageing time support
  net: dsa: qca: ar9331: add bridge support
  net: dsa: qca: ar9331: add vlan support

 drivers/net/dsa/qca/ar9331.c | 782 ++++++++++++++++++++++++++++++++++-
 1 file changed, 777 insertions(+), 5 deletions(-)

-- 
2.30.2

