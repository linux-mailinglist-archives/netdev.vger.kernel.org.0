Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D65B27163C
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 19:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgITRRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 13:17:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46144 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgITRRX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 13:17:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kK2xi-00FUYa-LT; Sun, 20 Sep 2020 19:17:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/5] PHY subsystem kernel doc
Date:   Sun, 20 Sep 2020 19:16:58 +0200
Message-Id: <20200920171703.3692328-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first two patches just fixed warnings seen while trying to work on
PHY documentation.

The following patches then first fix existing warnings in the
kerneldoc for the PHY subsystem, and then extend the kernel
documentation for the major structures and functions in the PHY
subsystem.

Andrew Lunn (5):
  net: netdevice.h: Document proto_down_reason
  net: netdevice.h: Document xdp_state
  net: phy: Fixup kernel doc
  net: phy: Document core PHY structures
  net: mdio: Add kerneldoc for main data structures and some functions

 Documentation/networking/kapi.rst |  24 ++
 drivers/net/phy/mdio_bus.c        |  37 +++
 drivers/net/phy/mdio_device.c     |  21 ++
 drivers/net/phy/phy-core.c        |  30 +++
 drivers/net/phy/phy.c             |  69 ++++-
 include/linux/mdio.h              |  91 ++++++-
 include/linux/netdevice.h         |   3 +
 include/linux/phy.h               | 414 +++++++++++++++++++++---------
 8 files changed, 554 insertions(+), 135 deletions(-)

-- 
2.28.0

