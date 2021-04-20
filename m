Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8809365399
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhDTHzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhDTHzU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 03:55:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB67A6101E;
        Tue, 20 Apr 2021 07:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618905289;
        bh=5md9IdnmH+hmc5sHBWkRX0QIcRXu9vGS6/Al35naVZs=;
        h=From:To:Cc:Subject:Date:From;
        b=G+6PrT2j7oYh80jZCXSBXILryiLNubvBWGtm5c9aPR27j0xnnJsjT2orANrTtrVs9
         JGOs+fkGYy0uVlzlUQbJZ9OzDO7/mGLd9ofytOihf2h9vGHOp1gH/nl+rPktVhcN7S
         SpJlVzv2s+z+LiJFguCw6dfk3Y1M5caOlPVn/FIBz265OrG+JnT3rkGLpXcQkm3vLi
         oyX0aTyg1hbPs4cwGF6IjXt8IGAirUvQbWllz1BxBxZFibRMNMNXvE5jwsIT6k/x/s
         RLfNlEijQxvH6fGwcduHpWkLMKPJX4QaffrQwQRoEfrdekMnyZiSr4OSMCeSxqyeRT
         T9mk9TYR77Xdw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 0/5] net: phy: marvell: some HWMON updates
Date:   Tue, 20 Apr 2021 09:53:58 +0200
Message-Id: <20210420075403.5845-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some updates for Marvell PHY HWMON, mainly
- refactoring for code deduplication
- Amethyst PHY support

Changes since v1:
- addressed Andrew's comments
- fixed macro names
   MII_88E6393_MISC_TEST_SAMPLES_4096 to _2048
   MII_88E6393_MISC_TEST_SAMPLES_8192 to _4096
   ...

Marek Behún (5):
  net: phy: marvell: refactor HWMON OOP style
  net: phy: marvell: fix HWMON enable register for 6390
  net: phy: marvell: use assignment by bitwise AND operator
  net: dsa: mv88e6xxx: simulate Amethyst PHY model number
  net: phy: marvell: add support for Amethyst internal PHY

 drivers/net/dsa/mv88e6xxx/chip.c |   1 +
 drivers/net/phy/marvell.c        | 505 +++++++++++++++----------------
 include/linux/marvell_phy.h      |   1 +
 3 files changed, 250 insertions(+), 257 deletions(-)

-- 
2.26.3

