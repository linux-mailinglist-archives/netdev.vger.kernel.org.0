Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8F042258D
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhJELrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:47:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:61521 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233672AbhJELrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 07:47:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="223132354"
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="223132354"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 04:45:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="477646370"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 05 Oct 2021 04:44:52 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id D46EE5805EE;
        Tue,  5 Oct 2021 04:44:48 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Wong Vee Khee <veekhee@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net 0/2] net: stmmac: Turn off EEE on MAC link down
Date:   Tue,  5 Oct 2021 19:50:58 +0800
Message-Id: <20211005115100.1648170-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series ensure PCS EEE is turned off on the event of MAC
link down.

Tested on Intel AlderLake-S (STMMAC + MaxLinear GPY211 PHY).

Wong Vee Khee (2):
  net: pcs: xpcs: fix incorrect steps on disable EEE
  net: stmmac: trigger PCS EEE to turn off on link down

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  6 +++++-
 drivers/net/pcs/pcs-xpcs.c                        | 13 +++++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

-- 
2.25.1

