Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EB927B88D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgI1X7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:59:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:45855 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbgI1X7G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:59:06 -0400
IronPort-SDR: wYxbzVHGEpQeGMxusJnJsomlkQh/sstsW60SolrtrSKDTPcK4TOdO418DwI5pUUFyUHB9VXvti
 0MSUXtd25J+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="142086330"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="142086330"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:30 -0700
IronPort-SDR: X34sc1GkeoEHmlBq2LinE0de+j9uHN/LLanZRTHz8LXRx+CoTn4wmfz+dTTC/EeLqtZPTM8zN2
 ypxrdk8AzSEg==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="311962133"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 14/15] igc: Clean up nvm_info structure
Date:   Mon, 28 Sep 2020 14:50:17 -0700
Message-Id: <20200928215018.952991-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
References: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

flash_bank_size and flash_base_addr field not in use and can
be removed from a nvm_info structure

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 17d6669959db..55dae7c4703f 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -130,9 +130,6 @@ struct igc_nvm_info {
 	struct igc_nvm_operations ops;
 	enum igc_nvm_type type;
 
-	u32 flash_bank_size;
-	u32 flash_base_addr;
-
 	u16 word_size;
 	u16 delay_usec;
 	u16 address_bits;
-- 
2.26.2

