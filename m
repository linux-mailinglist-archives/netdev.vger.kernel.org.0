Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C413A3C1B
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhFKGm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:42:27 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3842 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbhFKGmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:42:18 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G1WLP2THzzWsR4;
        Fri, 11 Jun 2021 14:35:25 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:40:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:40:14 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 0/8] net: phy: fix some coding-style issues
Date:   Fri, 11 Jun 2021 14:36:51 +0800
Message-ID: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema753-chm.china.huawei.com (10.1.198.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make some cleanups according to the coding style of kernel.

Wenpeng Liang (8):
  net: phy: add a blank line after declarations
  net: phy: correct format of block comments
  net: phy: delete repeated word of block comments
  net: phy: fixed formatting issues with braces
  net: phy: fixed space alignment issues
  net: phy: print the function name by __func__ instead of an fixed
    string
  net: phy: remove unnecessary line continuation
  net: phy: use '__packed' instead of '__attribute__((__packed__))'

 drivers/net/phy/bcm87xx.c       |   4 +-
 drivers/net/phy/davicom.c       |   4 +-
 drivers/net/phy/dp83640.c       |   5 +-
 drivers/net/phy/et1011c.c       |  12 +--
 drivers/net/phy/fixed_phy.c     |   4 +-
 drivers/net/phy/lxt.c           |   6 +-
 drivers/net/phy/marvell.c       |   9 +--
 drivers/net/phy/mdio_bus.c      |   1 +
 drivers/net/phy/mdio_device.c   |   4 +-
 drivers/net/phy/mscc/mscc_ptp.h |   4 +-
 drivers/net/phy/national.c      |   6 +-
 drivers/net/phy/phy-c45.c       |   2 +-
 drivers/net/phy/phy-core.c      | 161 ++++++++++++++++++++--------------------
 drivers/net/phy/phy.c           |   3 +-
 drivers/net/phy/phy_device.c    |   9 +--
 drivers/net/phy/phylink.c       |  14 ++--
 drivers/net/phy/qsemi.c         |   1 +
 drivers/net/phy/sfp-bus.c       |  28 +++----
 drivers/net/phy/sfp.c           |   2 +-
 drivers/net/phy/spi_ks8995.c    |  10 +--
 drivers/net/phy/ste10Xp.c       |   6 +-
 drivers/net/phy/vitesse.c       |   3 +-
 22 files changed, 153 insertions(+), 145 deletions(-)

-- 
2.8.1

