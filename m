Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623C71BB965
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgD1JBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:01:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726271AbgD1JBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 05:01:07 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 452689890E86C316FB36;
        Tue, 28 Apr 2020 17:01:04 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Apr 2020 17:00:53 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] libbpf: Remove unneeded semicolon
Date:   Tue, 28 Apr 2020 17:07:09 +0800
Message-ID: <1588064829-70613-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

 tools/lib/bpf/btf_dump.c:661:4-5: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 tools/lib/bpf/btf_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 0c28ee8..de07e55 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -658,7 +658,7 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 			if (!btf_dump_is_blacklisted(d, id)) {
 				btf_dump_emit_typedef_def(d, id, t, 0);
 				btf_dump_printf(d, ";\n\n");
-			};
+			}
 			tstate->fwd_emitted = 1;
 			break;
 		default:
-- 
2.6.2

