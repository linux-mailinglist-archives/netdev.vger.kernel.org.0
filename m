Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80AF751C9F6
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385582AbiEEUKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385588AbiEEUKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:10:42 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25FE5E771
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651781221; x=1683317221;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=90cwBt4qih991xKqniC4jJrkSgtA523bAUMiPVQdVKA=;
  b=WZiv+odJkbi8Wq9uOTCtR2Mxto3bC3EM/W4jGtLy3hePK2Rx//BrgzIi
   QZAAo74UTGVfLqFs87m+DON8rHhKQgmQ7J4GYksPCcq6ko9rE3trZTKlM
   k8PSZFYagCHHmZCZJHZFfppnBqJptzHoBWA/xsRKmWILLbSP640B+5FJh
   hIQzM7W6EDBvrvF+Ye8QvjXJl4LDZWEsXgDXQLJ42U00XFx4hJiIKx0qF
   T+cK3UVNjm8WTTGGLZn0DTe1OvyGeJxjXVPkZNJkqLjQk5+1oBVPKA1fO
   JNGK8tdg0ka41KtSEG3eYCZdh7CztJnVEqSxNWI2Q5UEHILhyDkC8hgwx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="354672209"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="354672209"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 13:07:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="735111728"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 05 May 2022 13:07:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next v2 09/10] ice: add a function comment for ice_cfg_mac_antispoof
Date:   Thu,  5 May 2022 13:03:58 -0700
Message-Id: <20220505200359.3080110-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
References: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
2.35.1

