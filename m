Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46E558060D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237245AbiGYU5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237162AbiGYU5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:57:01 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BBC237CC;
        Mon, 25 Jul 2022 13:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658782620; x=1690318620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0kXqfUNi/jgGvAXXtFXYbOie9+AqkuIqUlmkWyVE6ko=;
  b=fFrh/3Jwx8CXohulI86k5jPawm931k8fj9E3fGaIK5jPcxiy9BTp0tTM
   wJFAmAheu8WUUwV+d2XU7C18AqGdJJEet+0SdXIy07vATPST+l3KX/+hq
   6FmHdgYyu5DolvyMfbPpTq5kQJ9FP6DFGwqAU9DLPKXeMGyT2O+O9r3/O
   KRwetQMw+6F0lFdODeoDzyeGa2BVZLHJX9R5vW5QwCrxADfAjMl0lvxf4
   kD014Z5AzTEkuZ2hVv7pexOI/eVAsBkVcnQjwFswd9TpkYKC2yopxjj6I
   ZrAXLITCUPGxJOlRTWunbzRnrEEMC4hOvWxZdXj7DMnfBV+XYHpkJI3jh
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="313548922"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="313548922"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:58 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="550135508"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:58 -0700
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
        linux-doc@vger.kernel.org
Subject: [iproute2-next v3 1/3] update <linux/devlink.h> UAPI header
Date:   Mon, 25 Jul 2022 13:56:48 -0700
Message-Id: <20220725205650.4018731-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
In-Reply-To: <20220725205650.4018731-1-jacob.e.keller@intel.com>
References: <20220725205650.4018731-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
2.35.1.456.ga9c7032d4631

