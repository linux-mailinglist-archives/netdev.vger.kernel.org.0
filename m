Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3D4252652
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 06:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgHZEfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 00:35:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:38861 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgHZEfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 00:35:31 -0400
IronPort-SDR: dtdM38uslWRZ4LBkutHLksPaFoxB9wZN31doZSPR6g6mdXaWOEJNVufpz0yhOedZOrqiu2nDIb
 Z8UFljrdmUsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9724"; a="143897913"
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="143897913"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 21:35:31 -0700
IronPort-SDR: gvW+fa0XopgGj4m5A7PsAdai2br24l96G+A6pa6m2O7YebGOXSereuYQmdbZjDhJy3UKu4lk+5
 6vSuqpqA6Tsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="373260389"
Received: from vgjayaku-ilbpg7.png.intel.com ([10.88.227.96])
  by orsmga001.jf.intel.com with ESMTP; 25 Aug 2020 21:35:28 -0700
From:   vineetha.g.jaya.kumaran@intel.com
To:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        weifeng.voon@intel.com, hock.leong.kweh@intel.com,
        boon.leong.ong@intel.com, lakshmi.bai.raja.subramanian@intel.com
Subject: [PATCH v3 0/2]  Add Ethernet support for Intel Keem Bay SoC
Date:   Wed, 26 Aug 2020 12:33:40 +0800
Message-Id: <1598416422-30796-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>

Hello,

This patch set enables support for Ethernet on the Intel Keem Bay SoC.
The first patch contains the required Device Tree bindings documentation, 
while the second patch adds the Intel platform glue layer for the stmmac
device driver.

This driver was tested on the Keem Bay evaluation module board.

Thank you.

Best regards,
Vineetha

Changes since v2:
-Add a select in DT documentation to avoid matching with all nodes containing 'snps,dwmac'
-Rebased to 5.9-rc1

Changes since v1:
-Removed clocks maxItems property from DT bindings documentation
-Removed phy compatible strings from DT bindings documentation

Rusaimi Amira Ruslan (1):
  net: stmmac: Add dwmac-intel-plat for GBE driver

Vineetha G. Jaya Kumaran (1):
  dt-bindings: net: Add bindings for Intel Keem Bay

 .../devicetree/bindings/net/intel,dwmac-plat.yaml  | 130 ++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |  10 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 191 +++++++++++++++++++++
 4 files changed, 332 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c

-- 
1.9.1

