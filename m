Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8169245963
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 21:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgHPToC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 15:44:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729334AbgHPToB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 15:44:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7OZR-009c8Z-TV; Sun, 16 Aug 2020 21:43:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/7] net: dsa: mv88e6xxx: Add devlink regions support
Date:   Sun, 16 Aug 2020 21:43:09 +0200
Message-Id: <20200816194316.2291489-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of devlink regions to allow read access to some of the
internal of the switches. The switch itself will never trigger a
region snapshot, it is assumed it is performed from user space as
needed.

Andrew Lunn (7):
  net: dsa: Add helper to convert from devlink to ds
  net: dsa: Add devlink regions support to DSA
  net: dsa: mv88e6xxx: Move devlink code into its own file
  net: dsa: mv88e6xxx: Create helper for FIDs in use
  net: dsa: mv88e6xxx: Add devlink regions
  net: dsa: wire up devlink info get
  net: dsa: mv88e6xxx: Implement devlink info get callback

 drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c    | 290 ++----------
 drivers/net/dsa/mv88e6xxx/chip.h    |  14 +
 drivers/net/dsa/mv88e6xxx/devlink.c | 690 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/devlink.h |  21 +
 include/net/dsa.h                   |  13 +-
 net/dsa/dsa.c                       |  36 +-
 net/dsa/dsa2.c                      |  21 +-
 8 files changed, 813 insertions(+), 273 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.h

-- 
2.28.0

