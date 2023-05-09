Return-Path: <netdev+bounces-1217-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 987076FCB72
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3829F28134C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ABBCF9D6;
	Tue,  9 May 2023 16:37:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA0618018
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 16:37:03 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BB13AAE
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683650222; x=1715186222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YFiT4bPCtuXxy6+RTYQDj3JE4QUOovgWV4z/WyuUFrk=;
  b=MY9WYF3sdsvgZ4ttuhOsbYdOAKT6xUuNsFCTCzJu3CKgr419yk3e676J
   i8W96g5RA+klikhDpJPdq7zJ9en5wZs2VxI3vSqECAVnQsDzrxMcYSPU8
   KGzIPhTjyL0ysJAX6NZmZm4bT9sXR9WyQu3mo2TGAe6PV4h3QmPYNOlmg
   uIDtyOE8VUTzJOkQ4CQO/szd5ag4hqrrr7qjPI3yM3wfOG9BRepEql6tV
   8cIwYd/DmTIP1OigfuMgMqfg71iuAghRq1Yzo0VAZz4NkOc8VW7elzDyk
   +6vwJCudDwcSrzmocbc8W3NwRV9X4SG8pZXNI3jw+KYSVBwtz9LJOey7q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="350015266"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="350015266"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 09:37:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="693046582"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="693046582"
Received: from bswcg4446240.iind.intel.com ([10.224.174.140])
  by orsmga007.jf.intel.com with ESMTP; 09 May 2023 09:36:57 -0700
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
Subject: [PATCH net-next 3/3] net: wwan: iosm: clean up unused struct members
Date: Tue,  9 May 2023 22:06:35 +0530
Message-Id: <92ee483d79dfc871ed7408da8fec60b395ff3a9c.1683649868.git.m.chetan.kumar@linux.intel.com>
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

Below members are unused.
- td_tag member defined in struct ipc_pipe.
- adb_finish_timer & params defined in struct iosm_mux.

Remove it to avoid unexpected usage.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.h | 2 --
 drivers/net/wwan/iosm/iosm_ipc_mux.h  | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index 93d57aa7854a..5664ac507c90 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -193,7 +193,6 @@ enum ipc_hp_identifier {
  * @pipe_nr:			Pipe identification number
  * @irq:			Interrupt vector
  * @dir:			Direction of data stream in pipe
- * @td_tag:			Unique tag of the buffer queued
  * @buf_size:			Buffer size (in bytes) for preallocated
  *				buffers (for DL pipes)
  * @nr_of_queued_entries:	Aueued number of entries
@@ -213,7 +212,6 @@ struct ipc_pipe {
 	u32 pipe_nr;
 	u32 irq;
 	enum ipc_mem_pipe_dir dir;
-	u32 td_tag;
 	u32 buf_size;
 	u16 nr_of_queued_entries;
 	u8 is_open:1;
diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux.h b/drivers/net/wwan/iosm/iosm_ipc_mux.h
index 9968bb885c1f..17ca8d1f9397 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux.h
@@ -333,9 +333,7 @@ struct mux_acb {
  * @wwan_q_offset:	This will hold the offset of the given instance
  *			Useful while passing or receiving packets from
  *			wwan/imem layer.
- * @adb_finish_timer:	Timer for forcefully finishing the ADB
  * @acb_tx_sequence_nr: Sequence number for the ACB header.
- * @params:		user configurable parameters
  * @adb_tx_sequence_nr: Sequence number for ADB header
  * @acc_adb_size:       Statistic data for logging
  * @acc_payload_size:   Statistic data for logging
@@ -367,9 +365,7 @@ struct iosm_mux {
 	long long ul_data_pend_bytes;
 	struct mux_acb acb;
 	int wwan_q_offset;
-	struct hrtimer adb_finish_timer;
 	u16 acb_tx_sequence_nr;
-	struct ipc_params *params;
 	u16 adb_tx_sequence_nr;
 	unsigned long long acc_adb_size;
 	unsigned long long acc_payload_size;
-- 
2.34.1


