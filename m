Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F811981D9
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgC3RFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:05:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:10809 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728716AbgC3RFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 13:05:16 -0400
IronPort-SDR: fLNpP5044+TaCMRTELqnln2q1e8m6oHow9XIRjpBZyifY5ra2ojMTd3gfJu7HZlWv8kMjSzEU1
 H9BXvty4Urvw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 10:05:16 -0700
IronPort-SDR: 5/TDhULDr9K4f4azVxRH5osuvGcI9/UOgfezISiV8M41fTzacCl2FrMeWIJyBFfaWGRw0j9mNC
 ghf7hoytlbfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="294667145"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Mar 2020 10:05:13 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [net-next,v2, 0/3] Add additional EHL PCI info and PCI ID
Date:   Tue, 31 Mar 2020 01:05:09 +0800
Message-Id: <20200330170512.22240-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Jose Miguel Abreu for the feedback. Summary of v2 patches:

1/3: As suggested to keep the stmmac_pci.c file simple. So created a new
     file dwmac-intel.c and moved all the Intel specific PCI device out
     of stmmac_pci.c.

2/3: Added Intel(R) Programmable Services Engine (Intel(R) PSE) MAC PCI ID
     and PCI info

3/3: Added EHL 2.5Gbps PCI ID and info

Changes from v1:
-Added a patch to move all Intel specific PCI device from stmmac_pci.c to
 a new file named dwmac-intel.c.
-Combine v1 patch 1/3 and 2/3 into single patch.

Voon Weifeng (3):
  net: stmmac: create dwmac-intel.c to contain all Intel platform
  net: stmmac: add EHL PSE0 & PSE1 1Gbps PCI info and PCI ID
  net: stmmac: add EHL 2.5Gbps PCI info and PCI ID

 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   9 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 592 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  | 313 ---------
 4 files changed, 602 insertions(+), 313 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c

-- 
2.17.1

