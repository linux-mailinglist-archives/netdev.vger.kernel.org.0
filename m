Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E7143D74A
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 01:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhJ0XMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 19:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhJ0XMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 19:12:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E4AE961040;
        Wed, 27 Oct 2021 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635376208;
        bh=TMOjPuBi30omm3OUP+u3FY5YEYx/Fers7Q3speDYL70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ewjnVUVSADGqvovFoOISngvEzer+/1cRAF+JPrAc2UBw+XlZQ6k5ewnNE+OJEorrZ
         RXEPFxuWzxGKGmam8ryq8cDviPzqa52XbanzGmAocOXKT7wHF8WDu36mJQa7RhCTWR
         WaqS2L18p/ZkmiM7OuAWdtrNCAPoQeyudbIIUnH/Y7BlwtxMsFP7NkZUOOM3mPZ0bv
         pW4Ao8tElfgL4SAXIcKU4/PGgsD35EdxX0Iol5yLOQEKhr5TM6VifXE62DaVFUiSqj
         JI11+q1V3r9VKT7TQXMIrKmU7qbmG1+Ly2Sth9Ruq4CXfnh78Myyp5WXgxN8fLzmRl
         tPYednYtvvymA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D3F7F60A17;
        Wed, 27 Oct 2021 23:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next,v3] riscv, bpf: Add BPF exception tables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163537620786.14362.5033693418821355895.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Oct 2021 23:10:07 +0000
References: <20211027111822.3801679-1-tongtiangen@huawei.com>
In-Reply-To: <20211027111822.3801679-1-tongtiangen@huawei.com>
To:     tongtiangen <tongtiangen@huawei.com>
Cc:     paul.walmsley@sifive.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, aou@eecs.berkeley.edu, bjorn@kernel.org,
        luke.r.nels@gmail.com, xi.wang@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 27 Oct 2021 11:18:22 +0000 you wrote:
> When a tracing BPF program attempts to read memory without using the
> bpf_probe_read() helper, the verifier marks the load instruction with
> the BPF_PROBE_MEM flag. Since the riscv JIT does not currently recognize
> this flag it falls back to the interpreter.
> 
> Add support for BPF_PROBE_MEM, by appending an exception table to the
> BPF program. If the load instruction causes a data abort, the fixup
> infrastructure finds the exception table and fixes up the fault, by
> clearing the destination register and jumping over the faulting
> instruction.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3] riscv, bpf: Add BPF exception tables
    https://git.kernel.org/bpf/bpf-next/c/252c765bd764

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


