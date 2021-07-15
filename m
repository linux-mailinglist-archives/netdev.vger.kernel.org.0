Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896E03CAE14
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 22:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237791AbhGOUnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 16:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236182AbhGOUnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 16:43:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F2431613D4;
        Thu, 15 Jul 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626381608;
        bh=MzasXOfHjzlMXG327ziDG8NyTnBNbxuqmgzDJKDUSZM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DFoZXqfXuZCr4LIv4GT2c0Yr6BfFwZyengDgWaVz9wZTlOPgqdZ5wxM41UamMgsp9
         CaISHQwOn5FKVvlgF1/oyRix1eZw8M0HGSvXW9bM41NtDZzmuuDpaTr/eSgSDRL2r1
         RSI24TjxvsL9kEp+GM+gm3r6chCjfkY9Pm3++zCJiD/7z5bDlftQ5WcU3O126INkyZ
         XFPbwQfAORek5+89sUv6ZqDHbPG9+DWwqEOxpYPvQaF4T02h40QFMv/7q1EU5GPuFw
         txNRJ8MikOKduSdrhLSgyoR1bksO1HP8pcg3vQTqsoKb1PKP51YvXj5kY3ZFBDLh8/
         HmYBm9caFsbTA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E45A1609B8;
        Thu, 15 Jul 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 bpf-next 00/11] bpf: Introduce BPF timers.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162638160793.17206.8466927115509819243.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 20:40:07 +0000
References: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 14 Jul 2021 17:54:06 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The first request to support timers in bpf was made in 2013 before sys_bpf syscall
> was added. That use case was periodic sampling. It was address with attaching
> bpf programs to perf_events. Then during XDP development the timers were requested
> to do garbage collection and health checks. They were worked around by implementing
> timers in user space and triggering progs with BPF_PROG_RUN command.
> The user space timers and perf_event+bpf timers are not armed by the bpf program.
> They're done asynchronously vs program execution. The XDP program cannot send a
> packet and arm the timer at the same time. The tracing prog cannot record an
> event and arm the timer right away. This large class of use cases remained
> unaddressed. The jiffy based and hrtimer based timers are essential part of the
> kernel development and with this patch set the hrtimer based timers will be
> available to bpf programs.
> 
> [...]

Here is the summary with links:
  - [v7,bpf-next,01/11] bpf: Prepare bpf_prog_put() to be called from irq context.
    https://git.kernel.org/bpf/bpf-next/c/d809e134be7a
  - [v7,bpf-next,02/11] bpf: Factor out bpf_spin_lock into helpers.
    https://git.kernel.org/bpf/bpf-next/c/c1b3fed319d3
  - [v7,bpf-next,03/11] bpf: Introduce bpf timers.
    https://git.kernel.org/bpf/bpf-next/c/b00628b1c7d5
  - [v7,bpf-next,04/11] bpf: Add map side support for bpf timers.
    https://git.kernel.org/bpf/bpf-next/c/68134668c17f
  - [v7,bpf-next,05/11] bpf: Prevent pointer mismatch in bpf_timer_init.
    https://git.kernel.org/bpf/bpf-next/c/3e8ce29850f1
  - [v7,bpf-next,06/11] bpf: Remember BTF of inner maps.
    https://git.kernel.org/bpf/bpf-next/c/40ec00abf1cc
  - [v7,bpf-next,07/11] bpf: Relax verifier recursion check.
    https://git.kernel.org/bpf/bpf-next/c/86fc6ee6e246
  - [v7,bpf-next,08/11] bpf: Implement verifier support for validation of async callbacks.
    https://git.kernel.org/bpf/bpf-next/c/bfc6bb74e4f1
  - [v7,bpf-next,09/11] bpf: Teach stack depth check about async callbacks.
    https://git.kernel.org/bpf/bpf-next/c/7ddc80a476c2
  - [v7,bpf-next,10/11] selftests/bpf: Add bpf_timer test.
    https://git.kernel.org/bpf/bpf-next/c/3540f7c6b96a
  - [v7,bpf-next,11/11] selftests/bpf: Add a test with bpf_timer in inner map.
    https://git.kernel.org/bpf/bpf-next/c/61f71e746c72

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


