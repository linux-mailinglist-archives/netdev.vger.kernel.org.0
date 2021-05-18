Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD8A387BAB
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243460AbhEROv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 10:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235434AbhEROv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 10:51:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 43E63610CB;
        Tue, 18 May 2021 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621349410;
        bh=HN6Pc+SQl6MLK8JVm8vu72quXqoZp76gf5cDJSqraU4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iSNKnYqaTMdKgFqoRGxY2ZepR+xyOonrrdXPt2a2UNXGM3C1tSztYOJQ8VzSq4w9y
         Im9MCGytoqgdgDS5cVF9VaPt8r6hAmhBN7TTyGZt8OPFLEPCOn1m3hLCYnXnToumB0
         PH7XmboUxLiwpFebI/4ITc/lyjDzvWiSh5szBK6mf6CEZr9469fyMq5kbyXwlSAzLY
         CKfxRmNDsJXn7R08zs9EEModIfHcSm894Dx4YV5ZL4MAG6fbbt0L65XHMxBawE3+ZL
         PjyGBj7Rxdk+F04UZB3Eiha3tGMuMGaObn0yDNXWNZk0coFfLyv1+b0h4ZLcSfuq6L
         01wBQXED3qZnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3642760A47;
        Tue, 18 May 2021 14:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf,
 arm64: Remove redundant switch case about BPF_DIV and BPF_MOD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162134941021.29155.11583425930314810514.git-patchwork-notify@kernel.org>
Date:   Tue, 18 May 2021 14:50:10 +0000
References: <1621328170-17583-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1621328170-17583-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     daniel@iogearbox.net, ast@kernel.org, zlim.lnx@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        lixuefeng@loongson.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 18 May 2021 16:56:10 +0800 you wrote:
> After commit 96a71005bdcb ("bpf, arm64: remove obsolete exception handling
> from div/mod"), there is no need to check twice about BPF_DIV and BPF_MOD,
> remove the redundant switch case.
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  arch/arm64/net/bpf_jit_comp.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)

Here is the summary with links:
  - [bpf-next] bpf, arm64: Remove redundant switch case about BPF_DIV and BPF_MOD
    https://git.kernel.org/bpf/bpf-next/c/119220d81258

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


