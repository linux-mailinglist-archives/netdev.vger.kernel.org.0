Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4254C1653F1
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgBTA5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:57:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:33266 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727362AbgBTA5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 19:57:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 16:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="408621359"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga005.jf.intel.com with ESMTP; 19 Feb 2020 16:57:15 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/12] igc: Fix the typo in comment
Date:   Wed, 19 Feb 2020 16:57:08 -0800
Message-Id: <20200220005713.682605-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
References: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Fix the typo and comment to correspond to the i225 device

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 5d38d0faeced..cb1362188c2a 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -112,7 +112,7 @@ extern char igc_driver_version[];
 #define IGC_RX_HDR_LEN			IGC_RXBUFFER_256
 
 /* Transmit and receive latency (for PTP timestamps) */
-/* FIXME: These values were estimated using the ones that i210 has as
+/* FIXME: These values were estimated using the ones that i225 has as
  * basis, they seem to provide good numbers with ptp4l/phc2sys, but we
  * need to confirm them.
  */
-- 
2.24.1

