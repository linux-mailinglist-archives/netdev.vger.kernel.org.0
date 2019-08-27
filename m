Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C139E9D517
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733129AbfHZRjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:39:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:54763 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729466AbfHZRjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 13:39:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 10:39:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="355499039"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga005.jf.intel.com with ESMTP; 26 Aug 2019 10:39:01 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH v1 net-next 0/4] Add EHL and TGL PCI info and PCI ID
Date:   Tue, 27 Aug 2019 09:38:07 +0800
Message-Id: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to keep PCI info simple and neat, this patch series have
introduced a 3 hierarchy of struct. First layer will be the
intel_mgbe_common_data struct which keeps all Intel common configuration.
Second layer will be xxx_common_data which keeps all the different Intel
microarchitecture, e.g tgl, ehl. The third layer will be configuration
that tied to the PCI ID only based on speed and RGMII/SGMII interface.

EHL and TGL will also having a higher system clock which is 200Mhz.

Voon Weifeng (4):
  net: stmmac: add EHL SGMII 1Gbps PCI info and PCI ID
  net: stmmac: add TGL SGMII 1Gbps PCI info and PCI ID
  net: stmmac: add EHL RGMII 1Gbps PCI info and PCI ID
  net: stmmac: setup higher frequency clk support for EHL & TGL

 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 172 +++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c |   3 +
 include/linux/stmmac.h                           |   1 +
 3 files changed, 176 insertions(+)

-- 
1.9.1

