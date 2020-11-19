Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36462B9BD3
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 21:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgKSUHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 15:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgKSUHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 15:07:25 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B5EC0613CF;
        Thu, 19 Nov 2020 12:07:24 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y22so3558432plr.6;
        Thu, 19 Nov 2020 12:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Gfttmh/gIY7+5iiEbsGW+i9A/fIfe0uw4/UJbH+DS54=;
        b=pPsM8/Bl2n7F/LWpKXZzLgO1clc07rDL9otkBnbc84LuxD4az5IbbSmYyK5MwUEZXD
         Q6c2imYjMXZLpdE8FMIpUVNA9lITg8GDawFFoWzpXnO/EKB0Wrp7+EQzh3RDnCR5QX7r
         X6NTqxKhe2Sz78IU1+OhcGuMKyG3tZ6eydlY/BNxMmuUofZD6oS8PcMaxp2AB+TlTuAx
         sanjwD1MxPUyyJJpbo9SN/t2jALY+XTNT8cglsUlgqCr4k4IW/CoYTujBaQ5qqBRV8bU
         FGOuMEWiHHsZmIx7p0dzBL7SULyLgpokgHmJs0ENH3aofWlJC6T7FVK0j3ixTkSQydul
         FqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Gfttmh/gIY7+5iiEbsGW+i9A/fIfe0uw4/UJbH+DS54=;
        b=L+k0pdsNlwDQ0mrswnzmFPBb4PlDp9Ji1s9gr3RSvDjWsmnFlfFrhWKyEwF4mMzEq9
         RNUY25jDv441veAFSHB7Eqi+0pyULKtejWLBPh/v/zp4QBD9v3mVn+DaJqJxdnRJ2s0e
         bqzrfBvHV46NWyzEzsFcA12SuI/R8Tk8hi3T3FSVwZv1k42ftvYdARUH7NxEjZ+cyYs2
         +uuSohf4AwcwqU8iewuz0DZCgBlOWHiTM9AasdOC9vkDyN0ytLXcoDA7vku6yTuKbIBK
         R5n0SE6RG6dMCi0GOkLlW6+ZpQQPUOkZTm7WYyxA4KAz6+bZYlli/ZwrsnqConF17x/5
         7pyw==
X-Gm-Message-State: AOAM5325Stt6vWLL0hvSCWI7PZM3Cw2o/WAsdLFW0jtQl5YHp/ZCcW9m
        imCShECDeVf1zmVw7a99A8o=
X-Google-Smtp-Source: ABdhPJzroy0LhNP3O7WiVg+OVIW7P+k1f2nNRblIgWF46yLyMZAB9UcxPyQd4hyvjh4M7R11v3amgQ==
X-Received: by 2002:a17:902:9307:b029:d9:d097:fd6c with SMTP id bc7-20020a1709029307b02900d9d097fd6cmr6945127plb.10.1605816444273;
        Thu, 19 Nov 2020 12:07:24 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id c2sm680298pfb.196.2020.11.19.12.07.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Nov 2020 12:07:23 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf 2020-11-19
Date:   Thu, 19 Nov 2020 12:07:21 -0800
Message-Id: <20201119200721.288-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 18 non-merge commits during the last 12 day(s) which contain
a total of 17 files changed, 301 insertions(+), 49 deletions(-).

The main changes are:

1) libbpf should not attempt to load unused subprogs, from Andrii.

2) Make strncpy_from_user() mask out bytes after NUL terminator, from Daniel.

3) Relax return code check for subprograms in the BPF verifier, from Dmitrii.

4) Fix several sockmap issues, from John.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Dmitrii Banshchikov, Hulk Robot, Jakub Sitnicki, John 
Fastabend, Masami Hiramatsu, Song Liu, Tosk Robot, Yonghong Song

----------------------------------------------------------------

The following changes since commit 4e0396c59559264442963b349ab71f66e471f84d:

  net: marvell: prestera: fix compilation with CONFIG_BRIDGE=m (2020-11-07 12:43:26 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 2801a5da5b25b7af9dd2addd19b2315c02d17b64:

  fail_function: Remove a redundant mutex unlock (2020-11-19 11:58:16 -0800)

----------------------------------------------------------------
Alexei Starovoitov (2):
      MAINTAINERS/bpf: Update Andrii's entry.
      Merge branch 'Fix bpf_probe_read_user_str() overcopying'

Andrii Nakryiko (2):
      libbpf: Don't attempt to load unused subprog as an entry-point BPF program
      selftests/bpf: Fix unused attribute usage in subprogs_unused test

Daniel Xu (2):
      lib/strncpy_from_user.c: Mask out bytes after NUL terminator.
      selftest/bpf: Test bpf_probe_read_user_str() strips trailing bytes after NUL

Dmitrii Banshchikov (1):
      bpf: Relax return code check for subprograms

Jiri Olsa (1):
      libbpf: Fix VERSIONED_SYM_COUNT number parsing

John Fastabend (6):
      bpf, sockmap: Fix partial copy_page_to_iter so progress can still be made
      bpf, sockmap: Ensure SO_RCVBUF memory is observed on ingress redirect
      bpf, sockmap: Use truesize with sk_rmem_schedule()
      bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self
      bpf, sockmap: Handle memory acct if skb_verdict prog redirects to self
      bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list

Kaixu Xia (1):
      bpf: Fix unsigned 'datasec_id' compared with zero in check_pseudo_btf_id

Luo Meng (1):
      fail_function: Remove a redundant mutex unlock

Wang Hai (2):
      tools, bpftool: Add missing close before bpftool net attach exit
      selftests/bpf: Fix error return code in run_getsockopt_test()

Wang Qing (1):
      bpf: Fix passing zero to PTR_ERR() in bpf_btf_printf_prepare

 MAINTAINERS                                        |  2 +-
 kernel/bpf/verifier.c                              | 18 ++++-
 kernel/fail_function.c                             |  5 +-
 kernel/trace/bpf_trace.c                           | 12 ++-
 lib/strncpy_from_user.c                            | 19 ++++-
 net/core/skmsg.c                                   | 87 ++++++++++++++++++----
 net/ipv4/tcp_bpf.c                                 | 18 +++--
 tools/bpf/bpftool/net.c                            | 18 ++---
 tools/lib/bpf/Makefile                             |  2 +
 tools/lib/bpf/libbpf.c                             | 23 +++---
 .../selftests/bpf/prog_tests/probe_read_user_str.c | 71 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockopt_multi.c       |  3 +-
 tools/testing/selftests/bpf/prog_tests/subprogs.c  |  6 ++
 .../selftests/bpf/prog_tests/test_global_funcs.c   |  1 +
 .../selftests/bpf/progs/test_global_func8.c        | 19 +++++
 .../selftests/bpf/progs/test_probe_read_user_str.c | 25 +++++++
 .../selftests/bpf/progs/test_subprogs_unused.c     | 21 ++++++
 17 files changed, 301 insertions(+), 49 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/probe_read_user_str.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func8.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_probe_read_user_str.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subprogs_unused.c
