Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B692AA050
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgKFWW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgKFWSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 17:18:02 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F09BC0613CF;
        Fri,  6 Nov 2020 14:18:02 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id x15so488393pll.2;
        Fri, 06 Nov 2020 14:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mt112lJeAhAZTLqtAccHSXk5WvwfNz95X0eDuczcqC4=;
        b=T3UScf7/XuIq0a/vqGgOXyRwbQHUcwRFhJTzoaReWAOXJBPSifycuq8Mv8tpfO19Jo
         2BzYJej+zTw/Va5H1UCPajZaee0h4ErEFZnjRwDYjHm4aXa+Iwt8Cz9YiGt0pvplavfY
         Ym8yAoHCpEHL9jemPJo97C5r1X9WUvyVI8WUy9Uh+TaboqKQ2NU9YiRR2q42bZBWsmxZ
         axW7TGE8dh3BYkT+AJmjl/6IQ+FZcwblOtY0719CIepFVlzF0AUrxaLG19VvjkLxOW6S
         /VTseg8eJ8kBQcpSQ6gpq5tE8tWcsTXuxI8r+RR7btOpk/V7dW8AeXECZniT8RBgaLg5
         vVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mt112lJeAhAZTLqtAccHSXk5WvwfNz95X0eDuczcqC4=;
        b=tJTqZE6NyQZWSN25Uji96iFUyrpmJOhiHjOqPlOfv+SfWeHQcnY6csISKHqcEI9JHA
         qSZx6qTcqNnF6iXUHbVfjfhhbSITJIA+DDfIU4Mg8kEAI3G29HJZaynLMENEA0Icfq6U
         b4Y3UPTbkurEXEQyha9jxyk3B9qu8YS5Uw/khBpWoj4lRbmkB6LzoDX+VBZayS5fXIbT
         wjelJIRXNGY5BY1Ic6gM2UUL5GjSC7k1P2TTdxtUAI13biPA0OpZ7NQlcsuWa1VVFAik
         nqZV/6rd3AzWVNOGEncWsRJSbKppSDrTk20xkRgwJzW3vF1SPnzTdVOzi1D4jbB5uFXH
         azWA==
X-Gm-Message-State: AOAM530jgAPTBSNf2NI8UMM0U4TIOZiKzuN1kbVpUWtQ5ntucYYihNhS
        wHChnubgZXZhLv4ZNxoNMDvqjTEY3DI=
X-Google-Smtp-Source: ABdhPJw9PBmMlLQnB8KXRTOoO629GuMv9aNh418vMYP0H/vCQHm5d1v7F4iNyPyoRSnzO6gH2kKAhQ==
X-Received: by 2002:a17:902:8209:b029:d6:d2c9:1db5 with SMTP id x9-20020a1709028209b02900d6d2c91db5mr3330007pln.54.1604701081650;
        Fri, 06 Nov 2020 14:18:01 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id v23sm3546739pjh.46.2020.11.06.14.18.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 14:18:00 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf 2020-11-06
Date:   Fri,  6 Nov 2020 14:17:59 -0800
Message-Id: <20201106221759.24143-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 15 non-merge commits during the last 14 day(s) which contain
a total of 25 files changed, 346 insertions(+), 49 deletions(-).

The main changes are:

1) Pre-allocated per-cpu hashmap needs to zero-fill reused element, from David.

2) Tighten bpf_lsm function check, from KP.

3) Fix bpftool attaching to flow dissector, from Lorenz.

4) Use -fno-gcse for the whole kernel/bpf/core.c instead of function attribute, from Ard.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Björn Töpel, Geert Uytterhoeven, Jesper Dangaard 
Brouer, Jiri Benc, kernel test robot, Matthieu Baerts, Nick Desaulniers, 
Randy Dunlap, Song Liu, Tobias Klauser, Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit 435ccfa894e35e3d4a1799e6ac030e48a7b69ef5:

  tcp: Prevent low rmem stalls with SO_RCVLOWAT. (2020-10-23 19:11:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 6f64e477830000746c1f992050fbd45c03c89429:

  bpf: Update verification logic for LSM programs (2020-11-06 13:15:21 -0800)

----------------------------------------------------------------
Andrii Nakryiko (2):
      selftest/bpf: Fix profiler test using CO-RE relocation for enums
      bpf: Add struct bpf_redir_neigh forward declaration to BPF helper defs

Ard Biesheuvel (1):
      bpf: Don't rely on GCC __attribute__((optimize)) to disable GCSE

Arnd Bergmann (1):
      bpf: Fix -Wshadow warnings

David Verbeiren (1):
      bpf: Zero-fill re-used per-cpu map element

Ian Rogers (3):
      tools, bpftool: Avoid array index warnings.
      tools, bpftool: Remove two unused variables.
      libbpf, hashmap: Fix undefined behavior in hash_bits

KP Singh (1):
      bpf: Update verification logic for LSM programs

Lorenz Bauer (1):
      tools/bpftool: Fix attaching flow dissector

Magnus Karlsson (3):
      xsk: Fix possible memory leak at socket close
      libbpf: Fix null dereference in xsk_socket__delete
      libbpf: Fix possible use after free in xsk_socket__delete

Randy Dunlap (1):
      bpf: BPF_PRELOAD depends on BPF_SYSCALL

Toke Høiland-Jørgensen (1):
      samples/bpf: Set rlimit for memlock to infinity in all samples

 include/linux/compiler-gcc.h                      |   2 -
 include/linux/compiler_types.h                    |   4 -
 include/linux/filter.h                            |  22 +--
 include/net/xsk_buff_pool.h                       |   2 +-
 kernel/bpf/Makefile                               |   6 +-
 kernel/bpf/bpf_lsm.c                              |  10 +-
 kernel/bpf/core.c                                 |   2 +-
 kernel/bpf/hashtab.c                              |  30 ++-
 kernel/bpf/preload/Kconfig                        |   1 +
 net/xdp/xsk.c                                     |   3 +-
 net/xdp/xsk_buff_pool.c                           |   7 +-
 samples/bpf/task_fd_query_user.c                  |   2 +-
 samples/bpf/tracex2_user.c                        |   2 +-
 samples/bpf/tracex3_user.c                        |   2 +-
 samples/bpf/xdp_redirect_cpu_user.c               |   2 +-
 samples/bpf/xdp_rxq_info_user.c                   |   2 +-
 scripts/bpf_helpers_doc.py                        |   1 +
 tools/bpf/bpftool/feature.c                       |   7 +-
 tools/bpf/bpftool/prog.c                          |   2 +-
 tools/bpf/bpftool/skeleton/profiler.bpf.c         |   4 +-
 tools/lib/bpf/hashmap.h                           |  15 +-
 tools/lib/bpf/xsk.c                               |   9 +-
 tools/testing/selftests/bpf/prog_tests/map_init.c | 214 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/profiler.inc.h  |  11 +-
 tools/testing/selftests/bpf/progs/test_map_init.c |  33 ++++
 25 files changed, 346 insertions(+), 49 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_init.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_init.c
