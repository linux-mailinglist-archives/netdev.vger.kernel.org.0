Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930101EB1E0
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgFAWu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgFAWu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:50:28 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086B4C05BD43;
        Mon,  1 Jun 2020 15:50:28 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y17so518271plb.8;
        Mon, 01 Jun 2020 15:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s5VMpBJN6l/HPhRb+WHpA5eDEBBizggJClrDGwCAQ2Q=;
        b=MDncYYmtNa4OKmyK7KnvgUzeVFUyfyPJfoOimCqmtF/nXKcwY6/j8XJH1VDkVtrtfz
         WmhR4UmFbueWFwhbmDFyDR/1DwNV7FR8hN8237oyY42OJAdAXTnmZUx/VpftxpouamcV
         JbH91i8+/ENUZvBjBa1fn3jvqoV+fZ/yt772gFQVJiei6aZNb3l86JQSI1SHFUyVwu/2
         maaOCmZOVR1B4oqN7h3UOdbC88Dxd/g/JSwGTP/teTRuMna99BPWvHLhoMeSbd7X2fT1
         7DHIEjUlsN+5GDt6PkclDqmyZkqWlHsEt1cwDazDGuhBTOHbW2i+N9fwmBldWEcg+7qG
         5ZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s5VMpBJN6l/HPhRb+WHpA5eDEBBizggJClrDGwCAQ2Q=;
        b=qpdLOYkW0T+NGplk+bQHQ6Oq6YB3dujMzZIWD51BYEVkBpb4nOz3rOal7TmQ6c0S8u
         ri/LFcyVDp8PlRuy2AOvfwcFfLP4+VVRzRNCYTujJZXqVgoi+kvkSqQuD77ttGLE8TvR
         T/4X8YC3Ij/+k0cg2VLN4Gx1nBXJskYvoYkdyyMGoMUF7s7kM1Wwlq2h23nA9eZlZvtE
         BP2CtOsJYXaP8j7RQ6BRVg75Zgtkys779a/rtlXQrB1jOrW3g4x3UsMrcXf8wDcCFQma
         LpKRX9T3KaxhtiLR5gU5QbCrSLP1k86ggc5lHx+E8qe0hqomzL8kYGmvvAnieWJkNOw+
         wyoQ==
X-Gm-Message-State: AOAM5320xEdcnUGFJEj+IiHT/8Plcy/4hcAGXm6ViBZmJy+WcruYdlaq
        z8/IRGFZzmEHm0xlhITShP0=
X-Google-Smtp-Source: ABdhPJxFha71wQo+dfuxGBuU7KJnU5TU8APmAIxTnnrM/3wbB6Bx/Pe/8yI9wl5h4rKzCuMvNYarzg==
X-Received: by 2002:a17:902:7c05:: with SMTP id x5mr22859130pll.278.1591051827428;
        Mon, 01 Jun 2020 15:50:27 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id t64sm380835pgd.24.2020.06.01.15.50.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jun 2020 15:50:26 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf-next 2020-06-01
Date:   Mon,  1 Jun 2020 15:50:24 -0700
Message-Id: <20200601225024.98035-1-alexei.starovoitov@gmail.com>
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

We've added 55 non-merge commits during the last 1 day(s) which contain
a total of 91 files changed, 4986 insertions(+), 463 deletions(-).

The main changes are:

1) Add rx_queue_mapping to bpf_sock from Amritha.

2) Add BPF ring buffer, from Andrii.

3) Attach and run programs through devmap, from David.

4) Allow SO_BINDTODEVICE opt in bpf_setsockopt, from Ferenc.

5) link based flow_dissector, from Jakub.

6) Use tracing helpers for lsm programs, from Jiri.

7) Several sk_msg fixes and extensions, from John.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Jakub Sitnicki, Jesper Dangaard Brouer, Song Liu, 
Stanislav Fomichev, Toke Høiland-Jørgensen, Yonghong Song

----------------------------------------------------------------

The following changes since commit 90040351a832acf862c8f1855c29411303d23755:

  tools, bpftool: Clean subcommand help messages (2020-06-01 14:38:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to cf51abcded837ef209faa03a62b2ea44e45995e8:

  Merge branch 'Link-based-attach-to-netns' (2020-06-01 15:21:12 -0700)

----------------------------------------------------------------
Alexei Starovoitov (5):
      Merge branch 'xdp_devmap'
      tools/bpf: sync bpf.h
      Merge branch 'fix-ktls-with-sk_skb_verdict'
      Merge branch 'bpf_setsockopt-SO_BINDTODEVICE'
      Merge branch 'Link-based-attach-to-netns'

Amritha Nambiar (1):
      bpf: Add rx_queue_mapping to bpf_sock

Andrii Nakryiko (6):
      bpf: Implement BPF ring buffer and verifier support for it
      libbpf: Add BPF ring buffer support
      selftests/bpf: Add BPF ringbuf selftests
      bpf: Add BPF ringbuf and perf buffer benchmarks
      docs/bpf: Add BPF ring buffer design notes
      libbpf: Add _GNU_SOURCE for reallocarray to ringbuf.c

Anton Protopopov (5):
      selftests/bpf: Fix a typo in test_maps
      selftests/bpf: Cleanup some file descriptors in test_maps
      selftests/bpf: Cleanup comments in test_maps
      bpf: Fix map permissions check
      selftests/bpf: Add tests for write-only stacks/queues

Chris Packham (1):
      bpf: Fix spelling in comment explaining ARG1 in ___bpf_prog_run

Daniel Borkmann (1):
      Merge branch 'bpf-ring-buffer'

David Ahern (5):
      devmap: Formalize map value as a named struct
      bpf: Add support to attach bpf program to a devmap entry
      xdp: Add xdp_txq_info to xdp_buff
      libbpf: Add SEC name for xdp programs attached to device map
      selftest: Add tests for XDP programs in devmap entries

Denis Efremov (1):
      bpf: Change kvfree to kfree in generic_map_lookup_batch()

Eelco Chaudron (2):
      libbpf: Add API to consume the perf ring buffer content
      libbpf: Fix perf_buffer__free() API for sparse allocs

Ferenc Fejes (3):
      net: Make locking in sock_bindtoindex optional
      bpf: Allow SO_BINDTODEVICE opt in bpf_setsockopt
      selftests/bpf: Add test for SO_BINDTODEVICE opt of bpf_setsockopt

Jakub Sitnicki (13):
      bpf: Fix returned error sign when link doesn't support updates
      flow_dissector: Pull locking up from prog attach callback
      net: Introduce netns_bpf for BPF programs attached to netns
      flow_dissector: Move out netns_bpf prog callbacks
      bpf: Add link-based BPF program attachment to network namespace
      bpf, cgroup: Return ENOLINK for auto-detached links on update
      libbpf: Add support for bpf_link-based netns attachment
      bpftool: Extract helpers for showing link attach type
      bpftool: Support link show for netns-attached links
      selftests/bpf: Add tests for attaching bpf_link to netns
      selftests/bpf, flow_dissector: Close TAP device FD after the test
      selftests/bpf: Convert test_flow_dissector to use BPF skeleton
      selftests/bpf: Extend test_flow_dissector to cover link creation

Jiri Olsa (1):
      bpf: Use tracing helpers for lsm programs

John Fastabend (8):
      bpf, sk_msg: Add some generic helpers that may be useful from sk_msg
      bpf: Extend bpf_base_func_proto helpers with probe_* and *current_task*
      bpf, sk_msg: Add get socket storage helpers
      bpf, selftests: Add sk_msg helpers load and attach test
      bpf, selftests: Test probe_* helpers from SCHED_CLS
      bpf: Refactor sockmap redirect code so its easy to reuse
      bpf: Fix running sk_skb program types with ktls
      bpf, selftests: Add test for ktls with skb bpf ingress policy

Lorenzo Bianconi (2):
      xdp: Introduce xdp_convert_frame_to_buff utility routine
      xdp: Rename convert_to_xdp_frame in xdp_convert_buff_to_frame

Lukas Bulwahn (1):
      MAINTAINERS: Adjust entry in XDP SOCKETS to actual file name

Nikolay Borisov (1):
      libbpf: Install headers as part of make install

Quentin Monnet (1):
      tools, bpftool: Make capability check account for new BPF caps

Tobias Klauser (1):
      tools, bpftool: Print correct error message when failing to load BTF

Yauheni Kaliuta (1):
      libbpf: Use .so dynamic symbols for abi check

Yonghong Song (1):
      bpf: Use strncpy_from_unsafe_strict() in bpf_seq_printf() helper

 Documentation/bpf/ringbuf.rst                      | 209 ++++++++
 MAINTAINERS                                        |   2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  10 +-
 drivers/net/ethernet/sfc/rx.c                      |   2 +-
 drivers/net/ethernet/socionext/netsec.c            |   2 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |   2 +-
 drivers/net/tun.c                                  |   2 +-
 drivers/net/veth.c                                 |   8 +-
 drivers/net/virtio_net.c                           |   4 +-
 include/linux/bpf-netns.h                          |  64 +++
 include/linux/bpf.h                                |  21 +
 include/linux/bpf_types.h                          |   4 +
 include/linux/bpf_verifier.h                       |   4 +
 include/linux/skbuff.h                             |  26 -
 include/linux/skmsg.h                              |   8 +
 include/net/flow_dissector.h                       |   6 +
 include/net/net_namespace.h                        |   4 +-
 include/net/netns/bpf.h                            |  18 +
 include/net/sock.h                                 |   2 +-
 include/net/tls.h                                  |   9 +
 include/net/xdp.h                                  |  17 +-
 include/uapi/linux/bpf.h                           |  95 +++-
 kernel/bpf/Makefile                                |   3 +-
 kernel/bpf/bpf_lsm.c                               |   2 +-
 kernel/bpf/cgroup.c                                |   2 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/cpumap.c                                |   2 +-
 kernel/bpf/devmap.c                                | 132 ++++-
 kernel/bpf/helpers.c                               |  34 ++
 kernel/bpf/net_namespace.c                         | 373 +++++++++++++
 kernel/bpf/ringbuf.c                               | 501 ++++++++++++++++++
 kernel/bpf/syscall.c                               |  29 +-
 kernel/bpf/verifier.c                              | 195 +++++--
 kernel/trace/bpf_trace.c                           |  28 +-
 net/core/dev.c                                     |  18 +
 net/core/filter.c                                  |  94 +++-
 net/core/flow_dissector.c                          | 124 +----
 net/core/skmsg.c                                   |  98 +++-
 net/core/sock.c                                    |  10 +-
 net/ipv4/udp_tunnel.c                              |   2 +-
 net/ipv6/ip6_udp_tunnel.c                          |   2 +-
 net/tls/tls_sw.c                                   |  20 +-
 tools/bpf/bpftool/btf.c                            |   2 +-
 tools/bpf/bpftool/feature.c                        |  85 ++-
 tools/bpf/bpftool/link.c                           |  54 +-
 tools/include/uapi/linux/bpf.h                     |  95 +++-
 tools/lib/bpf/Build                                |   2 +-
 tools/lib/bpf/Makefile                             |   6 +-
 tools/lib/bpf/libbpf.c                             |  49 +-
 tools/lib/bpf/libbpf.h                             |  24 +
 tools/lib/bpf/libbpf.map                           |   7 +
 tools/lib/bpf/libbpf_probes.c                      |   5 +
 tools/lib/bpf/ringbuf.c                            | 288 ++++++++++
 tools/testing/selftests/bpf/Makefile               |   5 +-
 tools/testing/selftests/bpf/bench.c                |  16 +
 .../testing/selftests/bpf/benchs/bench_ringbufs.c  | 566 ++++++++++++++++++++
 .../selftests/bpf/benchs/run_bench_ringbufs.sh     |  75 +++
 .../selftests/bpf/prog_tests/flow_dissector.c      | 166 ++++--
 .../bpf/prog_tests/flow_dissector_reattach.c       | 588 +++++++++++++++++++--
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   | 211 ++++++++
 .../selftests/bpf/prog_tests/ringbuf_multi.c       | 102 ++++
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |  30 ++
 .../selftests/bpf/prog_tests/sockmap_basic.c       |  35 ++
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |  97 ++++
 tools/testing/selftests/bpf/progs/bpf_flow.c       |  20 +-
 tools/testing/selftests/bpf/progs/connect4_prog.c  |  33 ++
 tools/testing/selftests/bpf/progs/perfbuf_bench.c  |  33 ++
 tools/testing/selftests/bpf/progs/ringbuf_bench.c  |  60 +++
 tools/testing/selftests/bpf/progs/test_ringbuf.c   |  78 +++
 .../selftests/bpf/progs/test_ringbuf_multi.c       |  77 +++
 .../testing/selftests/bpf/progs/test_skb_helpers.c |  28 +
 .../selftests/bpf/progs/test_skmsg_load_helpers.c  |  47 ++
 .../selftests/bpf/progs/test_sockmap_kern.h        |  46 +-
 .../selftests/bpf/progs/test_xdp_devmap_helpers.c  |  22 +
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |  44 ++
 tools/testing/selftests/bpf/test_maps.c            |  52 +-
 tools/testing/selftests/bpf/test_sockmap.c         | 163 +++++-
 tools/testing/selftests/bpf/verifier/and.c         |   4 +-
 .../testing/selftests/bpf/verifier/array_access.c  |   4 +-
 tools/testing/selftests/bpf/verifier/bounds.c      |   6 +-
 tools/testing/selftests/bpf/verifier/calls.c       |   2 +-
 .../selftests/bpf/verifier/direct_value_access.c   |   4 +-
 .../selftests/bpf/verifier/helper_access_var_len.c |   2 +-
 .../selftests/bpf/verifier/helper_value_access.c   |   6 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |   8 +-
 91 files changed, 4986 insertions(+), 463 deletions(-)
 create mode 100644 Documentation/bpf/ringbuf.rst
 create mode 100644 include/linux/bpf-netns.h
 create mode 100644 include/net/netns/bpf.h
 create mode 100644 kernel/bpf/net_namespace.c
 create mode 100644 kernel/bpf/ringbuf.c
 create mode 100644 tools/lib/bpf/ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_ringbufs.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_ringbufs.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/perfbuf_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/ringbuf_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
