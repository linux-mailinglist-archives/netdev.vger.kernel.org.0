Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECEE216381
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 03:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgGGBt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 21:49:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50142 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgGGBt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 21:49:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsck6-003wBs-JF; Tue, 07 Jul 2020 03:49:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 0/7] drivers/net/phy C=1 W=1 fixes
Date:   Tue,  7 Jul 2020 03:49:32 +0200
Message-Id: <20200707014939.938621-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes most of the Sparse and W=1 warnings in drivers/net/phy. The
Cavium code is still not fully clean, but it might actually be the
strange code is confusing Sparse.

v2
--
Added RB, TB, AB.
s/case/cause
Reverse Christmas tree
Module soft dependencies

Andrew Lunn (7):
  net: phy: at803x: Avoid comparison is always false warning
  net: phy: Fixup parameters in kerneldoc
  net: phy: Properly define genphy_c45_driver
  net: phy: Make  phy_10gbit_fec_features_array static
  net: phy: dp83640: Fixup cast to restricted __be16 warning
  net: phy: cavium: Improve __iomem mess
  net: phy: mdio-octeon: Cleanup module loading dependencies

 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c |  7 ++-----
 drivers/net/phy/adin.c                           | 12 ++++++------
 drivers/net/phy/at803x.c                         |  7 +++----
 drivers/net/phy/dp83640.c                        |  5 +++--
 drivers/net/phy/mdio-boardinfo.c                 |  3 ++-
 drivers/net/phy/mdio-cavium.h                    | 14 +++++++-------
 drivers/net/phy/mdio-octeon.c                    | 11 ++---------
 drivers/net/phy/mdio-thunder.c                   |  2 +-
 drivers/net/phy/mdio_device.c                    |  2 +-
 drivers/net/phy/phy_device.c                     |  4 +---
 drivers/staging/octeon/ethernet-mdio.c           |  2 +-
 drivers/staging/octeon/ethernet-mdio.h           |  2 --
 drivers/staging/octeon/ethernet.c                |  3 +--
 include/linux/phy.h                              |  3 +++
 14 files changed, 33 insertions(+), 44 deletions(-)

-- 
2.27.0.rc2

