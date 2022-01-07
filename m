Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38095487BAD
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348662AbiAGR5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:57:50 -0500
Received: from mga18.intel.com ([134.134.136.126]:47971 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348642AbiAGR5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 12:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641578263; x=1673114263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8feBBv29VIsuRi9Hul76s0sY95McOyGKYJZ7NvgT4PM=;
  b=L0vUXnFdP+smqnxUWuhun+4cHdoDnFESnfp7Tq+okujwbmJ80uNP2OaI
   pYqpvN/oCKYwXovO7xOj02I0uWObLvmPKO8GPzpIrnbU7SpI0yuwI+PJF
   vEBU/5pnvEuAVAVH3nyxijcx5E51R5mZH3DVM81439T35PnANaL/dEX6N
   DwR8jm1mPiZGcmRRyGdR68KslsvAR4XPH5zJ4qc8SCFM5XHVl2CzHYMln
   vstYramYecRSc0EZw2jLCH2k8ohFOUROE1HkQ4bx0jsVfkzyeBlVT6wDG
   LMu7Kaly6ltWrbNcEgoHDgY41eRkWLVC+0dvXc/rulQTUfWsKd64E6PUB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="229716412"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="229716412"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 09:57:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="668831911"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jan 2022 09:57:43 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Subject: [PATCH net-next v2 4/6] i40e: Remove non-inclusive language
Date:   Fri,  7 Jan 2022 09:57:02 -0800
Message-Id: <20220107175704.438387-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
References: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Remove non-inclusive language from the driver.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_status.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index f81a674c8d40..56cb2c62e52d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -154,8 +154,8 @@ const char *i40e_stat_str(struct i40e_hw *hw, i40e_status stat_err)
 		return "I40E_ERR_INVALID_MAC_ADDR";
 	case I40E_ERR_DEVICE_NOT_SUPPORTED:
 		return "I40E_ERR_DEVICE_NOT_SUPPORTED";
-	case I40E_ERR_MASTER_REQUESTS_PENDING:
-		return "I40E_ERR_MASTER_REQUESTS_PENDING";
+	case I40E_ERR_PRIMARY_REQUESTS_PENDING:
+		return "I40E_ERR_PRIMARY_REQUESTS_PENDING";
 	case I40E_ERR_INVALID_LINK_SETTINGS:
 		return "I40E_ERR_INVALID_LINK_SETTINGS";
 	case I40E_ERR_AUTONEG_NOT_COMPLETE:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_status.h b/drivers/net/ethernet/intel/i40e/i40e_status.h
index 77be0702d07c..db3714a65dc7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_status.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_status.h
@@ -18,7 +18,7 @@ enum i40e_status_code {
 	I40E_ERR_ADAPTER_STOPPED		= -9,
 	I40E_ERR_INVALID_MAC_ADDR		= -10,
 	I40E_ERR_DEVICE_NOT_SUPPORTED		= -11,
-	I40E_ERR_MASTER_REQUESTS_PENDING	= -12,
+	I40E_ERR_PRIMARY_REQUESTS_PENDING	= -12,
 	I40E_ERR_INVALID_LINK_SETTINGS		= -13,
 	I40E_ERR_AUTONEG_NOT_COMPLETE		= -14,
 	I40E_ERR_RESET_FAILED			= -15,
-- 
2.31.1

