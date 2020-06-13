Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C04E1F800E
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 02:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgFMApv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 20:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgFMApu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 20:45:50 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5568DC03E96F;
        Fri, 12 Jun 2020 17:45:50 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r18so4898038pgk.11;
        Fri, 12 Jun 2020 17:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qXn5fiVbJfuxAzRhFQhwC/94oLSF4HCE4NA+fdNKoxc=;
        b=qSuX8PJy96dd7g9rjrcKcXErgaQv/EYXJeJ7veKgUK28j0V3EpMPjTN7VGQS3+JmUj
         mvAriVq/wZTp7K22uZx2lOuTiCFY1exHWC87/xFCMUYls5eOL4VajmvlHrg7kl0K+P2m
         ZjR6g6OJZwG1mIPQZOWxCIhyNiYWSQy65MC6clY8Ed8S0liiTU1xZkjFeNy35AiRCmHN
         lQhuu9r2H/rmQb1pjBPEj15EAevRhZGQyKd6SN8UYIv8TZVv+Lqppy9ndun1JMo3D2lh
         h7kZoSUta/K1P+nEdbyWUSxw8p6a7mZxz0LbVcclQZNAcIdkolsBhsrc/q3CnslXopZh
         Nj4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qXn5fiVbJfuxAzRhFQhwC/94oLSF4HCE4NA+fdNKoxc=;
        b=Z0QEd4fSsz3AEbrNVc1ph1OmcLQzoZUDignhHhEllPNR5+kKYU68T9eS3Cja7Tc2Kg
         IoE/CUb3PAJyIp6oWNForP9djy/UUIPQHKNxmQFBGwGBhW6s7LSATWOpAbOc4OeYAxfp
         paHgqP0LaDwnISTIpkI5sgbjGgPcaXQ5h0JJPGbmf4E11K4UQa+dXE/Ww729QQu2qADs
         HcvMnepi8lUMuscYRReQfYtxxYUq+BVzph21FVta7XxJr6OdhtHXCY2MjvTdN2GwxPuJ
         /t/2xUOe/ZtpXOs/ibfU/l04EceKhgQFzOy9mEuuMOdTAP89L3+9x1ouKAfXqQC45UAO
         HiYA==
X-Gm-Message-State: AOAM532uceI/XUGOWJ83pI7bqYMC1ZTl1d8K2jqbWbmdOn/KM3/52A+5
        Zx4y7lQqHgywq2lF//eJ7tg=
X-Google-Smtp-Source: ABdhPJzWYiSbjDhsV+rQ80FbBUTZZT8niHe5QVY6Z0Cu97rCn9LbJ6QOT4TIzPFfXdyBCqWTOKB68A==
X-Received: by 2002:aa7:8506:: with SMTP id v6mr14033638pfn.303.1592009149698;
        Fri, 12 Jun 2020 17:45:49 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id y4sm6325187pgr.76.2020.06.12.17.45.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jun 2020 17:45:49 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf 2020-06-12
Date:   Fri, 12 Jun 2020 17:45:47 -0700
Message-Id: <20200613004547.82591-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 26 non-merge commits during the last 10 day(s) which contain
a total of 27 files changed, 348 insertions(+), 93 deletions(-).

The main changes are:

1) sock_hash accounting fix, from Andrey.

2) libbpf fix and probe_mem sanitizing, from Andrii.

3) sock_hash fixes, from Jakub.

4) devmap_val fix, from Jesper.

5) load_bytes_relative fix, from YiFei.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Björn Töpel, Eric Dumazet, Jakub Sitnicki, 
Jean-Philippe Brucker, John Fastabend, Masami Hiramatsu, Song Liu, 
Stanislav Fomichev, Tobias Klauser, Yonghong Song

----------------------------------------------------------------

The following changes since commit cb8e59cc87201af93dfbb6c3dccc8fcad72a09c2:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2020-06-03 16:27:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 29fcb05bbf1a7008900bb9bee347bdbfc7171036:

  bpf: Undo internal BPF_PROBE_MEM in BPF insns dump (2020-06-12 17:35:38 -0700)

----------------------------------------------------------------
Andrey Ignatov (1):
      bpf: Fix memlock accounting for sock_hash

Andrii Nakryiko (5):
      selftests/bpf: Fix ringbuf selftest sample counting undeterminism
      libbpf: Handle GCC noreturn-turned-volatile quirk
      tools/bpftool: Fix skeleton codegen
      libbpf: Support pre-initializing .bss global variables
      bpf: Undo internal BPF_PROBE_MEM in BPF insns dump

Arnaldo Carvalho de Melo (1):
      libbpf: Define __WORDSIZE if not available

Brett Mastbergen (1):
      tools, bpf: Do not force gcc as CC

Dan Carpenter (1):
      bpf: Fix an error code in check_btf_func()

David Ahern (1):
      bpf: Reset data_meta before running programs attached to devmap entry

Jakub Sitnicki (2):
      bpf, sockhash: Fix memory leak when unlinking sockets in sock_hash_free
      bpf, sockhash: Synchronize delete from bucket list on map free

Jean-Philippe Brucker (1):
      tracing/probe: Fix bpf_task_fd_query() for kprobes and uprobes

Jesper Dangaard Brouer (2):
      bpf: Devmap adjust uapi for attach bpf program
      bpf: Selftests and tools use struct bpf_devmap_val from uapi

Li RongQing (1):
      xdp: Fix xsk_generic_xmit errno

Lorenz Bauer (3):
      scripts: Require pahole v1.16 when generating BTF
      bpf: cgroup: Allow multi-attach program to replace itself
      bpf: sockmap: Don't attach programs to UDP sockets

Matthieu Baerts (1):
      bpf: Fix unused-var without NETDEVICES

Sabrina Dubroca (1):
      bpf: tcp: Recv() should return 0 when the peer socket is closed

Tobias Klauser (2):
      tools, bpftool: Fix memory leak in codegen error cases
      tools, bpftool: Exit on error in function codegen

YiFei Zhu (2):
      net/filter: Permit reading NET in load_bytes_relative when MAC not set
      selftests/bpf: Add cgroup_skb/egress test for load_bytes_relative

dihu (1):
      bpf/sockmap: Fix kernel panic at __tcp_bpf_recvmsg

 include/uapi/linux/bpf.h                           | 13 ++++
 kernel/bpf/cgroup.c                                |  2 +-
 kernel/bpf/devmap.c                                | 18 ++----
 kernel/bpf/syscall.c                               | 17 ++++--
 kernel/bpf/verifier.c                              |  2 +-
 kernel/trace/trace_kprobe.c                        |  2 +-
 kernel/trace/trace_uprobe.c                        |  2 +-
 net/core/filter.c                                  | 19 +++---
 net/core/sock_map.c                                | 38 ++++++++++--
 net/ipv4/tcp_bpf.c                                 |  6 ++
 net/xdp/xsk.c                                      |  4 +-
 scripts/link-vmlinux.sh                            |  4 +-
 tools/bpf/Makefile                                 |  1 -
 tools/bpf/bpftool/gen.c                            | 11 ++--
 tools/include/uapi/linux/bpf.h                     | 13 ++++
 tools/lib/bpf/btf_dump.c                           | 33 +++++++---
 tools/lib/bpf/hashmap.h                            |  7 +--
 tools/lib/bpf/libbpf.c                             |  4 --
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |  7 +++
 .../selftests/bpf/prog_tests/load_bytes_relative.c | 71 ++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   | 42 ++++++++++---
 tools/testing/selftests/bpf/prog_tests/skeleton.c  | 45 ++++++++++++--
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |  8 ---
 .../selftests/bpf/progs/load_bytes_relative.c      | 48 +++++++++++++++
 tools/testing/selftests/bpf/progs/test_skeleton.c  | 19 ++++--
 .../selftests/bpf/progs/test_xdp_devmap_helpers.c  |  2 +-
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |  3 +-
 27 files changed, 348 insertions(+), 93 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/load_bytes_relative.c
 create mode 100644 tools/testing/selftests/bpf/progs/load_bytes_relative.c
