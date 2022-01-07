Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E2C487BAE
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348664AbiAGR5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:57:51 -0500
Received: from mga18.intel.com ([134.134.136.126]:47970 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348655AbiAGR5n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 12:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641578263; x=1673114263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f+uhi+evyPx+g2DGyxoZMC/xE13sD0sY84+aPu+4xd0=;
  b=VxKpJ0SFLsvLitYAFj7XynJyXt68pFQdL1mG338tzUCkPTCwcUQ2gb4/
   KJJODonmXMUjoVB9EAk5Kdp3eP36beG2azfQmzFweG1jj59IfiAV/JJyJ
   Bsjo7kJHUujErzR8Z/12Zz7e/SVZ6tCCbL6IZk+0TAOYanDmqchEi1KHB
   OI861RDpx8YVaDr7tXSO8KABDL0IFQLp+osC+EqMqNLjJ+yaXNETJ1TQC
   Il7gD7mNqNpH1oOHTW+NLPYmfwsvKNyA12d/e86xh9+S2Pm7apdP66hst
   4990mrUJH2vnVjNazf18CHIXi42GFxQonakAB+4xElK550aPTWgDkpdll
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="229716409"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="229716409"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 09:57:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="668831908"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jan 2022 09:57:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 3/6] i40e: Update FW API version
Date:   Fri,  7 Jan 2022 09:57:01 -0800
Message-Id: <20220107175704.438387-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
References: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Update FW API versions to the newest supported NVM images.

Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index 140b677f114d..60f9e0a6aaca 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -11,8 +11,8 @@
  */
 
 #define I40E_FW_API_VERSION_MAJOR	0x0001
-#define I40E_FW_API_VERSION_MINOR_X722	0x0009
-#define I40E_FW_API_VERSION_MINOR_X710	0x0009
+#define I40E_FW_API_VERSION_MINOR_X722	0x000C
+#define I40E_FW_API_VERSION_MINOR_X710	0x000F
 
 #define I40E_FW_MINOR_VERSION(_h) ((_h)->mac.type == I40E_MAC_XL710 ? \
 					I40E_FW_API_VERSION_MINOR_X710 : \
-- 
2.31.1

