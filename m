Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDC344669A
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 17:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhKEQCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 12:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233749AbhKEQCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 12:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 362F86124A;
        Fri,  5 Nov 2021 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636128007;
        bh=4fTRiNDaXgUZHLhG+PBOGZ8SNrobddSUX1b5g8UISsI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jd/1+5qx1YzcvpQLcShIPW5/4yhG3i5AW7cgb9uZwyK+QNucJNMJp3cu4+QdMZkix
         4ULrdCQ+fTj1RUPUOck5m05kchi/WPdRhALG8tR9o7jnyKTDkCZqIRbqf+/DzuJNqh
         qoWRC+W3g49TwC3GfuQ203hsUlcHvaxBkZiv6R5Zy7nVLFaFXzanvlDQFvO8sK0wr2
         GZxELPViAhXKkg6UsdiuqO7a9r0c4UVHs530nb3q2RaCio4jHexmqRRxEAtIH9bgx4
         h3ENNsbgm8mKKRqdLNG0bYeexJ3qmRP4SkaQa2B+CfPCeKt8flYGTWbrNpQm0dlIay
         axbaluvb3Gv6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 26C0960A02;
        Fri,  5 Nov 2021 16:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] riscv, bpf: Fix RV32 broken build,
 and silence RV64 warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163612800715.13450.14251964534648869709.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 16:00:07 +0000
References: <20211103115453.397209-1-bjorn@kernel.org>
In-Reply-To: <20211103115453.397209-1-bjorn@kernel.org>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm5Aa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, tongtiangen@huawei.com, luke.r.nels@gmail.com,
        xi.wang@gmail.com, linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed,  3 Nov 2021 12:54:53 +0100 you wrote:
> Commit 252c765bd764 ("riscv, bpf: Add BPF exception tables") only
> addressed RV64, and broke the RV32 build [1]. Fix by gating the exception
> tables code with CONFIG_ARCH_RV64I.
> 
> Further, silence a "-Wmissing-prototypes" warning [2] in the RV64 BPF
> JIT.
> 
> [...]

Here is the summary with links:
  - [bpf-next] riscv, bpf: Fix RV32 broken build, and silence RV64 warning
    https://git.kernel.org/bpf/bpf/c/f47d4ffe3a84

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


