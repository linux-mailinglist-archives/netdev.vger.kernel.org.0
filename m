Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0EE27617F
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgIWT6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWT6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 15:58:43 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDCCC0613CE;
        Wed, 23 Sep 2020 12:58:43 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u4so287339plr.4;
        Wed, 23 Sep 2020 12:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gIv9K3zYM8Tl8uNUmL8RKWXC4Hqxd8R4na+bBDxQGIY=;
        b=S+pPE6+xM+obYJhLeDf+bH44gdRgmhahOXbVP8AJeiWczb4PNGB6xWRQZuKUCrY2EM
         ARu7NaWJHr0IvTJKTlWmPGElWHHYUognUsES9WSAsj/K/NYG98Z4Ytw8mQ1fvPkHy2wm
         z9BkMq6u6qWlYYVEA6b7AIXF/QgoFSJl/GhttgrqbTmPzZRF63sTSxwx+6+dcaAFEfyX
         ZvmVtLaXesR27yPIRJxnIQdvfQkXlKcACbTz0CRkfstsGvnLbEnGzvIGWHskVbpszuJg
         /F4YP/ynSaODSQu8XBV1d9V5dJ3Vfk+Z9AfaxMsP38NGYfLIXj3Bb6OZKu+9wWTvTLoD
         vFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gIv9K3zYM8Tl8uNUmL8RKWXC4Hqxd8R4na+bBDxQGIY=;
        b=Fw8ka5MxT2Try47bvQIE/FT4j5G7s83gh+TscrYVG1gnWT3cQWTTtFfuEETHW7ky3h
         d0l/KD4HYb4eUyWxi8MWn+CC0OVK56tUnRc2KVouF/nL1uOVjaM2rNTXfXPRHiDSTULQ
         1RSHHS+Er0jNJBM8d8m5VGYIYxQufH+4UQcw6vYV5bgakQjcmpg2WaJ0YtHL8zOdSkZN
         xCsuZM4Iv3EP6TWJL3l91Dy0ebztCpik2szd/HN6nJC6arVebIiDErVWAqcpp+fgEKvh
         05H18EtWhB6+mQsPCDLfTBakOA9hhHFnIMq91azZoqsRlEfgfCyONZYiVshac3KnZ4Xc
         OIbw==
X-Gm-Message-State: AOAM531h17OMEaExB6CPWwRXdZ3Lp8xdA9qzH23UwNQOG4LYCLaS+dz/
        lj4LEWDPR5aTgNPn0DnDDI1XUUJK0d4=
X-Google-Smtp-Source: ABdhPJxXGnioPKvSxLkxDgzUNOL1pKLnbt5jMKoAt2B6Fuqx7133a/qFv3c/KHVoITCzSnCtqcbhPQ==
X-Received: by 2002:a17:90b:1212:: with SMTP id gl18mr881981pjb.138.1600891122581;
        Wed, 23 Sep 2020 12:58:42 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id l78sm504672pfd.26.2020.09.23.12.58.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 12:58:41 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf-next 2020-09-23
Date:   Wed, 23 Sep 2020 12:58:39 -0700
Message-Id: <20200923195839.59606-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 95 non-merge commits during the last 22 day(s) which contain
a total of 124 files changed, 4211 insertions(+), 2040 deletions(-).

The main changes are:

1) Full multi function support in libbpf, from Andrii.

2) Refactoring of function argument checks, from Lorenz.

3) Make bpf_tail_call compatible with functions (subprograms), from Maciej.

4) Program metadata support, from YiFei.

5) bpf iterator optimizations, from Yonghong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Björn Töpel, Jesper Dangaard Brouer, Jiri Olsa, John 
Fastabend, Josef Bacik, Kevin Yang, Martin KaFai Lau, Seth Forshee, Song 
Liu, Tirthendu Sarkar, Tobias Klauser, Yonghong Song, Yuchung Cheng

----------------------------------------------------------------

The following changes since commit 0697fecf7ecd8abf70d0f46e6a352818e984cc9f:

  Merge branch 'dpaa2-eth-add-a-dpaa2_eth_-prefix-to-all-functions' (2020-09-01 13:23:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to dc3652d3f0d5479768ec8eb7f7aabbba6ed75d95:

  tools resolve_btfids: Always force HOSTARCH (2020-09-23 12:43:04 -0700)

----------------------------------------------------------------
Alexei Starovoitov (5):
      Merge branch 'libbpf-support-bpf-to-bpf-calls'
      Merge branch 'improve-bpf-tcp-cc-init'
      Merge branch 'bpf_metadata'
      bpf: Add abnormal return checks.
      Merge branch 'refactor-check_func_arg'

Andrii Nakryiko (18):
      libbpf: Ensure ELF symbols table is found before further ELF processing
      libbpf: Parse multi-function sections into multiple BPF programs
      libbpf: Support CO-RE relocations for multi-prog sections
      libbpf: Make RELO_CALL work for multi-prog sections and sub-program calls
      libbpf: Implement generalized .BTF.ext func/line info adjustment
      libbpf: Add multi-prog section support for struct_ops
      selftests/bpf: Add selftest for multi-prog sections and bpf-to-bpf calls
      tools/bpftool: Replace bpf_program__title() with bpf_program__section_name()
      selftests/bpf: Don't use deprecated libbpf APIs
      libbpf: Deprecate notion of BPF program "title" in favor of "section name"
      selftests/bpf: Turn fexit_bpf2bpf into test with subtests
      selftests/bpf: Add subprogs to pyperf, strobemeta, and l4lb_noinline tests
      selftests/bpf: Modernize xdp_noinline test w/ skeleton and __noinline
      selftests/bpf: Add __noinline variant of cls_redirect selftest
      libbpf: Fix another __u64 cast in printf
      libbpf: Fix potential multiplication overflow
      perf: Stop using deprecated bpf_program__title()
      selftests/bpf: Merge most of test_btf into test_progs

Chen Zhou (1):
      bpf: Remove duplicate headers

Daniel T. Lee (2):
      samples, bpf: Replace bpf_program__title() with bpf_program__section_name()
      samples, bpf: Add xsk_fwd test file to .gitignore

Gustavo A. R. Silva (1):
      xsk: Fix null check on error return path

Hao Luo (1):
      selftests/bpf: Fix check in global_data_init.

Ilya Leoshkevich (5):
      selftests/bpf: Fix test_ksyms on non-SMP kernels
      s390/bpf: Fix multiple tail calls
      selftests/bpf: Fix endianness issue in sk_assign
      selftests/bpf: Fix endianness issue in test_sockopt_sk
      samples/bpf: Fix test_map_in_map on s390

Jiri Olsa (3):
      selftests/bpf: Fix stat probe in d_path test
      bpf: Check CONFIG_BPF option for resolve_btfids
      tools resolve_btfids: Always force HOSTARCH

Lorenz Bauer (16):
      net: sockmap: Remove unnecessary sk_fullsock checks
      net: Allow iterating sockmap and sockhash
      selftests: bpf: Test iterating a sockmap
      bpf: Plug hole in struct bpf_sk_lookup_kern
      btf: Make btf_set_contains take a const pointer
      bpf: Check scalar or invalid register in check_helper_mem_access
      btf: Add BTF_ID_LIST_SINGLE macro
      bpf: Allow specifying a BTF ID per argument in function protos
      bpf: Make BTF pointer type checking generic
      bpf: Make reference tracking generic
      bpf: Make context access check generic
      bpf: Set meta->raw_mode for pointers close to use
      bpf: Check ARG_PTR_TO_SPINLOCK register type in check_func_arg
      bpf: Hoist type checking for nullable arg types
      bpf: Use a table to drive helper arg type checks
      bpf: Explicitly size compatible_reg_types

Maciej Fijalkowski (7):
      bpf, x64: use %rcx instead of %rax for tail call retpolines
      bpf: propagate poke descriptors to subprograms
      bpf: rename poke descriptor's 'ip' member to 'tailcall_target'
      bpf: Limit caller's stack depth 256 for subprogs with tailcalls
      bpf, x64: rework pro/epilogue and tailcall handling in JIT
      bpf: allow for tailcalls in BPF subprograms for x64 JIT
      selftests/bpf: Add tailcall_bpf2bpf tests

Magnus Karlsson (7):
      xsk: Fix possible segfault in xsk umem diagnostics
      xsk: Fix possible segfault at xskmap entry insertion
      xsk: Fix use-after-free in failed shared_umem bind
      samples/bpf: Fix one packet sending in xdpsock
      samples/bpf: Fix possible deadlock in xdpsock
      samples/bpf: Add quiet option to xdpsock
      xsk: Fix refcount warning in xp_dma_map

Martin KaFai Lau (1):
      bpf: Use hlist_add_head_rcu when linking to local_storage

Muchun Song (1):
      bpf: Fix potential call bpf_link_free() in atomic context

Neal Cardwell (5):
      tcp: Only init congestion control if not initialized already
      tcp: Simplify EBPF TCP_CONGESTION to always init CC
      tcp: simplify tcp_set_congestion_control(): Always reinitialize
      tcp: simplify _bpf_setsockopt(): Remove flags argument
      tcp: Simplify tcp_set_congestion_control() load=false case

Quentin Monnet (11):
      tools: bpftool: Fix formatting in bpftool-link documentation
      bpf: Fix formatting in documentation for BPF helpers
      tools, bpf: Synchronise BPF UAPI header with tools
      tools: bpftool: Log info-level messages when building bpftool man pages
      selftests, bpftool: Add bpftool (and eBPF helpers) documentation build
      tools: bpftool: Print optional built-in features along with version
      tools: bpftool: Include common options from separate file
      tools: bpftool: Clean up function to dump map entry
      tools: bpftool: Keep errors for map-of-map dumps if distinct from ENOENT
      tools: bpftool: Add "inner_map" to "bpftool map create" outer maps
      tools: bpftool: Automate generation for "SEE ALSO" sections in man pages

Song Liu (1):
      bpf: Fix comment for helper bpf_current_task_under_cgroup()

YiFei Zhu (5):
      bpf: Mutex protect used_maps array and count
      bpf: Add BPF_PROG_BIND_MAP syscall
      libbpf: Add BPF_PROG_BIND_MAP syscall and use it on .rodata section
      bpftool: Support dumping metadata
      selftests/bpf: Test load and dump metadata with btftool and skel

Yonghong Song (9):
      bpf: Avoid iterating duplicated files for task_file iterator
      selftests/bpf: Test task_file iterator without visiting pthreads
      bpf: Permit map_ptr arithmetic with opcode add and offset 0
      selftests/bpf: Add test for map_ptr arithmetic
      selftests/bpf: Fix test_sysctl_loop{1, 2} failure due to clang change
      selftests/bpf: Define string const as global for test_sysctl_prog.c
      bpftool: Fix build failure
      libbpf: Fix a compilation error with xsk.c for ubuntu 16.04
      bpf: Using rcu_read_lock for bpf_sk_storage_map iterator

 Makefile                                           |    4 +-
 arch/s390/net/bpf_jit_comp.c                       |   61 +-
 arch/x86/include/asm/nospec-branch.h               |   16 +-
 arch/x86/net/bpf_jit_comp.c                        |  265 +++-
 drivers/net/ethernet/netronome/nfp/bpf/offload.c   |   18 +-
 include/linux/bpf.h                                |   30 +-
 include/linux/bpf_verifier.h                       |    3 +
 include/linux/btf_ids.h                            |    8 +
 include/linux/filter.h                             |    4 +-
 include/net/inet_connection_sock.h                 |    3 +-
 include/net/tcp.h                                  |    2 +-
 include/uapi/linux/bpf.h                           |   98 +-
 kernel/bpf/arraymap.c                              |   55 +-
 kernel/bpf/bpf_inode_storage.c                     |    8 +-
 kernel/bpf/bpf_local_storage.c                     |    2 +-
 kernel/bpf/btf.c                                   |   15 +-
 kernel/bpf/core.c                                  |   18 +-
 kernel/bpf/stackmap.c                              |    5 +-
 kernel/bpf/syscall.c                               |   87 +-
 kernel/bpf/task_iter.c                             |   15 +-
 kernel/bpf/verifier.c                              |  540 +++++---
 kernel/trace/bpf_trace.c                           |   23 +-
 net/core/bpf_sk_storage.c                          |   40 +-
 net/core/dev.c                                     |   11 +-
 net/core/filter.c                                  |   49 +-
 net/core/sock_map.c                                |  284 +++-
 net/ipv4/bpf_tcp_ca.c                              |   19 +-
 net/ipv4/tcp.c                                     |    3 +-
 net/ipv4/tcp_cong.c                                |   27 +-
 net/ipv4/tcp_input.c                               |    4 +-
 net/xdp/xsk.c                                      |    7 +-
 net/xdp/xsk.h                                      |    1 -
 net/xdp/xsk_buff_pool.c                            |    6 +-
 net/xdp/xsk_diag.c                                 |   14 +-
 net/xdp/xskmap.c                                   |    5 -
 samples/bpf/.gitignore                             |    1 +
 samples/bpf/sockex3_user.c                         |    6 +-
 samples/bpf/spintest_user.c                        |    6 +-
 samples/bpf/test_map_in_map_kern.c                 |    7 +-
 samples/bpf/tracex5_user.c                         |    6 +-
 samples/bpf/xdp_redirect_cpu_user.c                |    2 +-
 samples/bpf/xdpsock_user.c                         |   28 +-
 scripts/link-vmlinux.sh                            |    6 +-
 tools/bpf/bpftool/Documentation/Makefile           |   15 +-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |   37 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   33 +-
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |   33 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |   37 +-
 tools/bpf/bpftool/Documentation/bpftool-iter.rst   |   27 +-
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |   36 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   46 +-
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |   34 +-
 tools/bpf/bpftool/Documentation/bpftool-perf.rst   |   34 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   34 +-
 .../bpftool/Documentation/bpftool-struct_ops.rst   |   35 +-
 tools/bpf/bpftool/Documentation/bpftool.rst        |   34 +-
 tools/bpf/bpftool/Documentation/common_options.rst |   22 +
 tools/bpf/bpftool/bash-completion/bpftool          |   22 +-
 tools/bpf/bpftool/json_writer.c                    |    6 +
 tools/bpf/bpftool/json_writer.h                    |    3 +
 tools/bpf/bpftool/main.c                           |   33 +-
 tools/bpf/bpftool/map.c                            |  149 ++-
 tools/bpf/bpftool/prog.c                           |  203 ++-
 tools/bpf/resolve_btfids/Makefile                  |    2 +
 tools/include/linux/btf_ids.h                      |    8 +
 tools/include/uapi/linux/bpf.h                     |   98 +-
 tools/lib/bpf/bpf.c                                |   16 +
 tools/lib/bpf/bpf.h                                |    8 +
 tools/lib/bpf/btf.h                                |   18 +-
 tools/lib/bpf/libbpf.c                             | 1356 +++++++++++++-------
 tools/lib/bpf/libbpf.h                             |    5 +-
 tools/lib/bpf/libbpf.map                           |    2 +
 tools/lib/bpf/libbpf_common.h                      |    2 +
 tools/lib/bpf/xsk.c                                |    1 +
 tools/perf/util/bpf-loader.c                       |   12 +-
 tools/testing/selftests/bpf/.gitignore             |    1 -
 tools/testing/selftests/bpf/Makefile               |   10 +-
 tools/testing/selftests/bpf/flow_dissector_load.h  |    8 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   21 +
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |    4 +
 .../selftests/bpf/{test_btf.c => prog_tests/btf.c} |  410 ++----
 .../selftests/bpf/prog_tests/cls_redirect.c        |   72 +-
 tools/testing/selftests/bpf/prog_tests/d_path.c    |   10 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   21 +-
 .../selftests/bpf/prog_tests/global_data_init.c    |    3 +-
 tools/testing/selftests/bpf/prog_tests/ksyms.c     |    6 +-
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |    9 +-
 tools/testing/selftests/bpf/prog_tests/metadata.c  |  141 ++
 .../selftests/bpf/prog_tests/reference_tracking.c  |    2 +-
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |    2 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   89 ++
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |    4 +-
 tools/testing/selftests/bpf/prog_tests/subprogs.c  |   31 +
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |  332 +++++
 .../selftests/bpf/prog_tests/xdp_noinline.c        |   49 +-
 tools/testing/selftests/bpf/progs/bpf_iter.h       |    9 +
 .../testing/selftests/bpf/progs/bpf_iter_sockmap.c |   43 +
 .../testing/selftests/bpf/progs/bpf_iter_sockmap.h |    3 +
 .../selftests/bpf/progs/bpf_iter_task_file.c       |   10 +-
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |   10 +-
 .../testing/selftests/bpf/progs/metadata_unused.c  |   15 +
 tools/testing/selftests/bpf/progs/metadata_used.c  |   15 +
 tools/testing/selftests/bpf/progs/pyperf.h         |   11 +-
 .../testing/selftests/bpf/progs/pyperf_subprogs.c  |    5 +
 tools/testing/selftests/bpf/progs/strobemeta.h     |   30 +-
 .../selftests/bpf/progs/strobemeta_subprogs.c      |   10 +
 .../selftests/bpf/progs/tailcall_bpf2bpf1.c        |   38 +
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c        |   41 +
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c        |   61 +
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |   61 +
 .../selftests/bpf/progs/test_cls_redirect.c        |  105 +-
 .../bpf/progs/test_cls_redirect_subprogs.c         |    2 +
 tools/testing/selftests/bpf/progs/test_d_path.c    |    9 +-
 .../selftests/bpf/progs/test_l4lb_noinline.c       |   41 +-
 tools/testing/selftests/bpf/progs/test_subprogs.c  |  103 ++
 .../selftests/bpf/progs/test_sysctl_loop1.c        |    4 +-
 .../selftests/bpf/progs/test_sysctl_loop2.c        |    4 +-
 .../testing/selftests/bpf/progs/test_sysctl_prog.c |    4 +-
 .../selftests/bpf/progs/test_xdp_noinline.c        |   36 +-
 tools/testing/selftests/bpf/test_bpftool_build.sh  |   21 +
 .../testing/selftests/bpf/test_bpftool_metadata.sh |   82 ++
 tools/testing/selftests/bpf/test_socket_cookie.c   |    2 +-
 tools/testing/selftests/bpf/verifier/calls.c       |    6 +-
 tools/testing/selftests/bpf/verifier/map_ptr.c     |   32 +
 124 files changed, 4211 insertions(+), 2040 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/common_options.rst
 rename tools/testing/selftests/bpf/{test_btf.c => prog_tests/btf.c} (96%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/metadata.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/subprogs.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_sockmap.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_sockmap.h
 create mode 100644 tools/testing/selftests/bpf/progs/metadata_unused.c
 create mode 100644 tools/testing/selftests/bpf/progs/metadata_used.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf_subprogs.c
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta_subprogs.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf1.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf3.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_subprogs.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subprogs.c
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_metadata.sh
