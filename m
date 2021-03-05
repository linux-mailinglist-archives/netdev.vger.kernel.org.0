Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E163932E021
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhCEDeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEDeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:34:01 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31DFC061574;
        Thu,  4 Mar 2021 19:34:01 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z5so686641plg.3;
        Thu, 04 Mar 2021 19:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yBS4aCo0I+bU55qHxLOS1mj4pllC3okpIwJhgJL4Plw=;
        b=p21Bz4HKZ2zBk8lQxNO4sNygJJPpxJRdTNLWQ53RTssDWAkhVaBeOMnB3iKv1wCqO+
         w59wY2NtqqnEHxR3fWATK1Cj5SQS7AJnGJRY86UyYscNjP9klPlJcOUNk6uJomv9qox+
         jEUg2iuT2d1CjcxDO/ilCcVWNzSGPnJtxH6gAKqmw8Xw1ERZJOvAcThZ+RyDlE/6e0l8
         ANyCH+wMO2izLzgJ9I6wCo0WIwNzhSqcLCy1LWUDiuMIj07NXLm9onfNMjMyrIwuSybi
         Gkk6MSxgoOofZf32eOgIRdn90FxIGdohHcxVKLvO6Wl+a5j6NiCqHUuBDxhpEn1QkAxF
         ZwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yBS4aCo0I+bU55qHxLOS1mj4pllC3okpIwJhgJL4Plw=;
        b=ehfNDQSIp0WsKXHRG3yFf+KTHgMiiuzfkvAOVSCHvVHDX4ekVADjJoVEPps0dJObhi
         +38iGQrkCailuZ3M2ZxUbR+U8tRCr9z9dJgwaWT7zTfBQm2jydVBTUR6XuPwMS3dnAYZ
         kBjmF8lJYaTryh+Ly0PRS9qlY1y0Z+YtH2GZxaFBNamyykaIeb6FSPGVYx3wRLaWk8X5
         isAW7e87W0PTBIi1xpCqkljOyLVuzyXQ3OIhsrw5W2XoALep2vo9TrAjyhm1YQBhH72M
         MTREztqLNLHAo26BkukmhEara/WwiGW5X7TCFqQs3Hwe6tYGmfK7Lo0s3KqKsLR/DwJ7
         Kc3A==
X-Gm-Message-State: AOAM532rxmRkiWnz7lKTNEa/1W/rMr06NDUXkRv8lOcU1UilbVBHcRZ1
        EIdIWmT7OjRoqBJIVKnkw2M=
X-Google-Smtp-Source: ABdhPJwYdSKcghZsoTB0+qeAi4A5GLyRgObMkM+w0AORhLPxrxbG+7O4+xIdE5jHnuHSMvH34UTG0A==
X-Received: by 2002:a17:902:ea12:b029:e3:1b24:414f with SMTP id s18-20020a170902ea12b02900e31b24414fmr6748431plg.13.1614915240977;
        Thu, 04 Mar 2021 19:34:00 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id n4sm561837pjf.52.2021.03.04.19.33.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Mar 2021 19:34:00 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2021-03-04
Date:   Thu,  4 Mar 2021 19:33:58 -0800
Message-Id: <20210305033358.69322-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 7 non-merge commits during the last 4 day(s) which contain
a total of 9 files changed, 128 insertions(+), 40 deletions(-).

The main changes are:

1) Fix 32-bit cmpxchg, from Brendan.

2) Fix atomic+fetch logic, from Ilya.

3) Fix usage of bpf_csum_diff in selftests, from Yauheni.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Björn Töpel, Brendan Jackman, Heiko Carstens, Ilya Leoshkevich, Martin 
KaFai Lau, Yonghong Song

----------------------------------------------------------------

The following changes since commit 8811f4a9836e31c14ecdf79d9f3cb7c5d463265d:

  tcp: add sanity tests to TCP_QUEUE_SEQ (2021-03-01 15:32:05 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 39491867ace594b4912c35f576864d204beed2b3:

  bpf: Explicitly zero-extend R0 after 32-bit cmpxchg (2021-03-04 19:06:03 -0800)

----------------------------------------------------------------
Brendan Jackman (1):
      bpf: Explicitly zero-extend R0 after 32-bit cmpxchg

Ilya Leoshkevich (2):
      selftests/bpf: Use the last page in test_snprintf_btf on s390
      bpf: Account for BPF_FETCH in insn_has_def32()

Maciej Fijalkowski (3):
      xsk: Remove dangling function declaration from header file
      samples, bpf: Add missing munmap in xdpsock
      libbpf: Clear map_info before each bpf_obj_get_info_by_fd

Yauheni Kaliuta (1):
      selftests/bpf: Mask bpf_csum_diff() return value to 16 bits in test_verifier

 include/linux/netdevice.h                          |  2 -
 kernel/bpf/core.c                                  |  4 +
 kernel/bpf/verifier.c                              | 89 ++++++++++++++--------
 samples/bpf/xdpsock_user.c                         |  2 +
 tools/lib/bpf/xsk.c                                |  5 +-
 .../selftests/bpf/progs/netif_receive_skb.c        | 13 +++-
 .../testing/selftests/bpf/verifier/array_access.c  |  3 +-
 .../selftests/bpf/verifier/atomic_cmpxchg.c        | 25 ++++++
 tools/testing/selftests/bpf/verifier/atomic_or.c   | 25 ++++++
 9 files changed, 128 insertions(+), 40 deletions(-)
