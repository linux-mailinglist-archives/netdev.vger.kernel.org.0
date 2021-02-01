Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7019A30B244
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhBAVrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:47:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:26856 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhBAVq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 16:46:59 -0500
IronPort-SDR: zMFUW3djnRIlWUxFvkb/ZVxGxqnJV/8UsFD7oLyQS1kzb7yRfGxyUnJSfBCU40HYyzFfzWs5y1
 Mv1xUsaYeSyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="177249333"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="177249333"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 13:45:35 -0800
IronPort-SDR: lJXxmTkH10t+hNypcDrCBWfCbQkrQ6uQpNr8oG0wN3C4qT/KeuZyKhVfVhiHRoJlkZjG89VCMZ
 XRBMzHX3WqcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="354638544"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 01 Feb 2021 13:45:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Kevin Lo <kevlo@kevlo.org>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Sasha Neftin <sasha.neftin@intel.com>
Subject: [PATCH net v2 3/4] igc: check return value of ret_val in igc_config_fc_after_link_up
Date:   Mon,  1 Feb 2021 13:46:17 -0800
Message-Id: <20210201214618.852831-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210201214618.852831-1-anthony.l.nguyen@intel.com>
References: <20210201214618.852831-1-anthony.l.nguyen@intel.com>
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

