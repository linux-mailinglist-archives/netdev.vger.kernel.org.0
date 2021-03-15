Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA16633C92F
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 23:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhCOWPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 18:15:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:14823 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhCOWPC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 18:15:02 -0400
IronPort-SDR: qCQkmrYDhC7p05wGgljtQyB5NtSGyK11Nn0Z5KU7BvBC2Y6dGmeueB/HYKFX8rIAoMxxcBX/A2
 TJqD60Dh8rHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="185802455"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="185802455"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 15:15:01 -0700
IronPort-SDR: c0b+b6oRICwJO87b95gI6ipio3zVpkP7x7cmmY3pTJe7+AySSzTTNJf7NmxSzEbTsjEuvNHdAn
 NBm4Xoqj4llA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="410807033"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by orsmga007.jf.intel.com with ESMTP; 15 Mar 2021 15:14:57 -0700
From:   mohammad.athari.ismail@intel.com
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, vee.khee.wong@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net-next 0/2] net: stmmac: EST interrupts and ethtool
Date:   Tue, 16 Mar 2021 06:14:07 +0800
Message-Id: <20210315221409.3867-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

This patchset adds support for handling EST interrupts and reporting EST errors. Additionally, the errors are added into ethtool statistic.

Ong Boon Leong (1):
  net: stmmac: Add EST errors into ethtool statistic

Voon Weifeng (1):
  net: stmmac: EST interrupts handling and error reporting

 drivers/net/ethernet/stmicro/stmmac/common.h  |  6 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c  | 88 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h  | 32 +++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  4 +
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  6 ++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +
 6 files changed, 140 insertions(+)

-- 
2.17.1

