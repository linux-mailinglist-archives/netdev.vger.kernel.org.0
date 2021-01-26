Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC63F303FC7
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 15:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405812AbhAZOKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 09:10:32 -0500
Received: from mail.loongson.cn ([114.242.206.163]:49896 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391768AbhAZOGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 09:06:38 -0500
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9AxRb2nIRBg_DsNAA--.17412S2;
        Tue, 26 Jan 2021 22:05:28 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>
Subject: [PATCH bpf-next] samples/bpf: Add include dir for MIPS Loongson64 to fix build errors
Date:   Tue, 26 Jan 2021 22:05:25 +0800
Message-Id: <1611669925-25315-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9AxRb2nIRBg_DsNAA--.17412S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGrW5Aw1UCFy7uFyxAFWUurg_yoWrXFyDpa
        1Duw1kWF45WryUAFn8Ar1Ik3y3Jw45G3yjvFy5W34jv3ZIgFyfJrsakr15Gr1ktF4qva18
        Kry3WrWagr1UZw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_Xryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JUWlksUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There exists many build errors when make M=samples/bpf on the Loongson
platform, this issue is MIPS related, x86 compiles just fine.

Here are some errors:

  CLANG-bpf  samples/bpf/sockex2_kern.o
In file included from samples/bpf/sockex2_kern.c:2:
In file included from ./include/uapi/linux/in.h:24:
In file included from ./include/linux/socket.h:8:
In file included from ./include/linux/uio.h:8:
In file included from ./include/linux/kernel.h:11:
In file included from ./include/linux/bitops.h:32:
In file included from ./arch/mips/include/asm/bitops.h:19:
In file included from ./arch/mips/include/asm/barrier.h:11:
./arch/mips/include/asm/addrspace.h:13:10: fatal error: 'spaces.h' file not found
         ^~~~~~~~~~
1 error generated.

  CLANG-bpf  samples/bpf/sockex2_kern.o
In file included from samples/bpf/sockex2_kern.c:2:
In file included from ./include/uapi/linux/in.h:24:
In file included from ./include/linux/socket.h:8:
In file included from ./include/linux/uio.h:8:
In file included from ./include/linux/kernel.h:11:
In file included from ./include/linux/bitops.h:32:
In file included from ./arch/mips/include/asm/bitops.h:22:
In file included from ./arch/mips/include/asm/cpu-features.h:13:
In file included from ./arch/mips/include/asm/cpu-info.h:15:
In file included from ./include/linux/cache.h:6:
./arch/mips/include/asm/cache.h:12:10: fatal error: 'kmalloc.h' file not found
         ^~~~~~~~~~~
1 error generated.

  CLANG-bpf  samples/bpf/sockex2_kern.o
In file included from samples/bpf/sockex2_kern.c:2:
In file included from ./include/uapi/linux/in.h:24:
In file included from ./include/linux/socket.h:8:
In file included from ./include/linux/uio.h:8:
In file included from ./include/linux/kernel.h:11:
In file included from ./include/linux/bitops.h:32:
In file included from ./arch/mips/include/asm/bitops.h:22:
./arch/mips/include/asm/cpu-features.h:15:10: fatal error: 'cpu-feature-overrides.h' file not found
         ^~~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.

$ find arch/mips/include/asm -name spaces.h | sort
arch/mips/include/asm/mach-ar7/spaces.h
...
arch/mips/include/asm/mach-generic/spaces.h
...
arch/mips/include/asm/mach-loongson64/spaces.h
...
arch/mips/include/asm/mach-tx49xx/spaces.h

$ find arch/mips/include/asm -name kmalloc.h | sort
arch/mips/include/asm/mach-generic/kmalloc.h
arch/mips/include/asm/mach-ip32/kmalloc.h
arch/mips/include/asm/mach-tx49xx/kmalloc.h

$ find arch/mips/include/asm -name cpu-feature-overrides.h | sort
arch/mips/include/asm/mach-ath25/cpu-feature-overrides.h
...
arch/mips/include/asm/mach-generic/cpu-feature-overrides.h
...
arch/mips/include/asm/mach-loongson64/cpu-feature-overrides.h
...
arch/mips/include/asm/mach-tx49xx/cpu-feature-overrides.h

In the arch/mips/Makefile, there exists the following board-dependent
options:

include arch/mips/Kbuild.platforms
cflags-y += -I$(srctree)/arch/mips/include/asm/mach-generic

So we can do the similar things in samples/bpf/Makefile, just add
platform specific and generic include dir for MIPS Loongson64 to
fix the build errors.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 samples/bpf/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 362f314..45ceca4 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -185,6 +185,10 @@ endif
 
 ifeq ($(ARCH), mips)
 TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__
+ifdef CONFIG_MACH_LOONGSON64
+BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-loongson64
+BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-generic
+endif
 endif
 
 TPROGS_CFLAGS += -Wall -O2
-- 
2.1.0

