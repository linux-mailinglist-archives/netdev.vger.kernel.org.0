Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD1E3E58BF
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbhHJLAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239968AbhHJLAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:00:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B039361051;
        Tue, 10 Aug 2021 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628593208;
        bh=ka7esywCDSl8n32QaZDLHiNZ5b3roQvqKrZzIfHpWG8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mnd9Gwbj+V32Ac2pmoQlVlSIGPwMOPukFDQn8jNkp63SAuS0B5WElTLMRoK6k424i
         OXBFerujyghvM3HaYp8kNSYVzbN5zDE838LdjMBJD5t3DfYICoeILCR+aSVPiKkUty
         cJdxoB4QTmi5z3ocKo/QLkQwlzNSj5ut5WiuEzfMagwM0tC4x+XVrIxbY0Qj+Zvudc
         YVlAVLnrWrEi/C+3hQu0U7dMRKD/D3Yb3OlHTNnGUo7s306NCM7tOkl+as+f6Jdjfx
         3frSKf9jYRdHvNrmO6AAVChbY7lcvpHxvOy4PpeBFqGRVbb48xcBKt4LZNQSw8+nPr
         Ae4+AQKyfXUEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB01860A3B;
        Tue, 10 Aug 2021 11:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: igmp: fix data-race in igmp_ifc_timer_expire()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162859320869.31319.7144625605190527566.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 11:00:08 +0000
References: <20210810094547.1851947-1-eric.dumazet@gmail.com>
In-Reply-To: <20210810094547.1851947-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 10 Aug 2021 02:45:47 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Fix the data-race reported by syzbot [1]
> Issue here is that igmp_ifc_timer_expire() can update in_dev->mr_ifc_count
> while another change just occured from another context.
> 
> in_dev->mr_ifc_count is only 8bit wide, so the race had little
> consequences.
> 
> [...]

Here is the summary with links:
  - [net] net: igmp: fix data-race in igmp_ifc_timer_expire()
    https://git.kernel.org/netdev/net/c/4a2b285e7e10

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


