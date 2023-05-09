Return-Path: <netdev+bounces-1215-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B526FCB67
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:36:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5E9D281356
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05FFF9D5;
	Tue,  9 May 2023 16:36:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EAA1800B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 16:36:48 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC5EE77
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683650207; x=1715186207;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hni16i5Cv4v7UKEYgKZ9dvt/WKA0+SRGtrvmuKFM+mI=;
  b=XjmM28k71GLoY43X8bcxv5mr/Qr2y6EQCyJ/+c30qrOU4ZBSve+EtNI+
   K7ACagj6CYFurMhxE3cnblI/NSpoSFx0afQhxYHHK8gmJyJ8OGytn7f3E
   ggQstOsTywO34ryhUqXLu4F4+sVI8IEHi5s31sjTEVrKL+jAxxpThoxgp
   B0RDYSo3X1pfSTQuUlTLdkCRzfNZye9vq0zy3OaxdbGH4AVI/nV9hXOc4
   Lzd8uqrH3gPmGUTVDXiCYOA75nK1cBz1Saw4bYX2+GHBoc7UM5bXOXqsK
   xrDJU42bzdwNp3e9VbJGVovz17G3vn+EX0ES+02hqmAbuB1wHQAS7h1mI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="350015192"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="350015192"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 09:36:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="693046504"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="693046504"
Received: from bswcg4446240.iind.intel.com ([10.224.174.140])
  by orsmga007.jf.intel.com with ESMTP; 09 May 2023 09:36:44 -0700
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
Subject: [PATCH net-next 2/3] net: wwan: iosm: remove unused enum definition
Date: Tue,  9 May 2023 22:06:22 +0530
Message-Id: <8295a6138f13c686590ee4021384ee992f717408.1683649868.git.m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <0697e811cb7f10b4fd8f99e66bda1329efdd3d1d.1683649868.git.m.chetan.kumar@linux.intel.com>
References: <0697e811cb7f10b4fd8f99e66bda1329efdd3d1d.1683649868.git.m.chetan.kumar@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

ipc_time_unit enum is defined but not used.
Remove it to avoid unexpected usage.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index e700dc8bfe0a..93d57aa7854a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -140,17 +140,6 @@ enum ipc_channel_state {
 	IMEM_CHANNEL_CLOSING,
 };
 
-/* Time Unit */
-enum ipc_time_unit {
-	IPC_SEC = 0,
-	IPC_MILLI_SEC = 1,
-	IPC_MICRO_SEC = 2,
-	IPC_NANO_SEC = 3,
-	IPC_PICO_SEC = 4,
-	IPC_FEMTO_SEC = 5,
-	IPC_ATTO_SEC = 6,
-};
-
 /**
  * enum ipc_ctype - Enum defining supported channel type needed for control
  *		    /IP traffic.
-- 
2.34.1


