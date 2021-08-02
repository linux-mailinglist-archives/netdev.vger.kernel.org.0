Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976FA3DCF08
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 05:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhHBD6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 23:58:11 -0400
Received: from out0.migadu.com ([94.23.1.103]:24851 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231425AbhHBD6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Aug 2021 23:58:09 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627876679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xXttDcdgMtO70n4+Bnxj/8qRW2/JnpjzU4V0hygBryo=;
        b=TBr+Xct6kS6NB2mLaTZj8uevrdef6hqdBQwxQRz6e2uHt0/yXzqOIlGR8kXsWwVF9Tr98I
        RFcyj8vX2v5QvNMWYKqwbw6nKPxtEPif+gF2skQYTdtVmncF78eFouQ9IKahV4YfFiNogo
        nJeUwCjGaGjY5Hb+8ukD+SHQqQdCdME=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] neighbour: Rename procfs entry
Date:   Mon,  2 Aug 2021 11:57:45 +0800
Message-Id: <20210802035745.29934-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use gc_thresh_{min, default, max} instead of gc_thresh{1, 2, 3}.
This is more friendly for user.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/neighbour.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index e831b9adf1e4..c294addb7818 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3595,7 +3595,7 @@ static struct neigh_sysctl_table {
 			.proc_handler	= proc_dointvec_jiffies,
 		},
 		[NEIGH_VAR_GC_THRESH1] = {
-			.procname	= "gc_thresh1",
+			.procname	= "gc_thresh_min",
 			.maxlen		= sizeof(int),
 			.mode		= 0644,
 			.extra1		= SYSCTL_ZERO,
@@ -3603,7 +3603,7 @@ static struct neigh_sysctl_table {
 			.proc_handler	= proc_dointvec_minmax,
 		},
 		[NEIGH_VAR_GC_THRESH2] = {
-			.procname	= "gc_thresh2",
+			.procname	= "gc_thresh_default",
 			.maxlen		= sizeof(int),
 			.mode		= 0644,
 			.extra1		= SYSCTL_ZERO,
@@ -3611,7 +3611,7 @@ static struct neigh_sysctl_table {
 			.proc_handler	= proc_dointvec_minmax,
 		},
 		[NEIGH_VAR_GC_THRESH3] = {
-			.procname	= "gc_thresh3",
+			.procname	= "gc_thresh_max",
 			.maxlen		= sizeof(int),
 			.mode		= 0644,
 			.extra1		= SYSCTL_ZERO,
-- 
2.32.0

