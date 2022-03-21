Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BC44E33F0
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiCUXAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbiCUW6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:58:52 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3C960CCC;
        Mon, 21 Mar 2022 15:46:12 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t14so11321111pgr.3;
        Mon, 21 Mar 2022 15:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l+CmMQ7xIe1hJwx52hILGJjkQAdOVU3CV6RfzCTdyeg=;
        b=qEHx1sgQybnHJzf8fv5+ybLeZKWsYKWZDrqtohz+608KEfVLIViaLEdirPOXg992CG
         LNFBRO9KTYvlEtpyzLsvLrq1VPlVyJeS7PiBH6AtSu0xLVkkEuN4OAZfQJlR68nk0D/+
         qqvovdRB17Isl/xTxzMvOd3XiTszTf07UToIrtl/y5f4rKj8x5vzrdEUpqp2b4vKUneT
         D7hCZzRrbc65zQdMbInpeY045s0IBREIckl9lszni24XCDfQ6gc5wXEH5uAkiYZ+jukM
         BGnbG1FTYn+cqYoCYQ5YDVkTeU2tTSk/noX3z2ebyWX7MOeHOgjG9PfzpA4snMIquohS
         rQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l+CmMQ7xIe1hJwx52hILGJjkQAdOVU3CV6RfzCTdyeg=;
        b=hJZnkZq1zWvJmK7T9tUm4Lf6LV4hjFQ2hDvwsMDpGt6SDZQ7IdFumjoEsgh4GtXKHF
         VlFODgO24/zuvWxhEHke9pXcPi3KTWZ5pt9hGTQtTvFUc1XPSzEXt52kOHQ07vaPMC0Z
         xsFfIbR+OCVbgbps7IC9PE2HMUcynal3fvSG7veTbQOxgXJpLYGmD7dgly6qmym4LUK+
         7n9GE9iqVrWziKPLLmJoYpt/MNopQs+Fr54b1OXChDWluJ4XjxmaNR5F8a44GqpHuDG+
         cgH8adg3b4FfKybDsZwAsMJxJAlXOPNaOeQdVgkNmPFDQDsuIhbCJKAJV8GmHpQQQ1Il
         YbHA==
X-Gm-Message-State: AOAM5319NWgAQ0FdrxMUBB91GMvjjoobioDImRFLDUoLreOyzju7at/x
        4j2eOZYn9dYhVh2fd6RLtdxXvSxC8rU=
X-Google-Smtp-Source: ABdhPJwMPrc/S02H6KYgrSPUW6JxHRf0RaWdBp1z54eFg6gNODsC2WwOz/aNf8Jz3RY73s0gSGdZBA==
X-Received: by 2002:a63:de55:0:b0:374:2526:3596 with SMTP id y21-20020a63de55000000b0037425263596mr19984854pgi.592.1647902771440;
        Mon, 21 Mar 2022 15:46:11 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:9575])
        by smtp.gmail.com with ESMTPSA id t18-20020a17090ad51200b001c71bec7b22sm425409pju.23.2022.03.21.15.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 15:46:11 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, peterz@infradead.org, rostedt@goodmis.org,
        mhiramat@kernel.org, kuba@kernel.org, andrii@kernel.org,
        torvalds@linux-foundation.org, sfr@canb.auug.org.au,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2022-03-21
Date:   Mon, 21 Mar 2022 15:46:08 -0700
Message-Id: <20220321224608.55798-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 132 non-merge commits during the last 17 day(s) which contain
a total of 162 files changed, 7558 insertions(+), 1097 deletions(-).

The main changes are:

1) Custom SEC() handling in libbpf, from Andrii.

2) subskeleton support, from Delyan.

3) Use btf_tag to recognize __percpu pointers in the verifier, from Hao.

4) Fix net.core.bpf_jit_harden race, from Hou.

5) Fix bpf_sk_lookup remote_port on big-endian, from Jakub.

6) Introduce fprobe (multi kprobe), from Masami.

7) Introduce multi_kprobe bpf programs on top of fprobe, from Jiri.

8) Enable non-atomic allocations in local storage, from Joanne.

9) Various var_off ptr_to_btf_id fixed, from Kumar.

10) bpf_ima_file_hash helper, from Roberto.

11) Add "live packet" mode for XDP in BPF_PROG_RUN, from Toke.

There should be no merge conflicts with net-next,
but fprobe changes conflict with Peter's endbr set.
The objtool warnings will need a fix like:
https://lore.kernel.org/lkml/YjisdqdofbDIYj2U@hirez.programming.kicks-ass.net/

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Andrii Nakryiko, Dan Carpenter, "Geyslan G. Bem", Joanne 
Koong, John Fastabend, kernel test robot, KP Singh, Martin KaFai Lau, 
Masami Hiramatsu, Mimi Zohar, Nathan Chancellor, Quentin Monnet, Shuah 
Khan, Stanislav Fomichev, Steven Rostedt (Google), Toke 
Hoiland-Jorgensen, Toke Høiland-Jørgensen, Yonghong Song

----------------------------------------------------------------

The following changes since commit d59e3cbaef707f0d3dc1e3b6735cb25060ca74c2:

  Merge branch 'bnxt_en-updates' (2022-03-05 11:16:56 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to f97b8b9bd630fb76c0e9e11cbf390e3d64a144d7:

  bpftool: Fix a bug in subskeleton code generation (2022-03-21 14:46:10 -0700)

----------------------------------------------------------------
Adrian Ratiu (1):
      tools: Fix unavoidable GCC call in Clang builds

Alexei Starovoitov (10):
      Merge branch 'libbpf: support custom SEC() handlers'
      Merge branch 'Fixes for bad PTR_TO_BTF_ID offset'
      Merge branch 'bpf: add __percpu tagging in vmlinux BTF'
      Merge branch 'Add support for transmitting packets using XDP in bpf_prog_run()'
      Merge branch 'bpf-lsm: Extend interoperability with IMA'
      Merge branch 'Remove libcap dependency from bpf selftests'
      Merge branch 'fprobe: Introduce fprobe function entry/exit probe'
      Merge branch 'bpf: Add kprobe multi link'
      Merge branch 'Enable non-atomic allocations in local storage'
      Merge branch 'Make 2-byte access to bpf_sk_lookup->remote_port endian-agnostic'

Andrii Nakryiko (7):
      libbpf: Allow BPF program auto-attach handlers to bail out
      libbpf: Support custom SEC() handlers
      selftests/bpf: Add custom SEC() handling selftest
      Merge branch 'BPF test_progs tests improvement'
      Merge branch 'Subskeleton support for BPF librariesThread-Topic: [PATCH bpf-next v4 0/5'
      bpftool: Add BPF_TRACE_KPROBE_MULTI to attach type names table
      libbpf: Avoid NULL deref when initializing map BTF info

Chris J Arges (1):
      bpftool: Ensure bytes_memlock json output is correct

Daniel Borkmann (2):
      Merge branch 'bpf-tstamp-follow-ups'
      Merge branch 'bpf-fix-sock-field-tests'

Daniel Xu (1):
      bpftool: man: Add missing top level docs

Delyan Kratunov (5):
      libbpf: .text routines are subprograms in strict mode
      libbpf: Init btf_{key,value}_type_id on internal map open
      libbpf: Add subskeleton scaffolding
      bpftool: Add support for subskeletons
      selftests/bpf: Test subskeleton functionality

Dmitrii Dolgov (1):
      bpftool: Add bpf_cookie to link output

Felix Maurer (1):
      selftests/bpf: Make test_lwt_ip_encap more stable and faster

Guo Zhengkui (2):
      libbpf: Fix array_size.cocci warning
      selftests/bpf: Clean up array_size.cocci warnings

Hangbin Liu (1):
      selftests/bpf/test_lirc_mode2.sh: Exit with proper code

Hao Luo (5):
      bpf: Fix checking PTR_TO_BTF_ID in check_mem_access
      compiler_types: Define __percpu as __attribute__((btf_type_tag("percpu")))
      bpf: Reject programs that try to load __percpu memory.
      selftests/bpf: Add a test for btf_type_tag "percpu"
      compiler_types: Refactor the use of btf_type_tag attribute.

Hengqi Chen (2):
      bpf: Fix comment for helper bpf_current_task_under_cgroup()
      libbpf: Close fd in bpf_object__reuse_map

Hou Tao (3):
      bpf, x86: Fall back to interpreter mode when extra pass fails
      bpf: Fix net.core.bpf_jit_harden race
      selftests/bpf: Test subprog jit when toggle bpf_jit_harden repeatedly

Jakub Sitnicki (7):
      selftests/bpf: Fix error reporting from sock_fields programs
      selftests/bpf: Check dst_port only on the client socket
      selftests/bpf: Use constants for socket states in sock_fields test
      selftests/bpf: Fix test for 4-byte load from dst_port on big-endian
      bpf: Treat bpf_sk_lookup remote_port as a 2-byte field
      selftests/bpf: Fix u8 narrow load checks for bpf_sk_lookup remote_port
      selftests/bpf: Fix test for 4-byte load from remote_port on big-endian

Jiri Olsa (16):
      ftrace: Add ftrace_set_filter_ips function
      lib/sort: Add priv pointer to swap function
      kallsyms: Skip the name search for empty string
      bpf: Add multi kprobe link
      bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
      bpf: Add support to inline bpf_get_func_ip helper on x86
      bpf: Add cookie support to programs attached with kprobe multi link
      libbpf: Add libbpf_kallsyms_parse function
      libbpf: Add bpf_link_create support for multi kprobes
      libbpf: Add bpf_program__attach_kprobe_multi_opts function
      selftests/bpf: Add kprobe_multi attach test
      selftests/bpf: Add kprobe_multi bpf_cookie test
      selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts
      selftests/bpf: Add cookie test for bpf_program__attach_kprobe_multi_opts
      Revert "bpf: Add support to inline bpf_get_func_ip helper on x86"
      bpf: Fix kprobe_multi return probe backtrace

Joanne Koong (3):
      bpf: Enable non-atomic allocations in local storage
      selftests/bpf: Test for associating multiple elements with the local storage
      bpf: Fix warning for cast from restricted gfp_t in verifier

Julia Lawall (1):
      bpf, arm: Fix various typos in comments

KP Singh (2):
      bpf/docs: Update vmtest docs for static linking
      bpf/docs: Update list of architectures supported.

Kaixi Fan (1):
      selftests/bpf: Fix tunnel remote IP comments

Kumar Kartikeya Dwivedi (10):
      bpf: Add check_func_arg_reg_off function
      bpf: Fix PTR_TO_BTF_ID var_off check
      bpf: Disallow negative offset in check_ptr_off_reg
      bpf: Harden register offset checks for release helpers and kfuncs
      compiler_types.h: Add unified __diag_ignore_all for GCC/LLVM
      bpf: Replace __diag_ignore with unified __diag_ignore_all
      selftests/bpf: Add tests for kfunc register offset checks
      bpf: Factor out fd returning from bpf_btf_find_by_name_kind
      bpf: Always raise reference in btf_get_module_btf
      bpf: Check for NULL return from bpf_get_btf_vmlinux

Lorenzo Bianconi (3):
      net: veth: Account total xdp_frame len running ndo_xdp_xmit
      veth: Rework veth_xdp_rcv_skb in order to accept non-linear skb
      veth: Allow jumbo frames in xdp mode

Martin KaFai Lau (8):
      bpf: net: Remove TC_AT_INGRESS_OFFSET and SKB_MONO_DELIVERY_TIME_OFFSET macro
      bpf: Simplify insn rewrite on BPF_READ __sk_buff->tstamp
      bpf: Simplify insn rewrite on BPF_WRITE __sk_buff->tstamp
      bpf: Remove BPF_SKB_DELIVERY_TIME_NONE and rename s/delivery_time_/tstamp_/
      bpf: selftests: Update tests after s/delivery_time/tstamp/ change in bpf.h
      bpf: selftests: Add helpers to directly use the capget and capset syscall
      bpf: selftests: Remove libcap usage from test_verifier
      bpf: selftests: Remove libcap usage from test_progs

Masami Hiramatsu (11):
      fprobe: Add ftrace based probe APIs
      rethook: Add a generic return hook
      rethook: x86: Add rethook x86 implementation
      arm64: rethook: Add arm64 rethook implementation
      powerpc: Add rethook support
      ARM: rethook: Add rethook arm implementation
      fprobe: Add exit_handler support
      fprobe: Add sample program for fprobe
      fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
      docs: fprobe: Add fprobe description to ftrace-use.rst
      fprobe: Add a selftest for fprobe

Mykola Lysenko (3):
      Improve perf related BPF tests (sample_freq issue)
      Improve send_signal BPF test stability
      Improve stability of find_vma BPF test

Namhyung Kim (2):
      bpf: Adjust BPF stack helper functions to accommodate skip > 0
      selftests/bpf: Test skipping stacktrace

Nathan Chancellor (1):
      compiler-clang.h: Add __diag infrastructure for clang

Niklas Söderlund (2):
      bpftool: Restore support for BPF offload-enabled feature probing
      samples/bpf, xdpsock: Fix race when running for fix duration of time

Roberto Sassu (9):
      ima: Fix documentation-related warnings in ima_main.c
      ima: Always return a file measurement in ima_file_hash()
      bpf-lsm: Introduce new helper bpf_ima_file_hash()
      selftests/bpf: Move sample generation code to ima_test_common()
      selftests/bpf: Add test for bpf_ima_file_hash()
      selftests/bpf: Check if the digest is refreshed after a file write
      bpf-lsm: Make bpf_lsm_kernel_read_file() as sleepable
      selftests/bpf: Add test for bpf_lsm_kernel_read_file()
      selftests/bpf: Check that bpf_kernel_read_file() denies reading IMA policy

Shung-Hsi Yu (1):
      bpf: Determine buf_info inside check_buffer_access()

Song Liu (3):
      bpf: Select proper size for bpf_prog_pack
      bpf: Fix bpf_prog_pack for multi-node setup
      bpf: Fix bpf_prog_pack when PMU_SIZE is not defined

Toke Høiland-Jørgensen (8):
      bpf: Add "live packet" mode for XDP in BPF_PROG_RUN
      Documentation/bpf: Add documentation for BPF_PROG_RUN
      libbpf: Support batch_size option to bpf_prog_test_run
      selftests/bpf: Move open_netns() and close_netns() into network_helpers.c
      selftests/bpf: Add selftest for XDP_REDIRECT in BPF_PROG_RUN
      bpf: Initialise retval in bpf_prog_test_run_xdp()
      bpf, test_run: Fix packet size check for live packet mode
      selftests/bpf: Add a test for maximum packet size in xdp_do_redirect

Wang Yufen (4):
      bpf, sockmap: Fix memleak in sk_psock_queue_msg
      bpf, sockmap: Fix memleak in tcp_bpf_sendmsg while sk msg is full
      bpf, sockmap: Fix more uncharged while msg has more_data
      bpf, sockmap: Fix double uncharge the mem of sk_msg

Yafang Shao (1):
      bpftool: Fix print error when show bpf map

Yihao Han (1):
      bpf, test_run: Use kvfree() for memory allocated with kvmalloc()

Yonghong Song (2):
      selftests/bpf: Fix a clang compilation error for send_signal.c
      bpftool: Fix a bug in subskeleton code generation

Yuntao Wang (4):
      bpf: Replace strncpy() with strscpy()
      bpf: Remove redundant slash
      bpf: Use offsetofend() to simplify macro definition
      bpf: Simplify check in btf_parse_hdr()

lic121 (1):
      libbpf: Unmap rings when umem deleted

 Documentation/bpf/bpf_prog_run.rst                 | 117 ++++
 Documentation/bpf/index.rst                        |   1 +
 Documentation/trace/fprobe.rst                     | 174 +++++
 Documentation/trace/index.rst                      |   1 +
 arch/arm/Kconfig                                   |   1 +
 arch/arm/include/asm/stacktrace.h                  |   4 +-
 arch/arm/kernel/stacktrace.c                       |   6 +
 arch/arm/net/bpf_jit_32.c                          |   4 +-
 arch/arm/probes/Makefile                           |   1 +
 arch/arm/probes/rethook.c                          | 103 +++
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/stacktrace.h                |   2 +-
 arch/arm64/kernel/probes/Makefile                  |   1 +
 arch/arm64/kernel/probes/rethook.c                 |  25 +
 arch/arm64/kernel/probes/rethook_trampoline.S      |  87 +++
 arch/arm64/kernel/stacktrace.c                     |   7 +-
 arch/powerpc/Kconfig                               |   1 +
 arch/powerpc/kernel/Makefile                       |   1 +
 arch/powerpc/kernel/rethook.c                      |  72 +++
 arch/x86/Kconfig                                   |   1 +
 arch/x86/include/asm/unwind.h                      |   8 +-
 arch/x86/kernel/Makefile                           |   1 +
 arch/x86/kernel/kprobes/common.h                   |   1 +
 arch/x86/kernel/rethook.c                          | 119 ++++
 arch/x86/net/bpf_jit_comp.c                        |  11 +-
 drivers/net/veth.c                                 | 192 ++++--
 include/linux/bpf.h                                |  11 +-
 include/linux/bpf_local_storage.h                  |   7 +-
 include/linux/bpf_types.h                          |   1 +
 include/linux/bpf_verifier.h                       |   4 +
 include/linux/compiler-clang.h                     |  25 +
 include/linux/compiler-gcc.h                       |   3 +
 include/linux/compiler_types.h                     |  18 +-
 include/linux/filter.h                             |   3 +-
 include/linux/fprobe.h                             | 105 +++
 include/linux/ftrace.h                             |   3 +
 include/linux/kprobes.h                            |   3 +
 include/linux/rethook.h                            | 100 +++
 include/linux/sched.h                              |   3 +
 include/linux/skbuff.h                             |  10 +-
 include/linux/skmsg.h                              |  13 +-
 include/linux/sort.h                               |   2 +-
 include/linux/trace_events.h                       |   7 +
 include/linux/types.h                              |   1 +
 include/net/xdp.h                                  |  14 +
 include/uapi/linux/bpf.h                           |  80 ++-
 kernel/bpf/Kconfig                                 |   1 +
 kernel/bpf/bpf_inode_storage.c                     |   9 +-
 kernel/bpf/bpf_local_storage.c                     |  58 +-
 kernel/bpf/bpf_lsm.c                               |  21 +
 kernel/bpf/bpf_task_storage.c                      |  10 +-
 kernel/bpf/btf.c                                   | 166 +++--
 kernel/bpf/core.c                                  |  89 ++-
 kernel/bpf/helpers.c                               |   9 +-
 kernel/bpf/preload/Makefile                        |   5 +-
 kernel/bpf/stackmap.c                              |  56 +-
 kernel/bpf/syscall.c                               |  28 +-
 kernel/bpf/verifier.c                              | 161 +++--
 kernel/exit.c                                      |   2 +
 kernel/fork.c                                      |   3 +
 kernel/kallsyms.c                                  |   4 +
 kernel/trace/Kconfig                               |  26 +
 kernel/trace/Makefile                              |   2 +
 kernel/trace/bpf_trace.c                           | 348 +++++++++-
 kernel/trace/fprobe.c                              | 332 ++++++++++
 kernel/trace/ftrace.c                              |  58 +-
 kernel/trace/rethook.c                             | 317 +++++++++
 lib/Kconfig.debug                                  |  12 +
 lib/Makefile                                       |   2 +
 lib/sort.c                                         |  40 +-
 lib/test_fprobe.c                                  | 174 +++++
 net/bpf/test_run.c                                 | 351 +++++++++-
 net/core/bpf_sk_storage.c                          |  23 +-
 net/core/filter.c                                  | 153 +++--
 net/core/skmsg.c                                   |  17 +-
 net/core/xdp.c                                     |   1 +
 net/ipv4/tcp_bpf.c                                 |  14 +-
 net/netfilter/nf_conntrack_bpf.c                   |   5 +-
 samples/Kconfig                                    |   7 +
 samples/Makefile                                   |   1 +
 samples/bpf/xdpsock_user.c                         |   6 +-
 samples/fprobe/Makefile                            |   3 +
 samples/fprobe/fprobe_example.c                    | 120 ++++
 security/integrity/ima/ima_main.c                  |  57 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |  25 +
 tools/bpf/bpftool/Documentation/bpftool.rst        |  13 +-
 tools/bpf/bpftool/bash-completion/bpftool          |  14 +-
 tools/bpf/bpftool/common.c                         |   2 +-
 tools/bpf/bpftool/feature.c                        | 152 ++++-
 tools/bpf/bpftool/gen.c                            | 587 ++++++++++++++---
 tools/bpf/bpftool/main.h                           |   2 +
 tools/bpf/bpftool/map.c                            |   9 +-
 tools/bpf/bpftool/pids.c                           |   8 +
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c          |  22 +
 tools/bpf/bpftool/skeleton/pid_iter.h              |   2 +
 tools/include/uapi/linux/bpf.h                     |  72 ++-
 tools/lib/bpf/bpf.c                                |  13 +-
 tools/lib/bpf/bpf.h                                |  12 +-
 tools/lib/bpf/libbpf.c                             | 720 ++++++++++++++++-----
 tools/lib/bpf/libbpf.h                             | 161 +++++
 tools/lib/bpf/libbpf.map                           |   9 +
 tools/lib/bpf/libbpf_internal.h                    |   5 +
 tools/lib/bpf/libbpf_legacy.h                      |   4 +
 tools/lib/bpf/libbpf_version.h                     |   2 +-
 tools/lib/bpf/xsk.c                                |  15 +-
 tools/scripts/Makefile.include                     |   4 +
 tools/testing/selftests/bpf/.gitignore             |   1 +
 tools/testing/selftests/bpf/Makefile               |  20 +-
 tools/testing/selftests/bpf/README.rst             |  10 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |  14 +
 tools/testing/selftests/bpf/cap_helpers.c          |  67 ++
 tools/testing/selftests/bpf/cap_helpers.h          |  19 +
 tools/testing/selftests/bpf/ima_setup.sh           |  35 +-
 tools/testing/selftests/bpf/network_helpers.c      |  86 +++
 tools/testing/selftests/bpf/network_helpers.h      |   9 +
 tools/testing/selftests/bpf/prog_tests/bind_perm.c |  44 +-
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  | 179 ++++-
 tools/testing/selftests/bpf/prog_tests/btf_tag.c   | 164 ++++-
 .../bpf/prog_tests/cgroup_attach_autodetach.c      |   2 +-
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |   2 +-
 .../bpf/prog_tests/cgroup_attach_override.c        |   2 +-
 .../selftests/bpf/prog_tests/custom_sec_handlers.c | 176 +++++
 tools/testing/selftests/bpf/prog_tests/find_vma.c  |  30 +-
 .../testing/selftests/bpf/prog_tests/global_data.c |   6 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   | 323 +++++++++
 tools/testing/selftests/bpf/prog_tests/obj_name.c  |   2 +-
 .../selftests/bpf/prog_tests/perf_branches.c       |   4 +-
 tools/testing/selftests/bpf/prog_tests/perf_link.c |   2 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |  17 +-
 .../selftests/bpf/prog_tests/stacktrace_map_skip.c |  63 ++
 tools/testing/selftests/bpf/prog_tests/subprogs.c  |  77 ++-
 .../testing/selftests/bpf/prog_tests/subskeleton.c |  78 +++
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |  89 ---
 tools/testing/selftests/bpf/prog_tests/test_ima.c  | 149 ++++-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     | 201 ++++++
 .../selftests/bpf/progs/btf_type_tag_percpu.c      |  66 ++
 tools/testing/selftests/bpf/progs/ima.c            |  66 +-
 tools/testing/selftests/bpf/progs/kprobe_multi.c   |  98 +++
 tools/testing/selftests/bpf/progs/local_storage.c  |  19 +
 .../selftests/bpf/progs/stacktrace_map_skip.c      |  68 ++
 .../selftests/bpf/progs/test_custom_sec_handlers.c |  63 ++
 .../selftests/bpf/progs/test_send_signal_kern.c    |   2 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |  13 +-
 .../testing/selftests/bpf/progs/test_sock_fields.c |  24 +-
 .../testing/selftests/bpf/progs/test_subskeleton.c |  28 +
 .../selftests/bpf/progs/test_subskeleton_lib.c     |  61 ++
 .../selftests/bpf/progs/test_subskeleton_lib2.c    |  16 +
 tools/testing/selftests/bpf/progs/test_tc_dtime.c  |  38 +-
 .../selftests/bpf/progs/test_xdp_do_redirect.c     | 100 +++
 tools/testing/selftests/bpf/test_cgroup_storage.c  |   2 +-
 tools/testing/selftests/bpf/test_lirc_mode2.sh     |   5 +-
 tools/testing/selftests/bpf/test_lru_map.c         |   4 +-
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh   |  10 +-
 tools/testing/selftests/bpf/test_sock_addr.c       |   6 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   4 +-
 tools/testing/selftests/bpf/test_tunnel.sh         |   2 +-
 tools/testing/selftests/bpf/test_verifier.c        |  88 +--
 tools/testing/selftests/bpf/trace_helpers.c        |   7 +
 .../selftests/bpf/verifier/bounds_deduction.c      |   2 +-
 tools/testing/selftests/bpf/verifier/calls.c       |  83 +++
 tools/testing/selftests/bpf/verifier/ctx.c         |   8 +-
 162 files changed, 7558 insertions(+), 1097 deletions(-)
 create mode 100644 Documentation/bpf/bpf_prog_run.rst
 create mode 100644 Documentation/trace/fprobe.rst
 create mode 100644 arch/arm/probes/rethook.c
 create mode 100644 arch/arm64/kernel/probes/rethook.c
 create mode 100644 arch/arm64/kernel/probes/rethook_trampoline.S
 create mode 100644 arch/powerpc/kernel/rethook.c
 create mode 100644 arch/x86/kernel/rethook.c
 create mode 100644 include/linux/fprobe.h
 create mode 100644 include/linux/rethook.h
 create mode 100644 kernel/trace/fprobe.c
 create mode 100644 kernel/trace/rethook.c
 create mode 100644 lib/test_fprobe.c
 create mode 100644 samples/fprobe/Makefile
 create mode 100644 samples/fprobe/fprobe_example.c
 create mode 100644 tools/testing/selftests/bpf/cap_helpers.c
 create mode 100644 tools/testing/selftests/bpf/cap_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/custom_sec_handlers.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/subskeleton.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_type_tag_percpu.c
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi.c
 create mode 100644 tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_custom_sec_handlers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subskeleton.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subskeleton_lib.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subskeleton_lib2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
