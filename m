Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D4C15007C
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 03:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgBCCID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 21:08:03 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:55756 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726393AbgBCCIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 21:08:02 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5C22F322EA07049DCC32;
        Mon,  3 Feb 2020 10:07:59 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Mon, 3 Feb 2020 10:07:52 +0800
From:   Hongbo Yao <yaohongbo@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>
CC:     <yaohongbo@huawei.com>, <chenzhou10@huawei.com>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
Subject: [PATCH -next] bpf: make btf_check_func_type_match() static
Date:   Mon, 3 Feb 2020 10:02:20 +0800
Message-ID: <20200203020220.117152-1-yaohongbo@huawei.com>
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
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8c9d8f266bef..83d3d92023af 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4144,7 +4144,7 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
  * EFAULT - verifier bug
  * 0 - 99% match. The last 1% is validated by the verifier.
  */
-int btf_check_func_type_match(struct bpf_verifier_log *log,
+static int btf_check_func_type_match(struct bpf_verifier_log *log,
 			      struct btf *btf1, const struct btf_type *t1,
 			      struct btf *btf2, const struct btf_type *t2)
 {
-- 
2.20.1

