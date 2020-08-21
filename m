Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D3424E127
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHUTt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgHUTtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 15:49:53 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CFCC061573;
        Fri, 21 Aug 2020 12:49:53 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id v15so1474632pgh.6;
        Fri, 21 Aug 2020 12:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t+7sm0mHNo7Gv1dhkh5jtZsEuL2tQjt9JTREh2yQwvc=;
        b=Ok878LylWS6IlvDYM4/to17YQg5WbsMQkQlXtQIOKCUBN0Jq5lswxZyURhjoX7567p
         xoQBnOlNXLggHLjqEtHt6n9hfHlwzkGu6YfF8BqpUt8DMPxf56n/5emctwPGFEs7lMT0
         5+mDKHWEmPf9A2wiGJJTV/bwYO2MCPTFpck50nhTLbmMpiCzNp56o5ngVb9KOiSDMSsX
         bs9Rlh4dMGX4/U4fCovDxRjN3hBNg1unnsJkKtb+Dqxe3hMp/qaAn4fH9/UwB5hNOi5R
         7dS7YeN0YON0UJ+7DklaVSg01afu5UpO7WH/ZlM7+4BCxmkBSDYW7ZpOzJqOelVQ0jz/
         9QlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t+7sm0mHNo7Gv1dhkh5jtZsEuL2tQjt9JTREh2yQwvc=;
        b=i6IK5X4QG3olwD9vJISa8WIn54xnJbtRgQRPP3qkg5RT9eT+kNOz04Lp2+BN3M6VX+
         GsqWtuUtFSTGZxdDVGNl4mObhb/w+/hpbDZde3RsGvSSzlNFln5renbwvQBKXnsF6QR8
         Gqj2e17yI9QbdzflAt7gGG689GmfRnCY91gAIC8GmtZe7P/YuUbU8WeyUf5iAvXSPTK/
         JB9Z7OpcPpPWzChUJroPiMP31LfJKWORJkl2FqKHLIXr5jJwwv+cqoqbVQ6/tyiJU2jK
         kqAObwvQDQ3WUqVOC5E/3J/3XD9IKt0heFO/kGgRM6ACECHYrrsK89Cy4NM2j23dk359
         ldMQ==
X-Gm-Message-State: AOAM531P+AEyGjB+jYMIDn7qbHceMN63g5qEa8hKEXWgs202UZihsQUd
        YEIPTB/AwgtOmfJEzIMttYa0DQJzums=
X-Google-Smtp-Source: ABdhPJyzrYuGri/Wwkcsqjy1g/k3jJ0JcCALuHmPobk2pg50xI/RxRvag1Fhb/mow1GBFKZCXuZUMg==
X-Received: by 2002:a63:30c2:: with SMTP id w185mr3433008pgw.15.1598039392437;
        Fri, 21 Aug 2020 12:49:52 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id g8sm3106380pfo.132.2020.08.21.12.49.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Aug 2020 12:49:51 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf 2020-08-21
Date:   Fri, 21 Aug 2020 12:49:49 -0700
Message-Id: <20200821194949.71179-1-alexei.starovoitov@gmail.com>
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

We've added 11 non-merge commits during the last 5 day(s) which contain
a total of 12 files changed, 78 insertions(+), 24 deletions(-).

The main changes are:

1) three fixes in BPF task iterator logic, from Yonghong.

2) fix for compressed dwarf sections in vmlinux, from Jiri.

3) fix xdp attach regression, from Andrii.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Jesper Dangaard Brouer, Josef Bacik, Lorenzo Bianconi, 
Yonghong Song

----------------------------------------------------------------

The following changes since commit 7f9bf6e82461b97ce43a912cb4a959c5a41367ac:

  Revert "net: xdp: pull ethernet header off packet after computing skb->protocol" (2020-08-17 11:48:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to b16fc097bc283184cde40e5b30d15705e1590410:

  bpf: Fix two typos in uapi/linux/bpf.h (2020-08-21 12:26:17 -0700)

----------------------------------------------------------------
Andrii Nakryiko (2):
      libbpf: Fix build on ppc64le architecture
      bpf: xdp: Fix XDP mode when no mode flags specified

Jiri Olsa (1):
      tools/resolve_btfids: Fix sections with wrong alignment

Tobias Klauser (1):
      bpf: Fix two typos in uapi/linux/bpf.h

Toke Høiland-Jørgensen (1):
      libbpf: Fix map index used in error message

Veronika Kabatova (1):
      selftests/bpf: Remove test_align leftovers

Yauheni Kaliuta (1):
      bpf: selftests: global_funcs: Check err_str before strstr

Yonghong Song (4):
      bpf: Use get_file_rcu() instead of get_file() for task_file iterator
      bpf: Fix a rcu_sched stall issue with bpf task/task_file iterator
      bpf: Avoid visit same object multiple times
      bpftool: Handle EAGAIN error code properly in pids collection

 include/uapi/linux/bpf.h                           | 10 +++---
 kernel/bpf/bpf_iter.c                              | 15 ++++++++-
 kernel/bpf/task_iter.c                             |  6 ++--
 net/core/dev.c                                     | 14 +++++----
 tools/bpf/bpftool/pids.c                           |  2 ++
 tools/bpf/resolve_btfids/main.c                    | 36 ++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h                     | 10 +++---
 tools/lib/bpf/btf_dump.c                           |  2 +-
 tools/lib/bpf/libbpf.c                             |  2 +-
 tools/testing/selftests/bpf/.gitignore             |  1 -
 tools/testing/selftests/bpf/Makefile               |  2 +-
 .../selftests/bpf/prog_tests/test_global_funcs.c   |  2 +-
 12 files changed, 78 insertions(+), 24 deletions(-)
