Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B8F33FC6A
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 01:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhCRAvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 20:51:02 -0400
Received: from mga12.intel.com ([192.55.52.136]:30788 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhCRAu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 20:50:59 -0400
IronPort-SDR: gMybZBIRByJWg+jijAgUmLnd4QUP8aMbAcCDcmBP3xsLezFoiBtU65BJfHnS2vi+vG8I/7RVHI
 JEwm+oDz4tiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="168852713"
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="168852713"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 17:50:58 -0700
IronPort-SDR: NThe0sP+wsRaDL43ZWqqyTqsF139nvSDXrqYQotLgn1+t9JWq7nMOr9W+d4/z2+22epYk2Owtl
 AVB/wo8rK8Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="602458589"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2021 17:50:55 -0700
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
Date:   Thu, 18 Mar 2021 08:50:51 +0800
Message-Id: <20210318005053.31400-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

This patchset adds support for handling EST interrupts and reporting EST
errors. Additionally, the errors are added into ethtool statistic.

Ong Boon Leong (1):
  net: stmmac: Add EST errors into ethtool statistic

Voon Weifeng (1):
  net: stmmac: EST interrupts handling and error reporting

 drivers/net/ethernet/stmicro/stmmac/common.h  |  6 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c  | 86 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h  | 32 +++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  4 +
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  6 ++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +
 6 files changed, 138 insertions(+)

-- 
2.17.1

