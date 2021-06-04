Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9938739BCF5
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhFDQXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:23:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:53967 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230446AbhFDQXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:23:40 -0400
IronPort-SDR: pSjzAw1cLHYs8P7i726EJzeBnVcoz7Wva1Mi7EkOKGh8nXrj1ODJB6wOmPSfBS23lzN9YIe7Q/
 jW9ZDntKpR2Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="184003818"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="184003818"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:21:52 -0700
IronPort-SDR: 2DqXHn/XdvkJCDPVEJq9c+8xjiVqF7zjjvpHJvbbwu9zCii035r+YYGmb00loH2IsLZm/3CtII
 hTerMkwhgW3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="448309156"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jun 2021 09:21:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        vitaly.lifshits@intel.com
Subject: [PATCH net-next 2/5] igc: Remove unused asymmetric pause bit from igc defines
Date:   Fri,  4 Jun 2021 09:24:18 -0700
Message-Id: <20210604162421.3392644-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
References: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

The CR_1000T_ASYM_PAUSE bit from igc defines is not used so remove it.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 0103dda32f39..af2f5e16e994 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -128,7 +128,6 @@
 #define NWAY_LPAR_ASM_DIR	0x0800 /* LP Asymmetric Pause Direction bit */
 
 /* 1000BASE-T Control Register */
-#define CR_1000T_ASYM_PAUSE	0x0080 /* Advertise asymmetric pause bit */
 #define CR_1000T_HD_CAPS	0x0100 /* Advertise 1000T HD capability */
 #define CR_1000T_FD_CAPS	0x0200 /* Advertise 1000T FD capability  */
 
-- 
2.26.2

