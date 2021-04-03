Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA313533D1
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 13:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbhDCLtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 07:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbhDCLtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 07:49:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3DBC061794
        for <netdev@vger.kernel.org>; Sat,  3 Apr 2021 04:49:06 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSelp-0000ep-6z; Sat, 03 Apr 2021 13:48:53 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSell-0007xO-LG; Sat, 03 Apr 2021 13:48:49 +0200
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
Subject: [PATCH net-next v1 0/9] ar9331: mainline some parts of switch functionality 
Date:   Sat,  3 Apr 2021 13:48:39 +0200
Message-Id: <20210403114848.30528-1-o.rempel@pengutronix.de>
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

Till now the ar9331 switch was supporting only port multiplexing mode.
With this patch set we should be able to bridging, VLAN and STP

Oleksij Rempel (9):
  net: dsa: add rcv_post call back
  net: dsa: tag_ar9331: detect IGMP and MLD packets
  net: dsa: qca: ar9331: reorder MDIO write sequence
  net: dsa: qca: ar9331: make proper initial port defaults
  net: dsa: qca: ar9331: add forwarding database support
  net: dsa: qca: ar9331: add ageing time support
  net: dsa: qca: ar9331: add bridge support
  net: dsa: qca: ar9331: add STP support
  net: dsa: qca: ar9331: add vlan support

 drivers/net/dsa/qca/ar9331.c | 927 ++++++++++++++++++++++++++++++++++-
 include/net/dsa.h            |   2 +
 net/dsa/dsa.c                |   4 +
 net/dsa/port.c               |   1 +
 net/dsa/tag_ar9331.c         | 130 +++++
 5 files changed, 1059 insertions(+), 5 deletions(-)

-- 
2.29.2

