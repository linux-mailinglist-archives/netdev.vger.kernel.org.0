Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4B6214E85
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgGESbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:31:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47444 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727925AbgGESbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 14:31:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1js9Pc-003isl-Jb; Sun, 05 Jul 2020 20:30:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandru Ardelean <alexaundru.ardelean@analog.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH net-next 0/7] drivers/net/phy C=1 W=1 fixes
Date:   Sun,  5 Jul 2020 20:29:14 +0200
Message-Id: <20200705182921.887441-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixed most of the Sparse and W=1 warnings in drivers/net/phy. The
Cavium code is still not fully clean, but it might actually be the
strange code is confusing Sparse.

GregKH: Is it O.K. to take the last patch via netdev, not staging?

Cc: Alexandru Ardelean <alexaundru.ardelean@analog.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: Robert Richter <rrichter@marvell.com>
Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: Robert Richter <rrichter@marvell.com>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Andrew Lunn (7):
  net: phy: at803x: Avoid comparison is always false warning
  net: phy: Fixup parameters in kerneldoc
  net: phy: Properly define genphy_c45_driver
  net: phy: Make  phy_10gbit_fec_features_array static
  net: phy: dp83640: Fixup cast to restricted __be16 warning
  net: phy: cavium: Improve __iomem mess
  net: phy: mdio-octeon: Cleanup module loading dependencies

 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c |  6 +-----
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
 drivers/staging/octeon/ethernet.c                |  2 --
 include/linux/phy.h                              |  3 +++
 14 files changed, 31 insertions(+), 44 deletions(-)

-- 
2.27.0.rc2

