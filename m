Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359E447C627
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241116AbhLUSQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:16:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:10323 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241107AbhLUSQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:16:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110583; x=1671646583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0YGphBLdVUghFpOfj7hM4ZYD/4s4TSSz/ittix+Z9OI=;
  b=fWOryr4t9qO+y5bsf3E8alLC+wFrXuOmU/oh8USSAHYPDr+/RR4kMr9X
   XcsRH6ls5Oqlq944jXtJGHiFLjp52jXZIeEfecoh3HvrwI1KstEfhLuUq
   36kSRAg2sLIwU2Ss+QdAaqBihyy/zJ5sonMexZuS04v8ck+AUw5/XK+Tt
   b4lHIpEfNmvqsU0d4MBKYhPctIMLDhKSuSrdwKGY3TIKFHF36m2RWQFHs
   GiJq93RqRIHQBcEFXCCEWxKok9zYvdUmAsX10BqTbpzRyAJdp47K3flD2
   mSEgEvWHuGZ30XdqxqZPXE1hKvU4hV16Jt8nqkxV4nuaMXqNjXscAzQE6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240684219"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240684219"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 10:02:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="613557848"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 21 Dec 2021 10:02:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 5/8] igc: Remove obsolete define
Date:   Tue, 21 Dec 2021 10:01:57 -0800
Message-Id: <20211221180200.3176851-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
References: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

'MII_CR_FULL_DUPLEX' define not in use. This patch comes to tidy up
 obsolete define.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index bf2c31d1549c..5c66b97c0cfa 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -581,7 +581,6 @@
 #define IGC_GEN_POLL_TIMEOUT	1920
 
 /* PHY Control Register */
-#define MII_CR_FULL_DUPLEX	0x0100  /* FDX =1, half duplex =0 */
 #define MII_CR_RESTART_AUTO_NEG	0x0200  /* Restart auto negotiation */
 #define MII_CR_POWER_DOWN	0x0800  /* Power down */
 #define MII_CR_AUTO_NEG_EN	0x1000  /* Auto Neg Enable */
-- 
2.31.1

