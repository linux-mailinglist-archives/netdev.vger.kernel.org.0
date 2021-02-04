Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436BB30F297
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbhBDLko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:40:44 -0500
Received: from mail.loongson.cn ([114.242.206.163]:48076 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235772AbhBDLkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 06:40:19 -0500
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9BxLezi3Btg06UEAA--.6894S2;
        Thu, 04 Feb 2021 19:39:15 +0800 (CST)
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
Subject: [PATCH bpf-next] samples/bpf: Add hello world sample for newbies
Date:   Thu,  4 Feb 2021 19:39:13 +0800
Message-Id: <1612438753-30133-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9BxLezi3Btg06UEAA--.6894S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4Utr4DXw1DGFy8tw43KFg_yoW5KFW5p3
        W5Zr13Gr4qqr17tFW3Wa1jkFWYvw18ury7GFZaqrW5AwnFva4kJrWqgrs8uFs8Jr9rKa93
        Zr4qkFy3Gr18Xa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_Gw4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI
        42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
        evJa73UjIFyTuYvjfU0PEfUUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The program is made in a way that everytime an execve syscall
is executed it prints Hello, BPF World!

This is inspired and based on the code example for the book
Linux Observability with BPF [1], load_bpf_file() has been
removed after commit ceb5dea56543 ("samples: bpf: Remove
bpf_load loader completely"), so the old version can not
work in the latest mainline kernel.

Since it is very simple and useful for newbies, I think it is
necessary to be upstreamed.

[1] https://github.com/bpftools/linux-observability-with-bpf/tree/master/code/chapter-2/hello_world

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 samples/bpf/Makefile     |  3 +++
 samples/bpf/hello_kern.c | 14 ++++++++++++++
 samples/bpf/hello_user.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)
 create mode 100644 samples/bpf/hello_kern.c
 create mode 100644 samples/bpf/hello_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 45ceca4..fd17cbd 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -55,6 +55,7 @@ tprogs-y += task_fd_query
 tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
+tprogs-y += hello
 
 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
@@ -113,6 +114,7 @@ task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o
 ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS)
+hello-objs := hello_user.o $(TRACE_HELPERS)
 
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
@@ -174,6 +176,7 @@ always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
 always-y += xdpsock_kern.o
+always-y += hello_kern.o
 
 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
diff --git a/samples/bpf/hello_kern.c b/samples/bpf/hello_kern.c
new file mode 100644
index 0000000..b841029
--- /dev/null
+++ b/samples/bpf/hello_kern.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("tracepoint/syscalls/sys_enter_execve")
+int trace_enter_execve(void *ctx)
+{
+	static const char msg[] = "Hello, BPF World!\n";
+
+	bpf_trace_printk(msg, sizeof(msg));
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/hello_user.c b/samples/bpf/hello_user.c
new file mode 100644
index 0000000..9423bbb
--- /dev/null
+++ b/samples/bpf/hello_user.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <bpf/libbpf.h>
+#include "trace_helpers.h"
+
+int main(int argc, char **argv)
+{
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+
+	obj = bpf_object__open_file("hello_kern.o", NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
+	}
+
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	prog = bpf_object__find_program_by_name(obj, "trace_enter_execve");
+	if (!prog) {
+		fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
+		goto cleanup;
+	}
+
+	link = bpf_program__attach(prog);
+	if (libbpf_get_error(link)) {
+		fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+		link = NULL;
+		goto cleanup;
+	}
+
+	read_trace_pipe();
+
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
+	return 0;
+}
-- 
2.1.0

