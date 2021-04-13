Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E21E35D969
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhDMH4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhDMH4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 03:56:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 396DF61244;
        Tue, 13 Apr 2021 07:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618300579;
        bh=kVVabL5zdyMp+h1zLrQ68aRA1oeaHd1lXt68E2zSic4=;
        h=From:To:Cc:Subject:Date:From;
        b=DEYp3eSN+Z9eHPfHIMp0VYTOnwlImTRli7uvMRGQZ8I3L0h8IdlCp79dQwIqhESx1
         ygmw3cqQ9GhRkZTppfHIsNwuHSNBMYfn1kpmXUVna2rLqCGDwRoqUcRfMstD7N5RZS
         +2c5RasV6CB1mlcbOaKKovM6KewM1D0MvlXgwWldNJHAOvBb5NZOdLVE6+O7IqTQfm
         UAyNUfJQI3VV+lYKn+4Td4GQBi/dtpN00L8R6GNrDSlX066/iuYkYAkRbzUGcTNGTE
         w8DFKx0pds7NCn4+rVE68hZ9FzVI/8EhGasotz3lNxzz9Ub8+EpoffA26ck/42lJpD
         1/ApYlGp9ItvA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 0/5] net: phy: marvell: some HWMON updates
Date:   Tue, 13 Apr 2021 09:55:33 +0200
Message-Id: <20210413075538.30175-1-kabel@kernel.org>
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

Marek Behún (5):
  net: phy: marvell: refactor HWMON OOP style
  net: phy: marvell: fix HWMON enable register for 6390
  net: phy: marvell: use assignment by bitwise AND operator
  net: dsa: mv88e6xxx: simulate Amethyst PHY model number
  net: phy: marvell: add support for Amethyst internal PHY

 drivers/net/dsa/mv88e6xxx/chip.c |   1 +
 drivers/net/phy/marvell.c        | 507 +++++++++++++++----------------
 include/linux/marvell_phy.h      |   1 +
 3 files changed, 252 insertions(+), 257 deletions(-)

-- 
2.26.3

