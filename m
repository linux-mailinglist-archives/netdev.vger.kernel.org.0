Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECA264D451
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 01:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiLOAFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 19:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiLOAFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 19:05:04 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D15A59158
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671062285; x=1702598285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OUm3It5eiUx+fCL6aKNRKthVKH9aGmPJxRhFZgF06UU=;
  b=RkWLwDX6jMxtrb2Nt6mx/CGQ68T/LMJGxKz1czoz7MBvQk/hHut3Gml8
   vnYdAa7cglDTJxLWvqOGwNOFqwNiAQgd3dlu8dqGO+7bdW07L2s1tdFDE
   dmAGUUpE1j/8icRTDmKevmb7NhARGu9dIX8xhwNwb7uetAuT60yRvR359
   ZvLw3ZsE94fz3au7dMAPsNAu0ZE9bC8kLk3z4Qb+2HhWbA+L8CjGpSFlj
   J+wG6TmOFy1PHUMV4DCHBVl57FJ3HS9LRsdXvCebeCkeb8aNnhEcQGmjH
   yEuO1otlyRYL7tMxkcx2w1idfVBYpGPH456Ba0BOMbBvVY83OcnmAQJfY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="301951802"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="301951802"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 15:57:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="773503924"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="773503924"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga004.jf.intel.com with ESMTP; 14 Dec 2022 15:57:25 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, kuba@kernel.org, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH ethtool-next v1 1/3] update UAPI header copies for RSS_GET support
Date:   Wed, 14 Dec 2022 15:54:16 -0800
Message-Id: <20221214235418.1033834-2-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221214235418.1033834-1-sudheer.mogilappagari@intel.com>
References: <20221214235418.1033834-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel
'commit 7112a04664bf ("ethtool:add netlink based get rss support")'

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
 uapi/linux/ethtool_netlink.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index d581c43..0d553ec 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -51,6 +51,7 @@ enum {
 	ETHTOOL_MSG_MODULE_SET,
 	ETHTOOL_MSG_PSE_GET,
 	ETHTOOL_MSG_PSE_SET,
+	ETHTOOL_MSG_RSS_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -97,6 +98,7 @@ enum {
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_PSE_GET_REPLY,
+	ETHTOOL_MSG_RSS_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -880,6 +882,18 @@ enum {
 	ETHTOOL_A_PSE_MAX = (__ETHTOOL_A_PSE_CNT - 1)
 };
 
+enum {
+	ETHTOOL_A_RSS_UNSPEC,
+	ETHTOOL_A_RSS_HEADER,
+	ETHTOOL_A_RSS_CONTEXT,		/* u32 */
+	ETHTOOL_A_RSS_HFUNC,		/* u32 */
+	ETHTOOL_A_RSS_INDIR,		/* binary */
+	ETHTOOL_A_RSS_HKEY,		/* binary */
+
+	__ETHTOOL_A_RSS_CNT,
+	ETHTOOL_A_RSS_MAX = (__ETHTOOL_A_RSS_CNT - 1),
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
-- 
2.31.1

