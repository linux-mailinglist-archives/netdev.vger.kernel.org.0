Return-Path: <netdev+bounces-3409-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C06C9706EED
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B43511C20FD4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4633131EE8;
	Wed, 17 May 2023 16:59:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C58E442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:59:29 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB027ABA
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684342766; x=1715878766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aRHNnPI/0HUV3ZT+1gEhQGYMQgzaeggHZDEHIl651s4=;
  b=UXdxFBGj6BLtuOCd9VuBUwSiPtSvrtwD7ojkbgQlux516FOkxNH+1SYY
   V2GltkWX+Wi2WQYJIfTKsC8gBVmb4xPBDwrHI5DZhQ+qxh2OZn6LVraWx
   c7T/fVpefZP6eHHVNFEgKAI1Jmc4XBXJh327zi148MQlpL+Oj5w66No2u
   lKfqZkwtDLMCaYdT4Y3KBjYuQ6hFfDfI29ay6QMMQ6y9BNygA93yoGfYq
   yXU19oMXa+RDiK9fOYa2vljf7qEGRIIsLk9bWQ8E4x3Tkk2gHHWiekJC3
   d3n7TlMcIPWaRGCXRSFMbuJx2UTFmi2jtXV4jr4gNXQy+GbPX3sxq6kIk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="380011566"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="380011566"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 09:59:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="704876784"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="704876784"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 17 May 2023 09:59:17 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	anthony.l.nguyen@intel.com
Subject: [PATCH net-next 5/5] MAINTAINERS: update Intel Ethernet links
Date: Wed, 17 May 2023 09:55:30 -0700
Message-Id: <20230517165530.3179965-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
References: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Freshen up some links, and remove the non-kernel related Sourceforge
link.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 MAINTAINERS | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a83be7caa468..041e3e8e8d52 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10336,9 +10336,8 @@ M:	Jesse Brandeburg <jesse.brandeburg@intel.com>
 M:	Tony Nguyen <anthony.l.nguyen@intel.com>
 L:	intel-wired-lan@lists.osuosl.org (moderated for non-subscribers)
 S:	Supported
-W:	http://www.intel.com/support/feedback.htm
-W:	http://e1000.sourceforge.net/
-Q:	http://patchwork.ozlabs.org/project/intel-wired-lan/list/
+W:	https://www.intel.com/content/www/us/en/support.html
+Q:	https://patchwork.ozlabs.org/project/intel-wired-lan/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git
 F:	Documentation/networking/device_drivers/ethernet/intel/
-- 
2.38.1


