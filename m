Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF862200D0
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 00:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgGNW6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 18:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbgGNW6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 18:58:10 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF05C061755;
        Tue, 14 Jul 2020 15:58:10 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k5so7675155plk.13;
        Tue, 14 Jul 2020 15:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=I1LTB4/JS87xoaS8Y+5jv1nPacVU0zDKVQnIOq9GqHU=;
        b=PtR/9aDSHRqisXvpz9THPGbPPC/BfqwG9sAMCJsi/2n++OEsTVhngabB/cd0mryk31
         7u71yD3akWQCo3AlmoIQ39eUvMQifVLo96qkut6h4f9MhcRyXVJl1YR1kT/UdKFXHHIs
         +m4wv2rKat2GnFL3+xfKEUFmVK47j9n1A7ca/sL7fflk9O0VErkOxiEiydXNJH8yzsyr
         sZY5PJjqKv2j3q2T/h479etk6ycQlwfExXKs3S/0pDrrqgJ9ZIWhCnKiq1bt/MbSlILH
         Ywn5aQqSjqXPT2FGKZ0jmtAMGZN0OEA/uVXeoe9v3NY2WMSSKG3MyRgiikfNwfXcdtIs
         Z7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I1LTB4/JS87xoaS8Y+5jv1nPacVU0zDKVQnIOq9GqHU=;
        b=eUzZrXf0nUySm18fqRwCv4APPiVmf18eQGlc9WoF3B6k5h4pCPJz3AtW70VhaDKkF6
         ti6Tw+fsbnNHmxH88+SsnUHOJ8a3+qO/U0TYqeL9dnKhlh+jOupHGd9rctW+HfffRRtm
         9O+5YzPX3EkTMp7F4JEi0v3TBYw7TZxyxgRDGfp2R4zoUyFvDFemDwS45aHUbNxuV8Jv
         zBmQt2+PYANXurIU854zclw7dH7CPD0qc1ChxhIa+NfPNPpfQeD1650KlkEiAGRuYqiB
         zNzn2lBv2+2S1aJWcrgNeJCY8Qm7I1kkZjLX9+2tNjVv5IF/Gq0JFd8JlbpOwLyaFyv2
         /PWw==
X-Gm-Message-State: AOAM531yAJAymCb0K+NFSolZ9QJfTerKuW326zy8htHVnO3F8hSFEOKG
        XcZJTdjjb3cruinr3hVpuLM=
X-Google-Smtp-Source: ABdhPJw8KrJYQWlSPhRmaRkpSqu2hgI3oVw9bKxrqOzPKFXKXiU9WQ0D7zHv6HsDceX0FXrAEaxqvw==
X-Received: by 2002:a17:90a:3d0e:: with SMTP id h14mr6525655pjc.184.1594767489640;
        Tue, 14 Jul 2020 15:58:09 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id k189sm181488pfd.175.2020.07.14.15.58.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jul 2020 15:58:08 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf-next 2020-07-14
Date:   Tue, 14 Jul 2020 15:58:07 -0700
Message-Id: <20200714225807.56649-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 21 non-merge commits during the last 1 day(s) which contain
a total of 20 files changed, 308 insertions(+), 279 deletions(-).

The main changes are:

1) Fix selftests/bpf build, from Alexei.

2) Fix resolve_btfids build issues, from Jiri.

3) Pull usermode-driver-cleanup set, from Eric.

4) Two minor fixes to bpfilter, from Alexei and Masahiro.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Christian Brauner, Geert Uytterhoeven, Greg 
Kroah-Hartman, kernel test robot, Michal Kubecek, Stephen Rothwell, 
Tetsuo Handa

----------------------------------------------------------------

The following changes since commit 07dd1b7e68e4b83a1004b14dffd7e142c0bc79bd:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2020-07-13 18:04:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 9326e0f85bfaf0578d40f5357f8143ec857469f5:

  bpfilter: Allow to build bpfilter_umh as a module without static library (2020-07-14 12:37:06 -0700)

----------------------------------------------------------------
Alexei Starovoitov (3):
      selftests/bpf: Fix merge conflict resolution
      Merge branch 'usermode-driver-cleanup' of git://git.kernel.org/.../ebiederm/user-namespace into bpf-next
      bpfilter: Initialize pos variable

Eric W. Biederman (17):
      umh: Capture the pid in umh_pipe_setup
      umh: Move setting PF_UMH into umh_pipe_setup
      umh: Rename the user mode driver helpers for clarity
      umh: Remove call_usermodehelper_setup_file.
      umh: Separate the user mode driver and the user mode helper support
      umd: For clarity rename umh_info umd_info
      umd: Rename umd_info.cmdline umd_info.driver_name
      umd: Transform fork_usermode_blob into fork_usermode_driver
      umh: Stop calling do_execve_file
      exec: Remove do_execve_file
      bpfilter: Move bpfilter_umh back into init data
      umd: Track user space drivers with struct pid
      exit: Factor thread_group_exited out of pidfd_poll
      bpfilter: Take advantage of the facilities of struct pid
      umd: Remove exit_umh
      umd: Stop using split_argv
      Make the user mode driver code a better citizen

Jiri Olsa (2):
      bpf: Fix build for disabled CONFIG_DEBUG_INFO_BTF option
      bpf: Fix cross build for CONFIG_DEBUG_INFO_BTF option

Masahiro Yamada (1):
      bpfilter: Allow to build bpfilter_umh as a module without static library

 fs/exec.c                                          |  38 +----
 include/linux/binfmts.h                            |   1 -
 include/linux/bpfilter.h                           |   7 +-
 include/linux/btf_ids.h                            |  11 +-
 include/linux/sched.h                              |   9 -
 include/linux/sched/signal.h                       |   2 +
 include/linux/umh.h                                |  15 --
 include/linux/usermode_driver.h                    |  18 ++
 kernel/Makefile                                    |   1 +
 kernel/exit.c                                      |  25 ++-
 kernel/fork.c                                      |   6 +-
 kernel/umh.c                                       | 171 +------------------
 kernel/usermode_driver.c                           | 182 +++++++++++++++++++++
 net/bpfilter/Kconfig                               |  10 +-
 net/bpfilter/Makefile                              |   2 +
 net/bpfilter/bpfilter_kern.c                       |  39 ++---
 net/bpfilter/bpfilter_umh_blob.S                   |   2 +-
 net/ipv4/bpfilter/sockopt.c                        |  20 ++-
 tools/bpf/resolve_btfids/Makefile                  |  14 ++
 .../testing/selftests/bpf/progs/bpf_iter_netlink.c |  14 --
 20 files changed, 308 insertions(+), 279 deletions(-)
 create mode 100644 include/linux/usermode_driver.h
 create mode 100644 kernel/usermode_driver.c
