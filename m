Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D0D1DDBD7
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbgEVALb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:11:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:41703 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730631AbgEVALO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:11:14 -0400
IronPort-SDR: zOoAwVFSHnrvOrToLkWy0DJB/Px2/a6ogLIgqgN16BAYXePdbTrT9/Qt5ZaPOdyVcf5CyCSK6o
 SiI1sjnU2ZqA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 17:11:11 -0700
IronPort-SDR: MvuEG/LatDdi0BW28mQrAMs8ikJElteNx27DueOjeG7gyVuEFMiI9HqQFYSDi28lft5FjL9mSi
 vp4m3HjIh58Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="254133950"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 May 2020 17:11:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 09/15] igc: Remove unused field from igc_nfc_filter
Date:   Thu, 21 May 2020 17:11:02 -0700
Message-Id: <20200522001108.1675149-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
References: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The 'cookie' field is not used anywhere in the code so this patch
removes it from struct igc_nfc_filter.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index b501be243536..7c92fc7703be 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -470,7 +470,6 @@ struct igc_nfc_input {
 struct igc_nfc_filter {
 	struct hlist_node nfc_node;
 	struct igc_nfc_input filter;
-	unsigned long cookie;
 	u16 sw_idx;
 	u16 action;
 };
-- 
2.26.2

