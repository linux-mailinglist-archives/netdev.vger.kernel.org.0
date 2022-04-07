Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8934F72B8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 05:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbiDGDOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 23:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239821AbiDGDOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 23:14:46 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0CA2296F4;
        Wed,  6 Apr 2022 20:12:47 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c23so3753150plo.0;
        Wed, 06 Apr 2022 20:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bMRlXp+1H6vxnCjSCNskJ7yVWM8QGfvwnrKf2El1BUY=;
        b=mo3l3D7a7GdIo/GMKuQboNdvSaP8f1xLpd8WbjZ6DrmyQO3YM3Zd/WQac02cWs6OZN
         6JEeTWGoZ2UzcLT1vUSaL4sAuLoTpzKlDVL7+gNj2VyulpP8QuWbMRVPSxBF2kgEep5M
         0uJJiZ1/OvaJNIwgMFGl3idnI8kPUW/9D6M2GPtzzdoBfjto0RgdULghfbb3qspNd4dq
         1q3F3fzsCJKdywCkXL+n0JPiycx8gp1RGWVFC5KTyeVPAsLMr6k51b82/MQi8V0voccD
         ZDsbMoRHhIzW8/qtonTf9iIc3/dT2lxANLmWA45CCaxH3fmR7RhAR3GhoD+RffHdTnvf
         n5IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bMRlXp+1H6vxnCjSCNskJ7yVWM8QGfvwnrKf2El1BUY=;
        b=dldjVK0XL+c9zVaPm0bVFQl52um6uoJQk6kYD/f8MtGMQZOoCRcin/+T5PKGkESthU
         +lR9Bh9KWqY/wVqHkq36fXceUaUB5oi9ro5JXLZUcwsUFgTx/nDbVmuMI1WFUBhsnzbt
         ISNAdYwbrNeFKeUV/harNwEYr7+njmDHDAiTbk6NOg7NAu+vUCc6gWMJWT7njGC2jLX1
         osGGdOI1snEgrg1EkVF6Fkw0/3LQGbDhcu8AbdXJ7HjRTgC805VjoP0hn06iw5H9QTLR
         fYehrKucFN/ZVzER5HVip1JOXGeCI3bmvlLJmw9Wx1Fka30LU7aU61BcqWZPQSw4A0X8
         O4xQ==
X-Gm-Message-State: AOAM530VQxP7T1u4ci6M4DB/TyuSQhamXPidqq8l3IXatGfXIxyAKozd
        DimP8IPNcLn5T/WKy5EWrxE=
X-Google-Smtp-Source: ABdhPJx/xM+bv5xIAi68KVSiQROVcbVggo/IZuLxJY3TB/uUTWi3aKpzzU9A77YkkkKJc6tJAfA+PA==
X-Received: by 2002:a17:90a:7403:b0:1ca:7de0:8cf9 with SMTP id a3-20020a17090a740300b001ca7de08cf9mr13525900pjg.74.1649301167283;
        Wed, 06 Apr 2022 20:12:47 -0700 (PDT)
Received: from ast-mbp.lan ([2603:3023:16e:5000:1c05:63fe:2a0d:fa56])
        by smtp.gmail.com with ESMTPSA id u18-20020a056a00125200b004fb112ee9b7sm18630353pfi.75.2022.04.06.20.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 20:12:46 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2022-04-06
Date:   Wed,  6 Apr 2022 20:12:45 -0700
Message-Id: <20220407031245.73026-1-alexei.starovoitov@gmail.com>
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

We've added 8 non-merge commits during the last 8 day(s) which contain
a total of 9 files changed, 139 insertions(+), 36 deletions(-).

The main changes are:

1) rethook related fixed, from Jiri and Masami.

2) Fix the case when tracing bpf prog is attached to struct_ops, from Martin. 

3) Support dual-stack sockets in bpf_tcp_check_syncookie, from Maxim.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Arthur Fabre, Jakub Kicinski, Tariq Toukan, Yonghong 
Song

----------------------------------------------------------------

The following changes since commit 77c9387c0c5bd496fba3200024e3618356b2fd34:

  Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2022-03-29 18:59:15 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 53968dafc4a6061c1e01d884f1f9a4b8c4b0d5bc:

  bpf: Adjust bpf_tcp_check_syncookie selftest to test dual-stack sockets (2022-04-06 09:44:45 -0700)

----------------------------------------------------------------
Delyan Kratunov (1):
      bpftool: Explicit errno handling in skeletons

Haowen Bai (1):
      selftests/bpf: Fix warning comparing pointer to 0

Jiri Olsa (1):
      bpf: Fix sparse warnings in kprobe_multi_resolve_syms

Martin KaFai Lau (2):
      bpf: Resolve to prog->aux->dst_prog->type only for BPF_PROG_TYPE_EXT
      bpf: selftests: Test fentry tracing a struct_ops program

Masami Hiramatsu (1):
      rethook: Fix to use WRITE_ONCE() for rethook:: Handler

Maxim Mikityanskiy (2):
      bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
      bpf: Adjust bpf_tcp_check_syncookie selftest to test dual-stack sockets

 include/linux/bpf_verifier.h                       |  4 +-
 kernel/trace/bpf_trace.c                           |  4 +-
 kernel/trace/rethook.c                             |  2 +-
 net/core/filter.c                                  | 17 +++--
 tools/bpf/bpftool/gen.c                            | 22 ++++--
 .../selftests/bpf/prog_tests/dummy_st_ops.c        | 23 +++++++
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |  4 +-
 .../selftests/bpf/progs/trace_dummy_st_ops.c       | 21 ++++++
 .../selftests/bpf/test_tcp_check_syncookie_user.c  | 78 ++++++++++++++++------
 9 files changed, 139 insertions(+), 36 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/trace_dummy_st_ops.c
