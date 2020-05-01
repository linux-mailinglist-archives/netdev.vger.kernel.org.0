Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DEA1C21BC
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 01:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgEAXzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 19:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgEAXzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 19:55:21 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A060C061A0C;
        Fri,  1 May 2020 16:55:21 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t7so4197395plr.0;
        Fri, 01 May 2020 16:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AhLKHmQ6SCZTq3mMUG+vzOeFPyPnHTWaPhJsOL4PDBw=;
        b=FvzX4qiinyDhHt3eIjsVkVWG2tA8tccVVqG8yXNq0kJAzfY5CQvxRzkE6+PDuUM5RG
         vSivw67ExgTFhMD119RX/Pxw6t36K4E2yxXOtsTQYjwNADwsyr5wjV+O7xMaCo8imTZ6
         MBezdxm/Z66iFiUV9+qcC7X51dkOkMSX2d6lZZizuSbZoRA+DvOBpBpKkCg/tKj5ENmw
         M7hSkpUQd4pEMMsm+sRLC6MtJrNHMgJgGWUoH3OPCw0I+d7qPcZKtocGOtwzUsMqPutL
         xNZAmynKWlU0aXVgkfWmaPcbjEcRghcXiPLz9tOHSsb8mvrbUsoVmuSo/H2aVVYqc+9z
         qk1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AhLKHmQ6SCZTq3mMUG+vzOeFPyPnHTWaPhJsOL4PDBw=;
        b=pPAFqMlFjiSzPvCax+k80SNhTj6kpK7UlhquYq4Ph8SV/l8RCGbsKp0nXlpb5vGfJh
         wFF2sJs8ZoFzfuzEhxo0LUbsjRiRHArU+hw6vESFYrp8cqlqHVoxcT3O0+Hfwl2JnK3y
         T2el6WD82g7nVU8TmV1PlCNVGnZ+3kQqHZO1eByT7RwBlveC5sb1w42MatsB/ISe6zYx
         CeZykthjSEfdj2bX2Fu0padvy0O4e7jIbdnXG4vfyk8d6mR4+wQzNtdh/gA2GCJiliT2
         g07up+1ga6DxMg7JHRiRL1KTilEnjXF7sf5Yf5y6Y0SdL3NXE8r/7Jjq9khoqxmNJXPm
         kxaw==
X-Gm-Message-State: AGi0PuamLl443YFwAogFXhXcZLOKbiooPuFlU9R4SuO/DD4K8e/5cbtP
        xb3XnJ3k0FraATrPNvpan8U=
X-Google-Smtp-Source: APiQypLGsQECzDXQJKvdI9DTvowwqjHawVfO6o+vOspHBtOkhZCBv1ThyFKsCUYcKOwNj5T4gJq5sA==
X-Received: by 2002:a17:90a:784c:: with SMTP id y12mr2524554pjl.124.1588377320959;
        Fri, 01 May 2020 16:55:20 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.1])
        by smtp.gmail.com with ESMTPSA id w11sm634574pjy.11.2020.05.01.16.55.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 16:55:20 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf-next 2020-05-01 (v2)
Date:   Fri,  1 May 2020 16:55:18 -0700
Message-Id: <20200501235518.78512-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 61 non-merge commits during the last 6 day(s) which contain
a total of 153 files changed, 6739 insertions(+), 3367 deletions(-).

The main changes are:

1) pulled work.sysctl from vfs tree with sysctl bpf changes.

2) bpf_link observability, from Andrii.

3) BTF-defined map in map, from Andrii.

4) asan fixes for selftests, from Andrii.

5) Allow bpf_map_lookup_elem for SOCKMAP and SOCKHASH, from Jakub.

6) production cloudflare classifier as a selftes, from Lorenz.

7) bpf_ktime_get_*_ns() helper improvements, from Maciej.

8) unprivileged bpftool feature probe, from Quentin.

9) BPF_ENABLE_STATS command, from Song.

10) enable bpf_[gs]etsockopt() helpers for sock_ops progs, from Stanislav.

11) enable a bunch of common helpers for cg-device, sysctl, sockopt progs,
 from Stanislav.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alston Tang, Andrey Ignatov, Andrii Nakryiko, David Rientjes, Hulk 
Robot, John Fastabend, Magnus Karlsson, Martin KaFai Lau, Quentin 
Monnet, Song Liu, Toke Høiland-Jørgensen, Xi Wang

----------------------------------------------------------------

The following changes since commit 3fd8dc269ff0647819589c21b2ce60af6fc0a455:

  net: hns3: remove an unnecessary check in hclge_set_umv_space() (2020-04-25 20:56:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 57dc6f3b4133f45e73d87895180ca1f3eaf01722:

  selftests/bpf: Use reno instead of dctcp (2020-05-01 16:51:07 -0700)

----------------------------------------------------------------
Alexei Starovoitov (6):
      Merge branch 'cloudflare-prog'
      selftests/bpf: fix test_sysctl_prog with alu32
      Merge branch 'bpf_link-observability'
      Merge branch 'BTF-map-in-map'
      Merge branch 'test_progs-asan'
      Merge branch 'bpf_enable_stats'

Andrii Nakryiko (27):
      bpf: Make verifier log more relevant by default
      bpf: Refactor bpf_link update handling
      bpf: Allocate ID for bpf_link
      bpf: Support GET_FD_BY_ID and GET_NEXT_ID for bpf_link
      bpf: Add support for BPF_OBJ_GET_INFO_BY_FD for bpf_link
      libbpf: Add low-level APIs for new bpf_link commands
      selftests/bpf: Test bpf_link's get_next_id, get_fd_by_id, and get_obj_info
      bpftool: Expose attach_type-to-string array to non-cgroup code
      bpftool: Add bpf_link show and pin support
      bpftool: Add bpftool-link manpage
      bpftool: Add link bash completions
      libbpf: Refactor BTF-defined map definition parsing logic
      libbpf: Refactor map creation logic and fix cleanup leak
      libbpf: Add BTF-defined map-in-map support
      selftests/bpf: Ensure test flavors use correct skeletons
      selftests/bpf: Add SAN_CFLAGS param to selftests build to allow sanitizers
      selftests/bpf: Convert test_hashmap into test_progs test
      libbpf: Fix memory leak and possible double-free in hashmap__clear
      selftests/bpf: Fix memory leak in test selector
      selftests/bpf: Fix memory leak in extract_build_id()
      selftests/bpf: Fix invalid memory reads in core_relo selftest
      libbpf: Fix huge memory leak in libbpf_find_vmlinux_btf_id()
      selftests/bpf: Disable ASAN instrumentation for mmap()'ed memory read
      selftests/bpf: Fix bpf_link leak in ns_current_pid_tgid selftest
      selftests/bpf: Add runqslower binary to .gitignore
      libbpf: Fix false uninitialized variable warning
      bpf: Fix use-after-free of bpf_link when priming half-fails

Arnd Bergmann (1):
      bpf: Fix unused variable warning

Christoph Hellwig (5):
      mm: remove watermark_boost_factor_sysctl_handler
      sysctl: remove all extern declaration from sysctl.c
      sysctl: avoid forward declarations
      sysctl: pass kernel pointers to ->proc_handler
      bpf, cgroup: Remove unused exports

Daniel Borkmann (1):
      Merge branch 'work.sysctl' of ssh://gitolite.kernel.org/.../viro/vfs

Jagadeesh Pagadala (1):
      tools/bpf/bpftool: Remove duplicate headers

Jakub Sitnicki (4):
      bpf: Allow bpf_map_lookup_elem for SOCKMAP and SOCKHASH
      selftests/bpf: Test that lookup on SOCKMAP/SOCKHASH is allowed
      selftests/bpf: Use SOCKMAP for server sockets in bpf_sk_assign test
      selftests/bpf: Test allowed maps for bpf_sk_select_reuseport

Lorenz Bauer (1):
      selftests/bpf: Add cls_redirect classifier

Lorenzo Colitti (1):
      net: bpf: Allow TC programs to call BPF_FUNC_skb_change_head

Luke Nelson (2):
      bpf, riscv: Fix tail call count off by one in RV32 BPF JIT
      bpf, riscv: Fix stack layout of JITed code on RV32

Maciej Żenczykowski (2):
      net: bpf: Make bpf_ktime_get_ns() available to non GPL programs
      bpf: add bpf_ktime_get_boot_ns()

Mao Wenan (2):
      bpf: Remove set but not used variable 'dst_known'
      libbpf: Return err if bpf_object__load failed

Quentin Monnet (3):
      tools: bpftool: For "feature probe" define "full_mode" bool as global
      tools: bpftool: Allow unprivileged users to probe features
      tools: bpftool: Make libcap dependency optional

Song Liu (3):
      bpf: Sharing bpf runtime stats with BPF_ENABLE_STATS
      libbpf: Add support for command BPF_ENABLE_STATS
      bpf: Add selftest for BPF_ENABLE_STATS

Stanislav Fomichev (4):
      bpf: Enable more helpers for BPF_PROG_TYPE_CGROUP_{DEVICE,SYSCTL,SOCKOPT}
      bpf: Fix missing bpf_base_func_proto in cgroup_base_func_proto for CGROUP_NET=n
      bpf: Bpf_{g,s}etsockopt for struct bpf_sock_addr
      selftests/bpf: Use reno instead of dctcp

Tobias Klauser (1):
      xsk: Fix typo in xsk_umem_consume_tx and xsk_generic_xmit comments

Veronika Kabatova (1):
      selftests/bpf: Copy runqslower to OUTPUT directory

Yoshiki Komachi (1):
      bpf_helpers.h: Add note for building with vmlinux.h or linux/types.h

Zou Wei (1):
      libbpf: Remove unneeded semicolon in btf_dump_emit_type

 arch/arm64/kernel/armv8_deprecated.c               |    2 +-
 arch/arm64/kernel/fpsimd.c                         |    3 +-
 arch/mips/lasat/sysctl.c                           |   13 +-
 arch/riscv/net/bpf_jit_comp32.c                    |  103 +-
 arch/s390/appldata/appldata_base.c                 |   11 +-
 arch/s390/kernel/debug.c                           |    2 +-
 arch/s390/kernel/topology.c                        |    2 +-
 arch/s390/mm/cmm.c                                 |   12 +-
 arch/x86/kernel/itmt.c                             |    3 +-
 drivers/cdrom/cdrom.c                              |    2 +-
 drivers/char/random.c                              |    2 +-
 drivers/macintosh/mac_hid.c                        |    3 +-
 drivers/media/rc/bpf-lirc.c                        |    2 +
 drivers/parport/procfs.c                           |   39 +-
 fs/dcache.c                                        |    2 +-
 fs/drop_caches.c                                   |    2 +-
 fs/file_table.c                                    |    4 +-
 fs/fscache/main.c                                  |    3 +-
 fs/inode.c                                         |    2 +-
 fs/proc/proc_sysctl.c                              |   47 +-
 fs/quota/dquot.c                                   |    2 +-
 fs/xfs/xfs_sysctl.c                                |    4 +-
 include/linux/bpf-cgroup.h                         |   23 +-
 include/linux/bpf.h                                |   37 +-
 include/linux/bpf_types.h                          |    6 +
 include/linux/compaction.h                         |    2 +-
 include/linux/coredump.h                           |    4 +
 include/linux/file.h                               |    2 +
 include/linux/filter.h                             |    2 -
 include/linux/fs.h                                 |    6 +-
 include/linux/ftrace.h                             |    3 +-
 include/linux/hugetlb.h                            |   15 +-
 include/linux/kprobes.h                            |    2 +-
 include/linux/latencytop.h                         |    4 +-
 include/linux/mm.h                                 |   14 +-
 include/linux/mmzone.h                             |   27 +-
 include/linux/nmi.h                                |   15 +-
 include/linux/perf_event.h                         |   13 +-
 include/linux/pid.h                                |    3 +
 include/linux/printk.h                             |    2 +-
 include/linux/sched/sysctl.h                       |   44 +-
 include/linux/security.h                           |    2 +-
 include/linux/sysctl.h                             |   61 +-
 include/linux/timer.h                              |    3 +-
 include/linux/vmstat.h                             |    8 +-
 include/linux/writeback.h                          |   28 +-
 include/uapi/linux/bpf.h                           |   69 +-
 ipc/ipc_sysctl.c                                   |   10 +-
 ipc/mq_sysctl.c                                    |    4 +-
 kernel/bpf/btf.c                                   |    2 +
 kernel/bpf/cgroup.c                                |  146 +-
 kernel/bpf/core.c                                  |    6 +
 kernel/bpf/helpers.c                               |   89 +-
 kernel/bpf/syscall.c                               |  410 ++-
 kernel/bpf/verifier.c                              |   80 +-
 kernel/cgroup/cgroup.c                             |   27 -
 kernel/events/callchain.c                          |    2 +-
 kernel/events/core.c                               |    6 +-
 kernel/kprobes.c                                   |    2 +-
 kernel/latencytop.c                                |    4 +-
 kernel/pid_namespace.c                             |    2 +-
 kernel/printk/printk.c                             |    2 +-
 kernel/sched/core.c                                |    9 +-
 kernel/sched/fair.c                                |    3 +-
 kernel/sched/rt.c                                  |   10 +-
 kernel/sched/topology.c                            |    2 +-
 kernel/seccomp.c                                   |    2 +-
 kernel/sysctl.c                                    | 3871 ++++++++++----------
 kernel/time/timer.c                                |    3 +-
 kernel/trace/bpf_trace.c                           |    2 +
 kernel/trace/trace.c                               |    2 +-
 kernel/umh.c                                       |    2 +-
 kernel/utsname_sysctl.c                            |    2 +-
 kernel/watchdog.c                                  |   12 +-
 mm/compaction.c                                    |    2 +-
 mm/hugetlb.c                                       |    9 +-
 mm/page-writeback.c                                |   16 +-
 mm/page_alloc.c                                    |   42 +-
 mm/util.c                                          |   10 +-
 mm/vmstat.c                                        |    4 +-
 net/bridge/br_netfilter_hooks.c                    |    2 +-
 net/core/filter.c                                  |  200 +-
 net/core/neighbour.c                               |   28 +-
 net/core/sock_map.c                                |   18 +-
 net/core/sysctl_net_core.c                         |   27 +-
 net/decnet/dn_dev.c                                |    7 +-
 net/decnet/sysctl_net_decnet.c                     |   27 +-
 net/ipv4/devinet.c                                 |    9 +-
 net/ipv4/route.c                                   |    3 +-
 net/ipv4/sysctl_net_ipv4.c                         |   38 +-
 net/ipv6/addrconf.c                                |   33 +-
 net/ipv6/ndisc.c                                   |    3 +-
 net/ipv6/route.c                                   |    5 +-
 net/ipv6/sysctl_net_ipv6.c                         |    3 +-
 net/mpls/af_mpls.c                                 |    5 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |    6 +-
 net/netfilter/nf_conntrack_standalone.c            |    2 +-
 net/netfilter/nf_log.c                             |    2 +-
 net/phonet/sysctl.c                                |    3 +-
 net/rds/tcp.c                                      |    6 +-
 net/sctp/sysctl.c                                  |   32 +-
 net/sunrpc/sysctl.c                                |   29 +-
 net/sunrpc/xprtrdma/svc_rdma.c                     |    7 +-
 net/xdp/xsk.c                                      |    4 +-
 security/apparmor/lsm.c                            |    2 +-
 security/min_addr.c                                |    2 +-
 security/yama/yama_lsm.c                           |    2 +-
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |   12 +-
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |  118 +
 tools/bpf/bpftool/Makefile                         |   13 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   41 +-
 tools/bpf/bpftool/btf.c                            |    1 -
 tools/bpf/bpftool/cgroup.c                         |   48 +-
 tools/bpf/bpftool/common.c                         |    2 +
 tools/bpf/bpftool/feature.c                        |  143 +-
 tools/bpf/bpftool/gen.c                            |    1 -
 tools/bpf/bpftool/jit_disasm.c                     |    1 -
 tools/bpf/bpftool/link.c                           |  333 ++
 tools/bpf/bpftool/main.c                           |    6 +-
 tools/bpf/bpftool/main.h                           |   37 +
 tools/include/uapi/linux/bpf.h                     |   69 +-
 tools/lib/bpf/bpf.c                                |   29 +-
 tools/lib/bpf/bpf.h                                |    5 +-
 tools/lib/bpf/bpf_helpers.h                        |    7 +
 tools/lib/bpf/btf_dump.c                           |    2 +-
 tools/lib/bpf/hashmap.c                            |    7 +
 tools/lib/bpf/libbpf.c                             |  705 ++--
 tools/lib/bpf/libbpf.map                           |    7 +
 tools/testing/selftests/bpf/.gitignore             |    4 +-
 tools/testing/selftests/bpf/Makefile               |   16 +-
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |  110 +-
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |   49 +
 .../selftests/bpf/prog_tests/cls_redirect.c        |  456 +++
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |    2 +-
 .../selftests/bpf/prog_tests/enable_stats.c        |   45 +
 .../bpf/{test_hashmap.c => prog_tests/hashmap.c}   |  280 +-
 .../selftests/bpf/prog_tests/ns_current_pid_tgid.c |    5 +-
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |    5 +
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |   21 +-
 tools/testing/selftests/bpf/progs/connect4_prog.c  |   46 +
 .../selftests/bpf/progs/test_btf_map_in_map.c      |   76 +
 .../selftests/bpf/progs/test_cls_redirect.c        | 1058 ++++++
 .../selftests/bpf/progs/test_cls_redirect.h        |   54 +
 .../selftests/bpf/progs/test_enable_stats.c        |   18 +
 tools/testing/selftests/bpf/progs/test_obj_id.c    |   14 +-
 tools/testing/selftests/bpf/progs/test_sk_assign.c |   82 +-
 .../testing/selftests/bpf/progs/test_sysctl_prog.c |    2 +-
 tools/testing/selftests/bpf/test_progs.c           |   21 +-
 tools/testing/selftests/bpf/test_progs.h           |    7 +
 tools/testing/selftests/bpf/test_verifier.c        |   19 +-
 .../testing/selftests/bpf/verifier/event_output.c  |   24 +
 .../selftests/bpf/verifier/prevent_map_lookup.c    |   30 -
 tools/testing/selftests/bpf/verifier/sock.c        |  115 +
 153 files changed, 6739 insertions(+), 3367 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-link.rst
 create mode 100644 tools/bpf/bpftool/link.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cls_redirect.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
 rename tools/testing/selftests/bpf/{test_hashmap.c => prog_tests/hashmap.c} (53%)
 create mode 100644 tools/testing/selftests/bpf/progs/test_btf_map_in_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c
