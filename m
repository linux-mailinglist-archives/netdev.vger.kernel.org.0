Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FBA513AE5
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350470AbiD1Rav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350493AbiD1Rai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:30:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C8E3EBAD
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651166838; x=1682702838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6isuq11tY6H3N/spkDipw/6QTYg/FFe/WX8PwKHniRo=;
  b=YtAbsAOC31EmPpUap2kedkGa+/EzP9NOIUvG13KtW6uybMvrvUY2eyE+
   fwgxUGDcwJYPgsBfFctuEPqGjeVgtc8/lCfb4ebAbH9TARCckv6U71tqx
   /5jNLw55ugJL9qu0LvyaToO1to2ZNXU/Irb7TPiVNqcRV0BCTabbM4HTn
   fPmV1+sxXhVfYGeG8TkiLtq0WJPfW/ulCCySl2CEZPgcNBsfRGqcmPVFE
   VKTTEvwaYLPHi3ZK3BPG4FDWPjLBL3maSekc0IF31GeVjh/7UscNt0vLx
   ddKWGHEaYUIxtaZ5QocZ46c02rlG/2DsoROPioA0MylFh0RToHLATEKnC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="329306370"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="329306370"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 10:27:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="581497060"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 10:27:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 10/11] ice: add a function comment for ice_cfg_mac_antispoof
Date:   Thu, 28 Apr 2022 10:24:29 -0700
Message-Id: <20220428172430.1004528-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

This function definition was missing a comment describing its
implementation. Add one.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 8f875a17755f..cd8e6b50968c 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -657,6 +657,13 @@ struct ice_port_info *ice_vf_get_port_info(struct ice_vf *vf)
 	return vf->pf->hw.port_info;
 }
 
+/**
+ * ice_cfg_mac_antispoof - Configure MAC antispoof checking behavior
+ * @vsi: the VSI to configure
+ * @enable: whether to enable or disable the spoof checking
+ *
+ * Configure a VSI to enable (or disable) spoof checking behavior.
+ */
 static int ice_cfg_mac_antispoof(struct ice_vsi *vsi, bool enable)
 {
 	struct ice_vsi_ctx *ctx;
-- 
2.31.1

