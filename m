Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBAA67BE31
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbjAYVYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbjAYVYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:24:38 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3B845F6E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674681877; x=1706217877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vme2vVxI/vwdRGLXseUPe+lknPGoYIMo8dx5PL9Bwak=;
  b=LKpTFgn19zTmze4fU/nKoa9+GTCfXtkGtmmP1kx2Aew/aRzlsQNK8FGS
   rMM9mjluGDxGfgmgfXVlhAl3psdGXerpcpGrvqqjcwHsmtRvxUqNQL96J
   6MWP3JsfcSsD1lz4OMS438jGXonscazJfYc2S1IvYQ1h8NclOXNTtZXOY
   8MB/jn4mkKPmH2k6Zw5FdtFPVJ4GsBOgJcRAmK51nz4+A2nxrZqIt6f9b
   mHgSl3yM2WlZH02RrZKg1Wvob6foI+wtjCVBwK3cipEOqkIQhl+Xu9ZOr
   RO8J/4wbbuwDfCQ2SnKYxIE8V4RQh1pV01qHpE6axl841BCmxzGlnr1kp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="328767486"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="328767486"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 13:24:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="770894103"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="770894103"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jan 2023 13:24:35 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 1/4] virtchnl: remove unused structure declaration
Date:   Wed, 25 Jan 2023 13:24:38 -0800
Message-Id: <20230125212441.4030014-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230125212441.4030014-1-anthony.l.nguyen@intel.com>
References: <20230125212441.4030014-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Nothing uses virtchnl_msg, just remove it.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/linux/avf/virtchnl.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index d91af50ac58d..b1cfa84904b1 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -162,19 +162,6 @@ enum virtchnl_ops {
 #define VIRTCHNL_CHECK_UNION_LEN(n, X) enum virtchnl_static_asset_enum_##X \
 	{ virtchnl_static_assert_##X = (n)/((sizeof(union X) == (n)) ? 1 : 0) }
 
-/* Virtual channel message descriptor. This overlays the admin queue
- * descriptor. All other data is passed in external buffers.
- */
-
-struct virtchnl_msg {
-	u8 pad[8];			 /* AQ flags/opcode/len/retval fields */
-	enum virtchnl_ops v_opcode; /* avoid confusion with desc->opcode */
-	enum virtchnl_status_code v_retval;  /* ditto for desc->retval */
-	u32 vfid;			 /* used by PF when sending to VF */
-};
-
-VIRTCHNL_CHECK_STRUCT_LEN(20, virtchnl_msg);
-
 /* Message descriptions and data structures. */
 
 /* VIRTCHNL_OP_VERSION
-- 
2.38.1

