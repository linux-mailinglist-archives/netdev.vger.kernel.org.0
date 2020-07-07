Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3876216586
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 06:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgGGEtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 00:49:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:18686 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbgGGEtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 00:49:06 -0400
IronPort-SDR: EpaEcoGHdfrCfNbOFQmKVimyoThE4SmX2E7Hv41mGqlF57QeSeCZPaivjAxKqKaHnUmxEhoP+E
 pD6PmdtRZ2VA==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="127625362"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="127625362"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 21:49:06 -0700
IronPort-SDR: ZziL/FOyVWI3UFNsNz29L18g0qIbRxyaZ5ZjeoMNUi2vZ6LkMAWlo7Rk5iCuf70J1+BTNXAq1c
 SV8+ZQ9R1gRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="279485168"
Received: from vgjayaku-ilbpg7.png.intel.com ([10.88.227.96])
  by orsmga003.jf.intel.com with ESMTP; 06 Jul 2020 21:49:03 -0700
From:   vineetha.g.jaya.kumaran@intel.com
To:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        weifeng.voon@intel.com, hock.leong.kweh@intel.com,
        boon.leong.ong@intel.com
Subject: [PATCH 0/2] Add Ethernet support for Intel Keem Bay SoC
Date:   Tue,  7 Jul 2020 12:47:16 +0800
Message-Id: <1594097238-8827-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
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

Rusaimi Amira Ruslan (1):
  net: stmmac: Add dwmac-intel-plat for GBE driver

Vineetha G. Jaya Kumaran (1):
  dt-bindings: net: Add bindings for Intel Keem Bay

 .../devicetree/bindings/net/intel,dwmac-plat.yaml  | 123 +++++++++++++
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |  10 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 191 +++++++++++++++++++++
 4 files changed, 325 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c

-- 
1.9.1

