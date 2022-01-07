Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D10487BAC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348659AbiAGR5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:57:48 -0500
Received: from mga18.intel.com ([134.134.136.126]:47970 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348657AbiAGR5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 12:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641578264; x=1673114264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2RK0AaFvqVtJ483G4qvCoGrrh3H1hBCHk16MAHe29wU=;
  b=JGeIsfiOb16UFsg2GD2bd8FIWyJemYy+gC+NTQKzdKeULkenefIrZqo/
   2h1Z62EOo2OCpy+ObTw8rEjMXoOWIZGl99jXUsFuMuHZYY52MyaUxd2bW
   XR6yG0wQnMuwxPibdzeEVNaYoX8IOtbjIweiBsmRUPTQ6ExAYwKDSPFhI
   TokFj+2dCmxA6RQOthqV1arI1sHJAJWMFJ0pXWQw9vyPxBx085BR3cOZW
   EYK+L9y8mMzjXwOxv4zKtIXvIGdo0rGNu6Tpxxn+ZQgPNH+4ilJjpShyg
   XEm0iNnSincUqwiPWJ6E/P6NSnvGmn+QXMcrBcgbk3pcW7QAUUYjmY2C2
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="229716413"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="229716413"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 09:57:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="668831918"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jan 2022 09:57:43 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Abaci Robot <abaci@linux.alibaba.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 5/6] i40e: remove variables set but not used
Date:   Fri,  7 Jan 2022 09:57:03 -0800
Message-Id: <20220107175704.438387-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
References: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

The code that uses variables pe_cntx_size and pe_filt_size
has been removed, so they should be removed as well.

Eliminate the following clang warnings:
drivers/net/ethernet/intel/i40e/i40e_common.c:4139:20:
warning: variable 'pe_filt_size' set but not used.
drivers/net/ethernet/intel/i40e/i40e_common.c:4139:6:
warning: variable 'pe_cntx_size' set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 56cb2c62e52d..9ddeb015eb7e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -4138,7 +4138,6 @@ static i40e_status i40e_validate_filter_settings(struct i40e_hw *hw,
 				struct i40e_filter_control_settings *settings)
 {
 	u32 fcoe_cntx_size, fcoe_filt_size;
-	u32 pe_cntx_size, pe_filt_size;
 	u32 fcoe_fmax;
 	u32 val;
 
@@ -4182,8 +4181,6 @@ static i40e_status i40e_validate_filter_settings(struct i40e_hw *hw,
 	case I40E_HASH_FILTER_SIZE_256K:
 	case I40E_HASH_FILTER_SIZE_512K:
 	case I40E_HASH_FILTER_SIZE_1M:
-		pe_filt_size = I40E_HASH_FILTER_BASE_SIZE;
-		pe_filt_size <<= (u32)settings->pe_filt_num;
 		break;
 	default:
 		return I40E_ERR_PARAM;
@@ -4200,8 +4197,6 @@ static i40e_status i40e_validate_filter_settings(struct i40e_hw *hw,
 	case I40E_DMA_CNTX_SIZE_64K:
 	case I40E_DMA_CNTX_SIZE_128K:
 	case I40E_DMA_CNTX_SIZE_256K:
-		pe_cntx_size = I40E_DMA_CNTX_BASE_SIZE;
-		pe_cntx_size <<= (u32)settings->pe_cntx_num;
 		break;
 	default:
 		return I40E_ERR_PARAM;
-- 
2.31.1

