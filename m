Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A4E660929
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 22:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbjAFV73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 16:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235901AbjAFV7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 16:59:21 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702FF6B5F1;
        Fri,  6 Jan 2023 13:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673042360; x=1704578360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SSz6BzP2REm+D8MWs8FHchah/89P2zMYb+LTILGyOH0=;
  b=Lz0IRZY4A30z7DBfUdVognpVAMZY8c76zAH3/VaaDISgHFJ36lP+ZwH7
   roBhmtYRZAn+/DUZ9cf/ml4doaGHs6LhdZjzFhorXITEaNanancI2hZ1J
   miOGyKf3HdQifzDL8I4KkM4qBosaLPRS8qf0n1/w9/BHNS2XQTXAst2m2
   L+Jms2mEYhvZvyiMEZZ7HlVLde2bsL3+BEpKWTOLMDubGPEGXITO3et1o
   Z631Fkf3x2W+xB92Dg3uQBdu483JIgcc7oll408BKlrMw6527KrGOACS4
   YMW1BLKlrYnzs6/hA6QXZaTkq4XWi2n6sR/OeFRBFz1mxF74UlFtakoO2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="387030718"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="387030718"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 13:59:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="763652895"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="763652895"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.60])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jan 2023 13:59:16 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next 6/7] sunvnet: Remove event tracing file
Date:   Fri,  6 Jan 2023 14:00:19 -0800
Message-Id: <20230106220020.1820147-7-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
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

An earlier patch removed the Sun LDOM vswitch and sunvnet drivers, and
as a result, nothing includes sunvnet.h anymore. Remove it.

Note:

checkpatch complains "WARNING: added, moved or deleted file(s), does
MAINTAINERS need updating?". The file being removed doesn't have its
own entry in the MAINTAINERS file, so there's nothing to remove.

Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
 include/trace/events/sunvnet.h | 140 ---------------------------------
 1 file changed, 140 deletions(-)
 delete mode 100644 include/trace/events/sunvnet.h

diff --git a/include/trace/events/sunvnet.h b/include/trace/events/sunvnet.h
deleted file mode 100644
index 8d444f1..00000000
--- a/include/trace/events/sunvnet.h
+++ /dev/null
@@ -1,140 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM sunvnet
-
-#if !defined(_TRACE_SUNVNET_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_SUNVNET_H
-
-#include <linux/tracepoint.h>
-
-TRACE_EVENT(vnet_rx_one,
-
-	TP_PROTO(int lsid, int rsid, int index, int needs_ack),
-
-	TP_ARGS(lsid, rsid, index, needs_ack),
-
-	TP_STRUCT__entry(
-		__field(int, lsid)
-		__field(int, rsid)
-		__field(int, index)
-		__field(int, needs_ack)
-	),
-
-	TP_fast_assign(
-		__entry->lsid = lsid;
-		__entry->rsid = rsid;
-		__entry->index = index;
-		__entry->needs_ack = needs_ack;
-	),
-
-	TP_printk("(%x:%x) walk_rx_one index %d; needs_ack %d",
-		__entry->lsid, __entry->rsid,
-		__entry->index, __entry->needs_ack)
-);
-
-DECLARE_EVENT_CLASS(vnet_tx_stopped_ack_template,
-
-	TP_PROTO(int lsid, int rsid, int ack_end, int npkts),
-
-	TP_ARGS(lsid, rsid, ack_end, npkts),
-
-	TP_STRUCT__entry(
-		__field(int, lsid)
-		__field(int, rsid)
-		__field(int, ack_end)
-		__field(int, npkts)
-	),
-
-	TP_fast_assign(
-		__entry->lsid = lsid;
-		__entry->rsid = rsid;
-		__entry->ack_end = ack_end;
-		__entry->npkts = npkts;
-	),
-
-	TP_printk("(%x:%x) stopped ack for %d; npkts %d",
-		__entry->lsid, __entry->rsid,
-		__entry->ack_end, __entry->npkts)
-);
-DEFINE_EVENT(vnet_tx_stopped_ack_template, vnet_tx_send_stopped_ack,
-	     TP_PROTO(int lsid, int rsid, int ack_end, int npkts),
-	     TP_ARGS(lsid, rsid, ack_end, npkts));
-DEFINE_EVENT(vnet_tx_stopped_ack_template, vnet_tx_defer_stopped_ack,
-	     TP_PROTO(int lsid, int rsid, int ack_end, int npkts),
-	     TP_ARGS(lsid, rsid, ack_end, npkts));
-DEFINE_EVENT(vnet_tx_stopped_ack_template, vnet_tx_pending_stopped_ack,
-	     TP_PROTO(int lsid, int rsid, int ack_end, int npkts),
-	     TP_ARGS(lsid, rsid, ack_end, npkts));
-
-TRACE_EVENT(vnet_rx_stopped_ack,
-
-	TP_PROTO(int lsid, int rsid, int end),
-
-	TP_ARGS(lsid, rsid, end),
-
-	TP_STRUCT__entry(
-		__field(int, lsid)
-		__field(int, rsid)
-		__field(int, end)
-	),
-
-	TP_fast_assign(
-		__entry->lsid = lsid;
-		__entry->rsid = rsid;
-		__entry->end = end;
-	),
-
-	TP_printk("(%x:%x) stopped ack for index %d",
-		__entry->lsid, __entry->rsid, __entry->end)
-);
-
-TRACE_EVENT(vnet_tx_trigger,
-
-	TP_PROTO(int lsid, int rsid, int start, int err),
-
-	TP_ARGS(lsid, rsid, start, err),
-
-	TP_STRUCT__entry(
-		__field(int, lsid)
-		__field(int, rsid)
-		__field(int, start)
-		__field(int, err)
-	),
-
-	TP_fast_assign(
-		__entry->lsid = lsid;
-		__entry->rsid = rsid;
-		__entry->start = start;
-		__entry->err = err;
-	),
-
-	TP_printk("(%x:%x) Tx trigger for %d sent with err %d %s",
-		__entry->lsid, __entry->rsid, __entry->start,
-		__entry->err, __entry->err > 0 ? "(ok)" : " ")
-);
-
-TRACE_EVENT(vnet_skip_tx_trigger,
-
-	TP_PROTO(int lsid, int rsid, int last),
-
-	TP_ARGS(lsid, rsid, last),
-
-	TP_STRUCT__entry(
-		__field(int, lsid)
-		__field(int, rsid)
-		__field(int, last)
-	),
-
-	TP_fast_assign(
-		__entry->lsid = lsid;
-		__entry->rsid = rsid;
-		__entry->last = last;
-	),
-
-	TP_printk("(%x:%x) Skip Tx trigger. Last trigger sent was %d",
-		__entry->lsid, __entry->rsid, __entry->last)
-);
-#endif /* _TRACE_SOCK_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
-- 
2.37.2

