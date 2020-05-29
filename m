Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11DC1E7510
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgE2Eki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:40325 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgE2EkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:17 -0400
IronPort-SDR: fsgtAfGC6FNEwOjnxf+Z9s6Cz6W+yY6WUE4XlG8Md2f6GYSWM4dIyECgtgDx8h1cdN9SnggPf2
 VzAxFluuvgAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:06 -0700
IronPort-SDR: RbPBu7d4PbQQH9HhLmF2faGtF/wu9Wqrpygwx1BPcOQtiN1WM3feC+RgVhTW2Zn7UGz6+RGKkw
 +cC13jiB3gSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850926"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/17] igc: Fix IGC_MAX_RXNFC_RULES
Date:   Thu, 28 May 2020 21:39:57 -0700
Message-Id: <20200529044004.3725307-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
References: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

IGC supports a total of 32 rules. 16 MAC address based, 8 VLAN priority
based, and 8 Ethertype based. This patch fixes IGC_MAX_RXNFC_RULES
accordingly.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 14f9edaaaf83..5dbc5a156626 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -457,7 +457,10 @@ struct igc_nfc_rule {
 	u16 action;
 };
 
-#define IGC_MAX_RXNFC_RULES		16
+/* IGC supports a total of 32 NFC rules: 16 MAC address based,, 8 VLAN priority
+ * based, and 8 ethertype based.
+ */
+#define IGC_MAX_RXNFC_RULES		32
 
 /* igc_desc_unused - calculate if we have unused descriptors */
 static inline u16 igc_desc_unused(const struct igc_ring *ring)
-- 
2.26.2

