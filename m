Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2745A1D4461
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 06:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgEOEVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 00:21:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:35155 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgEOEVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 00:21:48 -0400
IronPort-SDR: 2eh/0eSzr4Ji0fdBT2FGnjWsTlJk+clknNNUqRbPWa09mJOQKtBiUD/9iL0kg+AwznD39W6bLK
 xXEWKLnhJLxg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 21:21:41 -0700
IronPort-SDR: BVFr0o3MECSeVHJcUdaLKh0Z4L3Z2vQQKB8bZyS3y7TbCI7DOO71BQSsq265JPCFDHsW1sNWjB
 QjVCsYCdQhww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,393,1583222400"; 
   d="scan'208";a="263066088"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 14 May 2020 21:21:41 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 9/9] igc: Remove unneeded register
Date:   Thu, 14 May 2020 21:21:39 -0700
Message-Id: <20200515042139.749859-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515042139.749859-1-jeffrey.t.kirsher@intel.com>
References: <20200515042139.749859-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Flow control status register not applicable for i225 parts
so clean up the unneeded define.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_regs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 633545977a65..5a6110e211fd 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -35,7 +35,6 @@
 #define IGC_FCRTL		0x02160  /* FC Receive Threshold Low - RW */
 #define IGC_FCRTH		0x02168  /* FC Receive Threshold High - RW */
 #define IGC_FCRTV		0x02460  /* FC Refresh Timer Value - RW */
-#define IGC_FCSTS		0x02464  /* FC Status - RO */
 
 /* PCIe Register Description */
 #define IGC_GCR			0x05B00  /* PCIe control- RW */
-- 
2.26.2

