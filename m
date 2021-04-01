Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F96F352385
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbhDAXZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbhDAXZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 19:25:01 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9BBC0613E6;
        Thu,  1 Apr 2021 16:25:00 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id l123so998051pfl.8;
        Thu, 01 Apr 2021 16:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z9jDpo3Dv8A1ssqGBQ26R0URdA4xsS6oorbUrQmwzJI=;
        b=rLl+yRFBZz9hOSeL2/G3tPMmZ463v7VDc/vlNwGQUtzZMUvZOdt5XI6jYPKcCD9Qcg
         tYUe8+EGU02CkWkNxVPuJekv5VYvrMJVq//BVSc8x3jJpa74yY5NJiIgqSGXQ0JG+O2k
         ueej4PS+6k4xVA0NG5TC7+B6vnzxQHSz3udifbjk9N0vGmkLYU4RwT9kVQex3KykNlBU
         ad4MUoZNM8M3gbTnoMSUZLGaDb4gJMj19Wizi7rD2FYvIPiXIPe7DR3uQuxkxqg9slQH
         cHzQjtQhH2EUEBecZJCT0NX0lc9DgydK7isYuIh6wFfGHa75FdH6/9gg+SN9brjWhryk
         YNSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z9jDpo3Dv8A1ssqGBQ26R0URdA4xsS6oorbUrQmwzJI=;
        b=UK6HxsQCTEtMqLixwKGf74fOIfWEu7rFP9CpIMxvcgxUgkTlSB7kEukho0M7EyiY/h
         YjGjS2Z4OnXA/Z/iMslo6wcUV2qTZPWBB5X3byiQ86YBxj+M82HaG2VqO8W6XKqIlTir
         KKik6XK/pCf7hArgx5vQxYhFu36JOS9Fewq3opsoR9Y1PKCeixXeYRMJSWJDAkw0MM8n
         AI2NSDWFvqlItTDl/bMEF6q8QyepL3g5SjdE6iQgcDS4REFbQmaKaGrMFCRLOXQG7lLL
         cGmhRDeMQnzpTOOJDRIhGBW7PXS47NepndxN7CHxnu1LVR66+7g3R4h0JCoeLpykCE9S
         gIzw==
X-Gm-Message-State: AOAM532jhQZ51Alk+p1X1RpDEjpAnJQ79+XHsnj3BNgBvzCau1XR8KBW
        7BnJIbOu9yU1717vSgc1Qh81pJCCyh4=
X-Google-Smtp-Source: ABdhPJz5bMNyrrN4/VqGwEs8LKwHN7Npu6hMgviJ+IzFh5jkAtUpAPUWRVprrA7kKPxE0kZbqr8lKg==
X-Received: by 2002:a63:5a55:: with SMTP id k21mr9465667pgm.312.1617319499766;
        Thu, 01 Apr 2021 16:24:59 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id p25sm6496208pfe.100.2021.04.01.16.24.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Apr 2021 16:24:59 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2021-04-01
Date:   Thu,  1 Apr 2021 16:24:57 -0700
Message-Id: <20210401232457.64488-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 11 non-merge commits during the last 8 day(s) which contain
a total of 10 files changed, 151 insertions(+), 26 deletions(-).

The main changes are:

1) xsk creation fixes, from Ciara.

2) bpf_get_task_stack fix, from Dave.

3) trampoline in modules fix, from Jiri.

4) bpf_obj_get fix for links and progs, from Lorenz.

5) struct_ops progs must be gpl compatible fix, from Toke.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Brendan Jackman, Daniel Borkmann, Magnus Karlsson, 
Martin KaFai Lau, Song Liu

----------------------------------------------------------------

The following changes since commit 002322402dafd846c424ffa9240a937f49b48c42:

  Merge branch 'akpm' (patches from Andrew) (2021-03-25 11:43:43 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 6dcc4e38386950abf9060784631622dfc4df9577:

  Merge branch 'AF_XDP Socket Creation Fixes' (2021-04-01 14:45:52 -0700)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'AF_XDP Socket Creation Fixes'

Ciara Loftus (3):
      libbpf: Ensure umem pointer is non-NULL before dereferencing
      libbpf: Restore umem state after socket create failure
      libbpf: Only create rx and tx XDP rings when necessary

Dave Marchevsky (1):
      bpf: Refcount task stack in bpf_get_task_stack

Jiri Olsa (1):
      bpf: Take module reference for trampoline in module

Lorenz Bauer (2):
      bpf: link: Refuse non-O_RDWR flags in BPF_OBJ_GET
      bpf: program: Refuse non-O_RDWR flags in BPF_OBJ_GET

Pedro Tammela (1):
      libbpf: Fix bail out from 'ringbuf_process_ring()' on error

Toke Høiland-Jørgensen (2):
      bpf: Enforce that struct_ops programs be GPL-only
      bpf/selftests: Test that kernel rejects a TCP CC with an invalid license

Xu Kuohai (1):
      bpf: Fix a spelling typo in bpf_atomic_alu_string disasm

 include/linux/bpf.h                                |  2 +
 kernel/bpf/disasm.c                                |  2 +-
 kernel/bpf/inode.c                                 |  4 +-
 kernel/bpf/stackmap.c                              | 12 ++++-
 kernel/bpf/trampoline.c                            | 30 ++++++++++++
 kernel/bpf/verifier.c                              |  5 ++
 tools/lib/bpf/ringbuf.c                            |  2 +-
 tools/lib/bpf/xsk.c                                | 57 ++++++++++++++--------
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  | 44 +++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_tcp_nogpl.c  | 19 ++++++++
 10 files changed, 151 insertions(+), 26 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_tcp_nogpl.c
