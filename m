Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD082EE83A
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 23:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbhAGWQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 17:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbhAGWQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 17:16:38 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706BCC0612F4;
        Thu,  7 Jan 2021 14:15:58 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id z21so6258599pgj.4;
        Thu, 07 Jan 2021 14:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=muzyCqDxWf6iO5Bp1ag6MnvxdkXGbtsHtI5XImWpXvw=;
        b=kuai81gEb6RnogRPCRRvdzDjh59GS/D4PwOhSkxxGEwhw12asKoM4tiKSAHTubMND3
         tU44f660mytNDasF6gpUOiPNkvptm1yjHkcRkSaNQ4Jl93Te5tfTYRlKAJiq88sc4aHh
         ncsjZUlkoigtI4/OWW8jKLRUUqIGI/ROJqrGBUwB+hfSZvyS21S3PgiFpxELa8enWc8a
         EGma300/55mtMaqIf+AgTIDjGOpu1IsKgSgYriHWNxl2uqTOk4IgiflqKafGfr3RqzSL
         mlfeDUIKOYvj0ajxGn+ae7/mYwbLW6VGLXJXYFi02DpB02xG8W2NILnC+zyM63x4TIyn
         jHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=muzyCqDxWf6iO5Bp1ag6MnvxdkXGbtsHtI5XImWpXvw=;
        b=dwlRQs7xFMocbmFtRmiS9QH0UTYfKuqPNJ1Z8Ybruuy/Yy1bxGCteW0xcMkpdXhty2
         HmMmxqD3nkymYAeyBfuqfxyXr9smIZAwLbqRM1oboQUhV4DUFHSb1jjB5kyHGsxTj29t
         t6AxSuBCVumkAmfDmdb2JMv1WBi4G7USqJM2yS8LDKMxbeU51Msf8qDp+JcF9noM5MdN
         5RaN7nVL6rpAX7rWigY9ggQNhAJ1MQzaSgb8EN43ZTtLLC2j/fPLeLW12TvQ2Szdkfhy
         7oNDNRPdf8lgKQs+cfCIH6rOY1XxBomuW8MNdy4hG/myUnaiJQC4Amckr28hLYtGtKUf
         rdCQ==
X-Gm-Message-State: AOAM532eqE6/BArDe9Eh4tlsqypWG72YJBPpkGurvhxEJy+0xVgbBZAp
        JBSQLh+qmOnutt1r3dnxq80=
X-Google-Smtp-Source: ABdhPJyv4fVdhfAEAbZd2g2ElnVa0yf845XFFhuh0gmEbzniy9x6MGcVl64fF4DuI3gtmDmcYJ1fhQ==
X-Received: by 2002:a63:5a01:: with SMTP id o1mr3896536pgb.407.1610057758004;
        Thu, 07 Jan 2021 14:15:58 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id x23sm7282093pgk.14.2021.01.07.14.15.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Jan 2021 14:15:57 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2021-01-07
Date:   Thu,  7 Jan 2021 14:15:55 -0800
Message-Id: <20210107221555.64959-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 4 non-merge commits during the last 10 day(s) which contain
a total of 4 files changed, 14 insertions(+), 7 deletions(-).

The main changes are:

1) Fix task_iter bug caused by the merge conflict resolution, from Yonghong.

2) Fix resolve_btfids for multiple type hierarchies, from Jiri.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, John Fastabend, Martin KaFai Lau, Song Liu

----------------------------------------------------------------

The following changes since commit 4bfc4714849d005e6835bcffa3c29ebd6e5ee35d:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2020-12-28 15:26:11 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 6f02b540d7597f357bc6ee711346761045d4e108:

  bpftool: Fix compilation failure for net.o with older glibc (2021-01-06 15:27:38 -0800)

----------------------------------------------------------------
Alan Maguire (1):
      bpftool: Fix compilation failure for net.o with older glibc

Jiang Wang (1):
      selftests/bpf: Fix a compile error for BPF_F_BPRM_SECUREEXEC

Jiri Olsa (1):
      tools/resolve_btfids: Warn when having multiple IDs for single type

Yonghong Song (1):
      bpf: Fix a task_iter bug caused by a merge conflict resolution

 kernel/bpf/task_iter.c                        |  1 +
 tools/bpf/bpftool/net.c                       |  1 -
 tools/bpf/resolve_btfids/main.c               | 17 ++++++++++++-----
 tools/testing/selftests/bpf/progs/bprm_opts.c |  2 +-
 4 files changed, 14 insertions(+), 7 deletions(-)
