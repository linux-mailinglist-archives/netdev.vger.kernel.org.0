Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A13428E54
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbhJKNmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237303AbhJKNmH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 09:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F2DD76103C;
        Mon, 11 Oct 2021 13:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633959607;
        bh=NzINuQsP248cTKyTh/NZgM1gLfIGv0m4/0Rgctye0Eo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f4BTNO524YTa6Ae9XOyUP2Ks1A0HG73Ie02qBtKNbabftxK1tmIq6x2BGqxiGIu71
         r5HH0MwBCad3a5w13b5Ppe8UastFLlOcboTWJI+R3Ax3M+XVMNNDqPap2U3+rVPrT0
         z+otDrCYcQEDMp0Dh9LJIAIbiPrGa50Bq26f+5hXomPbqD+XXP6+EjLHbp/Fn3Fi7J
         PpNYQ6PScGAq/XeWX8JiJMrngmR1ob7h3x7H6Ni6jtazUHTamJIyqFWcedKM7dRipH
         Fu1l4IKopI+pkbmN6GncMXOIzqGbuZsSSYk86S0roaBQsrG5eW1IlnOVXXq6OI2SA9
         FvZMFxxbMn3iQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E348F6095D;
        Mon, 11 Oct 2021 13:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] bpf, mips: Do some small changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163395960692.3494.2058779549253903670.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Oct 2021 13:40:06 +0000
References: <1633915150-13220-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1633915150-13220-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        tsbogend@alpha.franken.de, johan.almbladh@anyfinetworks.com,
        paulburton@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        lixuefeng@loongson.cn, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 11 Oct 2021 09:19:08 +0800 you wrote:
> This patchset is based on bpf-next tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
> 
> v2:
>   -- Update patch #2 to only fix the comment,
>      suggested by Johan Almbladh, thank you.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] bpf, mips: Clean up config options about JIT
    https://git.kernel.org/bpf/bpf-next/c/307d149d9435
  - [bpf-next,v2,2/2] bpf, mips: Fix comment on tail call count limiting
    https://git.kernel.org/bpf/bpf-next/c/431bfb9ee3e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


