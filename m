Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AE3156D5E
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 02:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgBJBUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 20:20:49 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9711 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725868AbgBJBUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Feb 2020 20:20:49 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2EB9D8629322D0A65290;
        Mon, 10 Feb 2020 09:20:46 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Mon, 10 Feb 2020 09:20:36 +0800
From:   Hongbo Yao <yaohongbo@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>
CC:     <yaohongbo@huawei.com>, <chenzhou10@huawei.com>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
Subject: [PATCH bpf-next] bpf: make btf_check_func_type_match() static
Date:   Mon, 10 Feb 2020 09:14:41 +0800
Message-ID: <20200210011441.147102-1-yaohongbo@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:
kernel/bpf/btf.c:4131:5: warning: symbol 'btf_check_func_type_match' was
not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
---
 kernel/bpf/btf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8c9d8f266bef..f24868a4176a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4144,9 +4144,9 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
  * EFAULT - verifier bug
  * 0 - 99% match. The last 1% is validated by the verifier.
  */
-int btf_check_func_type_match(struct bpf_verifier_log *log,
-			      struct btf *btf1, const struct btf_type *t1,
-			      struct btf *btf2, const struct btf_type *t2)
+static int btf_check_func_type_match(struct bpf_verifier_log *log,
+				     struct btf *btf1, const struct btf_type *t1,
+				     struct btf *btf2, const struct btf_type *t2)
 {
 	const struct btf_param *args1, *args2;
 	const char *fn1, *fn2, *s1, *s2;
-- 
2.20.1

