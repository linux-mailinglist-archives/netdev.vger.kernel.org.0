Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47EAB57D5AF
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 23:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiGUVPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 17:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbiGUVP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 17:15:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2781C5727C;
        Thu, 21 Jul 2022 14:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658438127; x=1689974127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bz91TNeeBfGTVdIdZvjlrnngeTyrZBksJ2a1iP5sz44=;
  b=HlAYywwVqivU2YTi19n/cL1tyo3FmDl9tqWOpfRcE2hUHkwtLloY2ITO
   pnzw2iMpm3WQueydHp3YG78+3fw+To3HKqhvKVLu/d80w+EsXeL7Ve6tD
   rUBDFFgzTqtIuEmNdABpmlN46xRFS+xOxFyKKf+fbnIyUhesV0+ak4t91
   lXSLXk1keiVtBgHhmx6D1KLV2IduCXwQjc0jrnSo1PIpgmCTIivZQTvI4
   bxcjfCylqlJFtTloM/Ye41FHycQubPwJpLmvc/ywvWqB7mz/PwSowiknK
   f4KJFEMLTBeQ4XiE5S/bY6lQoJM3gl9r1PPRs5p7dkSn+NhoYKiK/zTpn
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="312892789"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="312892789"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 14:15:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="925816212"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 14:14:59 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [iproute2-next v2 1/3] update <linux/devlink.h> UAPI header
Date:   Thu, 21 Jul 2022 14:14:49 -0700
Message-Id: <20220721211451.2475600-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.456.ga9c7032d4631
In-Reply-To: <20220721211451.2475600-1-jacob.e.keller@intel.com>
References: <20220721211451.2475600-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/uapi/linux/devlink.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index da0f1ba8f7a0..90f6cf97d308 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -576,6 +576,14 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
+	/* Before adding this attribute to a command, user space should check
+	 * the policy dump and verify the kernel recognizes the attribute.
+	 * Otherwise older kernels which do not recognize the attribute may
+	 * silently accept the unknown attribute while not actually performing
+	 * a dry run.
+	 */
+	DEVLINK_ATTR_DRY_RUN,			/* flag */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.36.1

