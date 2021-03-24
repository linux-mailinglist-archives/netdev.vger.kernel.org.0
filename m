Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66E83473AB
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 09:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhCXIag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 04:30:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14457 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhCXIaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 04:30:21 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F51b80dtZzwPWP;
        Wed, 24 Mar 2021 16:28:20 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.498.0; Wed, 24 Mar 2021
 16:30:18 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH] bpf: Remove unused headers
Date:   Wed, 24 Mar 2021 16:31:47 +0800
Message-ID: <20210324083147.149278-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The header <linux/version.h> is useless in sampleip_kern.c
and trace_event_kern.c, remove it.

Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 samples/bpf/sampleip_kern.c    | 1 -
 samples/bpf/trace_event_kern.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/samples/bpf/sampleip_kern.c b/samples/bpf/sampleip_kern.c
index f24806ac24e7..a3f8a3998e0a 100644
--- a/samples/bpf/sampleip_kern.c
+++ b/samples/bpf/sampleip_kern.c
@@ -4,7 +4,6 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
-#include <linux/version.h>
 #include <linux/ptrace.h>
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/bpf_perf_event.h>
diff --git a/samples/bpf/trace_event_kern.c b/samples/bpf/trace_event_kern.c
index 7d3c66fb3f88..0bba5fcd7d24 100644
--- a/samples/bpf/trace_event_kern.c
+++ b/samples/bpf/trace_event_kern.c
@@ -5,7 +5,6 @@
  * License as published by the Free Software Foundation.
  */
 #include <linux/ptrace.h>
-#include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/bpf_perf_event.h>
 #include <uapi/linux/perf_event.h>
-- 
2.17.1

