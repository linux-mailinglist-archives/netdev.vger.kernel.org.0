Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90116369E82
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 04:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbhDXCZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 22:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbhDXCZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 22:25:40 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815C9C061574;
        Fri, 23 Apr 2021 19:25:03 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lt13so15168875pjb.1;
        Fri, 23 Apr 2021 19:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJMOJherPDXPAwQz7zMKR9TdRbXkn6U4di8aK+tbR0A=;
        b=YXBi6QJonuUF8BM+f6j8KU9zrOWZ4mzSH0cwFj4OS3ut4Mg66oAu9FEXL1pCxm+ZuB
         toTq/muPTFvuDvaJfVGz8gonM1IQrps0J2zy8lj23uRUYZtsZIQB3nWWLUbj9np//g4l
         ifEn+Wy9Mms3jenSH2HnB94yUzBL5ziJqi/lasYHnnH4G4YsluaLPaQeLcL9ngEaWEIK
         HFAa3pA8V1v/TBMj0dRFuHTM3DYsZKRqBfc3xgbX89OjndlDoiUvx+dSPQySZf0AQWUz
         weWJV+fltAToh7FUiNOMMg91xLz0QAjRIrlB66WbT8gixOfnzwYVwXXjW0aDuLWop+Xh
         DU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJMOJherPDXPAwQz7zMKR9TdRbXkn6U4di8aK+tbR0A=;
        b=ERHMhMYvct/AOoxV2azEVwbZU7uo6wvvYr6HZEAsOSOdE5r4ivhqfFJ6ipyOKXaNXB
         oCzneED81OAvI0T8M+jz/zD1Xx5hRnY/3kldNaaocNpA7CZ5C89mORPfEVsgD4Ashja+
         neq6sfTDzxllFGyBSnnsRmyXOZRQcLgYlTR7of5Or5kMcYfmOprN/X0MwsugbW1lUbm0
         d1FSaA5wkfRzACJ8v298NbPj0vakmZiaRvbC1+6IPrqa16o6pI3Zj83Ge+qjWHRKmQf0
         f1fFbfQMDHMgTRq0dKOM4HdHA3r2sY5jwdp7lsuxWX9oSQqdnDA6Qn1bxnS+SKy3OcGb
         uT8w==
X-Gm-Message-State: AOAM530/NN/xowDm+DiHABIwl2fnccmMLIxmfucYgSAaMFOsMULud7FE
        uuyjaBL/Dux6XmJo/QbJebA=
X-Google-Smtp-Source: ABdhPJymK8JbJquiMayDFB6QNFlHWwHLXIHMTjSSt8D18txYlvSnqq9uhLRzQU4nPhzXPB9rZQF9Mw==
X-Received: by 2002:a17:90a:420d:: with SMTP id o13mr9154950pjg.61.1619231102781;
        Fri, 23 Apr 2021 19:25:02 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id k20sm5618812pfa.34.2021.04.23.19.25.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Apr 2021 19:25:01 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2021-04-23
Date:   Fri, 23 Apr 2021 19:24:59 -0700
Message-Id: <20210424022459.16039-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 69 non-merge commits during the last 22 day(s) which contain
a total of 69 files changed, 3141 insertions(+), 866 deletions(-).

The main changes are:

1) Add BPF static linker support for extern resolution of global, from Andrii.

2) Refine retval for bpf_get_task_stack helper, from Dave.

3) Add a bpf_snprintf helper, from Florent.

4) A bunch of miscellaneous improvements from many developers.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Arnaldo Carvalho de Melo, Jakub 
Sitnicki, Jesper Dangaard Brouer, John Fastabend, Lorenz Bauer, Magnus 
Karlsson, Martin KaFai Lau, Song Liu, Toke Høiland-Jørgensen, Yonghong 
Song

----------------------------------------------------------------

The following changes since commit 82506665179209e43d3c9d39ffa42f8c8ff968bd:

  tcp: reorder tcp_congestion_ops for better cache locality (2021-04-02 14:32:27 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 350a62ca065be252ababc43a7c96f8aca390a18f:

  bpf: Document the pahole release info related to libbpf in bpf_devel_QA.rst (2021-04-23 17:11:58 -0700)

----------------------------------------------------------------
Alexei Starovoitov (6):
      libbpf: Remove unused field.
      Merge branch 'bpf: tools: support build selftests/bpf with clang'
      Merge branch 'Add a snprintf eBPF helper'
      Merge branch 'bpf: refine retval for bpf_get_task_stack helper'
      Merge branch 'Simplify bpf_snprintf verifier code'
      Merge branch 'BPF static linker: support externs'

Andrii Nakryiko (20):
      libbpf: Add bpf_map__inner_map API
      Merge branch 'bpf/selftests: page size fixes'
      bpftool: Support dumping BTF VAR's "extern" linkage
      bpftool: Dump more info about DATASEC members
      libbpf: Suppress compiler warning when using SEC() macro with externs
      libbpf: Mark BPF subprogs with hidden visibility as static for BPF verifier
      libbpf: Allow gaps in BPF program sections to support overriden weak functions
      libbpf: Refactor BTF map definition parsing
      libbpf: Factor out symtab and relos sanity checks
      libbpf: Make few internal helpers available outside of libbpf.c
      libbpf: Extend sanity checking ELF symbols with externs validation
      libbpf: Tighten BTF type ID rewriting with error checking
      libbpf: Add linker extern resolution support for functions and global variables
      libbpf: Support extern resolution for BTF-defined maps in .maps section
      selftests/bpf: Use -O0 instead of -Og in selftests builds
      selftests/bpf: Omit skeleton generation for multi-linked BPF object files
      selftests/bpf: Add function linking selftest
      selftests/bpf: Add global variables linking selftest
      selftests/bpf: Add map linking selftest
      selftests/bpf: Document latest Clang fix expectations for linking tests

Cong Wang (3):
      bpf, udp: Remove some pointless comments
      skmsg: Pass psock pointer to ->psock_update_sk_prot()
      sock_map: Fix a potential use-after-free in sock_map_close()

Daniel Borkmann (1):
      bpf: Sync bpf headers in tooling infrastucture

Dave Marchevsky (3):
      bpf: Refine retval for bpf_get_task_stack helper
      bpf/selftests: Add bpf_get_task_stack retval bounds verifier test
      bpf/selftests: Add bpf_get_task_stack retval bounds test_prog

Florent Revest (9):
      selftests/bpf: Fix the ASSERT_ERR_PTR macro
      bpf: Factorize bpf_trace_printk and bpf_seq_printf
      bpf: Add a ARG_PTR_TO_CONST_STR argument type
      bpf: Add a bpf_snprintf helper
      libbpf: Initialize the bpf_seq_printf parameters array field by field
      libbpf: Introduce a BPF_SNPRINTF helper macro
      selftests/bpf: Add a series of tests for bpf_snprintf
      bpf: Notify user if we ever hit a bpf_snprintf verifier bug
      bpf: Remove unnecessary map checks for ARG_PTR_TO_CONST_STR

He Fengqing (1):
      bpf: Remove unused parameter from ___bpf_prog_run

Hengqi Chen (1):
      libbpf: Fix KERNEL_VERSION macro

Ilya Leoshkevich (1):
      bpf: Generate BTF_KIND_FLOAT when linking vmlinux

Jiri Olsa (1):
      selftests/bpf: Add docs target as all dependency

Joe Stringer (1):
      bpf: Document PROG_TEST_RUN limitations

John Fastabend (1):
      bpf, selftests: test_maps generating unrecognized data section

Li RongQing (1):
      xsk: Align XDP socket batch size with DPDK

Martin KaFai Lau (1):
      bpf: selftests: Specify CONFIG_DYNAMIC_FTRACE in the testing config

Martin Willi (1):
      net, xdp: Update pkt_type if generic XDP changes unicast MAC

Muhammad Usama Anjum (1):
      bpf, inode: Remove second initialization of the bpf_preload_lock

Pedro Tammela (1):
      libbpf: Clarify flags in ringbuf helpers

Tiezhu Yang (2):
      bpf, doc: Fix some invalid links in bpf_devel_QA.rst
      bpf: Document the pahole release info related to libbpf in bpf_devel_QA.rst

Toke Høiland-Jørgensen (2):
      bpf: Return target info when a tracing bpf_link is queried
      selftests/bpf: Add tests for target information in bpf_link info queries

Wan Jiabing (2):
      bpf, cgroup: Delete repeated struct bpf_prog declaration
      bpf: Remove repeated struct btf_type declaration

Yang Yingliang (1):
      libbpf: Remove redundant semi-colon

Yaqi Chen (1):
      samples/bpf: Fix broken tracex1 due to kprobe argument change

Yauheni Kaliuta (8):
      selftests/bpf: test_progs/sockopt_sk: Remove version
      selftests/bpf: test_progs/sockopt_sk: Convert to use BPF skeleton
      selftests/bpf: Pass page size from userspace in sockopt_sk
      selftests/bpf: Pass page size from userspace in map_ptr
      selftests/bpf: mmap: Use runtime page size
      selftests/bpf: ringbuf: Use runtime page size
      selftests/bpf: ringbuf_multi: Use runtime page size
      selftests/bpf: ringbuf_multi: Test bpf_map__set_inner_map_fd

Yonghong Song (5):
      selftests: Set CC to clang in lib.mk if LLVM is set
      tools: Allow proper CC/CXX/... override with LLVM=1 in Makefile.include
      selftests/bpf: Fix test_cpp compilation failure with clang
      selftests/bpf: Silence clang compilation warnings
      bpftool: Fix a clang compilation warning

zuoqilin (1):
      tools/testing: Remove unused variable

 Documentation/bpf/bpf_devel_QA.rst                 |   30 +-
 include/linux/bpf-cgroup.h                         |    1 -
 include/linux/bpf.h                                |   23 +-
 include/linux/bpf_verifier.h                       |    9 +
 include/linux/skmsg.h                              |    5 +-
 include/net/sock.h                                 |    5 +-
 include/net/tcp.h                                  |    2 +-
 include/net/udp.h                                  |    2 +-
 include/uapi/linux/bpf.h                           |   67 ++
 kernel/bpf/core.c                                  |    7 +-
 kernel/bpf/helpers.c                               |  306 +++++
 kernel/bpf/inode.c                                 |    2 -
 kernel/bpf/syscall.c                               |    3 +
 kernel/bpf/verifier.c                              |   84 ++
 kernel/trace/bpf_trace.c                           |  373 +-----
 net/core/dev.c                                     |    6 +-
 net/core/sock_map.c                                |    5 +-
 net/ipv4/tcp_bpf.c                                 |    3 +-
 net/ipv4/udp_bpf.c                                 |    5 +-
 net/xdp/xsk.c                                      |    2 +-
 samples/bpf/tracex1_kern.c                         |    4 +-
 scripts/link-vmlinux.sh                            |    7 +-
 tools/bpf/bpftool/btf.c                            |   30 +-
 tools/bpf/bpftool/net.c                            |    2 +-
 tools/include/uapi/linux/bpf.h                     |   83 +-
 tools/lib/bpf/bpf_helpers.h                        |   21 +-
 tools/lib/bpf/bpf_tracing.h                        |   58 +-
 tools/lib/bpf/btf.c                                |    5 -
 tools/lib/bpf/libbpf.c                             |  396 +++---
 tools/lib/bpf/libbpf.h                             |    1 +
 tools/lib/bpf/libbpf.map                           |    1 +
 tools/lib/bpf/libbpf_internal.h                    |   45 +
 tools/lib/bpf/linker.c                             | 1272 +++++++++++++++++---
 tools/scripts/Makefile.include                     |   12 +-
 tools/testing/selftests/bpf/Makefile               |   28 +-
 tools/testing/selftests/bpf/README.rst             |    9 +
 tools/testing/selftests/bpf/config                 |    2 +
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |    1 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   58 +-
 .../testing/selftests/bpf/prog_tests/fexit_sleep.c |    4 +-
 .../selftests/bpf/prog_tests/linked_funcs.c        |   42 +
 .../testing/selftests/bpf/prog_tests/linked_maps.c |   30 +
 .../testing/selftests/bpf/prog_tests/linked_vars.c |   43 +
 tools/testing/selftests/bpf/prog_tests/map_ptr.c   |   15 +-
 tools/testing/selftests/bpf/prog_tests/mmap.c      |   24 +-
 .../selftests/bpf/prog_tests/ns_current_pid_tgid.c |    4 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |   17 +-
 .../selftests/bpf/prog_tests/ringbuf_multi.c       |   37 +-
 tools/testing/selftests/bpf/prog_tests/snprintf.c  |  125 ++
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |   65 +-
 .../selftests/bpf/progs/bpf_iter_task_stack.c      |   27 +
 tools/testing/selftests/bpf/progs/linked_funcs1.c  |   73 ++
 tools/testing/selftests/bpf/progs/linked_funcs2.c  |   73 ++
 tools/testing/selftests/bpf/progs/linked_maps1.c   |   82 ++
 tools/testing/selftests/bpf/progs/linked_maps2.c   |   76 ++
 tools/testing/selftests/bpf/progs/linked_vars1.c   |   54 +
 tools/testing/selftests/bpf/progs/linked_vars2.c   |   55 +
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |    4 +-
 .../selftests/bpf/progs/sockmap_tcp_msg_prog.c     |   12 -
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |   11 +-
 tools/testing/selftests/bpf/progs/test_mmap.c      |    2 -
 tools/testing/selftests/bpf/progs/test_ringbuf.c   |    1 -
 .../selftests/bpf/progs/test_ringbuf_multi.c       |   12 +-
 tools/testing/selftests/bpf/progs/test_snprintf.c  |   73 ++
 .../selftests/bpf/progs/test_snprintf_single.c     |   20 +
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |    2 +-
 tools/testing/selftests/bpf/test_progs.h           |    2 +-
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |   43 +
 tools/testing/selftests/lib.mk                     |    4 +
 69 files changed, 3141 insertions(+), 866 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_funcs.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_maps.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_vars.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs2.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_maps1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_maps2.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_vars1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_vars2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_snprintf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_snprintf_single.c
