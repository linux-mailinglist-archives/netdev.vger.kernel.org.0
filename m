Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7719522D6AA
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 12:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGYKTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 06:19:13 -0400
Received: from mga12.intel.com ([192.55.52.136]:54026 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgGYKTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 06:19:13 -0400
IronPort-SDR: NAnBdZ+7kxCxEQP2IqQPVgy29NazYtKB/r2S55XbahQARy/kxbDLr4Sb0FFDUhA+fv28ebnNwz
 1e0c5GWT98Bg==
X-IronPort-AV: E=McAfee;i="6000,8403,9692"; a="130382092"
X-IronPort-AV: E=Sophos;i="5.75,394,1589266800"; 
   d="scan'208";a="130382092"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2020 03:19:13 -0700
IronPort-SDR: Ec3yfKE5GuFjLQ5BB0HAAntcV2LxK3HR8rcCqSosoDeoDu45+AF3WDZgofiFvos2uf46XftyLL
 N7RKPeSXL/RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,394,1589266800"; 
   d="scan'208";a="327549422"
Received: from vgjayaku-ilbpg7.png.intel.com ([10.88.227.96])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Jul 2020 03:19:11 -0700
From:   vineetha.g.jaya.kumaran@intel.com
To:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        weifeng.voon@intel.com, hock.leong.kweh@intel.com,
        boon.leong.ong@intel.com
Subject: [PATCH v2 0/2] Add Ethernet support for Intel Keem Bay SoC
Date:   Sat, 25 Jul 2020 18:17:57 +0800
Message-Id: <1595672279-13648-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
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

Changes since v1:
-Removed clocks maxItems property from DT bindings documentation
-Removed phy compatible strings from DT bindings documentation

Rusaimi Amira Ruslan (1):
  net: stmmac: Add dwmac-intel-plat for GBE driver

Vineetha G. Jaya Kumaran (1):
  dt-bindings: net: Add bindings for Intel Keem Bay

 .../devicetree/bindings/net/intel,dwmac-plat.yaml  | 121 +++++++++++++
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |  10 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 191 +++++++++++++++++++++
 4 files changed, 323 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c

-- 
1.9.1

