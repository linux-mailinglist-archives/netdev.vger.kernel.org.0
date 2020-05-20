Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DB11DA60C
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgETAEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:04:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:15429 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgETAEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 20:04:33 -0400
IronPort-SDR: VGmx3va2HpuGhAqWrgVkBzCpzaSMeLsSk6562U6mWh4MyDAeAz67ZvA0jiaPkGGH8YfEBlvsvc
 SispnBzbb0oQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 17:04:24 -0700
IronPort-SDR: g89GgPz5n2rd3N1m4/lyNE44iCq4p5A22Hgjt1Z+FByVkdAoZ05F7OQxUBM7aGlNLbRIy8vxCW
 0cfwttW5skoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466324793"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 17:04:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/14] igc: Fix MAX_ETYPE_FILTER value
Date:   Tue, 19 May 2020 17:04:15 -0700
Message-Id: <20200520000419.1595788-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The I225 controller has 8 ethertype filters, not 4. This patch fixes the
MAX_ETYPE_FILTER macro accordingly.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index e4169fe955d8..8389569aea8a 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -26,7 +26,7 @@ void igc_set_ethtool_ops(struct net_device *);
 #define MAX_Q_VECTORS			8
 #define MAX_STD_JUMBO_FRAME_SIZE	9216
 
-#define MAX_ETYPE_FILTER		4
+#define MAX_ETYPE_FILTER		8
 #define IGC_RETA_SIZE			128
 
 struct igc_tx_queue_stats {
-- 
2.26.2

