Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B843080A3
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhA1Vj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:39:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:19317 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229892AbhA1VjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 16:39:20 -0500
IronPort-SDR: mLW/40zADu+94zzRVx9ebCmSHZ0hD3b2dbqfFk4Qdo+c9sAS+tB1y1iMoFtTifHsiUbivxitpt
 Ug9r0mKcsvng==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="159491178"
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="159491178"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 13:38:20 -0800
IronPort-SDR: GaOKG5wI95+HChjpJ2wG+fyLXn34emiKvIIYIxT3ZI9cgcORsZUjrem3+HSZK/RRgjoITeLiWY
 neKWV0lUaFZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="474241011"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jan 2021 13:38:20 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Kevin Lo <kevlo@kevlo.org>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Sasha Neftin <sasha.neftin@intel.com>
Subject: [PATCH net 3/4] igc: check return value of ret_val in igc_config_fc_after_link_up
Date:   Thu, 28 Jan 2021 13:38:50 -0800
Message-Id: <20210128213851.2499012-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Lo <kevlo@kevlo.org>

Check return value from ret_val to make error check actually work.

Fixes: 4eb8080143a9 ("igc: Add setup link functionality")
Signed-off-by: Kevin Lo <kevlo@kevlo.org>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 09cd0ec7ee87..67b8ffd21d8a 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -638,7 +638,7 @@ s32 igc_config_fc_after_link_up(struct igc_hw *hw)
 	}
 
 out:
-	return 0;
+	return ret_val;
 }
 
 /**
-- 
2.26.2

