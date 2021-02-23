Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F70322722
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 09:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhBWIge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 03:36:34 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:44455 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232054AbhBWIgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 03:36:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UPLRz9i_1614069339;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UPLRz9i_1614069339)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Feb 2021 16:35:47 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     peterz@infradead.org
Cc:     mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] perf/core: make perf_pmu_snapshot_aux static
Date:   Tue, 23 Feb 2021 16:35:37 +0800
Message-Id: <1614069337-50399-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

kernel/events/core.c:6524:6: warning: symbol 'perf_pmu_snapshot_aux' was
not declared. Should it be static?

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 129dee5..45cb62f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6521,7 +6521,7 @@ static unsigned long perf_prepare_sample_aux(struct perf_event *event,
 	return data->aux_size;
 }
 
-long perf_pmu_snapshot_aux(struct perf_buffer *rb,
+static long perf_pmu_snapshot_aux(struct perf_buffer *rb,
 			   struct perf_event *event,
 			   struct perf_output_handle *handle,
 			   unsigned long size)
-- 
1.8.3.1

