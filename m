Return-Path: <netdev+bounces-3719-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C80470868A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 489EC281A32
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A3E27219;
	Thu, 18 May 2023 17:14:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71E027210
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 17:14:11 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C284A1B7
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684430043; x=1715966043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tCJv3eQ5SNz817p0HACqrj48JcA38jyTp3pJAVPQaVU=;
  b=fTYej+N5KulDe1SXuQC+aHpuMsFnUh8qWwjByYh0qj9CV+WMrFVxVclZ
   jMjs1eRT/7oOU4inxpV42qzjQPtc82bW2w1XWw223rQXy/oWwwB2f4p+W
   tWfCEH8FV8oM+MkF9PHBt46cgJpyYLnIG8uVCxutJV+2EJETFRUT4G9kS
   ziScJl6IRtheZm9AJv1lCTeFGwVykegoGilezwQcAxdqaEN2sYCsb79Fv
   /C+V2yJavsvIb2msPMwpIg20nwYXldD+20Sw1JVF6xh3pCHgsqVFQCnZr
   QcsGc5af3N4Cuk6I6Mm2/1KvVSEh71lliIOTmpSKAV0uon4u3763yABR2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="354468753"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="354468753"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 10:13:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="702207881"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="702207881"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 18 May 2023 10:13:30 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Baozhu Ni <nibaozhu@yeah.net>,
	anthony.l.nguyen@intel.com,
	sasha.neftin@intel.com,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 3/3] e1000e: Add @adapter description to kdoc
Date: Thu, 18 May 2023 10:09:42 -0700
Message-Id: <20230518170942.418109-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230518170942.418109-1-anthony.l.nguyen@intel.com>
References: <20230518170942.418109-1-anthony.l.nguyen@intel.com>
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
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Baozhu Ni <nibaozhu@yeah.net>

Provide a description for the kernel doc of the @adapter
of e1000e_trigger_lsc()

Signed-off-by: Baozhu Ni <nibaozhu@yeah.net>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index bd7ef59b1f2e..771a3c909c45 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4198,7 +4198,7 @@ void e1000e_reset(struct e1000_adapter *adapter)
 
 /**
  * e1000e_trigger_lsc - trigger an LSC interrupt
- * @adapter: 
+ * @adapter: board private structure
  *
  * Fire a link status change interrupt to start the watchdog.
  **/
-- 
2.38.1


