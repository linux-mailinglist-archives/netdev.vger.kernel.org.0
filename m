Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4292F4936
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 12:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbhAMK6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:58:45 -0500
Received: from mail.loongson.cn ([114.242.206.163]:54190 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726310AbhAMK6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 05:58:33 -0500
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxr78d0v5fhLMDAA--.6498S3;
        Wed, 13 Jan 2021 18:57:35 +0800 (CST)
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
Subject: [PATCH bpf 1/2] samples/bpf: Set flag __SANE_USERSPACE_TYPES__ for MIPS to fix build warnings
Date:   Wed, 13 Jan 2021 18:57:32 +0800
Message-Id: <1610535453-2352-2-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1610535453-2352-1-git-send-email-yangtiezhu@loongson.cn>
References: <1610535453-2352-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9Dxr78d0v5fhLMDAA--.6498S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tr18Gr1kZF4UuFWkCF4rXwb_yoW8Gw45pa
        n2kayxGrWFkw43GFW7Ar1jvr13J3y8u34jgFW8WFyYqFy2qFyvqr4kJrW3tr48urs2yayS
        qFy3GFy5CFyrXr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPC14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
        8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
        jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
        kIwI1lc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4U
        MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67
        AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z2
        80aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI
        43ZEXa7VUjZqXJUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MIPS needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
'int-ll64.h' in arch/mips/include/uapi/asm/types.h and avoid compile
warnings when printing __u64 with %llu, %llx or %lld.

    printf("0x%02x : %llu\n", key, value);
                     ~~~^          ~~~~~
                     %lu
   printf("%s/%llx;", sym->name, addr);
              ~~~^               ~~~~
              %lx
  printf(";%s %lld\n", key->waker, count);
              ~~~^                 ~~~~~
              %ld

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 samples/bpf/Makefile        | 4 ++++
 tools/include/linux/types.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 26fc96c..27de306 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -183,6 +183,10 @@ BPF_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
 TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
 endif
 
+ifeq ($(ARCH), mips)
+TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__
+endif
+
 TPROGS_CFLAGS += -Wall -O2
 TPROGS_CFLAGS += -Wmissing-prototypes
 TPROGS_CFLAGS += -Wstrict-prototypes
diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
index 154eb4e..e9c5a21 100644
--- a/tools/include/linux/types.h
+++ b/tools/include/linux/types.h
@@ -6,7 +6,10 @@
 #include <stddef.h>
 #include <stdint.h>
 
+#ifndef __SANE_USERSPACE_TYPES__
 #define __SANE_USERSPACE_TYPES__	/* For PPC64, to get LL64 types */
+#endif
+
 #include <asm/types.h>
 #include <asm/posix_types.h>
 
-- 
2.1.0

