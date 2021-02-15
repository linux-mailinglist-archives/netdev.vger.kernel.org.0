Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6B931C39A
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhBOVbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:31:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhBOVas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 16:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 078AD64E07;
        Mon, 15 Feb 2021 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613424608;
        bh=KU7mtMzFwOTcQqK6aPw0VOKCIj9JgO5PRHG6hbF7u80=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vLmr6WQ09DYI3FoqIlm8LHwwTQCvHgvSFcHo24Igh/Jyz3Fs/wuwi0Is0e+ame4fq
         f/gSyDo7MdWsu28f9w188JMXrJH4EhAfM0q6X0MjJEVLNG8hGMrddOJj1zwhng+hwj
         o6glrf0omNC9VEpWdfMZRdFd/h2TEaQd8CkSeq8+/GBcN8F9QPwjVYNybHImsESDZT
         hxGWqZUonm9ENmCLowm7EbsMPtxcO3u5ELNXe31gwFNq/xcUJ8moVqU2ih8O53u2PY
         BIC4GMDI/cyrWzCbvNIDHRPXHJ07TIrtzLrAuc9dHL4MPQAVkrT2CMYBQ2H4tVim7U
         yLStBTaY8h/9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EEAC1609EA;
        Mon, 15 Feb 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: tcp_data_ready() must look at SOCK_DONE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342460797.27343.6265387962424885407.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 21:30:07 +0000
References: <20210213142634.3237642-1-eric.dumazet@gmail.com>
In-Reply-To: <20210213142634.3237642-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, weiwan@google.com, arjunroy@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 13 Feb 2021 06:26:34 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> My prior cleanup missed that tcp_data_ready() has to look at SOCK_DONE.
> Otherwise, an application using SO_RCVLOWAT will not get EPOLLIN event
> if a FIN is received in the middle of expected payload.
> 
> The reason SOCK_DONE is not examined in tcp_epollin_ready()
> is that tcp_poll() catches the FIN because tcp_fin()
> is also setting RCV_SHUTDOWN into sk->sk_shutdown
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: tcp_data_ready() must look at SOCK_DONE
    https://git.kernel.org/netdev/net-next/c/39354eb29f59

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


