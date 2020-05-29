Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1721E1E892A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgE2UrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbgE2UrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 16:47:21 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5523C03E969;
        Fri, 29 May 2020 13:47:19 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 5so1967103pjd.0;
        Fri, 29 May 2020 13:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UfBjq9NVVBXNQcLvC21xkTDtN251+GrKOe/Yhp2Ygbc=;
        b=Y0fsjJAMS/WsaQcnabrx0jq0ZP/8J0Ms8Zxe5bGChCZOurbtM1pRSxydmgohI3GPh2
         V8bvutq3T5OjFXEl10Rx9gTxNFLFfSsrz0gH7II1y4pbnrDr+L5xS8exQh1riTsYuouk
         YhDITX5fedqCzXsA1sfY+1WvqBa/z279vfY4r2Qp2z2f96xtMubAHzDWCBHrKkyD8MFO
         C98moVpA7wDqw9/zNLMcuDpoyASfoA0sZTFyYzRzCDrcV725p3AOnwDWmqdnqhWbW2qC
         tMeVueJNr0J1yYRQXVC2zPeZxy76RXTnqw8fWNkafoLE8G5dWF6LqjOTO41bPwynKGrx
         W7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UfBjq9NVVBXNQcLvC21xkTDtN251+GrKOe/Yhp2Ygbc=;
        b=cdAJIXXGvwzXoBuad5tRd8MDwDK5snFoaXqLPIrLAd/jLtwQtwaglJROwwq0pQfDDe
         /cQ+pXEJaYowWs/yaaAbMKzQkzJC1MzZbOiNkKT2xIGMGlgn3AcH8bCJy3ZAG/3auHfp
         shcusNpVsigiYUCs2ILaCArd3hhNqHJ75uBp5708ekZ8mCWueYMJ33SLX5NFJcpnKaSe
         RCdZqpSehf5vMM4SfQZK1t88KmdwoE8GHyQVFQGGuHCuUle1mX8sV3mXEFUMgc1vVWaq
         3ZDZzw+BlnBkFYTk5FU6jSEqNsoEVny5WEVXufw6qfLlcTNpfsRWQvLbBp9gWz0BHO7P
         BtnA==
X-Gm-Message-State: AOAM530s9lCMZ8gta+1RLFuq6XloQL3mPBjQnzdJXFz9nvtfg/S1X8Ha
        Da5a7HapDJv82ZZA8FTlIn0vGZ8d
X-Google-Smtp-Source: ABdhPJzHf39EqrkSQt+0DerGkGcRlQqRFSiek7jXMiXsGM5SdYf0OPt7Ho2TQHaKdgE7U64wkBO0jg==
X-Received: by 2002:a17:90a:f292:: with SMTP id fs18mr10935319pjb.37.1590785239354;
        Fri, 29 May 2020 13:47:19 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id n205sm8287687pfd.50.2020.05.29.13.47.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 May 2020 13:47:18 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf 2020-05-29
Date:   Fri, 29 May 2020 13:47:16 -0700
Message-Id: <20200529204716.32393-1-alexei.starovoitov@gmail.com>
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

We've added 6 non-merge commits during the last 7 day(s) which contain
a total of 4 files changed, 55 insertions(+), 34 deletions(-).

The main changes are:

1) minor verifier fix for fmod_ret progs, from Alexei.

2) af_xdp overflow check, from Bjorn.

3) minor verifier fix for 32bit assignment, from John.

4) powerpc has non-overlapping addr space, from Petr.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Jonathan Lemon, KP Singh, Michael Ellerman, "Minh Bùi Quang", Yonghong 
Song

----------------------------------------------------------------

The following changes since commit d04322a0da1e86aedaa322ce933cfb8c0191d1eb:

  Merge tag 'rxrpc-fixes-20200523-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs (2020-05-22 16:43:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to cf66c29bd7534813d2e1971fab71e25fe87c7e0a:

  bpf, selftests: Add a verifier test for assigning 32bit reg states to 64bit ones (2020-05-29 13:34:06 -0700)

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf: Fix use-after-free in fmod_ret check

Björn Töpel (1):
      xsk: Add overflow check for u64 division, stored into u32

John Fastabend (3):
      bpf: Fix a verifier issue when assigning 32bit reg states to 64bit ones
      bpf, selftests: Verifier bounds tests need to be updated
      bpf, selftests: Add a verifier test for assigning 32bit reg states to 64bit ones

Petr Mladek (1):
      powerpc/bpf: Enable bpf_probe_read{, str}() on powerpc again

 arch/powerpc/Kconfig                          |  1 +
 kernel/bpf/verifier.c                         | 34 ++++++++++----------
 net/xdp/xdp_umem.c                            |  8 +++--
 tools/testing/selftests/bpf/verifier/bounds.c | 46 +++++++++++++++++++--------
 4 files changed, 55 insertions(+), 34 deletions(-)
