Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29A53487D0
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 05:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCYEFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 00:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhCYEFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 00:05:14 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66EFC06174A;
        Wed, 24 Mar 2021 21:05:11 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id h3so645467pfr.12;
        Wed, 24 Mar 2021 21:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A5yvqkyVYm431HGf7nHf/sq4Qxoujyd9ezSi8OSzXbU=;
        b=jQmALsWDE3go1ZaJJxZUTzmFXygVbwJmiToOoU958/9oPbVJcrFaR77/4LUHQNS4U1
         Ss8CfynkNRVLAqaYHngOq9gyfgl1yxAd2oES10XY94phg4vzY8nkh1fJXAZv3put51lp
         /PX2zzRPjxlh9wnVb0w6VrdoOEWqr/4oizQRbeRv32EMDH0hGAJVQhMTyK08D3VGoeen
         Sekmqekbo1HRwEOrrcaCDObXM7mVS+evZ3r7iW7JMr8Pb9p3e1puX4Q7TnYpUlPwue/x
         kUyHbvU1iwD44PShVhlvbr6njtNv829CfUZEL1zKffbyQFHBF+iQ15vg28o/oqyUfxIu
         cKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A5yvqkyVYm431HGf7nHf/sq4Qxoujyd9ezSi8OSzXbU=;
        b=BkaIqfxzzcMaARuH9g4xnK2V6EZz5Qrj6Y9NUb5lImEXHXIAKg6Efadbq+qHgn3k1K
         tWcoIYAOnOqeol1mYhoptwTfTiVtCa16FRLkyNdudEYpnYLl8LGNZucQl7eMs1YZVHK6
         N1fyTWMfFIEJ/LGxX+GXkn9qL3oPFXHOVEg2dz/znFEwoGKvFjpQbs7SHqiAd4+hLRLh
         WYkO/g8INe8mkslH0CD2hgoII4ucL7gD3tREkrsRRWm127S/G0JWl+Emt4oAYLURfFdS
         pR80VGRRPY+E5kRgBKs3wGlQpMh0OmLBjyXsa7sSOEZaOIoHFdXdDrWapAiz4sBRvc+h
         Vt7A==
X-Gm-Message-State: AOAM531mi/Rwr50zvYkj/+0XsysqN87KvUEW9alGeWZvsfRSrqlc6E9A
        DMewN3V4w26fMBtiyNQt1GHxy/5CVp4=
X-Google-Smtp-Source: ABdhPJzNfsaVzZevI89CYK8WD/IqtL+XJWvtF3srHpNHLz3NR3UeQuJlfjU2ed9XN8+58UFJyv4bAg==
X-Received: by 2002:a63:2bc4:: with SMTP id r187mr5893353pgr.131.1616645111170;
        Wed, 24 Mar 2021 21:05:11 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id e83sm4018830pfh.80.2021.03.24.21.05.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Mar 2021 21:05:10 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2021-03-24
Date:   Wed, 24 Mar 2021 21:05:08 -0700
Message-Id: <20210325040508.92541-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 37 non-merge commits during the last 15 day(s) which contain
a total of 65 files changed, 3200 insertions(+), 738 deletions(-).

The main changes are:

1) Static linking of multiple BPF ELF files, from Andrii.

2) Move drop error path to devmap for XDP_REDIRECT, from Lorenzo.

3) Spelling fixes from various folks.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Abaci Robot, Camelia Groza, Edward Cree, Hulk Robot, Ilias Apalodimas, 
Ioana Ciornei, Jesper Dangaard Brouer, Jiri Olsa, KP Singh, Martin KaFai 
Lau, Quentin Monnet, Shay Agroskin, Song Liu, Yonghong Song

----------------------------------------------------------------

The following changes since commit c1acda9807e2bbe1d2026b44f37d959d6d8266c8:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2021-03-09 18:07:05 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to e2c69f3a5b4edfbcade2c38862c1839fc371c5d5:

  bpf: Avoid old-style declaration warnings (2021-03-24 09:32:28 -0700)

----------------------------------------------------------------
Alexei Starovoitov (3):
      Merge branch 'Build BPF selftests and its libbpf, bpftool in debug mode'
      Merge branch 'Provide NULL and KERNEL_VERSION macros in bpf_helpers.h'
      Merge branch 'BPF static linking'

Andrii Nakryiko (20):
      Merge branch 'libbpf/xsk cleanups'
      libbpf: Add explicit padding to bpf_xdp_set_link_opts
      bpftool: Fix maybe-uninitialized warnings
      selftests/bpf: Fix maybe-uninitialized warning in xdpxceiver test
      selftests/bpf: Build everything in debug mode
      libbpf: provide NULL and KERNEL_VERSION macros in bpf_helpers.h
      selftests/bpf: drop custom NULL #define in skb_pkt_end selftest
      libbpf: Expose btf_type_by_id() internally
      libbpf: Generalize BTF and BTF.ext type ID and strings iteration
      libbpf: Rename internal memory-management helpers
      libbpf: Extract internal set-of-strings datastructure APIs
      libbpf: Add generic BTF type shallow copy API
      libbpf: Add BPF static linker APIs
      libbpf: Add BPF static linker BTF and BTF.ext support
      bpftool: Add ability to specify custom skeleton object name
      bpftool: Add `gen object` command to perform BPF static linking
      selftests/bpf: Re-generate vmlinux.h and BPF skeletons if bpftool changed
      selftests/bpf: Pass all BPF .o's through BPF static linker
      selftests/bpf: Add multi-file statically linked BPF object file test
      libbpf: Skip BTF fixup if object file has no BTF

Arnd Bergmann (1):
      bpf: Avoid old-style declaration warnings

Björn Töpel (2):
      libbpf: xsk: Remove linux/compiler.h header
      libbpf: xsk: Move barriers from libbpf_util.h to xsk.h

Ilya Leoshkevich (1):
      s390/bpf: Implement new atomic ops

Jianlin Lv (1):
      bpf: Remove insn_buf[] declaration in inner block

Jiapeng Chong (3):
      selftests/bpf: Fix warning comparing pointer to 0
      bpf: Fix warning comparing pointer to 0
      selftests/bpf: Fix warning comparing pointer to 0

KP Singh (1):
      libbpf: Add explicit padding to btf_dump_emit_type_decl_opts

Liu xuzhi (1):
      kernel/bpf/: Fix misspellings using codespell tool

Lorenzo Bianconi (1):
      bpf, devmap: Move drop error path to devmap for XDP_REDIRECT

Manu Bretelle (1):
      bpf: Add getter and setter for SO_REUSEPORT through bpf_{g,s}etsockopt

Masanari Iida (1):
      samples: bpf: Fix a spelling typo in do_hbm_test.sh

Pedro Tammela (2):
      libbpf: Avoid inline hint definition from 'linux/stddef.h'
      bpf: selftests: Remove unused 'nospace_err' in tests for batched ops in array maps

Ravi Bangoria (1):
      selftests/bpf: Use nanosleep() syscall instead of sleep() in get_cgroup_id

Wei Yongjun (1):
      bpf: Make symbol 'bpf_task_storage_busy' static

Yonghong Song (1):
      bpf: net: Emit anonymous enum with BPF_TCP_CLOSE value explicitly

 arch/s390/net/bpf_jit_comp.c                       |   64 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   21 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   20 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   12 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |    2 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   15 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   15 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   11 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   11 +-
 drivers/net/ethernet/marvell/mvneta.c              |   13 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   15 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   19 +-
 drivers/net/ethernet/sfc/tx.c                      |   15 +-
 drivers/net/ethernet/socionext/netsec.c            |   16 +-
 drivers/net/ethernet/ti/cpsw.c                     |   14 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   14 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |   11 +-
 drivers/net/tun.c                                  |   15 +-
 drivers/net/veth.c                                 |   28 +-
 drivers/net/virtio_net.c                           |   25 +-
 drivers/net/xen-netfront.c                         |   18 +-
 include/linux/btf.h                                |    1 +
 kernel/bpf/bpf_lsm.c                               |    4 +-
 kernel/bpf/bpf_task_storage.c                      |    2 +-
 kernel/bpf/devmap.c                                |   30 +-
 kernel/bpf/hashtab.c                               |    2 +-
 kernel/bpf/verifier.c                              |    1 -
 net/core/filter.c                                  |    6 +
 net/ipv4/tcp.c                                     |   12 +
 samples/bpf/do_hbm_test.sh                         |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |   78 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   17 +-
 tools/bpf/bpftool/btf.c                            |    3 +
 tools/bpf/bpftool/gen.c                            |   72 +-
 tools/bpf/bpftool/main.c                           |    3 +-
 tools/bpf/bpftool/map.c                            |    2 +-
 tools/lib/bpf/Build                                |    2 +-
 tools/lib/bpf/Makefile                             |    1 -
 tools/lib/bpf/bpf_helpers.h                        |   21 +-
 tools/lib/bpf/btf.c                                |  714 ++++---
 tools/lib/bpf/btf.h                                |    3 +
 tools/lib/bpf/btf_dump.c                           |    8 +-
 tools/lib/bpf/libbpf.c                             |   15 +-
 tools/lib/bpf/libbpf.h                             |   14 +
 tools/lib/bpf/libbpf.map                           |    5 +
 tools/lib/bpf/libbpf_internal.h                    |   38 +-
 tools/lib/bpf/libbpf_util.h                        |   75 -
 tools/lib/bpf/linker.c                             | 1944 ++++++++++++++++++++
 tools/lib/bpf/strset.c                             |  176 ++
 tools/lib/bpf/strset.h                             |   21 +
 tools/lib/bpf/xsk.h                                |   70 +-
 tools/testing/selftests/bpf/Makefile               |   34 +-
 tools/testing/selftests/bpf/get_cgroup_id_user.c   |    6 +-
 .../selftests/bpf/map_tests/array_map_batch_ops.c  |    5 -
 .../selftests/bpf/prog_tests/static_linked.c       |   40 +
 tools/testing/selftests/bpf/progs/bind4_prog.c     |   25 +
 tools/testing/selftests/bpf/progs/bind6_prog.c     |   25 +
 tools/testing/selftests/bpf/progs/fentry_test.c    |    2 +-
 tools/testing/selftests/bpf/progs/fexit_test.c     |    4 +-
 tools/testing/selftests/bpf/progs/skb_pkt_end.c    |    1 -
 .../selftests/bpf/progs/test_global_func10.c       |    2 +-
 .../selftests/bpf/progs/test_static_linked1.c      |   30 +
 .../selftests/bpf/progs/test_static_linked2.c      |   31 +
 tools/testing/selftests/bpf/xdpxceiver.c           |    4 +-
 65 files changed, 3200 insertions(+), 738 deletions(-)
 delete mode 100644 tools/lib/bpf/libbpf_util.h
 create mode 100644 tools/lib/bpf/linker.c
 create mode 100644 tools/lib/bpf/strset.c
 create mode 100644 tools/lib/bpf/strset.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/static_linked.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_static_linked1.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_static_linked2.c
