Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2590F38970E
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhESTx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbhESTxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 15:53:24 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CBCC06175F;
        Wed, 19 May 2021 12:52:03 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id e15so1037007plh.1;
        Wed, 19 May 2021 12:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5G3tVw7tswZnONxHE18yjyz+PAa4v5Tb69JHXsIWI0Y=;
        b=tpC16VaTulyZ2vRCy0uaskmlU8U57V0qKTwMZkgSVVBHST5iOtR/IVd1ydTzD131zi
         /410h/L076uJnAKABTEI9qJ+rbOe4VHblmrTPz/T9dDLulxP3BIEkkKkYhR391CWcjc/
         yp5Qggl9oBldF41nc6s4FtVoM1Gh7C02soAy94417Q4BgKROe9CAMQ/7tglV5r7YBmZC
         YPswAm6Udq80cP0iZqLVl26lf2K1CltSKALn3v8X0I2tTYuFh8MXD/iRmAcRN7Yxa6+J
         3QTsPNgHRYHohzyCTBNEBZ7Pg0CdCOGRm/MeW+2DtoIBD0n/rVCVKf0dSzbjzWgt4W9k
         sUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5G3tVw7tswZnONxHE18yjyz+PAa4v5Tb69JHXsIWI0Y=;
        b=QJfHpsMEDtyZBBdmnxp95c1Dv6wyNv9roJMjMc066VmAJOMXtbG4AiU9Brkp16CEqu
         9D4kR8qQib1oe1S1qKR28NvrZgxOcc7t1qDPQuF5PKbCYWhetkXRpaWHUgee6iLmlg4P
         MiIVB7cROgF7WIUH0A80rASBelXAh7xE8bTN2TER3dhL7o0wFS+4PcMJwa+oEkrl/PUo
         MtNJ0GjH+LUq/IEXN37lT4++sLkU5jLFGiHlJwoilEXBJojwPB5KyWmXml8cTGyf55HK
         pmSay0V2qXHZLi/xCB3wn3nOt9c6rrIGKB7Dtbx/in+WIozmb4nN5WsTXtvanL88BB9k
         p9HA==
X-Gm-Message-State: AOAM532r2wKFf+APjieQsUxGqnwdFx66K+TVa29DrklSYetP/UYiQhOR
        4qOzprBYH8OSOgR8qANI9viYWvXQkLI=
X-Google-Smtp-Source: ABdhPJxHWb2VlHKfwDs2VCRnWb+qRCS/oYiw8qzwV+a+27vkRQEw4CyJiSVrNv3sozXCSt9AMagXEA==
X-Received: by 2002:a17:90a:b88d:: with SMTP id o13mr659464pjr.207.1621453923434;
        Wed, 19 May 2021 12:52:03 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.4])
        by smtp.gmail.com with ESMTPSA id o10sm187303pfh.67.2021.05.19.12.52.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 May 2021 12:52:02 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2021-05-19
Date:   Wed, 19 May 2021 12:51:59 -0700
Message-Id: <20210519195159.41380-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 43 non-merge commits during the last 11 day(s) which contain
a total of 74 files changed, 3717 insertions(+), 578 deletions(-).

The main changes are:

1) syscall program type, fd array, and light skeleton, from Alexei.

2) Stop emitting static variables in skeleton, from Andrii.

3) Low level tc-bpf api, from Kumar.

4) Reduce verifier kmalloc/kfree churn, from Lorenz.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Edward Cree, John Fastabend, Song Liu, Toke 
Høiland-Jørgensen, Willem de Bruijn, Yonghong Song

----------------------------------------------------------------

The following changes since commit b741596468b010af2846b75f5e75a842ce344a6e:

  Merge tag 'riscv-for-linus-5.13-mw1' of git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux (2021-05-08 11:52:37 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 3a2daa7248647c0e5e165140553f9af5006e93a2:

  bpf: Make some symbols static (2021-05-19 10:47:43 -0700)

----------------------------------------------------------------
Alexei Starovoitov (23):
      Merge branch 'Reduce kmalloc / kfree churn in the verifier'
      bpf: Introduce bpf_sys_bpf() helper and program type.
      bpf: Introduce bpfptr_t user/kernel pointer.
      bpf: Prepare bpf syscall to be used from kernel and user space.
      libbpf: Support for syscall program type
      selftests/bpf: Test for syscall program type
      bpf: Make btf_load command to be bpfptr_t compatible.
      selftests/bpf: Test for btf_load command.
      bpf: Introduce fd_idx
      bpf: Add bpf_btf_find_by_name_kind() helper.
      bpf: Add bpf_sys_close() helper.
      libbpf: Change the order of data and text relocations.
      libbpf: Add bpf_object pointer to kernel_supports().
      libbpf: Preliminary support for fd_idx
      libbpf: Generate loader program out of BPF ELF file.
      libbpf: Cleanup temp FDs when intermediate sys_bpf fails.
      libbpf: Introduce bpf_map__initial_value().
      bpftool: Use syscall/loader program in "prog load" and "gen skeleton" command.
      selftests/bpf: Convert few tests to light skeleton.
      selftests/bpf: Convert atomics test to light skeleton.
      selftests/bpf: Convert test printk to use rodata.
      selftests/bpf: Convert test trace_printk to lskel.
      bpf: Add cmd alias BPF_PROG_RUN

Andrii Nakryiko (9):
      bpftool: Strip const/volatile/restrict modifiers from .bss and .data vars
      libbpf: Add per-file linker opts
      selftests/bpf: Stop using static variables for passing data to/from user-space
      bpftool: Stop emitting static variables in BPF skeleton
      libbpf: Fix ELF symbol visibility update logic
      libbpf: Treat STV_INTERNAL same as STV_HIDDEN for functions
      selftests/bpf: Validate skeleton gen handles skipped fields
      libbpf: Reject static maps
      libbpf: Reject static entry-point BPF programs

Cong Wang (1):
      skmsg: Remove unused parameters of sk_msg_wait_data()

Daniel Borkmann (1):
      Merge branch 'bpf-loader-progs'

Dongseok Yi (1):
      bpf: Check for BPF_F_ADJ_ROOM_FIXED_GSO when bpf_skb_change_proto

Hailong Liu (1):
      samples, bpf: Suppress compiler warning

Kumar Kartikeya Dwivedi (3):
      libbpf: Add various netlink helpers
      libbpf: Add low level TC-BPF management API
      libbpf: Add selftests for TC-BPF management API

Lorenz Bauer (3):
      bpf: verifier: Improve function state reallocation
      bpf: verifier: Use copy_array for jmp_history
      bpf: verifier: Allocate idmap scratch in verifier env

Pu Lehui (1):
      bpf: Make some symbols static

Tiezhu Yang (2):
      bpf, arm64: Replace STACK_ALIGN() with round_up() to align stack size
      bpf, arm64: Remove redundant switch case about BPF_DIV and BPF_MOD

 arch/arm64/net/bpf_jit_comp.c                      |  19 +-
 include/linux/bpf.h                                |  19 +-
 include/linux/bpf_types.h                          |   2 +
 include/linux/bpf_verifier.h                       |   9 +
 include/linux/bpfptr.h                             |  75 +++
 include/linux/btf.h                                |   2 +-
 include/linux/skmsg.h                              |   3 +-
 include/uapi/linux/bpf.h                           |  39 +-
 kernel/bpf/bpf_iter.c                              |  13 +-
 kernel/bpf/btf.c                                   |  70 +-
 kernel/bpf/syscall.c                               | 194 ++++--
 kernel/bpf/verifier.c                              | 345 +++++-----
 net/bpf/test_run.c                                 |  45 +-
 net/core/filter.c                                  |  22 +-
 net/core/skmsg.c                                   |   3 +-
 net/ipv4/tcp_bpf.c                                 |   9 +-
 net/ipv4/udp_bpf.c                                 |   8 +-
 samples/bpf/task_fd_query_user.c                   |   2 +-
 tools/bpf/bpftool/Makefile                         |   2 +-
 tools/bpf/bpftool/gen.c                            | 394 ++++++++++-
 tools/bpf/bpftool/main.c                           |   7 +-
 tools/bpf/bpftool/main.h                           |   1 +
 tools/bpf/bpftool/prog.c                           | 107 ++-
 tools/bpf/bpftool/xlated_dumper.c                  |   3 +
 tools/include/uapi/linux/bpf.h                     |  39 +-
 tools/lib/bpf/Build                                |   2 +-
 tools/lib/bpf/bpf_gen_internal.h                   |  41 ++
 tools/lib/bpf/gen_loader.c                         | 729 +++++++++++++++++++++
 tools/lib/bpf/libbpf.c                             | 427 +++++++++---
 tools/lib/bpf/libbpf.h                             |  67 +-
 tools/lib/bpf/libbpf.map                           |   7 +
 tools/lib/bpf/libbpf_internal.h                    |   2 +
 tools/lib/bpf/linker.c                             |  18 +-
 tools/lib/bpf/netlink.c                            | 568 +++++++++++++---
 tools/lib/bpf/nlattr.h                             |  48 ++
 tools/lib/bpf/skel_internal.h                      | 123 ++++
 tools/testing/selftests/bpf/.gitignore             |   1 +
 tools/testing/selftests/bpf/Makefile               |  16 +-
 tools/testing/selftests/bpf/prog_tests/atomics.c   |  72 +-
 .../selftests/bpf/prog_tests/fentry_fexit.c        |   6 +-
 .../testing/selftests/bpf/prog_tests/fentry_test.c |  10 +-
 .../testing/selftests/bpf/prog_tests/fexit_sleep.c |   6 +-
 .../testing/selftests/bpf/prog_tests/fexit_test.c  |  10 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |   6 +-
 .../selftests/bpf/prog_tests/ksyms_module.c        |   2 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |   8 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   2 +-
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |   6 +-
 .../selftests/bpf/prog_tests/static_linked.c       |   9 +-
 tools/testing/selftests/bpf/prog_tests/syscall.c   |  55 ++
 tools/testing/selftests/bpf/prog_tests/tc_bpf.c    | 395 +++++++++++
 .../selftests/bpf/prog_tests/trace_printk.c        |   5 +-
 .../selftests/bpf/progs/bpf_iter_test_kern4.c      |   4 +-
 tools/testing/selftests/bpf/progs/kfree_skb.c      |   4 +-
 tools/testing/selftests/bpf/progs/linked_maps1.c   |   2 +-
 tools/testing/selftests/bpf/progs/syscall.c        | 121 ++++
 tools/testing/selftests/bpf/progs/tailcall3.c      |   2 +-
 tools/testing/selftests/bpf/progs/tailcall4.c      |   2 +-
 tools/testing/selftests/bpf/progs/tailcall5.c      |   2 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c        |   2 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |   2 +-
 tools/testing/selftests/bpf/progs/test_check_mtu.c |   4 +-
 .../selftests/bpf/progs/test_cls_redirect.c        |   4 +-
 .../selftests/bpf/progs/test_global_func_args.c    |   2 +-
 .../testing/selftests/bpf/progs/test_rdonly_maps.c |   6 +-
 tools/testing/selftests/bpf/progs/test_ringbuf.c   |   4 +-
 tools/testing/selftests/bpf/progs/test_skeleton.c  |   4 +-
 .../selftests/bpf/progs/test_snprintf_single.c     |   2 +-
 .../selftests/bpf/progs/test_sockmap_listen.c      |   4 +-
 .../selftests/bpf/progs/test_static_linked1.c      |  10 +-
 .../selftests/bpf/progs/test_static_linked2.c      |  10 +-
 tools/testing/selftests/bpf/progs/test_subprogs.c  |  13 +
 tools/testing/selftests/bpf/progs/test_tc_bpf.c    |  12 +
 tools/testing/selftests/bpf/progs/trace_printk.c   |   6 +-
 74 files changed, 3717 insertions(+), 578 deletions(-)
 create mode 100644 include/linux/bpfptr.h
 create mode 100644 tools/lib/bpf/bpf_gen_internal.h
 create mode 100644 tools/lib/bpf/gen_loader.c
 create mode 100644 tools/lib/bpf/skel_internal.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/syscall.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/syscall.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c
