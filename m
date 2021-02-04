Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8400D30E8EE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhBDAuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:50:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:40026 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234463AbhBDAnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:43:12 -0500
IronPort-SDR: 1EvWJkmvoUhelhLG9NpRP3t+nm6kZQocexsK30LmlLwU42q8VPXS4PJIv5NG97L9d6iVLvae7y
 DterMFw9HdBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638225"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638225"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:13 -0800
IronPort-SDR: 2rCP06ghCGsroEKqJtsXpQTtDZ7ztFtOPaUvpqL8QZWuQzFg/YleLyeanFlwta9tIU9dX6ZktB
 w4KoIk3l68UQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687484"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 03/15] igc: Remove MULR mask define
Date:   Wed,  3 Feb 2021 16:42:47 -0800
Message-Id: <20210204004259.3662059-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Multiple Tx Data Read Requests is hardware pipeline feature and
is not controlled by software

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 32f5fd684139..6cc958031fce 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -284,7 +284,6 @@
 #define IGC_TCTL_CT		0x00000ff0 /* collision threshold */
 #define IGC_TCTL_COLD		0x003ff000 /* collision distance */
 #define IGC_TCTL_RTLC		0x01000000 /* Re-transmit on late collision */
-#define IGC_TCTL_MULR		0x10000000 /* Multiple request support */
 
 /* Flow Control Constants */
 #define FLOW_CONTROL_ADDRESS_LOW	0x00C28001
-- 
2.26.2

