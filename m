Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C7334658E
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhCWQm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:42:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:4837 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233062AbhCWQma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 12:42:30 -0400
IronPort-SDR: 6OIzuYq0mtzTUCYhD0ijkZoKapCKySfn/cY2n0eg8/+uYr5p6MtcCi2dbEsvGNNorTv/fVDodn
 p/a7+FMd0tUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="169849057"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="169849057"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 09:42:29 -0700
IronPort-SDR: SIqztD57fqzEqbYXR3xABWOT5+LJEqclamlJMDjNI4nl8Eul+Ezx0U7j+XtEPQRS4Oh1uLtn4o
 7W+uyeizxabg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="441779995"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 23 Mar 2021 09:42:29 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id EABEE58069F;
        Tue, 23 Mar 2021 09:42:26 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 0/2] Add support for Clause-45 PHY Loopback
Date:   Wed, 24 Mar 2021 00:46:39 +0800
Message-Id: <20210323164641.26059-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add support for Clause-45 PHY loopback.

It involves adding a generic API in the PHY framework, which can be
accessed by all C45 PHY drivers using the .set_loopback callback.

Also, enable PHY loopback for the Marvell 88x3310/88x2110 driver.

Wong Vee Khee (2):
  net: phy: add genphy_c45_loopback
  net: phy: marvell10g: Add PHY loopback support

 drivers/net/phy/marvell10g.c | 2 ++
 drivers/net/phy/phy-c45.c    | 8 ++++++++
 include/linux/phy.h          | 1 +
 3 files changed, 11 insertions(+)

-- 
2.25.1

