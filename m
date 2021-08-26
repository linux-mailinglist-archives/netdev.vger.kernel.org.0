Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1BC3F8B33
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 17:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242940AbhHZPiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 11:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhHZPiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 11:38:10 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CFDC061757;
        Thu, 26 Aug 2021 08:37:22 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id m4so2083515pll.0;
        Thu, 26 Aug 2021 08:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+WQVTJMp4/lY9tXT/37JtI4x17PgCvtnvWjLaN+DyR8=;
        b=qzWaX8t87xLnHXVmg01/m362oDMxu+6iHgBr9QChhXAZHeRQESJfETp2PzwMyrniSX
         1pslx3ALLCCbH3ldNLT08g++vl0xTZFHabTn68+d8UvgPaE6vDNEBieWHRn3qW/LVTv4
         jtSB5F8DiBjG+baupAljfk40ISe12h1hsmynNsFde7jbQKCugwW3RCN//mWo28PmPoX/
         UCq3/Axym9UKVDD6PwXrBASGneqVKQEG6MbP+JeVJC1fHnWp3ZMPNqcndgfk5RMMXQ5F
         EJByQFAS1Xl3Q7+45zVxKqYkmCRW2hBJlc/EFngjFu/ZL21Nk4wWU0zzBnQ8YtndBL4o
         bxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+WQVTJMp4/lY9tXT/37JtI4x17PgCvtnvWjLaN+DyR8=;
        b=Jp7vvW8tHy1UCpWz0FVU4j/vI8XqtsmvkBgKuqUIxn/E82LKl0OwN4fZ+6x0m3/F8b
         QNyLSN6we7BlhWZwjEaKHyrhWZCGtq8GRtxxpok/rN6D1WQaREWeLpDqA6dlGmoFC6Ob
         0As8LoLekhFp+3oLL7LUmFnBpJPnmezByUm+mHHrQVnhqkKAwRV6qet+P7Hp6PxtbYZ2
         S7fqeY752xEy5vAwPyNeZLz8U4k39M6vMZXPylJ1VP//e/jTMvy74Ajk1qIuE/NOMVbe
         e46wQfO47Qa+vhD54LgtehYXa+drVznd5MSYMUo4SE1Ej3ABa1/8XBCaqjG0csiBGkkN
         AiXA==
X-Gm-Message-State: AOAM531eQTgmpt4K5KeRUcY0I0EHoNPbOsn3/nAK9WfuxnpdIZ5+3VUd
        z8/5Llw3/TlZQdOKZAFWzOlXBI85D/o=
X-Google-Smtp-Source: ABdhPJxjkNCf/4fyclchItZwKZf2D0VO80Dfm4b0/3oLlSc9mPu8NhAmNAIc3X8Sd5SvXsxYMhMegA==
X-Received: by 2002:a17:902:7585:b0:135:2585:e261 with SMTP id j5-20020a170902758500b001352585e261mr4199899pll.21.1629992242192;
        Thu, 26 Aug 2021 08:37:22 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:500::5:2fa])
        by smtp.gmail.com with ESMTPSA id y23sm2915874pfe.129.2021.08.26.08.37.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Aug 2021 08:37:21 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2021-08-26
Date:   Thu, 26 Aug 2021 08:37:20 -0700
Message-Id: <20210826153720.19083-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 1 non-merge commits during the last 1 day(s) which contain
a total of.

The main changes are:

1) Fix ringbuf helper function compatibility, from Daniel.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Ryota Shiga (Flatt Security)

----------------------------------------------------------------

The following changes since commit 82a44ae113b7b35850f4542f0443fcab221e376a:

  net: stmmac: fix kernel panic due to NULL pointer dereference of plat->est (2021-08-23 11:49:34 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 5b029a32cfe4600f5e10e36b41778506b90fd4de:

  bpf: Fix ringbuf helper function compatibility (2021-08-23 23:09:10 +0200)

----------------------------------------------------------------
Daniel Borkmann (1):
      bpf: Fix ringbuf helper function compatibility

 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)
