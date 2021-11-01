Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CB0441DFD
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhKAQWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232692AbhKAQWm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 12:22:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BA7716115B;
        Mon,  1 Nov 2021 16:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635783608;
        bh=hUZM1gaPOjZAlPgpNZ5sCi4NaVWCN9ntfJOsTV3J2Aw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G1J6hxyOhppDDNCQOAkMSfAexH9U0Srb9rS4GlBN/44v1hcO7AfPbtoiNaiorSV9C
         jXiDnOGPH84mVVXoDsNoYVGtpUZ6UbenFstv8ejJJdvgz3UKDL8mZny/aJrLeu6Dvj
         CwchYAx65f1Lo/gUEV4Sn7mEgTT+bSBZ/feSqkW36+bq/uDl0dGyPBUCXYwIny+R18
         JSxgBGq5SLfEdetLbALwpzRNlkYoI2WXsAj8bfUoEgkeG7pH5EDbmaDk92EQWw1V9W
         Og5/Q9/KI3ysZd69NIDItaeXzAcWrV48lgKUcwVWm5SSZHIcpxndwV0VblwTX4n4ql
         u7kR2w6ZLuOVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AD27B60A0F;
        Mon,  1 Nov 2021 16:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/4] Various RISC-V BPF improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163578360870.18867.4815897974014023266.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 16:20:08 +0000
References: <20211028161057.520552-1-bjorn@kernel.org>
In-Reply-To: <20211028161057.520552-1-bjorn@kernel.org>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm5Aa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, luke.r.nels@gmail.com, xi.wang@gmail.com,
        linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 28 Oct 2021 18:10:53 +0200 you wrote:
> Unfortunately selftest/bpf does not build for RV64. This series fixes
> that.
> 
> * JIT requires more iterations to converge
> * Some Makefile issues
> * bpf_tracing.h was missing RISC-V macros for PT_REGS
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/4] riscv, bpf: Increase the maximum number of iterations
    https://git.kernel.org/bpf/bpf-next/c/4b54214f39ff
  - [bpf-next,v2,2/4] tools build: Add RISC-V to HOSTARCH parsing
    https://git.kernel.org/bpf/bpf-next/c/b390d69831ee
  - [bpf-next,v2,3/4] riscv, libbpf: Add RISC-V (RV64) support to bpf_tracing.h
    https://git.kernel.org/bpf/bpf-next/c/589fed479ba1
  - [bpf-next,v2,4/4] selftests/bpf: Fix broken riscv build
    https://git.kernel.org/bpf/bpf-next/c/36e70b9b06bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


