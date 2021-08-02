Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390413DD691
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhHBNK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbhHBNK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:10:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830ECC0613D5
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 06:10:47 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mAXiK-0003MX-Oj; Mon, 02 Aug 2021 15:10:40 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mAXiJ-0008WC-Ed; Mon, 02 Aug 2021 15:10:39 +0200
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
Subject: [PATCH net-next v3 0/6] ar9331: mainline some parts of switch functionality 
Date:   Mon,  2 Aug 2021 15:10:31 +0200
Message-Id: <20210802131037.32326-1-o.rempel@pengutronix.de>
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

changes v3:
- spell fixes
- remove debug print from ar9331_sw_port_fdb_add()
- fix reverse Christmas tree in ar9331_sw_port_fdb_rmw()
- rename _fdb to fdb in ar9331_sw_port_fdb_dump

Till now the ar9331 switch was supporting only port multiplexing mode.
With this patch set we should be able to bridging and VLAN

Oleksij Rempel (6):
  net: dsa: qca: ar9331: reorder MDIO write sequence
  net: dsa: qca: ar9331: make proper initial port defaults
  net: dsa: qca: ar9331: add forwarding database support
  net: dsa: qca: ar9331: add ageing time support
  net: dsa: qca: ar9331: add bridge support
  net: dsa: qca: ar9331: add vlan support

 drivers/net/dsa/qca/ar9331.c | 780 ++++++++++++++++++++++++++++++++++-
 1 file changed, 775 insertions(+), 5 deletions(-)

-- 
2.30.2

