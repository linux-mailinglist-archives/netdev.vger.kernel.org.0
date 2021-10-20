Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CC9434273
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 02:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhJTACZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 20:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229955AbhJTACV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 20:02:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 929FC610D0;
        Wed, 20 Oct 2021 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634688007;
        bh=w2LBCF0eDIlvlR185kEKqaplAvG3TUo3Gs/gr5wx1oQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HFkbejn2Je/1S77HvdH5SqBpJPkwV8ZE3kb94M3IkfVi671pw0z0mTUpJpyoAjmTR
         CeUUQpqIe+f9IMbFw2XQdORGPjndzDqHc9o7+gf4cDUa+SVjPjW/R/BaRCMOseUgxu
         iPwargfBKLf4YBGvaVhnfGtEi/XjTRGO9l0b8l/KeIDgDEq7CVF96s+Ix6sdtSYUs2
         cLeF/Tvz2X5t9Y6Tuj69085EUjiSv0Xx5CCGnb7nHSo5oZRwmH7yE9UJWerCu/zZ2o
         b76YdjE/bNvurf+s5DtnMO/06NERoQrNIPcZvhDlHu+3+4TeRWzAxOzMPjVBeRqNTF
         1t2rThY37Uvew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8D7A860A21;
        Wed, 20 Oct 2021 00:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: sched: fixes after recent qdisc->running
 changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163468800757.13259.4143236335575777818.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 00:00:07 +0000
References: <20211019003402.2110017-1-eric.dumazet@gmail.com>
In-Reply-To: <20211019003402.2110017-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 18 Oct 2021 17:34:00 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> First patch fixes a plain bug in qdisc_run_begin().
> Second patch removes a pair of atomic operations, increasing performance.
> 
> Eric Dumazet (2):
>   net: sched: fix logic error in qdisc_run_begin()
>   net: sched: remove one pair of atomic operations
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: sched: fix logic error in qdisc_run_begin()
    https://git.kernel.org/netdev/net-next/c/4c57e2fac41c
  - [net-next,2/2] net: sched: remove one pair of atomic operations
    https://git.kernel.org/netdev/net-next/c/97604c65bcda

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


