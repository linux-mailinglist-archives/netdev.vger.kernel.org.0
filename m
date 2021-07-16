Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E363CB0C1
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 04:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhGPCYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 22:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbhGPCYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 22:24:47 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61E7C06175F;
        Thu, 15 Jul 2021 19:21:51 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s18so8529847pgg.8;
        Thu, 15 Jul 2021 19:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2pV3nEuJ7NoXTPCXF39gw1r9HV1mDGqymnukc1rbFgM=;
        b=s+guN07dGX4//tJ7te8oDHmKvek4UVeY1DM6mz1oTP5pTpoDjqDLUgT9cWzvn7EKma
         /AoF+b/AEUgDdxnA/Pc77YcEcJXfaYk94o/V6PCua0HPURSp72gm2h4c0Nhz3owxl6BN
         q9+QQJhOuRkhqw74M7Px3f4NQzWxm2QM5EeyIVchBQ0Y7EQBAaIOkW4hNtnU3FvoEi2E
         F/aJDXe8rdTz5zVYyZZdyTzH1ONRwxQvaceP7ypnt5NBlStGWR579eAaRhTSXI7ddBNx
         T7vCYXnQ63F5NhXpAyZUP9J9R5Rh8TQ3zG2knZgw7bFRfroOTz8z77WGimzTGII0We8h
         s6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2pV3nEuJ7NoXTPCXF39gw1r9HV1mDGqymnukc1rbFgM=;
        b=tSPkzLqgWil3x4+U9YlSeGW8Cpe6oq9wcE5ZWaWHFIYvj1y9VkYix0oeENcllAyEAP
         JbPiXsyiEWe9y7YXE7OTQXDkVN6iv3tlMhhziO7FIWxl2KkXEyfxP1v1oKecjlrSVVef
         547ziZ8B/ixVC7glConQjKyoLtJruOBj0RuGb1AYBSQlw8OvoVDwUl+LH5p1MIRSkCF/
         G53bvxd9Fw062JrXm0HQuW5WrrHEoJ2wX2Tt3oVJ8UH2cWNydClrrIKKv367KztIXawn
         JpnMtKz2Mi+atqKEfBnw6Z3sUS04RIYs/gt7GCkXAgBa2jkEHffJkRjJxrcQ/76Fq0Lu
         89aA==
X-Gm-Message-State: AOAM533IFlm7GwOzNZiVTcpDFPlF9AbfajFa3aPqMgstloqXBDCfFh8Y
        M0L41BKBTytuVexG8xOI702kF0P8iDA=
X-Google-Smtp-Source: ABdhPJzsi+89b67Cx2S1aHDpODs3RScis3rtiI2KmH8F+pNZyg7NJM32xnLaM38EihpAsCYlfPF1ZA==
X-Received: by 2002:a05:6a00:d5f:b029:32c:7264:2f65 with SMTP id n31-20020a056a000d5fb029032c72642f65mr7788687pfv.40.1626402111143;
        Thu, 15 Jul 2021 19:21:51 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:608c])
        by smtp.gmail.com with ESMTPSA id y9sm7234786pfa.197.2021.07.15.19.21.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jul 2021 19:21:50 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2021-07-15
Date:   Thu, 15 Jul 2021 19:21:47 -0700
Message-Id: <20210716022147.82990-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 45 non-merge commits during the last 15 day(s) which contain
a total of 52 files changed, 3122 insertions(+), 384 deletions(-).

The main changes are:

1) Introduce bpf timers, from Alexei.

2) Add sockmap support for unix datagram socket, from Cong.

3) Fix potential memleak and UAF in the verifier, from He.

4) Add bpf_get_func_ip helper, from Jiri.

5) Improvements to generic XDP mode, from Kumar.

6) Support for passing xdp_md to XDP programs in bpf_prog_run, from Zvi.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Jesper Dangaard Brouer, John Fastabend, Martin KaFai 
Lau, Masami Hiramatsu, Song Liu, Toke Høiland-Jørgensen, Willem de 
Bruijn, Yonghong Song

----------------------------------------------------------------

The following changes since commit 5e437416ff66981d8154687cfdf7de50b1d82bfc:

  Merge branch 'dsa-mv88e6xxx-topaz-fixes' (2021-07-01 11:51:36 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to c50524ec4e3ad97d7d963268abd859c6413fbeb4:

  Merge branch 'sockmap: add sockmap support for unix datagram socket' (2021-07-15 18:17:51 -0700)

----------------------------------------------------------------
Alan Maguire (1):
      libbpf: Allow specification of "kprobe/function+offset"

Alexei Starovoitov (16):
      Merge branch 'bpf: support input xdp_md context in BPF_PROG_TEST_RUN'
      Merge branch 'Generic XDP improvements'
      bpf: Sync tools/include/uapi/linux/bpf.h
      bpf: Prepare bpf_prog_put() to be called from irq context.
      bpf: Factor out bpf_spin_lock into helpers.
      bpf: Introduce bpf timers.
      bpf: Add map side support for bpf timers.
      bpf: Prevent pointer mismatch in bpf_timer_init.
      bpf: Remember BTF of inner maps.
      bpf: Relax verifier recursion check.
      bpf: Implement verifier support for validation of async callbacks.
      bpf: Teach stack depth check about async callbacks.
      selftests/bpf: Add bpf_timer test.
      selftests/bpf: Add a test with bpf_timer in inner map.
      Merge branch 'Add bpf_get_func_ip helper'
      Merge branch 'sockmap: add sockmap support for unix datagram socket'

Cong Wang (11):
      sock_map: Relax config dependency to CONFIG_NET
      sock_map: Lift socket state restriction for datagram sockets
      af_unix: Implement ->read_sock() for sockmap
      af_unix: Set TCP_ESTABLISHED for datagram sockets too
      af_unix: Add a dummy ->close() for sockmap
      af_unix: Implement ->psock_update_sk_prot()
      af_unix: Implement unix_dgram_bpf_recvmsg()
      selftests/bpf: Factor out udp_socketpair()
      selftests/bpf: Factor out add_to_sockmap()
      selftests/bpf: Add a test case for unix sockmap
      selftests/bpf: Add test cases for redirection between udp and unix

Daniel Borkmann (1):
      Merge branch 'bpf-timers'

He Fengqing (1):
      bpf: Fix potential memleak and UAF in the verifier.

Jesper Dangaard Brouer (1):
      samples/bpf: xdp_redirect_cpu_user: Cpumap qsize set larger default

Jiri Olsa (7):
      bpf, x86: Store caller's ip in trampoline stack
      bpf: Enable BPF_TRAMP_F_IP_ARG for trampolines with call_get_func_ip
      bpf: Add bpf_get_func_ip helper for tracing programs
      bpf: Add bpf_get_func_ip helper for kprobe programs
      selftests/bpf: Add test for bpf_get_func_ip helper
      libbpf: Add bpf_program__attach_kprobe_opts function
      selftests/bpf: Add test for bpf_get_func_ip in kprobe+offset probe

Kumar Kartikeya Dwivedi (5):
      net: core: Split out code to run generic XDP prog
      bitops: Add non-atomic bitops for pointers
      bpf: cpumap: Implement generic cpumap
      bpf: devmap: Implement devmap prog execution for generic XDP
      bpf: Tidy xdp attach selftests

Kuniyuki Iwashima (1):
      bpf: Fix a typo of reuseport map in bpf.h.

Martynas Pumputis (1):
      libbpf: Fix reuse of pinned map on older kernel

Tobias Klauser (1):
      selftests/bpf: Remove unused variable in tc_tunnel prog

Zvi Effron (4):
      bpf: Add function for XDP meta data length check
      bpf: Support input xdp_md context in BPF_PROG_TEST_RUN
      bpf: Support specifying ingress via xdp_md context in BPF_PROG_TEST_RUN
      selftests/bpf: Add test for xdp_md context in BPF_PROG_TEST_RUN

 MAINTAINERS                                        |   1 +
 arch/x86/net/bpf_jit_comp.c                        |  19 +
 include/linux/bitops.h                             |  50 +++
 include/linux/bpf.h                                | 100 +++--
 include/linux/bpf_verifier.h                       |  19 +-
 include/linux/btf.h                                |   1 +
 include/linux/filter.h                             |   3 +-
 include/linux/netdevice.h                          |   2 +
 include/linux/skbuff.h                             |  10 +-
 include/linux/typecheck.h                          |   9 +
 include/net/af_unix.h                              |  12 +
 include/net/xdp.h                                  |   5 +
 include/uapi/linux/bpf.h                           |  85 ++++-
 kernel/bpf/Kconfig                                 |   2 +-
 kernel/bpf/arraymap.c                              |  21 ++
 kernel/bpf/btf.c                                   |  77 +++-
 kernel/bpf/cpumap.c                                | 116 +++++-
 kernel/bpf/devmap.c                                |  49 ++-
 kernel/bpf/hashtab.c                               | 105 +++++-
 kernel/bpf/helpers.c                               | 340 ++++++++++++++++-
 kernel/bpf/local_storage.c                         |   4 +-
 kernel/bpf/map_in_map.c                            |   8 +
 kernel/bpf/syscall.c                               |  53 ++-
 kernel/bpf/trampoline.c                            |  12 +-
 kernel/bpf/verifier.c                              | 379 ++++++++++++++++++-
 kernel/trace/bpf_trace.c                           |  33 +-
 net/bpf/test_run.c                                 | 109 +++++-
 net/core/Makefile                                  |   2 -
 net/core/dev.c                                     | 103 +++---
 net/core/filter.c                                  |  10 +-
 net/core/sock_map.c                                |  22 +-
 net/ipv4/udp_bpf.c                                 |   1 -
 net/unix/Makefile                                  |   1 +
 net/unix/af_unix.c                                 |  85 ++++-
 net/unix/unix_bpf.c                                | 122 +++++++
 samples/bpf/xdp_redirect_cpu_user.c                |  22 +-
 scripts/bpf_doc.py                                 |   2 +
 tools/include/uapi/linux/bpf.h                     |  85 ++++-
 tools/lib/bpf/libbpf.c                             | 104 +++++-
 .../selftests/bpf/prog_tests/get_func_ip_test.c    |  53 +++
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 406 +++++++++++++++++----
 tools/testing/selftests/bpf/prog_tests/timer.c     |  55 +++
 tools/testing/selftests/bpf/prog_tests/timer_mim.c |  69 ++++
 .../bpf/prog_tests/xdp_context_test_run.c          | 105 ++++++
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |  43 +--
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |  39 +-
 .../testing/selftests/bpf/progs/get_func_ip_test.c |  73 ++++
 tools/testing/selftests/bpf/progs/test_tc_tunnel.c |   1 -
 .../bpf/progs/test_xdp_context_test_run.c          |  20 +
 tools/testing/selftests/bpf/progs/timer.c          | 297 +++++++++++++++
 tools/testing/selftests/bpf/progs/timer_mim.c      |  88 +++++
 .../testing/selftests/bpf/progs/timer_mim_reject.c |  74 ++++
 52 files changed, 3122 insertions(+), 384 deletions(-)
 create mode 100644 net/unix/unix_bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_context_test_run.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_func_ip_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_context_test_run.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim_reject.c
