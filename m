Return-Path: <netdev+bounces-1216-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CDA6FCB68
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DF9928137A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54113F9E3;
	Tue,  9 May 2023 16:36:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395BEF9DD
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 16:36:49 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E96D10C8
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683650208; x=1715186208;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zuljIzkfizdHuUsUAR0Oz/jiFbRdWXo8zoG65jNaFKE=;
  b=fOukSsk1Fl1KU91BdwF4J3T/VHWzWfk61M7r9W8Gg6AOgumNVpHYZcTe
   Z3B+rXGrEkk9Uar++82hWTV4J1Tfd3w49q2n5nSNZDLE6G04Rsynm0GDf
   KLzss9tKDFO199/TKynmCFmddGjRUPuPX/HK90Mdk4E2GU6Zb2ViJtvd2
   zWKvtmQhSQwCMYy2aoQ1+xKnJ2fu8Qhf+uiaudAimGs/bj7yo3cWYB3ng
   AI5LvFfPdJXPCHYuPciSWThXzZ9kJBajzvTvDHRFECXNNGQ5ifQZ+lx+s
   MK5yN76BTZbYF5FvGlNVnOQBm5+7uyjDXSfYo3cOyQu3HE6HaJEWL+RHs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="339216833"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="339216833"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 09:36:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="823175900"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="823175900"
Received: from bswcg4446240.iind.intel.com ([10.224.174.140])
  by orsmga004.jf.intel.com with ESMTP; 09 May 2023 09:36:29 -0700
From: m.chetan.kumar@linux.intel.com
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	davem@davemloft.net,
	johannes@sipsolutions.net,
	ryazanov.s.a@gmail.com,
	loic.poulain@linaro.org,
	linuxwwan@intel.com,
	m.chetan.kumar@intel.com,
	edumazet@google.com,
	pabeni@redhat.com,
	M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH net-next 1/3] net: wwan: iosm: remove unused macro definition
Date: Tue,  9 May 2023 22:05:55 +0530
Message-Id: <0697e811cb7f10b4fd8f99e66bda1329efdd3d1d.1683649868.git.m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

IOSM_IF_ID_PAYLOAD is defined but not used.
Remove it to avoid unexpected usage.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 4c9022a93e01..ff747fc79aaf 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -18,8 +18,6 @@
 #define IOSM_IP_TYPE_IPV4 0x40
 #define IOSM_IP_TYPE_IPV6 0x60
 
-#define IOSM_IF_ID_PAYLOAD 2
-
 /**
  * struct iosm_netdev_priv - netdev WWAN driver specific private data
  * @ipc_wwan:	Pointer to iosm_wwan struct
-- 
2.34.1


