Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCF034278A
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhCSVQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:16:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:20604 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230186AbhCSVP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:15:59 -0400
IronPort-SDR: foSwQeOD/Gf9r0ONjskosGVLvuqLDA8QX/hNYe0W7cYxTZZtg8EyV57sxEQKdZ7XeaR0JcDqyM
 osVg80tbXIdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="177554727"
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="177554727"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 14:15:57 -0700
IronPort-SDR: k31xIxjsg1VDhmbLjjhU758Gu0YQPaUb8/HDo/PfbOSzfsAcadHyKqPaaxRqnb3qv5jbMCFQWC
 y3PirUtxs2Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="451005076"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 19 Mar 2021 14:15:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 3/5] igc: Remove unused MII_CR_LOOPBACK
Date:   Fri, 19 Mar 2021 14:17:21 -0700
Message-Id: <20210319211723.1488244-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210319211723.1488244-1-anthony.l.nguyen@intel.com>
References: <20210319211723.1488244-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

MII_CR_LOOPBACK masks not in use in i225 device and can be removed.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 59043c3c5657..35ed997af075 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -441,7 +441,6 @@
 #define MII_CR_RESTART_AUTO_NEG	0x0200  /* Restart auto negotiation */
 #define MII_CR_POWER_DOWN	0x0800  /* Power down */
 #define MII_CR_AUTO_NEG_EN	0x1000  /* Auto Neg Enable */
-#define MII_CR_LOOPBACK		0x4000  /* 0 = normal, 1 = loopback */
 
 /* PHY Status Register */
 #define MII_SR_LINK_STATUS	0x0004 /* Link Status 1 = link */
-- 
2.26.2

