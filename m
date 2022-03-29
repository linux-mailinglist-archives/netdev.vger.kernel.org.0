Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF084EB703
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 01:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239866AbiC2XvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 19:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241163AbiC2XvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 19:51:18 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0622204AB3;
        Tue, 29 Mar 2022 16:49:27 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c23so19063686plo.0;
        Tue, 29 Mar 2022 16:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aZ5ipX+0UXNiVk+c0PgmLprk82TH5gX5s9mJGZEZ42w=;
        b=h9HCcvK7Hovk4JdTzWAloEhT/S5hLgFBucwyVRP/3N9d4dMAzpxN1yq+mtlxQ5W5ex
         LbhcSQUQzfxNhCSIat+t0gQKAyNs9HpdE69I468g+AopO83pcwQR5KaKA6SbiKLChfwh
         X1uQ+2xPUAgPc4RGg+cL8o7XN+7YZUEe75z6cmk7cT+jyp8YaYWylzn5TG4HcljUOeUK
         ioC5Oz7+PV+o4m6/ZaIN+dMi2XYvC6Dw4gQ5cx4ruIWthe5tIol3RFxQ25wmEeXbeYVT
         aPVChSlEqAa4SKiKo0SYUq+91I9bSd4PChbsWJxSTxR7KLIacCmYFRwTjWWXWFKvHtsA
         ezeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aZ5ipX+0UXNiVk+c0PgmLprk82TH5gX5s9mJGZEZ42w=;
        b=ngvGHFF9cOXlPHLd5mQk7tSVu/lA7329zN8tEw4bLQKuiPp4EL+qmcWq+DFjrMSOzl
         YgxLQekBm9tdCJ+5KsrT6DiXkIMjsnS5T7joiWgAjx3tA8/H55GpJTCV/xntLDL85eVx
         KPbADewjsiC+4+KGjwxospfnJoaE/pwhjX6O6SP78w23+nIEHi/cMf4CsR9HJLD7ikpT
         HTmGUy32i1FGv11sHm1Or9cKzvrWPQOPIf2lH0KTx5lK102Bzt6s5b1PltNR6IraiEy1
         0p/0lsyi2hptbI4FNKTLtrpGr005Y2i4MGJnnPoILRsAITX9iIzRd4mVC0FIPUYC4Dqq
         hgFA==
X-Gm-Message-State: AOAM531NdziOFSsscqs0GAaotZbmDaECnmTCn+ormJHFQw78besIBOkg
        smq5ZurNZ0lRMm1k4ucGKLA=
X-Google-Smtp-Source: ABdhPJxKJHpZiJzxngILtgxnQWNfaCEVhYjuG52n17RqyHtQ5ISDzOCIsqRBPvU2mfhEdvvN2aHa5Q==
X-Received: by 2002:a17:90b:1e0e:b0:1c7:5b03:1d8b with SMTP id pg14-20020a17090b1e0e00b001c75b031d8bmr1690233pjb.121.1648597767263;
        Tue, 29 Mar 2022 16:49:27 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:f900])
        by smtp.gmail.com with ESMTPSA id p11-20020a17090a4f0b00b001c6e4898a36sm3989100pjh.28.2022.03.29.16.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 16:49:26 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, peterz@infradead.org, mhiramat@kernel.org,
        kuba@kernel.org, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2022-03-29
Date:   Tue, 29 Mar 2022 16:49:24 -0700
Message-Id: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 16 non-merge commits during the last 1 day(s) which contain
a total of 24 files changed, 354 insertions(+), 187 deletions(-).

The main changes are:

1) x86 specific bits of fprobe/rethook, from Masami and Peter.

2) ice/xsk fixes, from Maciej and Magnus.

3) Various small fixes, from Andrii, Yonghong, Geliang and others.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Arnaldo Carvalho de Melo, Dan Carpenter, Jiri Olsa, kernel test robot, 
KP Singh, Martin KaFai Lau, Masami Hiramatsu, Quentin Monnet, Yonghong 
Song

----------------------------------------------------------------

The following changes since commit d717e4cae0fe77e10a27e8545a967b8c379873ac:

  Merge tag 'net-5.18-rc0' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-03-28 17:02:04 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to ccaff3d56acc47c257a99b2807b7c78a9467cf09:

  selftests/bpf: Fix clang compilation errors (2022-03-28 20:00:11 -0700)

----------------------------------------------------------------
Alexei Starovoitov (3):
      Merge branch 'fprobe: Fixes for Sparse and Smatch warnings'
      Merge branch 'kprobes: rethook: x86: Replace kretprobe trampoline with rethook'
      Merge branch 'xsk: another round of fixes'

Andrii Nakryiko (1):
      selftests/bpf: fix selftest after random: Urandom_read tracepoint removal

Geliang Tang (1):
      bpf: Sync comments for bpf_get_stack

Jiri Olsa (1):
      bpftool: Fix generated code in codegen_asserts

Maciej Fijalkowski (2):
      ice: xsk: Stop Rx processing when ntc catches ntu
      ice: xsk: Fix indexing in ice_tx_xsk_pool()

Magnus Karlsson (2):
      xsk: Do not write NULL in SW ring at allocation failure
      ice: xsk: Eliminate unnecessary loop iteration

Masami Hiramatsu (5):
      fprobe: Fix smatch type mismatch warning
      fprobe: Fix sparse warning for acccessing __rcu ftrace_hash
      kprobes: Use rethook for kretprobe if possible
      x86,rethook,kprobes: Replace kretprobe with rethook on x86
      x86,kprobes: Fix optprobe trampoline to generate complete pt_regs

Milan Landaverde (1):
      bpf/bpftool: Add unprivileged_bpf_disabled check against value of 2

Peter Zijlstra (1):
      x86,rethook: Fix arch_rethook_trampoline() to generate a complete pt_regs

Yonghong Song (1):
      selftests/bpf: Fix clang compilation errors

Yuntao Wang (1):
      bpf: Fix maximum permitted number of arguments check

 arch/Kconfig                                       |   8 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/include/asm/unwind.h                      |  23 ++--
 arch/x86/kernel/Makefile                           |   1 +
 arch/x86/kernel/kprobes/common.h                   |   1 +
 arch/x86/kernel/kprobes/core.c                     | 107 -----------------
 arch/x86/kernel/kprobes/opt.c                      |  25 ++--
 arch/x86/kernel/rethook.c                          | 127 +++++++++++++++++++++
 arch/x86/kernel/unwind_orc.c                       |  10 +-
 drivers/net/ethernet/intel/ice/ice.h               |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   5 +-
 include/linux/kprobes.h                            |  51 ++++++++-
 kernel/Makefile                                    |   1 +
 kernel/bpf/btf.c                                   |   2 +-
 kernel/kprobes.c                                   | 124 ++++++++++++++++----
 kernel/trace/fprobe.c                              |   8 +-
 kernel/trace/trace_kprobe.c                        |   4 +-
 net/xdp/xsk_buff_pool.c                            |   8 +-
 tools/bpf/bpftool/feature.c                        |   5 +-
 tools/bpf/bpftool/gen.c                            |   2 +-
 tools/include/uapi/linux/bpf.h                     |   8 +-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |   3 -
 .../selftests/bpf/progs/test_stacktrace_build_id.c |  12 +-
 tools/testing/selftests/bpf/test_lpm_map.c         |   3 +-
 24 files changed, 354 insertions(+), 187 deletions(-)
 create mode 100644 arch/x86/kernel/rethook.c
