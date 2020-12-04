Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6962F2CE59E
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgLDCUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgLDCUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 21:20:19 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB2CC061A4F;
        Thu,  3 Dec 2020 18:19:39 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id f9so2061543pfc.11;
        Thu, 03 Dec 2020 18:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EdPQGYgm+S6jyi1ae/x25ZZfRF2j/997sKqHBbyVNxM=;
        b=UiHvLlSzDzPhH5wOEntuYgBBA0iZMTHZDQob4TkMViP7ubUY5mXdkZv+Boyww6ofoC
         EgXTc4K1RXbZj5eeMkA4bMGC0Z4v/9pHk6tztJc3cGlR+pvkQ19YCsJcyHxOJDIjh7Ur
         8KIgJwaZz7oH/tQXLO+mHvQPpg8v3tW8c0lh6uAy51EpuNTpFahBQ8iR8ZgrRtTMPsAe
         KdMKH6kNzL2mwWc7wwfc4CzzSkOjD9IrVFGdWEqNlsM5cNiC0NWe9Ne4qhAl/KuDAx+z
         0R5pktAN9QtQdN8oJjUhNm1znGUAfrEEp5w4N+HzQiML+rdbwVoEFnj/VF1t0eXzOU6I
         fOlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EdPQGYgm+S6jyi1ae/x25ZZfRF2j/997sKqHBbyVNxM=;
        b=pHRFG9PguwB34vusjucy0dLGi4uabYOUraBugxuifN3d8burUXTx6tcCVUCVdvxTA8
         sM6tlWTqKR0GowwUPat58eLOzufnhRFDwH5vbymd7m8Fkq/jJ32UQ9VCo+Gr5V3Cs55t
         69yTggTIP4+8wo956jOopHZ8cOFB7GDDdgA+nAmg8h9NE+ymxUa/6m0XQSKM1E/FZQiR
         823nFHp+f8wBWyG/VsAyVKNeCyBoUyUMkwQwH3wHTtMSJ1TZbUTHAAB3+gAYhvjgLkQc
         dWxFTGiFomPns/Tm0r2LOIOUf4Pxwxygvgi5UewOueKf5/F6xKPaPqH31WVOzxyTqSR4
         ohbw==
X-Gm-Message-State: AOAM530omgSOqti3S9TEY4fcQwTcqf8xkh+d213IyPmSrXsBmrjAPxhh
        bdTNz85TeuRERABdXIAr+/M=
X-Google-Smtp-Source: ABdhPJyxFlva7NVW6952S9wE7HaiYLZiMKInAbhg70eWWUIExGcKCTYxgfc2tl/a0bQK5OXFunJ+RA==
X-Received: by 2002:a63:6882:: with SMTP id d124mr5597346pgc.197.1607048378651;
        Thu, 03 Dec 2020 18:19:38 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id x10sm2169496pga.70.2020.12.03.18.19.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Dec 2020 18:19:37 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2020-12-03
Date:   Thu,  3 Dec 2020 18:19:36 -0800
Message-Id: <20201204021936.85653-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 118 non-merge commits during the last 20 day(s) which contain
a total of 196 files changed, 4330 insertions(+), 2569 deletions(-).

The main changes are:

1) Support BTF in kernel modules, from Andrii.

2) Introduce preferred busy-polling, from Björn.

3) bpf_ima_inode_hash() and bpf_bprm_opts_set() helpers, from KP Singh.

4) Memcg-based memory accounting for bpf objects, from Roman.

5) Allow bpf_{s,g}etsockopt from cgroup bind{4,6} hooks, from Stanislav.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrey Ignatov, Andrii Nakryiko, Björn Töpel, Bruce Allan, Daniel 
Borkmann, Florian Lehner, Ilias Apalodimas, Jakub Kicinski, Jakub 
Sitnicki, Jesper Dangaard Brouer, Jessica Yu, Jiri Olsa, Johannes 
Weiner, John Fastabend, Luke Nelson, Magnus Karlsson, Martin KaFai Lau, 
Michael S. Tsirkin, Michal Hocko, Mimi Zohar, Shakeel Butt, Song Liu, 
Stephen Rothwell, Tariq Toukan, Yonghong Song

----------------------------------------------------------------

The following changes since commit 2d38c5802f4626e85d280b68481c3f3ca4853ecb:

  Merge branch 'ionic-updates' (2020-11-14 13:23:01 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to eceae70bdeaeb6b8ceb662983cf663ff352fbc96:

  selftests/bpf: Fix invalid use of strncat in test_sockmap (2020-12-03 18:07:05 -0800)

----------------------------------------------------------------
Alan Maguire (1):
      libbpf: bpf__find_by_name[_kind] should use btf__get_nr_types()

Alexei Starovoitov (6):
      Merge branch 'bpf: expose bpf_{s,g}etsockopt helpers to bind{4,6} hooks'
      Merge branch 'switch to memcg-based memory accounting'
      Merge branch 'bpftool: improve split BTF support'
      Merge branch 'libbpf: add support for privileged/unprivileged control separation'
      Merge branch 'Add support to set window_clamp from bpf setsockops'
      Merge branch 'Support BTF-powered BPF tracing programs for kernel modules'

Andrei Matei (4):
      selftest/bpf: Fix link in readme
      selftest/bpf: Fix rst formatting in readme
      bpf: Fix selftest compilation on clang 11
      libbpf: Fail early when loading programs with unspecified type

Andrii Nakryiko (24):
      Merge branch 'RISC-V selftest/bpf fixes'
      kbuild: Skip module BTF generation for out-of-tree external modules
      bpf: Sanitize BTF data pointer after module is loaded
      Merge branch 'bpf: remove bpf_load loader completely'
      tools/bpftool: Emit name <anon> for anonymous BTFs
      libbpf: Add base BTF accessor
      tools/bpftool: Auto-detect split BTFs in common cases
      Merge branch 'Fixes for ima selftest'
      bpf: Fix bpf_put_raw_tracepoint()'s use of __module_address()
      bpf: Keep module's btf_data_size intact after load
      libbpf: Add internal helper to load BTF data by FD
      libbpf: Refactor CO-RE relocs to not assume a single BTF object
      libbpf: Add kernel module BTF support for CO-RE relocations
      selftests/bpf: Add bpf_testmod kernel module for testing
      selftests/bpf: Add support for marking sub-tests as skipped
      selftests/bpf: Add CO-RE relocs selftest relying on kernel module BTF
      bpf: Remove hard-coded btf_vmlinux assumption from BPF verifier
      bpf: Allow to specify kernel module BTFs when attaching BPF programs
      libbpf: Factor out low-level BPF program loading helper
      libbpf: Support attachment of BPF tracing programs to kernel modules
      selftests/bpf: Add tp_btf CO-RE reloc test for modules
      selftests/bpf: Add fentry/fexit/fmod_ret selftest for kernel module
      libbpf: Use memcpy instead of strncpy to please GCC
      selftests/bpf: Fix invalid use of strncat in test_sockmap

Björn Töpel (13):
      selftests/bpf: Fix broken riscv build
      selftests/bpf: Avoid running unprivileged tests with alignment requirements
      selftests/bpf: Mark tests that require unaligned memory access
      net: Introduce preferred busy-polling
      net: Add SO_BUSY_POLL_BUDGET socket option
      xsk: Add support for recvmsg()
      xsk: Check need wakeup flag in sendmsg()
      xsk: Add busy-poll support for {recv,send}msg()
      xsk: Propagate napi_id to XDP socket Rx path
      samples/bpf: Use recvfrom() in xdpsock/rxdrop
      samples/bpf: Use recvfrom() in xdpsock/l2fwd
      samples/bpf: Add busy-poll support to xdpsock
      samples/bpf: Add option to set the busy-poll budget

Brendan Jackman (2):
      tools/resolve_btfids: Fix some error messages
      bpf: Fix cold build of test_progs-no_alu32

Colin Ian King (1):
      samples/bpf: Fix spelling mistake "recieving" -> "receiving"

Daniel Borkmann (3):
      Merge branch 'af-xdp-tx-batch'
      Merge branch 'xdp-preferred-busy-polling'
      net, xdp, xsk: fix __sk_mark_napi_id_once napi_id error

Daniel T. Lee (7):
      samples: bpf: Refactor hbm program with libbpf
      samples: bpf: Refactor test_cgrp2_sock2 program with libbpf
      samples: bpf: Refactor task_fd_query program with libbpf
      samples: bpf: Refactor ibumad program with libbpf
      samples: bpf: Refactor test_overhead program with libbpf
      samples: bpf: Fix lwt_len_hist reusing previous BPF map
      samples: bpf: Remove bpf_load loader completely

Dmitrii Banshchikov (1):
      bpf: Add bpf_ktime_get_coarse_ns helper

KP Singh (10):
      bpf: Add bpf_bprm_opts_set helper
      bpf: Add tests for bpf_bprm_opts_set helper
      ima: Implement ima_inode_hash
      bpf: Add a BPF helper for getting the IMA hash of an inode
      bpf: Add a selftest for bpf_ima_inode_hash
      selftests/bpf: Fix flavored variants of test_ima
      selftests/bpf: Update ima_setup.sh for busybox
      selftests/bpf: Ensure securityfs mount before writing ima policy
      selftests/bpf: Add config dependency on BLK_DEV_LOOP
      selftests/bpf: Indent ima_setup.sh with tabs.

Li RongQing (1):
      libbpf: Add support for canceling cached_cons advance

Magnus Karlsson (6):
      samples/bpf: Increment Tx stats at sending
      i40e: Remove unnecessary sw_ring access from xsk Tx
      xsk: Introduce padding between more ring pointers
      xsk: Introduce batched Tx descriptor interfaces
      i40e: Use batched xsk Tx interfaces to increase performance
      libbpf: Replace size_t with __u32 in xsk interfaces

Mariusz Dudek (2):
      libbpf: Separate XDP program load with xsk socket creation
      samples/bpf: Sample application for eBPF load and socket creation split

Martin KaFai Lau (1):
      bpf: Fix the irq and nmi check in bpf_sk_storage for tracing usage

Prankur gupta (2):
      bpf: Adds support for setting window clamp
      selftests/bpf: Add Userspace tests for TCP_WINDOW_CLAMP

Roman Gushchin (34):
      mm: memcontrol: Use helpers to read page's memcg data
      mm: memcontrol/slab: Use helpers to access slab page's memcg_data
      mm: Introduce page memcg flags
      mm: Convert page kmemcg type to a page memcg flag
      bpf: Memcg-based memory accounting for bpf progs
      bpf: Prepare for memcg-based memory accounting for bpf maps
      bpf: Memcg-based memory accounting for bpf maps
      bpf: Refine memcg-based memory accounting for arraymap maps
      bpf: Refine memcg-based memory accounting for cpumap maps
      bpf: Memcg-based memory accounting for cgroup storage maps
      bpf: Refine memcg-based memory accounting for devmap maps
      bpf: Refine memcg-based memory accounting for hashtab maps
      bpf: Memcg-based memory accounting for lpm_trie maps
      bpf: Memcg-based memory accounting for bpf ringbuffer
      bpf: Memcg-based memory accounting for bpf local storage maps
      bpf: Refine memcg-based memory accounting for sockmap and sockhash maps
      bpf: Refine memcg-based memory accounting for xskmap maps
      bpf: Eliminate rlimit-based memory accounting for arraymap maps
      bpf: Eliminate rlimit-based memory accounting for bpf_struct_ops maps
      bpf: Eliminate rlimit-based memory accounting for cpumap maps
      bpf: Eliminate rlimit-based memory accounting for cgroup storage maps
      bpf: Eliminate rlimit-based memory accounting for devmap maps
      bpf: Eliminate rlimit-based memory accounting for hashtab maps
      bpf: Eliminate rlimit-based memory accounting for lpm_trie maps
      bpf: Eliminate rlimit-based memory accounting for queue_stack_maps maps
      bpf: Eliminate rlimit-based memory accounting for reuseport_array maps
      bpf: Eliminate rlimit-based memory accounting for bpf ringbuffer
      bpf: Eliminate rlimit-based memory accounting for sockmap and sockhash maps
      bpf: Eliminate rlimit-based memory accounting for stackmap maps
      bpf: Eliminate rlimit-based memory accounting for xskmap maps
      bpf: Eliminate rlimit-based memory accounting for bpf local storage maps
      bpf: Eliminate rlimit-based memory accounting infra for bpf maps
      bpf: Eliminate rlimit-based memory accounting for bpf progs
      bpf: samples: Do not touch RLIMIT_MEMLOCK

Santucci Pierpaolo (1):
      selftest/bpf: Fix IPV6FR handling in flow dissector

Song Liu (1):
      bpf: Simplify task_file_seq_get_next()

Stanislav Fomichev (5):
      selftests/bpf: Rewrite test_sock_addr bind bpf into C
      bpf: Allow bpf_{s,g}etsockopt from cgroup bind{4,6} hooks
      selftests/bpf: Extend bind{4,6} programs with a call to bpf_setsockopt
      selftests/bpf: Copy file using read/write in local storage test
      libbpf: Cap retries in sys_bpf_prog_load

Toke Høiland-Jørgensen (1):
      libbpf: Sanitise map names before pinning

Wedson Almeida Filho (1):
      bpf: Refactor check_cfg to use a structured loop.

Yonghong Song (1):
      bpftool: Add {i,d}tlb_misses support for bpftool profile

Zhu Yanjun (1):
      xdp: Remove the functions xsk_map_inc and xsk_map_put

 arch/alpha/include/uapi/asm/socket.h               |   3 +
 arch/mips/include/uapi/asm/socket.h                |   3 +
 arch/parisc/include/uapi/asm/socket.h              |   3 +
 arch/sparc/include/uapi/asm/socket.h               |   3 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  13 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |   1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         | 123 ++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |  16 +
 drivers/net/ethernet/intel/ice/ice_base.c          |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   2 +-
 drivers/net/ethernet/sfc/rx_common.c               |   2 +-
 drivers/net/ethernet/socionext/netsec.c            |   2 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |   2 +-
 drivers/net/hyperv/netvsc.c                        |   2 +-
 drivers/net/tun.c                                  |   2 +-
 drivers/net/veth.c                                 |  12 +-
 drivers/net/virtio_net.c                           |   2 +-
 drivers/net/xen-netfront.c                         |   2 +-
 fs/buffer.c                                        |   2 +-
 fs/eventpoll.c                                     |   3 +-
 fs/iomap/buffered-io.c                             |   2 +-
 include/linux/bpf-cgroup.h                         |  12 +-
 include/linux/bpf.h                                |  71 ++-
 include/linux/bpf_verifier.h                       |  28 +-
 include/linux/btf.h                                |   6 +-
 include/linux/ima.h                                |   6 +
 include/linux/memcontrol.h                         | 215 ++++++-
 include/linux/mm.h                                 |  22 -
 include/linux/mm_types.h                           |   5 +-
 include/linux/netdevice.h                          |  35 +-
 include/linux/page-flags.h                         |  11 +-
 include/net/busy_poll.h                            |  27 +-
 include/net/sock.h                                 |   6 +
 include/net/tcp.h                                  |   1 +
 include/net/xdp.h                                  |   3 +-
 include/net/xdp_sock_drv.h                         |   7 +
 include/trace/events/writeback.h                   |   2 +-
 include/uapi/asm-generic/socket.h                  |   3 +
 include/uapi/linux/bpf.h                           |  45 +-
 kernel/bpf/arraymap.c                              |  30 +-
 kernel/bpf/bpf_local_storage.c                     |  20 +-
 kernel/bpf/bpf_lsm.c                               |  52 ++
 kernel/bpf/bpf_struct_ops.c                        |  19 +-
 kernel/bpf/btf.c                                   |  70 ++-
 kernel/bpf/core.c                                  |  23 +-
 kernel/bpf/cpumap.c                                |  37 +-
 kernel/bpf/devmap.c                                |  25 +-
 kernel/bpf/hashtab.c                               |  43 +-
 kernel/bpf/helpers.c                               |  13 +
 kernel/bpf/local_storage.c                         |  44 +-
 kernel/bpf/lpm_trie.c                              |  19 +-
 kernel/bpf/queue_stack_maps.c                      |  16 +-
 kernel/bpf/reuseport_array.c                       |  12 +-
 kernel/bpf/ringbuf.c                               |  35 +-
 kernel/bpf/stackmap.c                              |  16 +-
 kernel/bpf/syscall.c                               | 310 +++++-----
 kernel/bpf/task_iter.c                             |  54 +-
 kernel/bpf/verifier.c                              | 256 ++++----
 kernel/fork.c                                      |   7 +-
 kernel/module.c                                    |   4 +
 kernel/trace/bpf_trace.c                           |  10 +-
 mm/debug.c                                         |   4 +-
 mm/huge_memory.c                                   |   4 +-
 mm/memcontrol.c                                    | 139 ++---
 mm/page_alloc.c                                    |   8 +-
 mm/page_io.c                                       |   6 +-
 mm/slab.h                                          |  38 +-
 mm/workingset.c                                    |   2 +-
 net/core/bpf_sk_storage.c                          |   4 +-
 net/core/dev.c                                     |  89 ++-
 net/core/filter.c                                  |   7 +
 net/core/sock.c                                    |  19 +
 net/core/sock_map.c                                |  42 +-
 net/core/xdp.c                                     |   3 +-
 net/ipv4/af_inet.c                                 |   2 +-
 net/ipv4/bpf_tcp_ca.c                              |   3 +-
 net/ipv4/tcp.c                                     |  25 +-
 net/ipv6/af_inet6.c                                |   2 +-
 net/xdp/xsk.c                                      | 114 +++-
 net/xdp/xsk.h                                      |   2 -
 net/xdp/xsk_buff_pool.c                            |  13 +-
 net/xdp/xsk_queue.h                                |  93 ++-
 net/xdp/xskmap.c                                   |  35 +-
 samples/bpf/.gitignore                             |   3 +
 samples/bpf/Makefile                               |  24 +-
 samples/bpf/bpf_load.c                             | 667 ---------------------
 samples/bpf/bpf_load.h                             |  57 --
 samples/bpf/do_hbm_test.sh                         |  32 +-
 samples/bpf/hbm.c                                  | 111 ++--
 samples/bpf/hbm_kern.h                             |   2 +-
 samples/bpf/ibumad_kern.c                          |  26 +-
 samples/bpf/ibumad_user.c                          |  71 ++-
 samples/bpf/lwt_len_hist.sh                        |   2 +
 samples/bpf/map_perf_test_user.c                   |   6 -
 samples/bpf/offwaketime_user.c                     |   6 -
 samples/bpf/sockex2_user.c                         |   2 -
 samples/bpf/sockex3_user.c                         |   2 -
 samples/bpf/spintest_user.c                        |   6 -
 samples/bpf/syscall_tp_user.c                      |   2 -
 samples/bpf/task_fd_query_user.c                   | 103 +++-
 samples/bpf/test_cgrp2_sock2.c                     |  61 +-
 samples/bpf/test_cgrp2_sock2.sh                    |  21 +-
 samples/bpf/test_lru_dist.c                        |   3 -
 samples/bpf/test_lwt_bpf.sh                        |   0
 samples/bpf/test_map_in_map_user.c                 |   6 -
 samples/bpf/test_overhead_user.c                   |  84 ++-
 samples/bpf/trace_event_user.c                     |   2 -
 samples/bpf/tracex2_user.c                         |   6 -
 samples/bpf/tracex3_user.c                         |   6 -
 samples/bpf/tracex4_user.c                         |   6 -
 samples/bpf/tracex5_user.c                         |   3 -
 samples/bpf/tracex6_user.c                         |   3 -
 samples/bpf/xdp1_user.c                            |   6 -
 samples/bpf/xdp2skb_meta_kern.c                    |   2 +-
 samples/bpf/xdp_adjust_tail_user.c                 |   6 -
 samples/bpf/xdp_monitor_user.c                     |   5 -
 samples/bpf/xdp_redirect_cpu_user.c                |   6 -
 samples/bpf/xdp_redirect_map_user.c                |   6 -
 samples/bpf/xdp_redirect_user.c                    |   6 -
 samples/bpf/xdp_router_ipv4_user.c                 |   6 -
 samples/bpf/xdp_rxq_info_user.c                    |   6 -
 samples/bpf/xdp_sample_pkts_user.c                 |   6 -
 samples/bpf/xdp_tx_iptunnel_user.c                 |   6 -
 samples/bpf/xdpsock.h                              |   8 +
 samples/bpf/xdpsock_ctrl_proc.c                    | 187 ++++++
 samples/bpf/xdpsock_user.c                         | 230 +++++--
 scripts/Makefile.modfinal                          |   9 +-
 scripts/bpf_helpers_doc.py                         |   4 +
 security/integrity/ima/ima_main.c                  |  78 ++-
 tools/bpf/bpftool/btf.c                            |  27 +-
 tools/bpf/bpftool/prog.c                           |  30 +-
 tools/bpf/resolve_btfids/main.c                    |   6 +-
 tools/include/uapi/linux/bpf.h                     |  45 +-
 tools/lib/bpf/bpf.c                                | 104 +++-
 tools/lib/bpf/btf.c                                |  74 ++-
 tools/lib/bpf/btf.h                                |   1 +
 tools/lib/bpf/libbpf.c                             | 527 ++++++++++++----
 tools/lib/bpf/libbpf.map                           |   3 +
 tools/lib/bpf/libbpf_internal.h                    |  31 +
 tools/lib/bpf/xsk.c                                |  92 ++-
 tools/lib/bpf/xsk.h                                |  22 +-
 tools/testing/selftests/bpf/.gitignore             |   1 +
 tools/testing/selftests/bpf/Makefile               |  18 +-
 tools/testing/selftests/bpf/README.rst             |  33 +-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |   1 +
 tools/testing/selftests/bpf/bpf_testmod/.gitignore |   6 +
 tools/testing/selftests/bpf/bpf_testmod/Makefile   |  20 +
 .../selftests/bpf/bpf_testmod/bpf_testmod-events.h |  36 ++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |  52 ++
 .../selftests/bpf/bpf_testmod/bpf_testmod.h        |  14 +
 tools/testing/selftests/bpf/config                 |   5 +
 tools/testing/selftests/bpf/ima_setup.sh           |  99 +++
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  80 ++-
 .../selftests/bpf/prog_tests/module_attach.c       |  53 ++
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   4 +
 .../selftests/bpf/prog_tests/test_bprm_opts.c      | 116 ++++
 tools/testing/selftests/bpf/prog_tests/test_ima.c  |  74 +++
 .../selftests/bpf/prog_tests/test_local_storage.c  |  28 +-
 tools/testing/selftests/bpf/progs/bind4_prog.c     | 102 ++++
 tools/testing/selftests/bpf/progs/bind6_prog.c     | 119 ++++
 tools/testing/selftests/bpf/progs/bpf_flow.c       |   2 +
 .../testing/selftests/bpf/progs/bpf_iter_bpf_map.c |   2 +-
 tools/testing/selftests/bpf/progs/bprm_opts.c      |  34 ++
 .../testing/selftests/bpf/progs/core_reloc_types.h |  17 +
 tools/testing/selftests/bpf/progs/ima.c            |  28 +
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |   7 -
 tools/testing/selftests/bpf/progs/profiler.inc.h   |   2 +
 .../selftests/bpf/progs/test_core_reloc_module.c   |  96 +++
 .../selftests/bpf/progs/test_module_attach.c       |  66 ++
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |  33 +
 tools/testing/selftests/bpf/test_progs.c           |  65 +-
 tools/testing/selftests/bpf/test_progs.h           |   1 +
 tools/testing/selftests/bpf/test_sock_addr.c       | 196 +-----
 tools/testing/selftests/bpf/test_sockmap.c         |  36 +-
 tools/testing/selftests/bpf/test_tcpbpf.h          |   2 +
 tools/testing/selftests/bpf/test_verifier.c        |  13 +
 .../testing/selftests/bpf/verifier/ctx_sk_lookup.c |   7 +
 .../selftests/bpf/verifier/direct_value_access.c   |   3 +
 tools/testing/selftests/bpf/verifier/map_ptr.c     |   1 +
 .../selftests/bpf/verifier/raw_tp_writable.c       |   1 +
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   4 +
 tools/testing/selftests/bpf/verifier/regalloc.c    |   8 +
 tools/testing/selftests/bpf/verifier/wide_access.c |  46 +-
 196 files changed, 4330 insertions(+), 2569 deletions(-)
 delete mode 100644 samples/bpf/bpf_load.c
 delete mode 100644 samples/bpf/bpf_load.h
 mode change 100644 => 100755 samples/bpf/lwt_len_hist.sh
 mode change 100644 => 100755 samples/bpf/test_lwt_bpf.sh
 create mode 100644 samples/bpf/xdpsock_ctrl_proc.c
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/Makefile
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
 create mode 100755 tools/testing/selftests/bpf/ima_setup.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/module_attach.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_bprm_opts.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_ima.c
 create mode 100644 tools/testing/selftests/bpf/progs/bind4_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/bind6_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/bprm_opts.c
 create mode 100644 tools/testing/selftests/bpf/progs/ima.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_module.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_module_attach.c
