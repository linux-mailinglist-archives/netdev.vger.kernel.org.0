Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FA91DC794
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 09:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgEUH2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 03:28:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:34923 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbgEUH2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 03:28:03 -0400
IronPort-SDR: BTgIz1ihrgswOB+pBRqWfYuDc3LHdeSsNRdBPXv2aUrS+puAKbqeRpBhsqnGWljfd+tPJegmxz
 ib/l5t119tuQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 00:28:02 -0700
IronPort-SDR: 2otU87DgdYVMnxCXCapgJb/nI2A2z3/ZKppLIAKWQkwtqhglHVsmevmznaQ3VSZS8sy//yfT3V
 X7ERZwn0FmVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,417,1583222400"; 
   d="scan'208";a="343758715"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga001.jf.intel.com with ESMTP; 21 May 2020 00:28:00 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/15] igc: Remove unused field from igc_nfc_filter
Date:   Thu, 21 May 2020 00:27:52 -0700
Message-Id: <20200521072758.440264-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521072758.440264-1-jeffrey.t.kirsher@intel.com>
References: <20200521072758.440264-1-jeffrey.t.kirsher@intel.com>
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

