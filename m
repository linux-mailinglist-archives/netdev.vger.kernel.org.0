Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7A538F863
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhEYC6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:58:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5694 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhEYC6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:58:44 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FpzFB3kB2z1BQQj;
        Tue, 25 May 2021 10:54:22 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 10:57:13 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 10:57:12 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] bpf: fix spelling mistakes
Date:   Tue, 25 May 2021 10:56:59 +0800
Message-ID: <20210525025659.8898-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210525025659.8898-1-thunder.leizhen@huawei.com>
References: <20210525025659.8898-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
aother ==> another
Netiher ==> Neither
desribe ==> describe
intializing ==> initializing
funciton ==> function
wont ==> won't		//Move the word 'the' at the end to the next line,
			//because it's more than 80 columns
accross ==> across
pathes ==> paths
triggerred ==> triggered
excute ==> execute
ether ==> either
conervative ==> conservative
convetion ==> convention
markes ==> marks
interpeter ==> interpreter

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/linux/bpf_local_storage.h |  2 +-
 kernel/bpf/bpf_inode_storage.c    |  2 +-
 kernel/bpf/btf.c                  |  6 +++---
 kernel/bpf/devmap.c               |  4 ++--
 kernel/bpf/hashtab.c              |  4 ++--
 kernel/bpf/reuseport_array.c      |  2 +-
 kernel/bpf/trampoline.c           |  2 +-
 kernel/bpf/verifier.c             | 12 ++++++------
 8 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf_local_storage.h b/include/linux/bpf_local_storage.h
index b902c580c48d..6915ba34d4a2 100644
--- a/include/linux/bpf_local_storage.h
+++ b/include/linux/bpf_local_storage.h
@@ -71,7 +71,7 @@ struct bpf_local_storage_elem {
 	struct bpf_local_storage __rcu *local_storage;
 	struct rcu_head rcu;
 	/* 8 bytes hole */
-	/* The data is stored in aother cacheline to minimize
+	/* The data is stored in another cacheline to minimize
 	 * the number of cachelines access during a cache hit.
 	 */
 	struct bpf_local_storage_data sdata ____cacheline_aligned;
diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
index 2921ca39a93e..96ceed0e0fb5 100644
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -72,7 +72,7 @@ void bpf_inode_storage_free(struct inode *inode)
 		return;
 	}
 
-	/* Netiher the bpf_prog nor the bpf-map's syscall
+	/* Neither the bpf_prog nor the bpf-map's syscall
 	 * could be modifying the local_storage->list now.
 	 * Thus, no elem can be added-to or deleted-from the
 	 * local_storage->list by the bpf_prog or by the bpf-map's syscall.
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0600ed325fa0..609d657d7943 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -51,7 +51,7 @@
  * The BTF type section contains a list of 'struct btf_type' objects.
  * Each one describes a C type.  Recall from the above section
  * that a 'struct btf_type' object could be immediately followed by extra
- * data in order to desribe some particular C types.
+ * data in order to describe some particular C types.
  *
  * type_id:
  * ~~~~~~~
@@ -1143,7 +1143,7 @@ static void *btf_show_obj_safe(struct btf_show *show,
 
 	/*
 	 * We need a new copy to our safe object, either because we haven't
-	 * yet copied and are intializing safe data, or because the data
+	 * yet copied and are initializing safe data, or because the data
 	 * we want falls outside the boundaries of the safe object.
 	 */
 	if (!safe) {
@@ -3417,7 +3417,7 @@ static struct btf_kind_operations func_proto_ops = {
 	 * BTF_KIND_FUNC_PROTO cannot be directly referred by
 	 * a struct's member.
 	 *
-	 * It should be a funciton pointer instead.
+	 * It should be a function pointer instead.
 	 * (i.e. struct's member -> BTF_KIND_PTR -> BTF_KIND_FUNC_PROTO)
 	 *
 	 * Hence, there is no btf_func_check_member().
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index aa516472ce46..d60d617ec0d7 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -382,8 +382,8 @@ void __dev_flush(void)
 }
 
 /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or
- * update happens in parallel here a dev_put wont happen until after reading the
- * ifindex.
+ * update happens in parallel here a dev_put won't happen until after reading
+ * the ifindex.
  */
 static void *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
 {
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d7ebb12ffffc..055ae930bcd6 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -46,12 +46,12 @@
  * events, kprobes and tracing to be invoked before the prior invocation
  * from one of these contexts completed. sys_bpf() uses the same mechanism
  * by pinning the task to the current CPU and incrementing the recursion
- * protection accross the map operation.
+ * protection across the map operation.
  *
  * This has subtle implications on PREEMPT_RT. PREEMPT_RT forbids certain
  * operations like memory allocations (even with GFP_ATOMIC) from atomic
  * contexts. This is required because even with GFP_ATOMIC the memory
- * allocator calls into code pathes which acquire locks with long held lock
+ * allocator calls into code paths which acquire locks with long held lock
  * sections. To ensure the deterministic behaviour these locks are regular
  * spinlocks, which are converted to 'sleepable' spinlocks on RT. The only
  * true atomic contexts on an RT kernel are the low level hardware
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 4838922f723d..93a55391791a 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -102,7 +102,7 @@ static void reuseport_array_free(struct bpf_map *map)
 	/*
 	 * ops->map_*_elem() will not be able to access this
 	 * array now. Hence, this function only races with
-	 * bpf_sk_reuseport_detach() which was triggerred by
+	 * bpf_sk_reuseport_detach() which was triggered by
 	 * close() or disconnect().
 	 *
 	 * This function and bpf_sk_reuseport_detach() are
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 2d44b5aa0057..28a3630c48ee 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -552,7 +552,7 @@ static void notrace inc_misses_counter(struct bpf_prog *prog)
  * __bpf_prog_enter returns:
  * 0 - skip execution of the bpf prog
  * 1 - execute bpf prog
- * [2..MAX_U64] - excute bpf prog and record execution time.
+ * [2..MAX_U64] - execute bpf prog and record execution time.
  *     This is start time.
  */
 u64 notrace __bpf_prog_enter(struct bpf_prog *prog)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 757476c91c98..50b25ea7f5db 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -47,7 +47,7 @@ static const struct bpf_verifier_ops * const bpf_verifier_ops[] = {
  * - unreachable insns exist (shouldn't be a forest. program = one function)
  * - out of bounds or malformed jumps
  * The second pass is all possible path descent from the 1st insn.
- * Since it's analyzing all pathes through the program, the length of the
+ * Since it's analyzing all paths through the program, the length of the
  * analysis is limited to 64k insn, which may be hit even if total number of
  * insn is less then 4K, but there are too many branches that change stack/regs.
  * Number of 'branches to be analyzed' is limited to 1k
@@ -132,7 +132,7 @@ static const struct bpf_verifier_ops * const bpf_verifier_ops[] = {
  * If it's ok, then verifier allows this BPF_CALL insn and looks at
  * .ret_type which is RET_PTR_TO_MAP_VALUE_OR_NULL, so it sets
  * R0->type = PTR_TO_MAP_VALUE_OR_NULL which means bpf_map_lookup_elem() function
- * returns ether pointer to map value or NULL.
+ * returns either pointer to map value or NULL.
  *
  * When type PTR_TO_MAP_VALUE_OR_NULL passes through 'if (reg != 0) goto +off'
  * insn, the register holding that pointer in the true branch changes state to
@@ -2613,7 +2613,7 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 		if (dst_reg != BPF_REG_FP) {
 			/* The backtracking logic can only recognize explicit
 			 * stack slot address like [fp - 8]. Other spill of
-			 * scalar via different register has to be conervative.
+			 * scalar via different register has to be conservative.
 			 * Backtrack from here and mark all registers as precise
 			 * that contributed into 'reg' being a constant.
 			 */
@@ -9049,7 +9049,7 @@ static int check_return_code(struct bpf_verifier_env *env)
 	    !prog->aux->attach_func_proto->type)
 		return 0;
 
-	/* eBPF calling convetion is such that R0 is used
+	/* eBPF calling convention is such that R0 is used
 	 * to return the value from eBPF program.
 	 * Make sure that it's readable at this time
 	 * of bpf_exit, which means that program wrote
@@ -9844,7 +9844,7 @@ static void clean_verifier_state(struct bpf_verifier_env *env,
  * Since the verifier pushes the branch states as it sees them while exploring
  * the program the condition of walking the branch instruction for the second
  * time means that all states below this branch were already explored and
- * their final liveness markes are already propagated.
+ * their final liveness marks are already propagated.
  * Hence when the verifier completes the search of state list in is_state_visited()
  * we can call this clean_live_states() function to mark all liveness states
  * as REG_LIVE_DONE to indicate that 'parent' pointers of 'struct bpf_reg_state'
@@ -12449,7 +12449,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			prog->aux->max_pkt_offset = MAX_PACKET_OFF;
 
 			/* mark bpf_tail_call as different opcode to avoid
-			 * conditional branch in the interpeter for every normal
+			 * conditional branch in the interpreter for every normal
 			 * call and to prevent accidental JITing by JIT compiler
 			 * that doesn't support bpf_tail_call yet
 			 */
-- 
2.25.1


