Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B469307272
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 10:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhA1JQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 04:16:56 -0500
Received: from mail.loongson.cn ([114.242.206.163]:56188 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232416AbhA1JOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 04:14:32 -0500
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx6L01gBJg0l0OAA--.21898S2;
        Thu, 28 Jan 2021 17:13:25 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>
Subject: [PATCH bpf-next] MAINTAINERS: BPF: Update web-page bpf.io to ebpf.io to avoid redirects
Date:   Thu, 28 Jan 2021 17:13:24 +0800
Message-Id: <1611825204-14887-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dx6L01gBJg0l0OAA--.21898S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XF4rZry7WFWDWFWDJry5Arb_yoWDAFX_Cr
        4fCrWxX395GF1rua1kGrnayr1rK3yUAFnay3W2gr43Aa4jyr98JrWfK3sayay5Xr1kGrZI
        qa43Grn8Zr43ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_GFWl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JU4BT5UUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I open https://bpf.io/, it seems too slow.

$ curl -s -S -L https://bpf.io/ -o /dev/null -w '%{time_redirect}\n'
2.373

$ curl -s -S -L https://bpf.io/ -o /dev/null -w '%{url_effective}\n'
https://ebpf.io/

$ curl -s -S -L https://ebpf.io/ -o /dev/null -w '%{time_redirect}\n'
0.000

So update https://bpf.io/ to https://ebpf.io/ to avoid redirects.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1df56a3..09314ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3260,7 +3260,7 @@ R:	KP Singh <kpsingh@kernel.org>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Supported
-W:	https://bpf.io/
+W:	https://ebpf.io/
 Q:	https://patchwork.kernel.org/project/netdevbpf/list/?delegate=121173
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
-- 
2.1.0

