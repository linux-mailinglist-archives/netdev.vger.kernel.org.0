Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFDC2F492F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 12:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbhAMK6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:58:36 -0500
Received: from mail.loongson.cn ([114.242.206.163]:54198 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727116AbhAMK6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 05:58:35 -0500
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxr78d0v5fhLMDAA--.6498S4;
        Wed, 13 Jan 2021 18:57:37 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-sparse@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
Subject: [PATCH 2/2] compiler.h: Include asm/rwonce.h under ARM64 and ALPHA to fix build errors
Date:   Wed, 13 Jan 2021 18:57:33 +0800
Message-Id: <1610535453-2352-3-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1610535453-2352-1-git-send-email-yangtiezhu@loongson.cn>
References: <1610535453-2352-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9Dxr78d0v5fhLMDAA--.6498S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw1UZFyrZr1rXr4kAw4kCrg_yoW8XrW3pF
        1DZr18KFW5ur1UGr98Aw12y347Zw4rGF17AFyDu348ZFyaq393X390gryYkF97Za9FqFWx
        Kr9rWrW3Cr1UZ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPK14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
        x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
        8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
        jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
        kIwI1lc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4U
        MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67
        AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4
        A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU
        0xZFpf9x0JUCzuAUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When make M=samples/bpf on the Loongson 3A3000 platform which
belongs to MIPS arch, there exists many similar build errors
about 'asm/rwonce.h' file not found, so include it only under
CONFIG_ARM64 and CONFIG_ALPHA due to it exists only in arm64
and alpha arch.

  CLANG-bpf  samples/bpf/xdpsock_kern.o
In file included from samples/bpf/xdpsock_kern.c:2:
In file included from ./include/linux/bpf.h:9:
In file included from ./include/linux/workqueue.h:9:
In file included from ./include/linux/timer.h:5:
In file included from ./include/linux/list.h:9:
In file included from ./include/linux/kernel.h:10:
./include/linux/compiler.h:246:10: fatal error: 'asm/rwonce.h' file not found
         ^~~~~~~~~~~~~~
1 error generated.

$ find . -name rwonce.h
./include/asm-generic/rwonce.h
./arch/arm64/include/asm/rwonce.h
./arch/alpha/include/asm/rwonce.h

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 include/linux/compiler.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index b8fe0c2..bdbe759 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -243,6 +243,12 @@ static inline void *offset_to_ptr(const int *off)
  */
 #define prevent_tail_call_optimization()	mb()
 
+#ifdef CONFIG_ARM64
 #include <asm/rwonce.h>
+#endif
+
+#ifdef CONFIG_ALPHA
+#include <asm/rwonce.h>
+#endif
 
 #endif /* __LINUX_COMPILER_H */
-- 
2.1.0

