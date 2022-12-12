Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC260649812
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 03:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbiLLCrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 21:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiLLCrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 21:47:08 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D87FCE28;
        Sun, 11 Dec 2022 18:47:06 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id v3so7264585pgh.4;
        Sun, 11 Dec 2022 18:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jm7kj/POCe5/UpK+wnmInuW7snbMde3vmUjNy6NrQWI=;
        b=eAF5SmBr2u6jrzCaT6gSomvfYwGeHlSlmFTEESrD16jp6AHzToJpisuTL2vHtUiX9r
         68yIMQd8jvDsmaU/al+Kk72NwqH7+vfo6AKFSapIlbMNYJKDUk26z97RlgNi2L72V+8L
         L7ou3P6TDVfGvDr9kClWzP+PoJbBpBUzkWf311D/7T860SKJzIzHuI9CRUmBdohQyFlJ
         MbqL4W3udwE43PCfgPEJ42VuR0Ebgaj5o9/y1EckWnwKn4GphYkOLefgrTSVK18zeUj7
         N4RPDiBtXkUyOdFoDMLwjUmBl/8XSteOB2BIpmnUY0Z7d3MXcANyqCbr/v+wQBexQTda
         ONtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jm7kj/POCe5/UpK+wnmInuW7snbMde3vmUjNy6NrQWI=;
        b=HOIegl9tmHIuyjVh5cshV/lgAmLKpGKWzGyWht9CIbw2maoJRrKDV5vSAPPTSgOxNA
         1cLE58c8EHVZgMSz64DhPv8wIoFDvqRemzWZofyu8cTUDORVHZ4r4MLf0q1kPD8eq4YV
         Y3wZYCt3JWWO96oQMzwel2mSMlopcVd+4EM2iITKKov9k+JpvuzNEFhGipavE1R28qVG
         i0UfXK72joMic3ASKP/nJHQ3VLbHfKD89Coiu694Voec/ciM2jtnUj8ghcIkyvs9Z9Up
         2GxCZOvpEvlXFwoB0PstwAuVTIGVyBi5/vYJPXJz0yCIE8vSWkxoZ6/q0t3Gc1sfq610
         JR2w==
X-Gm-Message-State: ANoB5pnr8cUNUD6HyohkZyrihuk7SGu0h3JNChvbsRRxPgenEFWLe/jT
        82ZedrRfenENcyBWOIfV8Q8=
X-Google-Smtp-Source: AA0mqf4L4lK1Sr8n3wk/7IUXfZnOe1CwmHT/KIttKrxwQ5M7i1oLhsrYYpzs6it6uaddodGixH0MdA==
X-Received: by 2002:a05:6a00:21c2:b0:56b:baf3:ad8b with SMTP id t2-20020a056a0021c200b0056bbaf3ad8bmr17549326pfj.6.1670813225713;
        Sun, 11 Dec 2022 18:47:05 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:55c6])
        by smtp.gmail.com with ESMTPSA id w16-20020a627b10000000b005636326fdbfsm4564698pfc.78.2022.12.11.18.47.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 11 Dec 2022 18:47:05 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        martin.lau@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2022-12-11
Date:   Sun, 11 Dec 2022 18:47:01 -0800
Message-Id: <20221212024701.73809-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 74 non-merge commits during the last 11 day(s) which contain
a total of 88 files changed, 3362 insertions(+), 789 deletions(-).

The main changes are:

1) Decouple prune and jump points handling in the verifier, from Andrii.

2) Do not rely on ALLOW_ERROR_INJECTION for fmod_ret, from Benjamin.
   Merged from hid tree.

3) Do not zero-extend kfunc return values. Necessary fix for 32-bit archs, from Björn.

4) Don't use rcu_users to refcount in task kfuncs, from David.

5) Three reg_state->id fixes in the verifier, from Eduard.

6) Optimize bpf_mem_alloc by reusing elements from free_by_rcu, from Hou.

7) Refactor dynptr handling in the verifier, from Kumar.

8) Remove the "/sys" mount and umount dance in {open,close}_netns in bpf selftests, from Martin.

9) Enable sleepable support for cgrp local storage, from Yonghong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Björn Töpel, David Vernet, Jakub 
Sitnicki, Joanne Koong, John Fastabend, Kumar Kartikeya Dwivedi, Matus 
Jokay, Paul E. McKenney, Stanislav Fomichev, syzbot, Yonghong Song

----------------------------------------------------------------

The following changes since commit 91a7de85600d5dfa272cea3cef83052e067dc0ab:

  selftests/net: add csum offload test (2022-11-29 21:24:32 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 99523094de48df65477cbbb9d8027f4bc4701794:

  Merge branch 'stricter register ID checking in regsafe()' (2022-12-10 13:36:22 -0800)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (8):
      bpf: Tighten ptr_to_btf_id checks.
      Merge branch 'bpf: Handle MEM_RCU type properly'
      Merge branch 'Refactor verifier prune and jump point handling'
      Merge "do not rely on ALLOW_ERROR_INJECTION for fmod_ret" into bpf-next
      Merge branch 'Document some recent core kfunc additions'
      Merge branch 'Misc optimizations for bpf mem allocator'
      Merge branch 'Dynptr refactorings'
      Merge branch 'stricter register ID checking in regsafe()'

Andrii Nakryiko (9):
      libbpf: Avoid enum forward-declarations in public API in C++ mode
      selftests/bpf: Make sure enum-less bpf_enable_stats() API works in C++ mode
      Merge branch 'BPF selftests fixes'
      bpf: decouple prune and jump points
      bpf: mostly decouple jump history management from is_state_visited()
      bpf: remove unnecessary prune and jump points
      bpf: Remove unused insn_cnt argument from visit_[func_call_]insn()
      selftests/bpf: add generic BPF program tester-loader
      selftests/bpf: convert dynptr_fail and map_kptr_fail subtests to generic tester

Benjamin Tissoires (1):
      bpf: do not rely on ALLOW_ERROR_INJECTION for fmod_ret

Björn Töpel (1):
      bpf: Do not zero-extend kfunc return values

Christophe JAILLET (1):
      net: xsk: Don't include <linux/rculist.h>

Daan De Meyer (3):
      selftests/bpf: Install all required files to run selftests
      selftests/bpf: Use "is not set" instead of "=n"
      selftests/bpf: Use CONFIG_TEST_BPF=m instead of CONFIG_TEST_BPF=y

Daniel Borkmann (1):
      selftests/bpf: Add bench test to arm64 and s390x denylist

Dave Marchevsky (3):
      bpf: Fix release_on_unlock release logic for multiple refs
      selftests/bpf: Validate multiple ref release_on_unlock logic
      bpf: Loosen alloc obj test in verifier's reg_btf_record

David Vernet (3):
      bpf: Don't use rcu_users to refcount in task kfuncs
      bpf/docs: Document struct task_struct * kfuncs
      bpf/docs: Document struct cgroup * kfuncs

Donald Hunter (1):
      docs/bpf: Add documentation for BPF_MAP_TYPE_SK_STORAGE

Eduard Zingerman (6):
      bpf: regsafe() must not skip check_ids()
      selftests/bpf: test cases for regsafe() bug skipping check_id()
      bpf: states_equal() must build idmap for all function frames
      selftests/bpf: verify states_equal() maintains idmap across all frames
      bpf: use check_ids() for active_lock comparison
      selftests/bpf: test case for relaxed prunning of active_lock.id

Eric Dumazet (1):
      bpf, sockmap: fix race in sock_map_free()

Eyal Birger (4):
      xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
      xfrm: interface: Add unstable helpers for setting/getting XFRM metadata from TC-BPF
      tools: add IFLA_XFRM_COLLECT_METADATA to uapi/linux/if_link.h
      selftests/bpf: add xfrm_info tests

Hou Tao (2):
      bpf: Reuse freed element in free_by_rcu during allocation
      bpf: Skip rcu_barrier() if rcu_trace_implies_rcu_gp() is true

James Hilliard (2):
      selftests/bpf: Add GCC compatible builtins to bpf_legacy.h
      selftests/bpf: Fix conflicts with built-in functions in bpf_iter_ksym

Kumar Kartikeya Dwivedi (8):
      bpf: Refactor ARG_PTR_TO_DYNPTR checks into process_dynptr_func
      bpf: Propagate errors from process_* checks in check_func_arg
      bpf: Rework process_dynptr_func
      bpf: Rework check_func_arg_reg_off
      bpf: Move PTR_TO_STACK alignment check to process_dynptr_func
      bpf: Use memmove for bpf_dynptr_{read,write}
      selftests/bpf: Add test for dynptr reinit in user_ringbuf callback
      selftests/bpf: Add pruning test case for bpf_spin_lock

Martin KaFai Lau (9):
      selftests/bpf: Use if_nametoindex instead of reading the /sys/net/class/*/ifindex
      selftests/bpf: Avoid pinning bpf prog in the tc_redirect_dtime test
      selftests/bpf: Avoid pinning bpf prog in the tc_redirect_peer_l3 test
      selftests/bpf: Avoid pinning bpf prog in the netns_load_bpf() callers
      selftests/bpf: Remove the "/sys" mount and umount dance in {open,close}_netns
      selftests/bpf: Remove serial from tests using {open,close}_netns
      selftests/bpf: Avoid pinning prog when attaching to tc ingress in btf_skc_cls_ingress
      Merge branch 'xfrm: interface: Add unstable helpers for XFRM metadata'
      selftests/bpf: Allow building bpf tests with CONFIG_XFRM_INTERFACE=[m|n]

Miaoqian Lin (1):
      bpftool: Fix memory leak in do_build_table_cb

Pengcheng Yang (4):
      bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
      bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
      bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect
      selftests/bpf: Add ingress tests for txmsg with apply_bytes

Pu Lehui (1):
      riscv, bpf: Emit fixed-length instructions for BPF_PSEUDO_FUNC

Sreevani Sreejith (1):
      bpf, docs: BPF Iterator Document

Stanislav Fomichev (1):
      selftests/bpf: Bring test_offload.py back to life

Timo Hunziker (1):
      libbpf: Parse usdt args without offset on x86 (e.g. 8@(%rsp))

Toke Høiland-Jørgensen (1):
      bpf: Add dummy type reference to nf_conn___init to fix type deduplication

Xin Liu (1):
      libbpf: Improve usability of libbpf Makefile

Yang Jihong (1):
      bpf: Fix comment error in fixup_kfunc_call function

Yonghong Song (7):
      bpf: Fix a compilation failure with clang lto build
      bpf: Handle MEM_RCU type properly
      selftests/bpf: Fix rcu_read_lock test with new MEM_RCU semantics
      docs/bpf: Add KF_RCU documentation
      bpf: Do not mark certain LSM hook arguments as trusted
      bpf: Enable sleeptable support for cgrp local storage
      bpf: Add sleepable prog tests for cgrp local storage

Zheng Yejian (1):
      bpf, docs: Correct the example of BPF_XOR

 Documentation/bpf/bpf_iterators.rst                | 485 ++++++++++++++
 Documentation/bpf/index.rst                        |   1 +
 Documentation/bpf/instruction-set.rst              |   4 +-
 Documentation/bpf/kfuncs.rst                       | 207 ++++++
 Documentation/bpf/map_sk_storage.rst               | 155 +++++
 arch/riscv/net/bpf_jit_comp64.c                    |  29 +-
 include/linux/bpf.h                                |   9 +-
 include/linux/bpf_lsm.h                            |   6 +
 include/linux/bpf_verifier.h                       |  16 +-
 include/linux/btf.h                                |   3 +
 include/linux/btf_ids.h                            |   1 +
 include/linux/skmsg.h                              |   1 +
 include/net/dst_metadata.h                         |   1 +
 include/net/netns/xdp.h                            |   2 +-
 include/net/tcp.h                                  |   4 +-
 include/net/xfrm.h                                 |  17 +
 include/uapi/linux/bpf.h                           |   8 +-
 kernel/bpf/bpf_cgrp_storage.c                      |   3 +-
 kernel/bpf/bpf_inode_storage.c                     |   4 +-
 kernel/bpf/bpf_lsm.c                               |  16 +
 kernel/bpf/bpf_task_storage.c                      |   4 +-
 kernel/bpf/btf.c                                   |  32 +-
 kernel/bpf/helpers.c                               | 118 ++--
 kernel/bpf/memalloc.c                              |  31 +-
 kernel/bpf/verifier.c                              | 696 +++++++++++++--------
 net/bpf/test_run.c                                 |  14 +-
 net/core/bpf_sk_storage.c                          |   3 +-
 net/core/dst.c                                     |   8 +-
 net/core/filter.c                                  |  23 +
 net/core/skmsg.c                                   |   9 +-
 net/core/sock_map.c                                |   2 +
 net/ipv4/tcp_bpf.c                                 |  19 +-
 net/tls/tls_sw.c                                   |   6 +-
 net/xfrm/Makefile                                  |   8 +
 net/xfrm/xfrm_interface_bpf.c                      | 115 ++++
 .../{xfrm_interface.c => xfrm_interface_core.c}    |  14 +
 scripts/bpf_doc.py                                 |   1 +
 tools/bpf/bpftool/common.c                         |   1 +
 tools/include/uapi/linux/bpf.h                     |   8 +-
 tools/include/uapi/linux/if_link.h                 |   1 +
 tools/lib/bpf/Makefile                             |  17 +
 tools/lib/bpf/bpf.h                                |   7 +
 tools/lib/bpf/usdt.c                               |   8 +
 tools/testing/selftests/bpf/DENYLIST.aarch64       |   1 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |   2 +
 tools/testing/selftests/bpf/Makefile               |   8 +-
 tools/testing/selftests/bpf/bpf_legacy.h           |  19 +-
 tools/testing/selftests/bpf/config                 |   6 +-
 tools/testing/selftests/bpf/network_helpers.c      |  51 +-
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c |  25 +-
 .../selftests/bpf/prog_tests/cgrp_local_storage.c  |  94 +++
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |  80 +--
 tools/testing/selftests/bpf/prog_tests/empty_skb.c |   2 +-
 .../selftests/bpf/prog_tests/kfunc_dynptr_param.c  |   7 +-
 tools/testing/selftests/bpf/prog_tests/map_kptr.c  |  80 +--
 .../testing/selftests/bpf/prog_tests/task_kfunc.c  |   1 +
 .../testing/selftests/bpf/prog_tests/tc_redirect.c | 314 +++++-----
 .../testing/selftests/bpf/prog_tests/test_tunnel.c |   2 +-
 .../selftests/bpf/prog_tests/user_ringbuf.c        |   6 +-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |   2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        |   2 +-
 tools/testing/selftests/bpf/prog_tests/xfrm_info.c | 362 +++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c  |   6 +-
 tools/testing/selftests/bpf/progs/bpf_misc.h       |   5 +
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |   3 +
 .../selftests/bpf/progs/btf_type_tag_percpu.c      |   1 +
 .../selftests/bpf/progs/cgrp_ls_sleepable.c        |  80 +++
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |  31 +
 tools/testing/selftests/bpf/progs/dynptr_success.c |   1 +
 tools/testing/selftests/bpf/progs/linked_list.c    |  17 +-
 tools/testing/selftests/bpf/progs/map_kptr_fail.c  |  27 +
 tools/testing/selftests/bpf/progs/rcu_read_lock.c  |  60 +-
 .../selftests/bpf/progs/task_kfunc_failure.c       |  11 +
 .../selftests/bpf/progs/task_kfunc_success.c       |   9 +-
 .../selftests/bpf/progs/test_kfunc_dynptr_param.c  |  12 -
 .../selftests/bpf/progs/user_ringbuf_fail.c        |  51 +-
 tools/testing/selftests/bpf/progs/xfrm_info.c      |  40 ++
 tools/testing/selftests/bpf/test_cpp.cpp           |  13 +-
 tools/testing/selftests/bpf/test_loader.c          | 233 +++++++
 tools/testing/selftests/bpf/test_offload.py        |   8 +-
 tools/testing/selftests/bpf/test_progs.h           |  33 +
 tools/testing/selftests/bpf/test_sockmap.c         |  18 +
 tools/testing/selftests/bpf/verifier/calls.c       |  84 ++-
 .../selftests/bpf/verifier/direct_packet_access.c  |  54 ++
 tools/testing/selftests/bpf/verifier/map_ptr.c     |   8 +-
 tools/testing/selftests/bpf/verifier/ringbuf.c     |   2 +-
 tools/testing/selftests/bpf/verifier/spin_lock.c   | 114 ++++
 .../testing/selftests/bpf/verifier/value_or_null.c |  49 ++
 88 files changed, 3362 insertions(+), 789 deletions(-)
 create mode 100644 Documentation/bpf/bpf_iterators.rst
 create mode 100644 Documentation/bpf/map_sk_storage.rst
 create mode 100644 net/xfrm/xfrm_interface_bpf.c
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (98%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_ls_sleepable.c
 create mode 100644 tools/testing/selftests/bpf/progs/xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/test_loader.c
