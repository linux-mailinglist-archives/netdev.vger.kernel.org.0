Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F092D3E43B5
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhHIKRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:17:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:15781 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234896AbhHIKRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 06:17:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="214648734"
X-IronPort-AV: E=Sophos;i="5.84,307,1620716400"; 
   d="scan'208";a="214648734"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 03:17:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,307,1620716400"; 
   d="scan'208";a="483284173"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2021 03:17:05 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id F14CD580910;
        Mon,  9 Aug 2021 03:17:00 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] Intel AlderLake-S 2.5Gbps link speed support 
Date:   Mon,  9 Aug 2021 18:22:27 +0800
Message-Id: <20210809102229.933748-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add 2.5Gbps support for Intel AlderLake-S platform.

Beside register 2.5G callback function in the dwmac_intel driver, an
additional step to not perform xPCS soft reset on driver init is also
required.

Michael Sit Wei Hong (2):
  net: pcs: xpcs: enable skip xPCS soft reset
  stmmac: intel: Enable 2.5Gbps on Intel AlderLake-S

 drivers/net/dsa/sja1105/sja1105_mdio.c           |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c    |  4 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c    |  4 +++-
 drivers/net/pcs/pcs-xpcs.c                       | 16 ++++++++++++----
 include/linux/pcs/pcs-xpcs.h                     |  3 ++-
 include/linux/stmmac.h                           |  1 +
 6 files changed, 23 insertions(+), 7 deletions(-)

-- 
2.25.1

