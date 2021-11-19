Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D45F457309
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbhKSQfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235244AbhKSQfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:35:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CBFC06174A;
        Fri, 19 Nov 2021 08:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=M2rJ/ktsq69iUWgiZ6174Hpbs0zLIB/GyOV8kUUeqAk=; b=ttZbEiw8GazD+Y/aKB6BY54eFe
        WD2RH/FpJFionjBMdTUasaUfmW53jg4VAZtyq1fVjwomWJHzrF343KLHIPefj036PxHhGlPlPqYZJ
        mPMn2eoJhaUVqJGq59+4Pp0qDPmSC85RwGjP2n2AG33QZax2gOvlwkUfQWjuMQsTwc9kIBEVXCEt/
        0CveozyxPqc08iSxXsBCHz/4tlos2+sGjU5fqJmCUljcSWVB3dLK0ouKmn1+M9zMXmk3B0mQPt6Ks
        v+QcZ4HsHId8GtdGYSO3Lo0+wVg5xsMfcbJZkOoR06fJ+VBElrrg/txUsieXfuYGPASIFqZFQa8Vh
        3lQCJxqA==;
Received: from [2001:4bb8:180:22b2:ffb8:fd25:b81f:ac15] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mo6oH-009gD0-65; Fri, 19 Nov 2021 16:32:22 +0000
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
Subject: [PATCH 3/5] bpf, docs: prune all references to "internal BPF"
Date:   Fri, 19 Nov 2021 17:32:13 +0100
Message-Id: <20211119163215.971383-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211119163215.971383-1-hch@lst.de>
References: <20211119163215.971383-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eBPF name has completely taken over from eBPF in general usage for
the actual eBPF representation, or BPF for any general in-kernel use.
Prune all remaining references to "internal BPF".

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/networking/filter.rst | 22 +++++++++++-----------
 arch/arm/net/bpf_jit_32.c           |  2 +-
 arch/arm64/net/bpf_jit_comp.c       |  2 +-
 arch/sparc/net/bpf_jit_comp_64.c    |  2 +-
 kernel/bpf/core.c                   |  2 +-
 net/core/filter.c                   | 11 +++++------
 6 files changed, 20 insertions(+), 21 deletions(-)

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
index e59b41e9ab0c1..10ceebb7530b6 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -163,7 +163,7 @@ static const s8 bpf2a32[][2] = {
 	[BPF_REG_9] = {STACK_OFFSET(BPF_R9_HI), STACK_OFFSET(BPF_R9_LO)},
 	/* Read only Frame Pointer to access Stack */
 	[BPF_REG_FP] = {STACK_OFFSET(BPF_FP_HI), STACK_OFFSET(BPF_FP_LO)},
-	/* Temporary Register for internal BPF JIT, can be used
+	/* Temporary Register for BPF JIT, can be used
 	 * for constant blindings and others.
 	 */
 	[TMP_REG_1] = {ARM_R7, ARM_R6},
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 07c12c42b7517..07aad85848fa3 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -44,7 +44,7 @@ static const int bpf2a64[] = {
 	[BPF_REG_9] = A64_R(22),
 	/* read-only frame pointer to access stack */
 	[BPF_REG_FP] = A64_R(25),
-	/* temporary registers for internal BPF JIT */
+	/* temporary registers for BPF JIT */
 	[TMP_REG_1] = A64_R(10),
 	[TMP_REG_2] = A64_R(11),
 	[TMP_REG_3] = A64_R(12),
diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index 0bfe1c72a0c9e..b1e38784eb238 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -227,7 +227,7 @@ static const int bpf2sparc[] = {
 
 	[BPF_REG_AX] = G7,
 
-	/* temporary register for internal BPF JIT */
+	/* temporary register for BPF JIT */
 	[TMP_REG_1] = G1,
 	[TMP_REG_2] = G2,
 	[TMP_REG_3] = G3,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 189d85d64bf1c..de3e5bc6781fe 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1892,7 +1892,7 @@ static void bpf_prog_select_func(struct bpf_prog *fp)
 
 /**
  *	bpf_prog_select_runtime - select exec runtime for BPF program
- *	@fp: bpf_prog populated with internal BPF program
+ *	@fp: bpf_prog populated with BPF program
  *	@err: pointer to error variable
  *
  * Try to JIT eBPF program, if JIT is not available, use interpreter.
diff --git a/net/core/filter.c b/net/core/filter.c
index 26e0276aa00de..fe27c91e37580 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1242,10 +1242,9 @@ static struct bpf_prog *bpf_migrate_filter(struct bpf_prog *fp)
 	int err, new_len, old_len = fp->len;
 	bool seen_ld_abs = false;
 
-	/* We are free to overwrite insns et al right here as it
-	 * won't be used at this point in time anymore internally
-	 * after the migration to the internal BPF instruction
-	 * representation.
+	/* We are free to overwrite insns et al right here as it won't be used at
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

