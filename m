Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A923E3A42C4
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 15:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhFKNNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 09:13:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:37358 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhFKNNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 09:13:30 -0400
IronPort-SDR: pMBvXXVMgg7swTZBpaFSs2rsyBxgJfD2uUz70uzDdO9pH1ft27V1QaRnSAoXR08A3NwIFDKlIY
 dZ7lWAwm5FHg==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="266671898"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="266671898"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 06:11:32 -0700
IronPort-SDR: 6WvQZ1PEMfDNQTKc6SriAlxRLpmFAIG+8xVVVyjPPXJTuo0V+qnDCJx5mEEBRONvBMh7BxvrLX
 935PO2irKaWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="552689675"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 11 Jun 2021 06:11:32 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id C96CE5808BA;
        Fri, 11 Jun 2021 06:11:29 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] stmmac: intel: fix wrong kernel-doc
Date:   Fri, 11 Jun 2021 21:16:09 +0800
Message-Id: <20210611131609.1685105-3-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611131609.1685105-1-vee.khee.wong@linux.intel.com>
References: <20210611131609.1685105-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel-doc for intel_eth_pci_remove is incorrect, pdev datatype is
struct pci_dev. Changed it to the 'pci device pointer'.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index a38e47e6d470..e0a7d2b17921 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -1087,7 +1087,7 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 /**
  * intel_eth_pci_remove
  *
- * @pdev: platform device pointer
+ * @pdev: pci device pointer
  * Description: this function calls the main to free the net resources
  * and releases the PCI resources.
  */
-- 
2.25.1

