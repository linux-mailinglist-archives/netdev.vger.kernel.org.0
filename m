Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A79A3A42BD
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 15:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhFKNN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 09:13:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:51274 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhFKNNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 09:13:25 -0400
IronPort-SDR: pJ3STiFUCnPHLORpzf1uVMrH3EC4mzkdxS7qkcxfxSVjODZ0uZmr24rYh6Lu0rw0GQFhp0JHXO
 ORoPeyegL1uA==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="202494340"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="202494340"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 06:11:27 -0700
IronPort-SDR: ury56IbSMFcCKlCvcXyUq/Y2WXyIrUKlnCyKXhtQ3JmjjFjCPfDVN9lh/Z/7qjYiBqeuwPramp
 5wgAiY0ZwNHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="470635506"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jun 2021 06:11:27 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 916595807AA;
        Fri, 11 Jun 2021 06:11:24 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] stmmac: intel: minor clean-up
Date:   Fri, 11 Jun 2021 21:16:07 +0800
Message-Id: <20210611131609.1685105-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series include two minor-cleanup patches:

  1. Move all the hardcoded DEFINEs to dwmac-intel header file.
  2. Fix the wrong kernel-doc on the intel_eth_pci_remove() function.

Since the changes are minor, only basic sanity tests are done on a
Intel TigerLake with Marvell88E2110 PHY:-

  - Link is up and able to perform ping.
  - phc2sys and ptp4l are running without errors.
 
Wong Vee Khee (2):
  stmmac: intel: move definitions to dwmac-intel header file
  stmmac: intel: fix wrong kernel-doc

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c  | 18 +-----------------
 .../net/ethernet/stmicro/stmmac/dwmac-intel.h  | 16 ++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.25.1

