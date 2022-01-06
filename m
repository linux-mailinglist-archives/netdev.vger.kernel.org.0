Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98757486BF9
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 22:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244306AbiAFVeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 16:34:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:23579 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244298AbiAFVeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 16:34:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641504840; x=1673040840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8feBBv29VIsuRi9Hul76s0sY95McOyGKYJZ7NvgT4PM=;
  b=FyG1FXig4xFFsIhtoY08TsYsMuHsIzrjeok7nxJeK4U07MOx+G0w/Nt/
   GpaNYVkitO9aHHp4bU479RNQHvLn3TQxqzBF3kRw2YIa0uLvVHtC0Idak
   F2okbgPCSdKNarmBFgTIimV5IQtTCW4350q+DX+dNfSXM3KB6C6qbjLOI
   45h+4z4+6L3h3mv6dA9QXXPSeMO4gnMByOOtdMN8UYHgKK+mmB3YV/grM
   12SXz7A1pLGQqM3t5jdZleHrxkfi260xVX3zQ9FSNc4rBDSk4zgaQ47o3
   tLSREDFToTg6GbX1osLHaX62A+8xTa9ah8p7dWSSNt7ZPk1uYd7idz6l3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="240296410"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="240296410"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 13:33:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="611972905"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jan 2022 13:33:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Subject: [PATCH net-next 5/7] i40e: Remove non-inclusive language
Date:   Thu,  6 Jan 2022 13:32:59 -0800
Message-Id: <20220106213301.11392-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
References: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
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

