Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A0A274C16
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 00:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgIVW3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 18:29:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50306 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIVW3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 18:29:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKqmf-00FofC-7S; Wed, 23 Sep 2020 00:29:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 0/2]  PHY subsystem kernel doc
Date:   Wed, 23 Sep 2020 00:29:01 +0200
Message-Id: <20200922222903.3769629-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patches fix existing warnings in the kerneldoc for the PHY
subsystem, and then the 2nd extend the kernel documentation for the
major structures and functions in the PHY subsystem.

v2:
Drop the other fixes which have already been merged.
s/phy/PHY/g
TBI
TypOs

Andrew Lunn (2):
  net: phy: Fixup kernel doc
  net: phy: Document core PHY structures

 Documentation/networking/kapi.rst |   9 +
 drivers/net/phy/phy-core.c        |  32 ++-
 drivers/net/phy/phy.c             |  69 ++++-
 include/linux/mdio.h              |   3 +-
 include/linux/phy.h               | 426 +++++++++++++++++++++---------
 5 files changed, 404 insertions(+), 135 deletions(-)

-- 
2.28.0

