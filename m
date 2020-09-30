Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775B127DFCA
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 07:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgI3FAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 01:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI3FAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 01:00:30 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CDAC061755;
        Tue, 29 Sep 2020 22:00:30 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x16so348513pgj.3;
        Tue, 29 Sep 2020 22:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=76fJrHqswAhsEtCIaA5VQyQXuuOpD7Tb3T3RF+TaEvk=;
        b=uLYx/eVoNtPuRZgFnoNAi17UGkPmDUTFcKprrI5IoNuaZa5vGOkzpRHj72oqk+S4mJ
         1wBw3hMcNAe+CgUvscZbDfGe5RU/t7P1xur0Asmm3TCsuBG1RgzKx+iBcDXAMuTCCr2e
         VF9rfbQNhe3a+vtuTf1XgWAtlHBCcHrHr6LGh6dSGvBbqdeZES7QjphfaXOS9pL1m+Jw
         4rk3/4SFszsLDTJr8tep2XR0mP6b6R8FdEN6iJjrniWsUfaTDHKnCzp3MGS/EOLdnwUH
         YTGJfRkOlQx22z+RZPxWNct+VJZLCqd0jS583nI9ig2wfk3L7imM0Pu/TsfeW5RQcLcq
         Xz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=76fJrHqswAhsEtCIaA5VQyQXuuOpD7Tb3T3RF+TaEvk=;
        b=BeqJR0Iq5QRe2oY8ulppvvABaRclByN/NOxf5kx8w6y9+wz9lPm1AIA8u7QsaRq/4I
         8rBz6I24tpiq8YfhFfaQoCAySqCAMCXLCyj2VSQBzDOx9oUg/y71UXRS6L08Ye/YmvH/
         fMqwgk8stZdCR5U3WiBggEnIvpFn8BMAd1LhIcZiK/h7n2V+cXf9/EUu7Zqv4pYqMp0o
         Ggus3F1jfz1cG60Iwp/RyeasMoNLUeQEvCUFF3F5bbdbaISTptAO8c1ydrek4W1Tgn7j
         88FgShSZlp3EwddhjP+Zlu5uv45iMpWJ7dFGGBhOM7EnKLbj73Ag1m1F0ZTt8zJch3tV
         SkIw==
X-Gm-Message-State: AOAM530q3lm6rosGrQPZ7nr4ITGXy0II+8bHEgpt91p9J8rMBO5MmLsK
        WvPB18HEPo9YefPUT+VfHDk=
X-Google-Smtp-Source: ABdhPJyoSisi/Bpm+JxeLQMDLesNkraHbWz3zFHsTSHaSUohuRYmQvMQ8JhW2duaiaTZzrMH5lNKSA==
X-Received: by 2002:a63:cb08:: with SMTP id p8mr794383pgg.247.1601442029735;
        Tue, 29 Sep 2020 22:00:29 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id f4sm490433pfj.147.2020.09.29.22.00.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 22:00:28 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf 2020-09-29
Date:   Tue, 29 Sep 2020 22:00:27 -0700
Message-Id: <20200930050027.80975-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 7 non-merge commits during the last 14 day(s) which contain
a total of 7 files changed, 28 insertions(+), 8 deletions(-).

The main changes are:

1) fix xdp loading regression in libbpf for old kernels, from Andrii.

2) Do not discard packet when NETDEV_TX_BUSY, from Magnus.

3) Fix corner cases in libbpf related to endianness and kconfig, from Tony.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Arkadiusz Zema, Jesse Brandeburg, John Fastabend, 
Nikita Shirokov, Quentin Monnet, Song Liu, Udip Pant

----------------------------------------------------------------

The following changes since commit d5d325eae7823c85eedabf05f78f9cd574fe832b:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2020-09-15 19:26:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 9cf51446e68607136e42a4e531a30c888c472463:

  bpf, powerpc: Fix misuse of fallthrough in bpf_jit_comp() (2020-09-29 16:39:11 +0200)

----------------------------------------------------------------
Andrii Nakryiko (1):
      libbpf: Fix XDP program load regression for old kernels

He Zhe (1):
      bpf, powerpc: Fix misuse of fallthrough in bpf_jit_comp()

Magnus Karlsson (1):
      xsk: Do not discard packet when NETDEV_TX_BUSY

Tony Ambardar (4):
      tools/bpftool: Support passing BPFTOOL_VERSION to make
      bpf: Fix sysfs export of empty BTF section
      bpf: Prevent .BTF section elimination
      libbpf: Fix native endian assumption when parsing BTF

 arch/powerpc/net/bpf_jit_comp.c   |  1 -
 include/asm-generic/vmlinux.lds.h |  2 +-
 kernel/bpf/sysfs_btf.c            |  6 +++---
 net/xdp/xsk.c                     | 17 ++++++++++++++++-
 tools/bpf/bpftool/Makefile        |  2 +-
 tools/lib/bpf/btf.c               |  6 ++++++
 tools/lib/bpf/libbpf.c            |  2 +-
 7 files changed, 28 insertions(+), 8 deletions(-)
