Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E97A468B8C
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbhLEPAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 10:00:50 -0500
Received: from mga03.intel.com ([134.134.136.65]:20600 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235138AbhLEPAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 10:00:50 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="237132509"
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="237132509"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 06:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="514507330"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2021 06:57:20 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH V2 net-next 7/7] net: wwan: iosm: correct open parenthesis alignment
Date:   Sun,  5 Dec 2021 20:34:55 +0530
Message-Id: <20211205150455.1829929-8-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
References: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix checkpatch warning in iosm_ipc_mmio.c
- Alignment should match open parenthesis

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
v2: No Change.
---
 drivers/net/wwan/iosm/iosm_ipc_mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mmio.c b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
index 09f94c123531..f09e5e77a2a5 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mmio.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
@@ -192,7 +192,7 @@ void ipc_mmio_config(struct iosm_mmio *ipc_mmio)
 	iowrite64(0, ipc_mmio->base + ipc_mmio->offset.ap_win_end);

 	iowrite64(ipc_mmio->context_info_addr,
-			ipc_mmio->base + ipc_mmio->offset.context_info);
+		  ipc_mmio->base + ipc_mmio->offset.context_info);
 }

 void ipc_mmio_set_psi_addr_and_size(struct iosm_mmio *ipc_mmio, dma_addr_t addr,
--
2.25.1

