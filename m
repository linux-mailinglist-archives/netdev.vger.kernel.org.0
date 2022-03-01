Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60CD4C93B3
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbiCATAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237189AbiCATAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:00:12 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E124D9C6
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646161170; x=1677697170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ECoUXK6lgjBfe+aOlWju3nZhR1T6IzeY9kU3ujSPmME=;
  b=I0VWiOV6gdN+lYWA2rsrGzvD+iioauRrnD0iGflue1AqW5u9Qt4jnCco
   siFS+Pf8VXnMGNKTIOVSwMFRnUFCj52oPGsYZ7TQpAAEI5iAY6raSGIbE
   dHmPmGGPvWRHv19vbxYGI4yx58QWrMmeWO2U0DjVjJN4+IP5yG9sr7Y/A
   YUYWmSCgLN5Nos3bsb0KddSk65f84i0aNlXmoMjzVWtEt/2/bCvenFyGV
   7QNL7MkTT1/jo+XFWBlOeCgENegSuOW9voOiWLrENFD1DlyyUSRzCYwIW
   k0HurnQnFXLYJs2UFKQ7JrUmHe4Dgc/vTjWZXvbX9rhrajzg1WKRsM3/v
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="252042328"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="252042328"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 10:59:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="507908278"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2022 10:59:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Subject: [PATCH net-next 7/7] iavf: Remove non-inclusive language
Date:   Tue,  1 Mar 2022 10:59:39 -0800
Message-Id: <20220301185939.3005116-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
References: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Remove non-inclusive language from the iavf driver.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_common.c | 4 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_status.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index e9cc7f6ddc46..34e46a23894f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -131,8 +131,8 @@ const char *iavf_stat_str(struct iavf_hw *hw, enum iavf_status stat_err)
 		return "IAVF_ERR_INVALID_MAC_ADDR";
 	case IAVF_ERR_DEVICE_NOT_SUPPORTED:
 		return "IAVF_ERR_DEVICE_NOT_SUPPORTED";
-	case IAVF_ERR_MASTER_REQUESTS_PENDING:
-		return "IAVF_ERR_MASTER_REQUESTS_PENDING";
+	case IAVF_ERR_PRIMARY_REQUESTS_PENDING:
+		return "IAVF_ERR_PRIMARY_REQUESTS_PENDING";
 	case IAVF_ERR_INVALID_LINK_SETTINGS:
 		return "IAVF_ERR_INVALID_LINK_SETTINGS";
 	case IAVF_ERR_AUTONEG_NOT_COMPLETE:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2d355a7383a4..56387cec024f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -90,7 +90,7 @@ int iavf_status_to_errno(enum iavf_status status)
 	case IAVF_ERR_UNKNOWN_PHY:
 	case IAVF_ERR_LINK_SETUP:
 	case IAVF_ERR_ADAPTER_STOPPED:
-	case IAVF_ERR_MASTER_REQUESTS_PENDING:
+	case IAVF_ERR_PRIMARY_REQUESTS_PENDING:
 	case IAVF_ERR_AUTONEG_NOT_COMPLETE:
 	case IAVF_ERR_RESET_FAILED:
 	case IAVF_ERR_BAD_PTR:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_status.h b/drivers/net/ethernet/intel/iavf/iavf_status.h
index 46e3d1f6b604..2ea5c7c339bc 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_status.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_status.h
@@ -18,7 +18,7 @@ enum iavf_status {
 	IAVF_ERR_ADAPTER_STOPPED		= -9,
 	IAVF_ERR_INVALID_MAC_ADDR		= -10,
 	IAVF_ERR_DEVICE_NOT_SUPPORTED		= -11,
-	IAVF_ERR_MASTER_REQUESTS_PENDING	= -12,
+	IAVF_ERR_PRIMARY_REQUESTS_PENDING	= -12,
 	IAVF_ERR_INVALID_LINK_SETTINGS		= -13,
 	IAVF_ERR_AUTONEG_NOT_COMPLETE		= -14,
 	IAVF_ERR_RESET_FAILED			= -15,
-- 
2.31.1

