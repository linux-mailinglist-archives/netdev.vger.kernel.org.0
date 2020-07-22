Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1BF22A169
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733037AbgGVVcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:32:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:4542 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733014AbgGVVcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 17:32:03 -0400
IronPort-SDR: e+uURaKccYAlJj4woPW3TUmSGRkPdem4v2cfSQMbY+ix6QGogOOhRaEN0BypUAWdDzgLvsgylC
 Y4tvCoNfn9MA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="137926759"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="137926759"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 14:32:00 -0700
IronPort-SDR: Mq6GComTcTtoTKirHIu+Jt4ttoSYn1ifW836XUnN59Q8rrcUfp5dRBrpUTr8i/zgj1swWXOQ2G
 Klr8O7Y7g+2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="284361360"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 22 Jul 2020 14:32:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 5/8] igc: Remove ledctl_ fields from the mac_info structure
Date:   Wed, 22 Jul 2020 14:31:47 -0700
Message-Id: <20200722213150.383393-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
References: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

LED control currently not implemented.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 2ab7d9fab6af..8066749a55d0 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -83,9 +83,6 @@ struct igc_mac_info {
 	enum igc_mac_type type;
 
 	u32 collision_delta;
-	u32 ledctl_default;
-	u32 ledctl_mode1;
-	u32 ledctl_mode2;
 	u32 mc_filter_type;
 	u32 tx_packet_delta;
 	u32 txcw;
-- 
2.26.2

