Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A233A96D5
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhFPKGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:06:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10105 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbhFPKGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:06:48 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4gh91L1ZzZdgG;
        Wed, 16 Jun 2021 18:01:45 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 18:04:40 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 18:04:40 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH v2 net-next 0/8] net: phy: fix some coding-style issues
Date:   Wed, 16 Jun 2021 18:01:18 +0800
Message-ID: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema753-chm.china.huawei.com (10.1.198.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make some cleanups according to the coding style of kernel.

Changes since v1:
- Update commit description of #1 and #3.
- Avoid changing the indentation in #2.
- Change a group of if-else statement into switch from #4 and put it into
  a single patch.
- Put '|' at the end of line in #5 and #7.
- Avoid deleting spaces in definition of 'settings' in #5.
- Drop #8 from the series which needs more discussion with David.

Weihang Li (1):
  net: phy: replace if-else statements with switch

Wenpeng Liang (7):
  net: phy: change format of some declarations
  net: phy: correct format of block comments
  net: phy: delete repeated words of comments
  net: phy: fix space alignment issues
  net: phy: fix formatting issues with braces
  net: phy: print the function name by __func__ instead of an fixed
    string
  net: phy: remove unnecessary line continuation

 drivers/net/phy/bcm87xx.c     |  4 ++--
 drivers/net/phy/davicom.c     |  6 +++---
 drivers/net/phy/dp83640.c     |  5 +++--
 drivers/net/phy/et1011c.c     | 15 ++++++++-------
 drivers/net/phy/fixed_phy.c   |  4 ++--
 drivers/net/phy/lxt.c         |  4 ++--
 drivers/net/phy/marvell.c     | 13 +++++++++----
 drivers/net/phy/mdio_bus.c    |  1 +
 drivers/net/phy/mdio_device.c |  4 ++--
 drivers/net/phy/national.c    |  6 ++++--
 drivers/net/phy/phy-c45.c     |  2 +-
 drivers/net/phy/phy-core.c    |  3 ++-
 drivers/net/phy/phy.c         |  3 +--
 drivers/net/phy/phy_device.c  |  9 ++++-----
 drivers/net/phy/phylink.c     | 14 ++++++++------
 drivers/net/phy/qsemi.c       |  1 +
 drivers/net/phy/sfp-bus.c     | 28 ++++++++++++++--------------
 drivers/net/phy/sfp.c         |  2 +-
 drivers/net/phy/spi_ks8995.c  | 10 +++++-----
 drivers/net/phy/ste10Xp.c     |  6 +++---
 drivers/net/phy/vitesse.c     |  3 ++-
 21 files changed, 78 insertions(+), 65 deletions(-)

-- 
2.8.1

