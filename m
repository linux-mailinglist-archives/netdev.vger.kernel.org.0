Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3963D74A7
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 13:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbhG0L7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 07:59:46 -0400
Received: from smtpbg126.qq.com ([106.55.201.22]:16661 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231802AbhG0L7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 07:59:45 -0400
X-QQ-mid: bizesmtp33t1627387177t3wv1n01
Received: from ficus.lan (unknown [171.223.99.141])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 27 Jul 2021 19:59:35 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: CXDQRtGtR3KzU4MBs10Nayaq8vi7JZkz9fRlw35l7TPh3pRJ+S+E8PbJ9MaZu
        inCttgpcKBS1AWJ9NturNkBJQGidOJGD29LKbOxxY9FjdXz65CP/SrnX1hVDYlPz3+jvIvq
        fuHX0WsA2NQQOJJF5vsnOL+74NlV3Hty7iEHVjVU2mzFP+b18p1xEhPAb8Zr+5ChJ7Dp5Pb
        JsusGjvZ9nxQtAZlhtxfUBuZ9SDSZpRlI+q+uL/iNWy5ob5mAvLIccDgqZ+D84Y+gBw0fdQ
        TPTEOsDKTakPHmkMLHL5OZJGW9D5NoO0334UrdRtSv0DMzALZAgG2hRtFwAB/Lp37lBRv/2
        Hsdqh/+
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] libbpf: fix commnet typo
Date:   Tue, 27 Jul 2021 19:59:28 +0800
Message-Id: <20210727115928.74600-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the repeated word 'the' in line 48.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 tools/lib/bpf/libbpf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4c153c379989..d474816ecd70 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7236,7 +7236,7 @@ static int bpf_object__collect_relos(struct bpf_object *obj)
 
 	for (i = 0; i < obj->nr_programs; i++) {
 		struct bpf_program *p = &obj->programs[i];
-		
+
 		if (!p->nr_reloc)
 			continue;
 
@@ -9533,7 +9533,7 @@ static int find_btf_by_prefix_kind(const struct btf *btf, const char *prefix,
 	ret = snprintf(btf_type_name, sizeof(btf_type_name),
 		       "%s%s", prefix, name);
 	/* snprintf returns the number of characters written excluding the
-	 * the terminating null. So, if >= BTF_MAX_NAME_SIZE are written, it
+	 * terminating null. So, if >= BTF_MAX_NAME_SIZE are written, it
 	 * indicates truncation.
 	 */
 	if (ret < 0 || ret >= sizeof(btf_type_name))
@@ -10075,7 +10075,7 @@ struct bpf_link {
 int bpf_link__update_program(struct bpf_link *link, struct bpf_program *prog)
 {
 	int ret;
-	
+
 	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog), NULL);
 	return libbpf_err_errno(ret);
 }
-- 
2.32.0

