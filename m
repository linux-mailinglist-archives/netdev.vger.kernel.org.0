Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C92628C369
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 22:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbgJLUz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 16:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgJLUzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 16:55:25 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E51C0613D0;
        Mon, 12 Oct 2020 13:55:25 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j7so4815498pgk.5;
        Mon, 12 Oct 2020 13:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOqX6ZA5NhEl9eqkMEXDWMgAlQbfF4PK52Ihdx6sTuE=;
        b=AiYQAAlYcJ9gOyZtJd4gZavbI7W2hW8BPMZJYtc9hwGfRxDGP5gK3OdjsFioE6vOMZ
         B09ufgRUQM4Bw28FilZK29XW4vUb3Kqr/eYBCeRJT5owuLIryknX+h4s00A5ruBk3FPK
         +HuFJQGTV31Igm67WZfV6Nyfw+O/GtFtjPcm38FTILl9s7iwiVnBItP3g5i5QaE22JRG
         JKiDIg7TCr5Hriujd+TL6hgnCjTrsIQmSlwqNsCq76qMfyT2YiKFa7VVvSg2IpMiJy5D
         7qfGBrBF86fVTMaz7h3sxD3qNL1U/Pfp55dPGWPGaunzFhL6ziCIP65PdrumYfD1e61r
         0gvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOqX6ZA5NhEl9eqkMEXDWMgAlQbfF4PK52Ihdx6sTuE=;
        b=GHxjaFb+rk0Q6JCM4DleE4AxYLU/jby92J2TabV/t0EHVx+VYSpbfegf/Wq6gEv2Ih
         CYUhhiN3QEwHXzAusIDcVmD57z0TVMcLA4W4HQ47PtrACCJOicm57F3dZyMxLjfPJdQX
         Brk7JPKwWFxD+gfimSounDYcKQW4MOJRsiVgmu10K0hC9ATPaIeFtJ0DAZwHalBZcWrv
         GjJ426bJEMVGjEcAW0c4haC+n5w1ru+BhfQ1An593nN+3xK+vrXhsnQvOWi6+grJTmcQ
         6sCex5TfvXj//DWjYbBpS1cxliWjbVFSzJqJMoBURG6oeXMjLktt31xeW/x2Ji2rM2v2
         LTLQ==
X-Gm-Message-State: AOAM530oDGgvcQyvmG7HQ44KHAnMdVh+inJsuywsqM4xe24prDKQfBth
        LXMnMI8YOfkx8iXb2Ew1tOAlwW+UIPJdmA==
X-Google-Smtp-Source: ABdhPJzPDBvoMhbkMrRir7B+YJ62ZsZsvi9M54YdmrQQL/OYfkgBBEA+sV4V9h+ed9H7FTmprOgViw==
X-Received: by 2002:a17:90a:fa86:: with SMTP id cu6mr12569489pjb.167.1602536124852;
        Mon, 12 Oct 2020 13:55:24 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id q16sm19598058pfu.206.2020.10.12.13.55.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2020 13:55:23 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf-next 2020-10-12
Date:   Mon, 12 Oct 2020 13:55:22 -0700
Message-Id: <20201012205522.27023-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 62 non-merge commits during the last 10 day(s) which contain
a total of 73 files changed, 4339 insertions(+), 772 deletions(-).

The main changes are:

1) The BPF verifier improvements to track register allocation pattern, from Alexei and Yonghong.

2) libbpf relocation support for different size load/store, from Andrii.

3) bpf_redirect_peer() helper and support for inner map array with different max_entries, from Daniel.

4) BPF support for per-cpu variables, form Hao.

5) sockmap improvements, from John.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Christoph Hellwig, David Ahern, 
John Fastabend, Martin KaFai Lau, Petar Penkov, Samanta Navarro, 
Stanislav Fomichev, Yonghong Song

----------------------------------------------------------------

The following changes since commit 360f89874635b08057757376b8cc4faa221862e2:

  lib8390: Use netif_msg_init to initialize msg_enable bits (2020-10-01 19:08:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 376dcfe3a4e5a5475a84e6b5f926066a8614f887:

  Merge branch 'bpf, sockmap: allow verdict only sk_skb progs' (2020-10-11 18:09:45 -0700)

----------------------------------------------------------------
Alexei Starovoitov (13):
      Merge branch 'Do not limit cb_flags when creating child sk'
      Merge branch 'bpf: BTF support for ksyms'
      Merge branch 'Add skb_adjust_room() for SK_SKB'
      Merge branch 'Fix pining maps after reuse map fd'
      Merge branch 'libbpf: auto-resize relocatable LOAD/STORE instructions'
      bpf: Propagate scalar ranges through register assignments.
      selftests/bpf: Add profiler test
      selftests/bpf: Asm tests for the verifier regalloc tracking.
      Merge branch 'Follow-up BPF helper improvements'
      Merge branch 'samples: bpf: Refactor XDP programs with libbpf'
      bpf: Migrate from patchwork.ozlabs.org to patchwork.kernel.org.
      Merge branch 'sockmap/sk_skb program memory acct fixes'
      Merge branch 'bpf, sockmap: allow verdict only sk_skb progs'

Andrii Nakryiko (5):
      bpf, doc: Update Andrii's email in MAINTAINERS
      libbpf: Skip CO-RE relocations for not loaded BPF programs
      libbpf: Support safe subset of load/store instruction resizing with CO-RE
      libbpf: Allow specifying both ELF and raw BTF for CO-RE BTF override
      selftests/bpf: Validate libbpf's auto-sizing of LD/ST/STX instructions

Björn Töpel (1):
      xsk: Remove internal DMA headers

Ciara Loftus (3):
      samples: bpf: Split xdpsock stats into new struct
      samples: bpf: Count syscalls in xdpsock
      samples: bpf: Driver interrupt statistics in xdpsock

Daniel Borkmann (7):
      Merge branch 'bpf-llvm-reg-alloc-patterns'
      bpf: Improve bpf_redirect_neigh helper description
      bpf: Add redirect_peer helper
      bpf: Allow for map-in-map with dynamic inner array map entries
      bpf, selftests: Add test for different array inner map size
      bpf, selftests: Make redirect_neigh test more extensible
      bpf, selftests: Add redirect_peer selftest

Daniel T. Lee (3):
      samples: bpf: Refactor xdp_monitor with libbpf
      samples: bpf: Replace attach_tracepoint() to attach() in xdp_redirect_cpu
      samples: bpf: Refactor XDP kern program maps with BTF-defined map

Gustavo A. R. Silva (1):
      bpf, verifier: Use fallthrough pseudo-keyword

Hangbin Liu (3):
      libbpf: Close map fd if init map slots failed
      libbpf: Check if pin_path was set even map fd exist
      selftest/bpf: Test pinning map with reused map fd

Hao Luo (7):
      bpf: Introduce pseudo_btf_id
      bpf/libbpf: BTF support for typed ksyms
      selftests/bpf: Ksyms_btf to test typed ksyms
      bpf: Introduce bpf_per_cpu_ptr()
      bpf: Introducte bpf_this_cpu_ptr()
      bpf/selftests: Test for bpf_per_cpu_ptr() and bpf_this_cpu_ptr()
      selftests/bpf: Fix test_verifier after introducing resolve_pseudo_ldimm64

Jakub Wilk (1):
      bpf: Fix typo in uapi/linux/bpf.h

John Fastabend (12):
      bpf, sockmap: Add skb_adjust_room to pop bytes off ingress payload
      bpf, sockmap: Update selftests to use skb_adjust_room
      bpf, sockmap: Skb verdict SK_PASS to self already checked rmem limits
      bpf, sockmap: On receive programs try to fast track SK_PASS ingress
      bpf, sockmap: Remove skb_set_owner_w wmem will be taken later from sendpage
      bpf, sockmap: Remove dropped data on errors in redirect case
      bpf, sockmap: Remove skb_orphan and let normal skb_kfree do cleanup
      bpf, sockmap: Add memory accounting so skbs on ingress lists are visible
      bpf, sockmap: Check skb_verdict and skb_parser programs explicitly
      bpf, sockmap: Allow skipping sk_skb parser program
      bpf, selftests: Add option to test_sockmap to omit adding parser program
      bpf, selftests: Add three new sockmap tests for verdict only programs

Luigi Rizzo (1):
      bpf, libbpf: Use valid btf in bpf_program__set_attach_target

Magnus Karlsson (2):
      libbpf: Fix compatibility problem in xsk_socket__create
      xsk: Introduce padding between ring pointers

Martin KaFai Lau (2):
      bpf: tcp: Do not limit cb_flags when creating child sk from listen sk
      bpf: selftest: Ensure the child sk inherited all bpf_sock_ops_cb_flags

Nikita V. Shirokov (1):
      bpf: Add tcp_notsent_lowat bpf setsockopt

Randy Dunlap (1):
      kernel/bpf/verifier: Fix build when NET is not enabled

Song Liu (1):
      bpf: Use raw_spin_trylock() for pcpu_freelist_push/pop in NMI

Stanislav Fomichev (3):
      selftests/bpf: Initialize duration in xdp_noinline.c
      selftests/bpf: Properly initialize linfo in sockmap_basic
      bpf: Deref map in BPF_PROG_BIND_MAP when it's already used

Toke Høiland-Jørgensen (1):
      bpf: Always return target ifindex in bpf_fib_lookup

Yonghong Song (4):
      samples/bpf: Change Makefile to cope with latest llvm
      samples/bpf: Fix a compilation error with fallthrough marking
      bpf: Fix build failure for kernel/trace/bpf_trace.c with CONFIG_NET=n
      bpf: Track spill/fill of bounded scalars.

 Documentation/bpf/bpf_devel_QA.rst                 |   4 +-
 MAINTAINERS                                        |   2 +-
 drivers/net/veth.c                                 |   9 +
 include/linux/bpf.h                                |   8 +-
 include/linux/bpf_verifier.h                       |   7 +
 include/linux/btf.h                                |  26 +
 include/linux/netdevice.h                          |   4 +
 include/linux/skmsg.h                              |   2 +
 include/net/tcp.h                                  |  33 -
 include/uapi/linux/bpf.h                           | 101 ++-
 kernel/bpf/arraymap.c                              |  17 +-
 kernel/bpf/btf.c                                   |  25 -
 kernel/bpf/hashtab.c                               |   6 +-
 kernel/bpf/helpers.c                               |  32 +
 kernel/bpf/percpu_freelist.c                       | 101 ++-
 kernel/bpf/percpu_freelist.h                       |   1 +
 kernel/bpf/syscall.c                               |   4 +-
 kernel/bpf/verifier.c                              | 270 +++++-
 kernel/trace/bpf_trace.c                           |   6 +
 net/core/dev.c                                     |  15 +-
 net/core/filter.c                                  | 107 ++-
 net/core/skmsg.c                                   | 161 +++-
 net/core/sock_map.c                                |  37 +-
 net/ipv4/tcp_minisocks.c                           |   1 -
 net/xdp/xsk_buff_pool.c                            |   3 -
 net/xdp/xsk_queue.h                                |   4 +
 net/xdp/xskmap.c                                   |   2 +-
 samples/bpf/Makefile                               |  15 +-
 samples/bpf/hbm.c                                  |   3 +-
 samples/bpf/xdp_monitor_kern.c                     |  60 +-
 samples/bpf/xdp_monitor_user.c                     | 159 +++-
 samples/bpf/xdp_redirect_cpu_user.c                | 153 ++--
 samples/bpf/xdp_sample_pkts_kern.c                 |  14 +-
 samples/bpf/xdp_sample_pkts_user.c                 |   1 -
 samples/bpf/xdpsock_user.c                         | 354 ++++++--
 tools/include/uapi/linux/bpf.h                     | 101 ++-
 tools/lib/bpf/libbpf.c                             | 348 ++++++--
 tools/lib/bpf/xsk.c                                |   7 +-
 tools/testing/selftests/bpf/README.rst             |  38 +
 tools/testing/selftests/bpf/prog_tests/align.c     |  16 +-
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |  39 +-
 .../selftests/bpf/prog_tests/core_autosize.c       | 225 +++++
 tools/testing/selftests/bpf/prog_tests/ksyms.c     |  38 +-
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |  88 ++
 tools/testing/selftests/bpf/prog_tests/pinning.c   |  49 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   2 +-
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |  12 +
 .../selftests/bpf/prog_tests/test_profiler.c       |  72 ++
 .../selftests/bpf/prog_tests/xdp_noinline.c        |   2 +-
 tools/testing/selftests/bpf/progs/connect4_prog.c  |  19 +
 tools/testing/selftests/bpf/progs/profiler.h       | 177 ++++
 tools/testing/selftests/bpf/progs/profiler.inc.h   | 969 +++++++++++++++++++++
 tools/testing/selftests/bpf/progs/profiler1.c      |   6 +
 tools/testing/selftests/bpf/progs/profiler2.c      |   6 +
 tools/testing/selftests/bpf/progs/profiler3.c      |   6 +
 .../selftests/bpf/progs/test_btf_map_in_map.c      |  43 +
 .../selftests/bpf/progs/test_core_autosize.c       | 172 ++++
 tools/testing/selftests/bpf/progs/test_ksyms_btf.c |  55 ++
 .../bpf/progs/test_misc_tcp_hdr_options.c          |   4 +-
 .../selftests/bpf/progs/test_sockmap_kern.h        |  34 +-
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |  40 +-
 tools/testing/selftests/bpf/progs/test_tc_peer.c   |  45 +
 .../selftests/bpf/progs/test_tcp_hdr_options.c     |   7 +-
 tools/testing/selftests/bpf/test_sockmap.c         |  81 +-
 tools/testing/selftests/bpf/test_tc_neigh.sh       | 168 ----
 tools/testing/selftests/bpf/test_tc_redirect.sh    | 204 +++++
 tools/testing/selftests/bpf/test_tcp_hdr_options.h |   5 +-
 tools/testing/selftests/bpf/trace_helpers.c        |  27 +
 tools/testing/selftests/bpf/trace_helpers.h        |   4 +
 tools/testing/selftests/bpf/verifier/basic.c       |   2 +-
 .../selftests/bpf/verifier/direct_packet_access.c  |   2 +-
 tools/testing/selftests/bpf/verifier/ld_imm64.c    |   8 -
 tools/testing/selftests/bpf/verifier/regalloc.c    | 243 ++++++
 73 files changed, 4339 insertions(+), 772 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_autosize.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_profiler.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler.h
 create mode 100644 tools/testing/selftests/bpf/progs/profiler.inc.h
 create mode 100644 tools/testing/selftests/bpf/progs/profiler1.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler2.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler3.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_autosize.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_peer.c
 delete mode 100755 tools/testing/selftests/bpf/test_tc_neigh.sh
 create mode 100755 tools/testing/selftests/bpf/test_tc_redirect.sh
 create mode 100644 tools/testing/selftests/bpf/verifier/regalloc.c
