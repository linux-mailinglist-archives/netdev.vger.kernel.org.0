Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38DA423FDB
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhJFOMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231600AbhJFOMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C444B6105A;
        Wed,  6 Oct 2021 14:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633529407;
        bh=Uc8Q20VnwsduTfwKM/OouKblxdsH43dSctysbxxvHgQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=deRmKfHTsAW50a/XcgivbYDC3eKZK2zTBYTBWI7vj6bYQ1l5r+1D0WQZk9I2ZmzIu
         68kAL0+DGSy8PNa7q7lwxw++YWLayz7Osqu7LBeNxH83M9R4XOzB1H8gBS207Ek3Lj
         ANYqC1hRbF2UutzL/G5tyinv2FPEYfHfc7qBDzgbJKFRWdnmAyCk1KL+I+j4Yb6ArL
         M5skWTtmEjhRGm5il2NzIt62eO//Tay42z+Jsw0cO/BOCgxLpRf7ciFzPaF7kOhq8W
         HBu2G1ErXbbGxoC9a2juSuMFj66ff9N4aM8RcLNHwzjJlawOk4ARKfuDsK5shA3/7D
         yLOf5yxiSOJww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B24C760971;
        Wed,  6 Oct 2021 14:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/7] A new eBPF JIT implementation for MIPS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163352940772.9599.5939069697064558862.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 14:10:07 +0000
References: <20211005165408.2305108-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20211005165408.2305108-1-johan.almbladh@anyfinetworks.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        paulburton@kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        tsbogend@alpha.franken.de, chenhuacai@kernel.org,
        jiaxun.yang@flygoat.com, yangtiezhu@loongson.cn,
        tony.ambardar@gmail.com, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Tue,  5 Oct 2021 18:54:01 +0200 you wrote:
> This is an implementation of an eBPF JIT for MIPS I-V and MIPS32/64 r1-r6.
> The new JIT is written from scratch, but uses the same overall structure
> as other eBPF JITs.
> 
> Before, the MIPS JIT situation looked like this.
> 
>   - 32-bit: MIPS32, cBPF-only, tests fail
>   - 64-bit: MIPS64r2-r6, eBPF, tests fail, incomplete eBPF ISA support
> 
> [...]

Here is the summary with links:
  - [1/7] MIPS: uasm: Enable muhu opcode for MIPS R6
    https://git.kernel.org/bpf/bpf-next/c/52738ad51026
  - [2/7] mips: uasm: Add workaround for Loongson-2F nop CPU errata
    https://git.kernel.org/bpf/bpf-next/c/be0f00d5a246
  - [3/7] mips: bpf: Add eBPF JIT for 32-bit MIPS
    https://git.kernel.org/bpf/bpf-next/c/88dfe3f95766
  - [4/7] mips: bpf: Add new eBPF JIT for 64-bit MIPS
    https://git.kernel.org/bpf/bpf-next/c/42fb8eacf86e
  - [5/7] mips: bpf: Add JIT workarounds for CPU errata
    https://git.kernel.org/bpf/bpf-next/c/a1db4f358142
  - [6/7] mips: bpf: Enable eBPF JITs
    https://git.kernel.org/bpf/bpf-next/c/6675d4a60007
  - [7/7] mips: bpf: Remove old BPF JIT implementations
    https://git.kernel.org/bpf/bpf-next/c/06b339fe5450

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


