Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4EA43DE1A
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 11:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhJ1Jwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 05:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhJ1Jwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 05:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 70F8B610E7;
        Thu, 28 Oct 2021 09:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635414607;
        bh=Pw7f694QeuTBSzXOZY3z4HjgXzZuelwivi3ONEK7jxs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L5X/6fqyCXHyuWi6iq8XjGL0UAyVLCq1a3l2Th/tZqq/NQmhKO1odmS/pPQV8FRwl
         bmRfoEftr0dkayG45C8pLF5U7DqZUAT4RQ1V0mL/pkHG5d1haRCUwj3TBrc63f8WbL
         QS4bz5VSX/HGRw/BMTUqSpWxA8X0zyk1g1HFs2X9waL784SJ+kWZoBVfLGAY0+iRdn
         CeisWhcDq8aT7cjC5X2/R/axGei6YTNEv5lfkZ8SMhyf9mvYXlnz3Ax935G4rdH+mD
         bu214M4K27huGat3K56Yq0bkk1mDqt4z7siy/htDC6qvcCjBvwZNlvxkM2QpDzjkXW
         gnX4IP/8YAG7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6345560A17;
        Thu, 28 Oct 2021 09:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v8] test_bpf: Add module parameter test_suite
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163541460740.23048.1974505348152957386.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 09:50:07 +0000
References: <1635384321-28128-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1635384321-28128-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, lixuefeng@loongson.cn,
        johan.almbladh@anyfinetworks.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 28 Oct 2021 09:25:21 +0800 you wrote:
> After commit 9298e63eafea ("bpf/tests: Add exhaustive tests of ALU
> operand magnitudes"), when modprobe test_bpf.ko with jit on mips64,
> there exists segment fault due to the following reason:
> 
> ALU64_MOV_X: all register value magnitudes jited:1
> Break instruction in kernel code[#1]
> 
> [...]

Here is the summary with links:
  - [bpf-next,v8] test_bpf: Add module parameter test_suite
    https://git.kernel.org/bpf/bpf-next/c/b066abba3ef1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


