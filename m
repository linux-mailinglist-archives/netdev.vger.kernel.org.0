Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D79E349332
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCYNle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:41:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14544 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhCYNlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 09:41:05 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F5mQZ6q5BzPkxm;
        Thu, 25 Mar 2021 21:38:30 +0800 (CST)
Received: from t01.huawei.com (10.67.174.119) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 21:41:00 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <ast@kernel.org>, <jackmanb@google.com>,
        <kpsingh@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <john.fastabend@gmail.com>, <songliubraving@fb.com>
Subject: [PATCH bpf-next v3] bpf: Fix a spelling typo in kernel/bpf/disasm.c
Date:   Thu, 25 Mar 2021 13:41:41 +0000
Message-ID: <20210325134141.8533-1-xukuohai@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.119]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The name string for BPF_XOR is "xor", not "or", fix it.

Fixes: 981f94c3e92146705b ("bpf: Add bitwise atomic instructions")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Acked-by: Brendan Jackman <jackmanb@google.com>
---
 kernel/bpf/disasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/disasm.c b/kernel/bpf/disasm.c
index 3acc7e0b6916..faa54d58972c 100644
--- a/kernel/bpf/disasm.c
+++ b/kernel/bpf/disasm.c
@@ -84,7 +84,7 @@ static const char *const bpf_atomic_alu_string[16] = {
 	[BPF_ADD >> 4]  = "add",
 	[BPF_AND >> 4]  = "and",
 	[BPF_OR >> 4]  = "or",
-	[BPF_XOR >> 4]  = "or",
+	[BPF_XOR >> 4]  = "xor",
 };
 
 static const char *const bpf_ldst_string[] = {
-- 
2.27.0

