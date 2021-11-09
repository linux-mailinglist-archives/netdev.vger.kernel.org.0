Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0858144B504
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 22:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhKIV7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 16:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhKIV7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 16:59:51 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156C0C061764;
        Tue,  9 Nov 2021 13:57:05 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id m26so698013pff.3;
        Tue, 09 Nov 2021 13:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k9Z+sxZ8cbNEXb8/B3sXJMj8knOd6u4n6TtYUs3qnxg=;
        b=PJF+Ks5irbYO1NgayTm5OXtGzzYkemzEVWsifCh+O0To5s2KVFBB7yFGbfoPNHwGnY
         17Ji8SKhq25yv11XhkPxQyh6SaKkRJwvoJd5ILLJSG+TJvnumYUQowtYnLl6q1DVBe6s
         MKEZi+Z1etVwr9WV+dTP8O3TKNbKs+WsXQjdAwOSUjLFfK2mrgke+jqSmWjlWgIaP57j
         Pa0wQ+QBzOqKj36egOaiZPLg9gt3KaAM98Wp/Xu4LHoKnX8ItN12dts1SHGo6G7cJSQA
         2yW1QLXWmnGFD6grhZlhKqT/VmCIKDK3eGOJZy66+88weTwB94efAT62PmS3FXYBcnAx
         mLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k9Z+sxZ8cbNEXb8/B3sXJMj8knOd6u4n6TtYUs3qnxg=;
        b=zzASw6iJHrKmtegJufDibrvGiEclSOqFvziOASutuXn34WTIWrd4fsrVmVtHum5+UJ
         I8xDzRQE2LINu97tA2bP79IGX9+4h0p4RGSZNQi0SB54jalgHNQS1jQEoNPIxnQ4WLPI
         CSqogq8UIMGeMiAQHaB9SOKhIJjTafkO96jMKKlwIRBEKJLvJLQbVGctJZ/PRxa74JpD
         ie8SFhQyDY1nw9ghvmv9FOYWaRZFqtBdHYUdcod4m06SVHo7hSOTB5hd1WNNBXt15weK
         03LZmurGpklLE3myIRajkidD2iRXw7/6Cv46jHTD/q9X8QOs2m2eXQOGdZDMEB8yU9oz
         oIvg==
X-Gm-Message-State: AOAM5324XXv1XjAbnT/tq+puWeT931PIY78TQKNtdS8uz19dyl2+Cz5k
        KuIo/SLLhOaoZuALhnzhyFM=
X-Google-Smtp-Source: ABdhPJwUMD2l0P46ZSvvWIO5fjoEEXDwwZw33NFIBBpadNa/0pPdTe+h3/y9MveVCGORu1yXJs4sMw==
X-Received: by 2002:a63:fd43:: with SMTP id m3mr8440743pgj.355.1636495024516;
        Tue, 09 Nov 2021 13:57:04 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:f8f1])
        by smtp.gmail.com with ESMTPSA id c3sm7007095pfm.177.2021.11.09.13.57.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Nov 2021 13:57:04 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2021-11-09
Date:   Tue,  9 Nov 2021 13:57:02 -0800
Message-Id: <20211109215702.38350-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 7 non-merge commits during the last 3 day(s) which contain
a total of 10 files changed, 174 insertions(+), 48 deletions(-).

The main changes are:

1) Various sockmap fixes, from John and Jussi.

2) Fix out-of-bound issue with bpf_pseudo_func, from Martin.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Jakub Sitnicki, Jussi Maki

----------------------------------------------------------------

The following changes since commit 70bf363d7adb3a428773bc905011d0ff923ba747:

  ipv6: remove useless assignment to newinet in tcp_v6_syn_recv_sock() (2021-11-05 19:49:40 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to b2c4618162ec615a15883a804cce7e27afecfa58:

  bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg (2021-11-09 01:05:34 +0100)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'bpf: Fix out-of-bound issue when jit-ing bpf_pseudo_func'

John Fastabend (4):
      bpf, sockmap: Use stricter sk state checks in sk_lookup_assign
      bpf, sockmap: Remove unhash handler for BPF sockmap usage
      bpf, sockmap: Fix race in ingress receive verdict with redirect to self
      bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and colliding

Jussi Maki (1):
      bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg

Martin KaFai Lau (2):
      bpf: Stop caching subprog index in the bpf_pseudo_func insn
      bpf: selftest: Trigger a DCE on the whole subprog

 include/linux/bpf.h                                |  6 ++
 include/linux/skmsg.h                              | 12 ++++
 include/net/strparser.h                            | 20 ++++++-
 kernel/bpf/core.c                                  |  7 +++
 kernel/bpf/verifier.c                              | 37 +++++--------
 net/core/filter.c                                  | 64 +++++++++++++++++++---
 net/core/sock_map.c                                |  6 --
 net/ipv4/tcp_bpf.c                                 | 48 +++++++++++++++-
 net/strparser/strparser.c                          | 10 +---
 .../selftests/bpf/progs/for_each_array_map_elem.c  | 12 ++++
 10 files changed, 174 insertions(+), 48 deletions(-)
