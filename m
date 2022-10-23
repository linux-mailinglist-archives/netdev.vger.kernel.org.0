Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320436095CD
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 21:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiJWTWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 15:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJWTWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 15:22:52 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24C567171;
        Sun, 23 Oct 2022 12:22:50 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id jo13so3205436plb.13;
        Sun, 23 Oct 2022 12:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NjXLsW45XIKhsmmKtd6rJwffqnWIuYRgp9eF1wVUbyo=;
        b=TxY/RLHEGdSbDBvNQJuZ27WyOQ74wl2rlTbNQ6RjUfW7gpCR7RUhnla8SpsEyJGi7d
         7xkucRQn7v/TwZCmy5aifSNG1fmtkmb9fK7c+nQ7r0KwWvZmWKADY7vnd1hOrV/DQIt8
         zjexggJhPOCrWvhflEOYCg19DpaLU5nRWsjtN5M39UQ6B41CLQjA5NIUYpXM9Ky2YZS1
         qOi4Fev/8XeAtwy72hYMeQL9Vk9gr/ubSvyRND81NMrExv83EgkECf9udlmyVnFa/ert
         pXuSY/lckUxki9PFVG1zgXb0HFDdrWhsF1vV2k/vZIPHuCWYHx0hvxQCmUlVzsndMz4z
         7zSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NjXLsW45XIKhsmmKtd6rJwffqnWIuYRgp9eF1wVUbyo=;
        b=iQHDcP2XlxEmk//ucwt0q50LojP1iNgs1ZACV6Yjw2YMfsUcFqIvctGT/vmjWW9051
         SnaL/1MqpJsGH9gLg0SpZOPirAzIfOmwyrk7nDQgxMIp/+JnsdNJqr/orWkm9hRZeroF
         pE75rE362xUGzBRxa5HTCl+0K5sRxDCxCI0BkkFSM7ZZ6Z0b9vm895scXUhg0RbYnclY
         bfrLXRApqq61LYy6DrlbTslFet2AFe4hEQhhtYcUOcgvoq8WT24wm6Hq0oI0YtUqKciz
         Wu3NAEgrPrtT/qMeOHlqEelDphHAb/0hiImILtxDNRrEZ+ENY7xxoJMDQB5cr/tClcGM
         9cWQ==
X-Gm-Message-State: ACrzQf0sx5RESEZdsmMD7/l86te6EgdSew8+jaND42h1UBDdloZ/ZUWZ
        2YJiVLTG8BBHflUv0dFZrFg=
X-Google-Smtp-Source: AMsMyM6qbsKIVYbXfGCN5UI+lH19SsoNIlJ2EDLb0dRk2+Hm7MrV/ezcFFf1A1UcGCph7fXbWfF2Xg==
X-Received: by 2002:a17:902:f681:b0:186:aab2:2168 with SMTP id l1-20020a170902f68100b00186aab22168mr1490104plg.62.1666552970046;
        Sun, 23 Oct 2022 12:22:50 -0700 (PDT)
Received: from macbook-pro-4.dhcp.thefacebook.com.com ([2620:10d:c090:400::5:2848])
        by smtp.gmail.com with ESMTPSA id r4-20020a170902be0400b00176ca089a7csm18299876pls.165.2022.10.23.12.22.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 23 Oct 2022 12:22:49 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kafai@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2022-10-23
Date:   Sun, 23 Oct 2022 12:22:44 -0700
Message-Id: <20221023192244.81137-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 7 non-merge commits during the last 18 day(s) which contain
a total of 8 files changed, 69 insertions(+), 5 deletions(-).

The main changes are:

1) Wait for busy refill_work when destroying bpf memory allocator, from Hou.

2) Allow bpf_user_ringbuf_drain() callbacks to return 1, from David.

3) Fix dispatcher patchable function entry to 5 bytes nop, from Jiri.

4) Prevent decl_tag from being referenced in func_proto, from Stanislav.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Peter Zijlstra (Intel), Stanislav Fomichev, Yonghong Song

----------------------------------------------------------------

The following changes since commit 0326074ff4652329f2a1a9c8685104576bd8d131:

  Merge tag 'net-next-6.1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-10-04 13:38:03 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git for-netdev

for you to fetch changes up to bed54aeb6ac1ced7e0ea27a82ee52af856610ff0:

  Merge branch 'Wait for busy refill_work when destroying bpf memory allocator' (2022-10-21 19:17:38 -0700)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'Wait for busy refill_work when destroying bpf memory allocator'

Andrii Nakryiko (1):
      Merge branch 'Allow bpf_user_ringbuf_drain() callbacks to return 1'

David Vernet (2):
      bpf: Allow bpf_user_ringbuf_drain() callbacks to return 1
      selftests/bpf: Make bpf_user_ringbuf_drain() selftest callback return 1

Hou Tao (2):
      bpf: Wait for busy refill_work when destroying bpf memory allocator
      bpf: Use __llist_del_all() whenever possbile during memory draining

Jiri Olsa (1):
      bpf: Fix dispatcher patchable function entry to 5 bytes nop

Stanislav Fomichev (2):
      selftests/bpf: Add reproducer for decl_tag in func_proto return type
      bpf: prevent decl_tag from being referenced in func_proto

 arch/x86/net/bpf_jit_comp.c                            | 13 +++++++++++++
 include/linux/bpf.h                                    | 14 +++++++++++++-
 kernel/bpf/btf.c                                       |  5 +++++
 kernel/bpf/dispatcher.c                                |  6 ++++++
 kernel/bpf/memalloc.c                                  | 18 ++++++++++++++++--
 kernel/bpf/verifier.c                                  |  1 +
 tools/testing/selftests/bpf/prog_tests/btf.c           | 13 +++++++++++++
 .../testing/selftests/bpf/progs/user_ringbuf_success.c |  4 ++--
 8 files changed, 69 insertions(+), 5 deletions(-)
