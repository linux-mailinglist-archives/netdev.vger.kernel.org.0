Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AFF42B3AA
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 05:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237282AbhJMDhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 23:37:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:58999 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhJMDhT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 23:37:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="208138747"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="208138747"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 20:35:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="524469770"
Received: from glass.png.intel.com ([10.158.65.69])
  by orsmga001.jf.intel.com with ESMTP; 12 Oct 2021 20:35:14 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: phy: dp83867 non-OF and loopback support
Date:   Wed, 13 Oct 2021 11:41:26 +0800
Message-Id: <20211013034128.2094426-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

1/2:  TI DP83867 is chosen as Ethernet PHY card that paired with intel
      mGbE controller (stmmac, dw-intel) and used for non-OF platform.
      It is important for DP83867 default settings (RX & TX internal
      delay and IO impedence) are initialied for non-OF platform in order
      to get the basic TX and RX traffics to work.

2/2:  To enable loopback operation enabled/disabled using BMCR register
      that is available for TI DP83867 PHY.

These two patches have been tested on Intel Elkhart Lake board with TI
DP83867 AIC card and other derivative platforms from board vendors

Thanks
Boon Leong

Lay, Kuan Loon (2):
  net: phy: dp83867: introduce critical chip default init for non-of
    platform
  net: phy: dp83867: add generic PHY loopback

 drivers/net/phy/dp83867.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

-- 
2.25.1

