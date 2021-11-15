Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279E14504FD
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhKONKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbhKONKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 08:10:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCED1C061570;
        Mon, 15 Nov 2021 05:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aC6U7ZVqc1iWICDfWSOG4/m8Qk+aNShCai93S2Cwlwk=; b=vjBxIRkJZnLe3B47c0fEOZgIE6
        Xlb8OgiHgV99qnQRQzpjHv+mwd3jUblEvsFA9EwH0xKGOJ3APHVaVT/egsdm0wDE53YdZK0XHzin0
        h3Fe5iA2sirQJ3XNq/NtEqSJmCDis3JIJxi/61BHPPAQEjJxGCh1Y+fYifOq6oPtsEFKRQjQhjbKu
        0sl2pHJX9PbnNPWAlpIxlKvV3Zpp38TQ9asl5EmAfdU/YoToK0gpJv4vRY9yESlryro82CDARq9M1
        Xj8ajUdINqwc93DGw217tohd+Ism52vNA9guK6XmbQQs5LXY18MMj2AucJg7A4g8wbCdrZDdxeqHE
        ZmVf6t+Q==;
Received: from [2001:4bb8:192:3ffe:2cb6:6339:4f3e:fe11] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmbhd-005hre-NX; Mon, 15 Nov 2021 13:07:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 1/2] bpf, docs: prune all references to "internal BPF"
Date:   Mon, 15 Nov 2021 14:07:14 +0100
Message-Id: <20211115130715.121395-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211115130715.121395-1-hch@lst.de>
References: <20211115130715.121395-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eBPF name has completely taken over from eBPF in general usage, so
prune all remaining references to "internal BPF".

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/networking/filter.rst | 22 +++++++++++-----------
 arch/arm/net/bpf_jit_32.c           |  2 +-
 arch/arm64/net/bpf_jit_comp.c       |  2 +-
 arch/sparc/net/bpf_jit_comp_64.c    |  2 +-
 arch/x86/net/bpf_jit_comp.c         |  2 +-
 kernel/bpf/core.c                   |  4 ++--
 net/core/filter.c                   | 11 +++++------
 7 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
index ce2b8e8bb9ab6..83ffcaa5b91aa 100644
--- a/Documentation/networking/filter.rst
+++ b/Documentation/networking/filter.rst
@@ -617,7 +617,7 @@ format with similar underlying principles from BPF described in previous
 paragraphs is being used. However, the instruction set format is modelled
 closer to the underlying architecture to mimic native instruction sets, so
 that a better performance can be achieved (more details later). This new
-ISA is called 'eBPF' or 'internal BPF' interchangeably. (Note: eBPF which
+ISA is called 'eBPF'. (Note: eBPF which
 originates from [e]xtended BPF is not the same as BPF extensions! While
 eBPF is an ISA, BPF extensions date back to classic BPF's 'overloading'
 of BPF_LD | BPF_{B,H,W} | BPF_ABS instruction.)
@@ -690,7 +690,7 @@ Some core changes of the new internal format:
   That behavior maps directly to x86_64 and arm64 subregister definition, but
   makes other JITs more difficult.
 
-  32-bit architectures run 64-bit internal BPF programs via interpreter.
+  32-bit architectures run 64-bit eBPF programs via interpreter.
   Their JITs may convert BPF programs that only use 32-bit subregisters into
   native instruction set and let the rest being interpreted.
 
@@ -711,7 +711,7 @@ Some core changes of the new internal format:
 - Introduces bpf_call insn and register passing convention for zero overhead
   calls from/to other kernel functions:
 
-  Before an in-kernel function call, the internal BPF program needs to
+  Before an in-kernel function call, the eBPF program needs to
   place function arguments into R1 to R5 registers to satisfy calling
   convention, then the interpreter will take them from registers and pass
   to in-kernel function. If R1 - R5 registers are mapped to CPU registers
@@ -780,7 +780,7 @@ Some core changes of the new internal format:
   ... since x86_64 ABI mandates rdi, rsi, rdx, rcx, r8, r9 for argument passing
   and rbx, r12 - r15 are callee saved.
 
-  Then the following internal BPF pseudo-program::
+  Then the following eBPF pseudo-program::
 
     bpf_mov R6, R1 /* save ctx */
     bpf_mov R2, 2
@@ -846,7 +846,7 @@ Some core changes of the new internal format:
     bpf_exit
 
   After the call the registers R1-R5 contain junk values and cannot be read.
-  An in-kernel eBPF verifier is used to validate internal BPF programs.
+  An in-kernel eBPF verifier is used to validate eBPF programs.
 
 Also in the new design, eBPF is limited to 4096 insns, which means that any
 program will terminate quickly and will only call a fixed number of kernel
@@ -861,23 +861,23 @@ A program, that is translated internally consists of the following elements::
 
   op:16, jt:8, jf:8, k:32    ==>    op:8, dst_reg:4, src_reg:4, off:16, imm:32
 
-So far 87 internal BPF instructions were implemented. 8-bit 'op' opcode field
+So far 87 eBPF instructions were implemented. 8-bit 'op' opcode field
 has room for new instructions. Some of them may use 16/24/32 byte encoding. New
 instructions must be multiple of 8 bytes to preserve backward compatibility.
 
-Internal BPF is a general purpose RISC instruction set. Not every register and
+eBPF is a general purpose RISC instruction set. Not every register and
 every instruction are used during translation from original BPF to new format.
 For example, socket filters are not using ``exclusive add`` instruction, but
 tracing filters may do to maintain counters of events, for example. Register R9
 is not used by socket filters either, but more complex filters may be running
 out of registers and would have to resort to spill/fill to stack.
 
-Internal BPF can be used as a generic assembler for last step performance
+eBPF can be used as a generic assembler for last step performance
 optimizations, socket filters and seccomp are using it as assembler. Tracing
 filters may use it as assembler to generate code from kernel. In kernel usage
-may not be bounded by security considerations, since generated internal BPF code
+may not be bounded by security considerations, since generated eBPF code
 may be optimizing internal code path and not being exposed to the user space.
-Safety of internal BPF can come from a verifier (TBD). In such use cases as
+Safety of eBPF can come from a verifier (TBD). In such use cases as
 described, it may be used as safe instruction set.
 
 Just like the original BPF, the new format runs within a controlled environment,
@@ -1675,7 +1675,7 @@ Testing
 -------
 
 Next to the BPF toolchain, the kernel also ships a test module that contains
-various test cases for classic and internal BPF that can be executed against
+various test cases for classic and eBPF that can be executed against
 the BPF interpreter and JIT compiler. It can be found in lib/test_bpf.c and
 enabled via Kconfig::
 
diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index eeb6dc0ecf463..a00821e820019 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -163,7 +163,7 @@ static const s8 bpf2a32[][2] = {
 	[BPF_REG_9] = {STACK_OFFSET(BPF_R9_HI), STACK_OFFSET(BPF_R9_LO)},
 	/* Read only Frame Pointer to access Stack */
 	[BPF_REG_FP] = {STACK_OFFSET(BPF_FP_HI), STACK_OFFSET(BPF_FP_LO)},
-	/* Temporary Register for internal BPF JIT, can be used
+	/* Temporary Register for eBPF JIT, can be used
 	 * for constant blindings and others.
 	 */
 	[TMP_REG_1] = {ARM_R7, ARM_R6},
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 3a8a7140a9bfb..c5e31448ee873 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -44,7 +44,7 @@ static const int bpf2a64[] = {
 	[BPF_REG_9] = A64_R(22),
 	/* read-only frame pointer to access stack */
 	[BPF_REG_FP] = A64_R(25),
-	/* temporary registers for internal BPF JIT */
+	/* temporary registers for eBPF JIT */
 	[TMP_REG_1] = A64_R(10),
 	[TMP_REG_2] = A64_R(11),
 	[TMP_REG_3] = A64_R(12),
diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index 9a2f20cbd48b7..98e572d969e39 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -227,7 +227,7 @@ static const int bpf2sparc[] = {
 
 	[BPF_REG_AX] = G7,
 
-	/* temporary register for internal BPF JIT */
+	/* temporary register for eBPF JIT */
 	[TMP_REG_1] = G1,
 	[TMP_REG_2] = G2,
 	[TMP_REG_3] = G3,
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 726700fabca6d..796795eea1016 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -3,7 +3,7 @@
  * bpf_jit_comp.c: BPF JIT compiler
  *
  * Copyright (C) 2011-2013 Eric Dumazet (eric.dumazet@gmail.com)
- * Internal BPF Copyright (c) 2011-2014 PLUMgrid, http://plumgrid.com
+ * eBPF Copyright (c) 2011-2014 PLUMgrid, http://plumgrid.com
  */
 #include <linux/netdevice.h>
 #include <linux/filter.h>
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 2405e39d800fe..355aa51899d62 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1891,7 +1891,7 @@ static void bpf_prog_select_func(struct bpf_prog *fp)
 
 /**
  *	bpf_prog_select_runtime - select exec runtime for BPF program
- *	@fp: bpf_prog populated with internal BPF program
+ *	@fp: bpf_prog populated with eBPF program
  *	@err: pointer to error variable
  *
  * Try to JIT eBPF program, if JIT is not available, use interpreter.
@@ -2300,7 +2300,7 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	}
 }
 
-/* Free internal BPF program */
+/* Free eBPF program */
 void bpf_prog_free(struct bpf_prog *fp)
 {
 	struct bpf_prog_aux *aux = fp->aux;
diff --git a/net/core/filter.c b/net/core/filter.c
index e471c9b096705..634e21647fe30 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1242,10 +1242,9 @@ static struct bpf_prog *bpf_migrate_filter(struct bpf_prog *fp)
 	int err, new_len, old_len = fp->len;
 	bool seen_ld_abs = false;
 
-	/* We are free to overwrite insns et al right here as it
-	 * won't be used at this point in time anymore internally
-	 * after the migration to the internal BPF instruction
-	 * representation.
+	/* We are free to overwrite insns et al right here as itwon't be used at
+	 * this point in time anymore internally after the migration to the eBPF
+	 * instruction representation.
 	 */
 	BUILD_BUG_ON(sizeof(struct sock_filter) !=
 		     sizeof(struct bpf_insn));
@@ -1336,8 +1335,8 @@ static struct bpf_prog *bpf_prepare_filter(struct bpf_prog *fp,
 	 */
 	bpf_jit_compile(fp);
 
-	/* JIT compiler couldn't process this filter, so do the
-	 * internal BPF translation for the optimized interpreter.
+	/* JIT compiler couldn't process this filter, so do the eBPF translation
+	 * for the optimized interpreter.
 	 */
 	if (!fp->jited)
 		fp = bpf_migrate_filter(fp);
-- 
2.30.2

