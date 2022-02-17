Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D854BA910
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 20:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244847AbiBQTAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 14:00:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241661AbiBQTAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 14:00:18 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560696E571;
        Thu, 17 Feb 2022 11:00:03 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso7927193pjs.1;
        Thu, 17 Feb 2022 11:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fT1aBF9CFe4BrljM+7+qgcuxfmHWGRlGo0uG7qxMiDk=;
        b=a6/X8r44OAKpUWk/4OpIVtfhwXS6TBPKSINbR3WCMcEtlQ5S9uoEo9fg5lS/3SgWhs
         4glwVQoejb1MuidXeurciYYv3yv3er1K/PrKt9Ih7qXsVO+4CtotR45gKWVPG6r4o39v
         eMa7ragpEPMKZv+dusw4TUiKVLaETujdfZP1gBvjcbFgGcQ8EDG29B8MZtYhTY5jeMdN
         QuUUv9evz4JYmjA5W2594Z8b41jAjfRy/XYK6/exNBopEYvXb8N7QRXH+mZH6Xwq0Ona
         PhdIxsndxFPBNew3o7WeN/8pZ1gxo/KDWZG9VqbgePivk5rfsfaZQSwZhwgyVpKLnTzs
         Jk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fT1aBF9CFe4BrljM+7+qgcuxfmHWGRlGo0uG7qxMiDk=;
        b=O4f9c4WTNmkKIlCs80ZffCiprUIDtG0cAJ58l/9UilwLqHAU/Y7tStfPhfbPTtYkiO
         KFg8T+qlAqa+Mt4YhELDHM1ZdsyL8i06uyHyylZpYvlBgbn7iptIpMKOG+nO1WgyYjf6
         1tdCmYe6x2uq3yPqU7uNBFim1SbElj5RTCZhL1X0J/CzjK4ZcWxrWVlIUtpVNOAuPUew
         c1MFKLLZeRxTAGQS4dAx2QcN1jQHExxWcjgIMc96BubEVjedGPKVruijQ/xUG93FeoLW
         JiHS9ahUlaUNLd1emaRNNmJuhSGzs2ZneAJaSc/I1IxfhiGyHObgpu6P5gP/O/1uRIbo
         Q1lg==
X-Gm-Message-State: AOAM533a7NLEVtFQIctZV29anr0UTVV3ftYgYQerIIbGk8XfY2JD4OAR
        crMVmWgp0fEj0dJQh9hDiUk=
X-Google-Smtp-Source: ABdhPJzElrfARpuwTl2X09GIuystTSAolhtDv/T6jUObWLrxBuy214d0vYFcMxG2mhxAuuVarUdjHA==
X-Received: by 2002:a17:902:f281:b0:148:b21d:bf92 with SMTP id k1-20020a170902f28100b00148b21dbf92mr3994160plc.16.1645124402694;
        Thu, 17 Feb 2022 11:00:02 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:60c1])
        by smtp.gmail.com with ESMTPSA id l11sm2371372pjm.23.2022.02.17.11.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 11:00:02 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2022-02-17
Date:   Thu, 17 Feb 2022 11:00:00 -0800
Message-Id: <20220217190000.37925-1-alexei.starovoitov@gmail.com>
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

We've added 8 non-merge commits during the last 7 day(s) which contain
a total of 8 files changed, 119 insertions(+), 15 deletions(-).

The main changes are:

1) Add schedule points in map batch ops, from Eric.

2) Fix bpf_msg_push_data with len 0, from Felix.

3) Fix crash due to incorrect copy_map_value, from Kumar.

4) Fix crash due to out of bounds access into reg2btf_ids, from Kumar.

5) Fix a bpf_timer initialization issue with clang, from Yonghong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Brian Vazquez, John Fastabend, Stanislav Fomichev, syzbot, Yonghong Song

----------------------------------------------------------------

The following changes since commit 525de9a79349bd83fe5276d7672f91887f9ee721:

  Merge ra.kernel.org:/pub/scm/linux/kernel/git/netfilter/nf (2022-02-11 11:55:08 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 75134f16e7dd0007aa474b281935c5f42e79f2c8:

  bpf: Add schedule points in batch ops (2022-02-17 10:48:26 -0800)

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'Fix for crash due to overwrite in copy_map_value'
      Merge branch 'bpf: fix a bpf_timer initialization issue'

Eric Dumazet (1):
      bpf: Add schedule points in batch ops

Felix Maurer (2):
      bpf: Do not try bpf_msg_push_data with len 0
      selftests: bpf: Check bpf_msg_push_data return value

Kumar Kartikeya Dwivedi (3):
      bpf: Fix crash due to incorrect copy_map_value
      selftests/bpf: Add test for bpf_timer overwriting crash
      bpf: Fix crash due to out of bounds access into reg2btf_ids.

Yonghong Song (2):
      bpf: Emit bpf_timer in vmlinux BTF
      bpf: Fix a bpf_timer initialization issue

 include/linux/bpf.h                                |  9 ++--
 kernel/bpf/btf.c                                   |  5 +-
 kernel/bpf/helpers.c                               |  2 +
 kernel/bpf/syscall.c                               |  3 ++
 net/core/filter.c                                  |  3 ++
 .../testing/selftests/bpf/prog_tests/timer_crash.c | 32 +++++++++++++
 .../selftests/bpf/progs/test_sockmap_kern.h        | 26 +++++++----
 tools/testing/selftests/bpf/progs/timer_crash.c    | 54 ++++++++++++++++++++++
 8 files changed, 119 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer_crash.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_crash.c
