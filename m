Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831203332E1
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 02:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhCJBy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 20:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbhCJByQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 20:54:16 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF22CC06174A;
        Tue,  9 Mar 2021 17:54:04 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so6590726pjb.0;
        Tue, 09 Mar 2021 17:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TXnaCFPIwRklfD9delQze244DLtPDDvbJaE3MIE025c=;
        b=cwkwlL7chTzN30a6XjxeEO1nHnqNvnTFZ4sHYclEq/5bPusYg2w7HqqvROuLCaiVuC
         FnsS2jAJUrUpxtCMiJ3fCwl5xUq+AKtPXVjWU7JJXva1A73ePH4VHgMQ2r3Ai6kjqH6d
         kUkdVZwWZ5I2dUI41qWKlJm5VpWiOFfIHZxd9WVwm/gnAjy5JtIQGyNd73CzYPrMne0h
         hTPnPB+I/bkyFK0vvv0fWaQkeE0g40wqMLg4I3vJMkHRY/TdFxkWydHKpkMmEIBBPQHJ
         1881A4M56Y1oBo0AHKP6NggelUx4qCmu2Izs8U5DEtw//Zpe528aj27D/35aNnr1gmoq
         5YMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TXnaCFPIwRklfD9delQze244DLtPDDvbJaE3MIE025c=;
        b=ACBXVdwDUL6MZkkFTtkaC9PcpgFHB+1VrWW1PhXnSR6unudzmFCroamiRfTvYkCwHK
         rnDrgFzUHsZBvXHp4LlB84ppXW+wsBALaqs0CJShfsJwQ2nAWxuRa43xhdmNiQva0h6T
         CFNbtm0IzmR9mj7Bd2I+5tKVFr2dO9OnhM55Nb/D84kpMZ02R8xHVn/URilxLFJrLqYF
         zDuz2BeLIJ99+FtVyYFkKNJdNltz3HHi/Nrg4m3mbuNKg5iP3DHo3QSKVymhBH9uvHW1
         +uagwjWPj2yg984CZ2/nsbfjeeLf7mSG6bgSnsIUJ/9tVoa9VPHCeNq05yAiafB6qy9W
         FJtA==
X-Gm-Message-State: AOAM531r/zd4p2l6+Q1Iukdb1snEv9wEwtnBITkKgQ1+y85pJBSi9iH6
        fH/rzMta5Rc1dxVkW4mSblQ=
X-Google-Smtp-Source: ABdhPJyvwkjQpxKGPiRujDJZ3uYkjRTlFjVXGloZZ1FNaJnxqzR8+/5JVnvzMsVLCTj/ttzsgdHAWQ==
X-Received: by 2002:a17:902:ff15:b029:e4:51ae:e1ee with SMTP id f21-20020a170902ff15b02900e451aee1eemr726646plj.83.1615341244252;
        Tue, 09 Mar 2021 17:54:04 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id a20sm3205122pfl.97.2021.03.09.17.54.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Mar 2021 17:54:03 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2021-03-09
Date:   Tue,  9 Mar 2021 17:54:01 -0800
Message-Id: <20210310015401.14607-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 90 non-merge commits during the last 17 day(s) which contain
a total of 114 files changed, 5158 insertions(+), 1288 deletions(-).

The main changes are:

1) Faster bpf_redirect_map(), from Björn.

2) skmsg cleanup, from Cong.

3) Support for floating point types in BTF, from Ilya.

4) Documentation for sys_bpf commands, from Joe.

5) Support for sk_lookup in bpf_prog_test_run, form Lorenz.

6) Enable task local storage for tracing programs, from Song.

7) bpf_for_each_map_elem() helper, from Yonghong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Abaci Robot, Andrii Nakryiko, Brian Vazquez, Dust Li, Ilya Leoshkevich, 
Jakub Sitnicki, Jesper Dangaard Brouer, John Fastabend, KP Singh, Lorenz 
Bauer, Maciej Fijalkowski, Magnus Karlsson, Martin KaFai Lau, Michael S. 
Tsirkin, Naveen N. Rao, Quentin Monnet, Toke Høiland-Jørgensen, Willem 
de Bruijn, Yonghong Song

----------------------------------------------------------------

The following changes since commit d310ec03a34e92a77302edb804f7d68ee4f01ba0:

  Merge tag 'perf-core-2021-02-17' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2021-02-21 12:49:32 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 32f91529e2bdbe0d92edb3ced41dfba4beffa84a:

  Merge branch 'bpf-xdp-redirect' (2021-03-10 01:07:21 +0100)

----------------------------------------------------------------
Alexander Lobakin (2):
      netdevice: Add missing IFF_PHONY_HEADROOM self-definition
      xsk: Respect device's headroom and tailroom on generic xmit path

Alexei Starovoitov (8):
      Merge branch 'bpf: enable task local storage for tracing'
      Merge branch 'selftests/bpf: xsk improvements and new stats'
      Merge branch 'sock_map: clean up and refactor code for BPF_SK_SKB_VERDICT'
      Merge branch 'bpf: add bpf_for_each_map_elem() helper'
      Merge branch 'Add BTF_KIND_FLOAT support'
      Merge branch 'Improve BPF syscall command documentation'
      Merge branch 'PROG_TEST_RUN support for sk_lookup programs'
      Merge branch 'Add clang-based BTF_KIND_FLOAT tests'

Andrii Nakryiko (3):
      tools/runqslower: Allow substituting custom vmlinux.h for the build
      Merge branch 'load-acquire/store-release barriers for'
      selftests/bpf: Fix compiler warning in BPF_KPROBE definition in loop6.c

Björn Töpel (4):
      xsk: Update rings for load-acquire/store-release barriers
      libbpf, xsk: Add libbpf_smp_store_release libbpf_smp_load_acquire
      bpf, xdp: Make bpf_redirect_map() a map operation
      bpf, xdp: Restructure redirect actions

Brendan Jackman (1):
      bpf: Rename fixup_bpf_calls and add some comments

Ciara Loftus (3):
      selftests/bpf: Expose and rename debug argument
      selftests/bpf: Restructure xsk selftests
      selftests/bpf: Introduce xsk statistics tests

Cong Wang (10):
      bpf: Clean up sockmap related Kconfigs
      skmsg: Get rid of struct sk_psock_parser
      bpf: Compute data_end dynamically with JIT code
      skmsg: Move sk_redir from TCP_SKB_CB to skb
      sock_map: Rename skb_parser and skb_verdict
      sock_map: Make sock_map_prog_update() static
      skmsg: Make __sk_psock_purge_ingress_msg() static
      skmsg: Get rid of sk_psock_bpf_run()
      skmsg: Remove unused sk_psock_stop() declaration
      skmsg: Add function doc for skb->_sk_redir

Daniel Borkmann (1):
      Merge branch 'bpf-xdp-redirect'

Dmitrii Banshchikov (1):
      bpf: Use MAX_BPF_FUNC_REG_ARGS macro

Grant Seltzer (1):
      bpf: Add kernel/modules BTF presence checks to bpftool feature command

Hangbin Liu (1):
      bpf: Remove blank line in bpf helper description comment

Ian Denhardt (2):
      tools, bpf_asm: Hard error on out of range jumps
      tools, bpf_asm: Exit non-zero on errors

Ilya Leoshkevich (12):
      selftests/bpf: Copy extras in out-of-srctree builds
      bpf: Add BTF_KIND_FLOAT to uapi
      libbpf: Fix whitespace in btf_add_composite() comment
      libbpf: Add BTF_KIND_FLOAT support
      tools/bpftool: Add BTF_KIND_FLOAT support
      selftests/bpf: Use the 25th bit in the "invalid BTF_INFO" test
      bpf: Add BTF_KIND_FLOAT support
      selftest/bpf: Add BTF_KIND_FLOAT tests
      selftests/bpf: Add BTF_KIND_FLOAT to the existing deduplication tests
      bpf: Document BTF_KIND_FLOAT in btf.rst
      selftests/bpf: Add BTF_KIND_FLOAT to test_core_reloc_size
      selftests/bpf: Add BTF_KIND_FLOAT to btf_dump_test_case_syntax

Jean-Philippe Brucker (2):
      libbpf: Fix arm64 build
      selftests/bpf: Fix typo in Makefile

Jiapeng Chong (2):
      bpf: Simplify the calculation of variables
      selftests/bpf: Simplify the calculation of variables

Jiri Olsa (1):
      selftests/bpf: Fix test_attach_probe for powerpc uprobes

Joe Stringer (15):
      bpf: Import syscall arg documentation
      bpf: Add minimal bpf() command documentation
      bpf: Document BPF_F_LOCK in syscall commands
      bpf: Document BPF_PROG_PIN syscall command
      bpf: Document BPF_PROG_ATTACH syscall command
      bpf: Document BPF_PROG_TEST_RUN syscall command
      bpf: Document BPF_PROG_QUERY syscall command
      bpf: Document BPF_MAP_*_BATCH syscall commands
      scripts/bpf: Abstract eBPF API target parameter
      scripts/bpf: Add syscall commands printer
      tools/bpf: Remove bpf-helpers from bpftool docs
      selftests/bpf: Templatize man page generation
      selftests/bpf: Test syscall command parsing
      docs/bpf: Add bpf() syscall command reference
      tools: Sync uapi bpf.h header with latest changes

KP Singh (1):
      selftests/bpf: Propagate error code of the command to vmtest.sh

Lorenz Bauer (5):
      bpf: Consolidate shared test timing code
      bpf: Add PROG_TEST_RUN support for sk_lookup programs
      selftests: bpf: Convert sk_lookup ctx access tests to PROG_TEST_RUN
      selftests: bpf: Check that PROG_TEST_RUN repeats as requested
      selftests: bpf: Don't run sk_lookup in verifier tests

Magnus Karlsson (1):
      selftest/bpf: Make xsk tests less verbose

Song Liu (6):
      bpf: Enable task local storage for tracing programs
      bpf: Prevent deadlock from recursive bpf_task_storage_[get|delete]
      selftests/bpf: Add non-BPF_LSM test for task local storage
      selftests/bpf: Test deadlock from recursive bpf_task_storage_[get|delete]
      bpf: runqslower: Prefer using local vmlimux to generate vmlinux.h
      bpf: runqslower: Use task local storage

Xuan Zhuo (3):
      net: Add priv_flags for allow tx skb without linear
      virtio-net: Support IFF_TX_SKB_NO_LINEAR flag
      xsk: Build skb by page (aka generic zerocopy xmit)

Xuesen Huang (2):
      bpf: Add bpf_skb_adjust_room flag BPF_F_ADJ_ROOM_ENCAP_L2_ETH
      selftests, bpf: Extend test_tc_tunnel test with vxlan

Yonghong Song (13):
      bpf: Factor out visit_func_call_insn() in check_cfg()
      bpf: Factor out verbose_invalid_scalar()
      bpf: Refactor check_func_call() to allow callback function
      bpf: Change return value of verifier function add_subprog()
      bpf: Add bpf_for_each_map_elem() helper
      bpf: Add hashtab support for bpf_for_each_map_elem() helper
      bpf: Add arraymap support for bpf_for_each_map_elem() helper
      libbpf: Move function is_ldimm64() earlier in libbpf.c
      libbpf: Support subprog address relocation
      bpftool: Print subprog address properly
      selftests/bpf: Add hashmap test for bpf_for_each_map_elem() helper
      selftests/bpf: Add arraymap test for bpf_for_each_map_elem() helper
      selftests/bpf: Add a verifier scale test with unknown bounded loop

 Documentation/bpf/btf.rst                          |  17 +-
 Documentation/bpf/index.rst                        |   9 +-
 Documentation/userspace-api/ebpf/index.rst         |  17 +
 Documentation/userspace-api/ebpf/syscall.rst       |  24 +
 Documentation/userspace-api/index.rst              |   1 +
 MAINTAINERS                                        |   2 +
 drivers/net/virtio_net.c                           |   3 +-
 include/linux/bpf.h                                |  94 +--
 include/linux/bpf_local_storage.h                  |   3 +-
 include/linux/bpf_lsm.h                            |  22 -
 include/linux/bpf_types.h                          |   8 +-
 include/linux/bpf_verifier.h                       |   3 +
 include/linux/filter.h                             |  31 +-
 include/linux/netdevice.h                          |   5 +
 include/linux/sched.h                              |   5 +
 include/linux/skbuff.h                             |   4 +
 include/linux/skmsg.h                              |  82 ++-
 include/net/tcp.h                                  |  41 +-
 include/net/udp.h                                  |   4 +-
 include/net/xdp_sock.h                             |  19 -
 include/trace/events/xdp.h                         |  62 +-
 include/uapi/linux/bpf.h                           | 763 ++++++++++++++++++++-
 include/uapi/linux/btf.h                           |   5 +-
 init/Kconfig                                       |   1 +
 kernel/bpf/Makefile                                |   3 +-
 kernel/bpf/arraymap.c                              |  40 ++
 kernel/bpf/bpf_inode_storage.c                     |   2 +-
 kernel/bpf/bpf_iter.c                              |  16 +
 kernel/bpf/bpf_local_storage.c                     |  39 +-
 kernel/bpf/bpf_lsm.c                               |   4 -
 kernel/bpf/bpf_task_storage.c                      | 100 +--
 kernel/bpf/btf.c                                   | 108 ++-
 kernel/bpf/cpumap.c                                |   9 +-
 kernel/bpf/devmap.c                                |  17 +-
 kernel/bpf/hashtab.c                               |  65 ++
 kernel/bpf/helpers.c                               |   2 +
 kernel/bpf/verifier.c                              | 393 +++++++++--
 kernel/fork.c                                      |   5 +
 kernel/trace/bpf_trace.c                           |   6 +
 net/Kconfig                                        |   6 +-
 net/bpf/test_run.c                                 | 244 +++++--
 net/core/Makefile                                  |   6 +-
 net/core/bpf_sk_storage.c                          |   2 +-
 net/core/filter.c                                  | 269 ++++----
 net/core/skmsg.c                                   | 212 +++---
 net/core/sock_map.c                                |  77 ++-
 net/ipv4/Makefile                                  |   2 +-
 net/ipv4/tcp_bpf.c                                 |   4 +-
 net/xdp/xsk.c                                      | 114 ++-
 net/xdp/xsk_queue.h                                |  30 +-
 net/xdp/xskmap.c                                   |  17 +-
 scripts/{bpf_helpers_doc.py => bpf_doc.py}         | 191 +++++-
 tools/bpf/Makefile.helpers                         |  60 --
 tools/bpf/bpf_dbg.c                                |   2 +-
 tools/bpf/bpf_exp.y                                |  14 +-
 tools/bpf/bpftool/.gitignore                       |   1 -
 tools/bpf/bpftool/Documentation/Makefile           |  11 +-
 tools/bpf/bpftool/btf.c                            |   8 +
 tools/bpf/bpftool/btf_dumper.c                     |   1 +
 tools/bpf/bpftool/feature.c                        |   4 +
 tools/bpf/bpftool/xlated_dumper.c                  |   3 +
 tools/bpf/runqslower/Makefile                      |   9 +-
 tools/bpf/runqslower/runqslower.bpf.c              |  33 +-
 tools/include/uapi/linux/bpf.h                     | 763 ++++++++++++++++++++-
 tools/include/uapi/linux/btf.h                     |   5 +-
 tools/lib/bpf/Makefile                             |   2 +-
 tools/lib/bpf/btf.c                                |  51 +-
 tools/lib/bpf/btf.h                                |   6 +
 tools/lib/bpf/btf_dump.c                           |   4 +
 tools/lib/bpf/libbpf.c                             | 105 ++-
 tools/lib/bpf/libbpf.map                           |   5 +
 tools/lib/bpf/libbpf_internal.h                    |   2 +
 tools/lib/bpf/libbpf_util.h                        |  72 +-
 tools/lib/bpf/xsk.h                                |  17 +-
 tools/perf/MANIFEST                                |   2 +-
 tools/testing/selftests/bpf/.gitignore             |   2 +
 tools/testing/selftests/bpf/Makefile               |  27 +-
 tools/testing/selftests/bpf/Makefile.docs          |  82 +++
 tools/testing/selftests/bpf/README.rst             |  48 ++
 tools/testing/selftests/bpf/btf_helpers.c          |   4 +
 .../selftests/bpf/prog_tests/attach_probe.c        |  40 +-
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |   1 +
 tools/testing/selftests/bpf/prog_tests/btf.c       | 176 ++++-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   1 +
 tools/testing/selftests/bpf/prog_tests/for_each.c  | 130 ++++
 .../selftests/bpf/prog_tests/prog_run_xattr.c      |  51 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |  83 ++-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |   8 +-
 .../selftests/bpf/prog_tests/task_local_storage.c  |  92 +++
 .../bpf/progs/btf_dump_test_case_syntax.c          |   7 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |   5 +
 .../selftests/bpf/progs/for_each_array_map_elem.c  |  61 ++
 .../selftests/bpf/progs/for_each_hash_map_elem.c   |  95 +++
 tools/testing/selftests/bpf/progs/loop6.c          |  99 +++
 .../selftests/bpf/progs/task_local_storage.c       |  64 ++
 .../bpf/progs/task_local_storage_exit_creds.c      |  32 +
 .../selftests/bpf/progs/task_ls_recursion.c        |  70 ++
 .../selftests/bpf/progs/test_core_reloc_size.c     |   3 +
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |  62 +-
 .../selftests/bpf/progs/test_sockmap_listen.c      |   4 +-
 tools/testing/selftests/bpf/progs/test_tc_tunnel.c | 113 ++-
 tools/testing/selftests/bpf/test_bpftool_build.sh  |  21 -
 tools/testing/selftests/bpf/test_btf.h             |   3 +
 tools/testing/selftests/bpf/test_doc_build.sh      |  13 +
 tools/testing/selftests/bpf/test_progs.h           |  11 +
 tools/testing/selftests/bpf/test_sockmap.c         |   2 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |  15 +-
 tools/testing/selftests/bpf/test_verifier.c        |   4 +-
 tools/testing/selftests/bpf/test_xsk.sh            | 135 +---
 .../testing/selftests/bpf/verifier/ctx_sk_lookup.c |   1 +
 tools/testing/selftests/bpf/vmtest.sh              |  26 +-
 tools/testing/selftests/bpf/xdpxceiver.c           | 380 +++++++---
 tools/testing/selftests/bpf/xdpxceiver.h           |  57 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh         |  30 +-
 114 files changed, 5158 insertions(+), 1288 deletions(-)
 create mode 100644 Documentation/userspace-api/ebpf/index.rst
 create mode 100644 Documentation/userspace-api/ebpf/syscall.rst
 rename scripts/{bpf_helpers_doc.py => bpf_doc.py} (82%)
 delete mode 100644 tools/bpf/Makefile.helpers
 create mode 100644 tools/testing/selftests/bpf/Makefile.docs
 create mode 100644 tools/testing/selftests/bpf/prog_tests/for_each.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_local_storage.c
 create mode 100644 tools/testing/selftests/bpf/progs/for_each_array_map_elem.c
 create mode 100644 tools/testing/selftests/bpf/progs/for_each_hash_map_elem.c
 create mode 100644 tools/testing/selftests/bpf/progs/loop6.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage_exit_creds.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_ls_recursion.c
 create mode 100755 tools/testing/selftests/bpf/test_doc_build.sh
