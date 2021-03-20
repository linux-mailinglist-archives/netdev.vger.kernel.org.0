Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F27342DC9
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 16:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCTPdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 11:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhCTPdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 11:33:09 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33854C061574;
        Sat, 20 Mar 2021 08:33:09 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b184so7979049pfa.11;
        Sat, 20 Mar 2021 08:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=u5bQM0dET0XHH+DjsfWvAVqI7tepR0lEwHfAG7aRgCQ=;
        b=FwXPsADvHcm/f2ssMaTbRWh9czKbUN0UE5Grn4m/d25oaFVgPWRxwpTkEgB+IBnvB0
         LMSBzCEyDQGTqzztOXBqH7DW+Zdd7bYrBaD4tlE3h4la0x5r6j9sBbqXg6iuq1hDYlNA
         S5MxblNVZ2N51NJqJt2qXe1hQPDPxd+ilYHN2vA3TfZZqgiY1Mykr3F7yhzP5zSZu79o
         Q039Jcfyp4siN9j3brRRAq6pH9ikI9YN3GsQrjK2natZVUQPBb7JtYYpr+BOCnX3UBVP
         0OHeetn5qk9K75pYLcpCcROHYZw2kWhvzZC7dRpvrUt8DmwTkANfBDEqiNX8ZhvK+jyM
         /hTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=u5bQM0dET0XHH+DjsfWvAVqI7tepR0lEwHfAG7aRgCQ=;
        b=QAc8B2uLEuE+L7W6PymnIIjX2qzf73FJDmV2N3SlXP8/kHaAWp0+XJVy8prsqNQs17
         1phTLt3I+jtLXzfKv/LMNPtNUO0I3HWe7sFSKASiAZUiQdp4n6xq++Aaee/teH2vsniU
         Y/dsuHrUzxys3wH75DIsXF7MXAWfWjNO7+iR5i1xQl7VdxtFli+tlFnRyV0WszbeNtI3
         9/gJBc7MvVVZ4fS9WEfRFBTHRNLI9BswsNwLrd84iSAYvwtePvjjrQK217Jb/EpcRNJ3
         RYlbTemtGLLIGV6o6QJOWJsRKGCB2PLPL72QITMs9uKEXyqpThHNlAJgB3gPRcaJ8a0Y
         8JDw==
X-Gm-Message-State: AOAM532ImsXYxlpVfvAPeL0ttTsi10wcPzaiSqwBvKAXOAlST/aPB0qa
        t92wdRistqDOFtYY5OP2EhPrEOkBMso=
X-Google-Smtp-Source: ABdhPJxL2Tq6q09AYe9WwiuuG4YjxyOh+yPl9d3mRSUHfy0fa4eqqillzmtO9dmoQHcCgokrKKGwtw==
X-Received: by 2002:a62:683:0:b029:1ec:c88c:8ea2 with SMTP id 125-20020a6206830000b02901ecc88c8ea2mr13739211pfg.27.1616254388746;
        Sat, 20 Mar 2021 08:33:08 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id z25sm8555547pfn.37.2021.03.20.08.33.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Mar 2021 08:33:08 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2021-03-20
Date:   Sat, 20 Mar 2021 08:33:06 -0700
Message-Id: <20210320153306.49142-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 5 non-merge commits during the last 3 day(s) which contain
a total of 8 files changed, 155 insertions(+), 12 deletions(-).

The main changes are:

1) Use correct nops in fexit trampoline, from Stanislav.

2) Fix BTF dump, from Jean-Philippe.

3) Fix umd memory leak, from Zqiang.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:



----------------------------------------------------------------

The following changes since commit e65eaded4cc4de6bf153def9dde6b25392d9a236:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-03-17 18:36:34 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to b9082970478009b778aa9b22d5561eef35b53b63:

  bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG (2021-03-19 19:25:39 -0700)

----------------------------------------------------------------
Alexei Starovoitov (1):
      selftest/bpf: Add a test to check trampoline freeing logic.

Andrii Nakryiko (1):
      Merge branch 'libbpf: Fix BTF dump of pointer-to-array-of-struct'

Jean-Philippe Brucker (2):
      libbpf: Fix BTF dump of pointer-to-array-of-struct
      selftests/bpf: Add selftest for pointer-to-array-of-struct BTF dump

Stanislav Fomichev (1):
      bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG

Zqiang (1):
      bpf: Fix umd memory leak in copy_process()

 arch/x86/net/bpf_jit_comp.c                        |  3 +-
 include/linux/usermode_driver.h                    |  1 +
 kernel/bpf/preload/bpf_preload_kern.c              | 19 +++--
 kernel/usermode_driver.c                           | 21 ++++--
 tools/lib/bpf/btf_dump.c                           |  2 +-
 .../testing/selftests/bpf/prog_tests/fexit_sleep.c | 82 ++++++++++++++++++++++
 .../bpf/progs/btf_dump_test_case_syntax.c          |  8 +++
 tools/testing/selftests/bpf/progs/fexit_sleep.c    | 31 ++++++++
 8 files changed, 155 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_sleep.c
