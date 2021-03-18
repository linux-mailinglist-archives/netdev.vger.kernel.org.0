Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402A8340D00
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhCRSav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232357AbhCRSaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:30:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9652E64E81;
        Thu, 18 Mar 2021 18:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616092239;
        bh=MYcIOIV53tQfsnTo1PH/Q9I4grYowZHaaAJzGBbSRGY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fqqAXKyiUqEtZ5vxyYnFWf5Tqpo/6U3grYe7JCDhLiONYdpuUew+afwijR5hd9SdC
         AkWIXfHhr813R1/U8AUFqgUL6kHkhGTK2mm886TiaZYPMBCUm+IQMpLtu/VxIJExtk
         qazuTIrRP/l93TcMf5nuMYffOuhrrGrm/pqBLHdlX7KEVVzAa1EsF22gcfAZ9ykGyO
         g9i0nuPcd4mdxowgLym7J5R8UhDVFzUMYtSl5gCTHPZdptOKzPnKcGkYfH4W/jlw2w
         wQtZNCdhLPBPgohB60wIwgS1EiB6a+b0ypabJjS2eG/FLygjdlFl2vSOFwN7Mt8i8W
         EFd/KMoQNN5ZQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 85AAB60191;
        Thu, 18 Mar 2021 18:30:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: weaken the v4mapped source check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161609223954.5907.2664426590302968288.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 18:30:39 +0000
References: <20210317165515.1914146-1-kuba@kernel.org>
In-Reply-To: <20210317165515.1914146-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        jamorris@linux.microsoft.com, paul@paul-moore.com,
        rdias@singlestore.com, dccp@vger.kernel.org, mptcp@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 17 Mar 2021 09:55:15 -0700 you wrote:
> This reverts commit 6af1799aaf3f1bc8defedddfa00df3192445bbf3.
> 
> Commit 6af1799aaf3f ("ipv6: drop incoming packets having a v4mapped
> source address") introduced an input check against v4mapped addresses.
> Use of such addresses on the wire is indeed questionable and not
> allowed on public Internet. As the commit pointed out
> 
> [...]

Here is the summary with links:
  - [net] ipv6: weaken the v4mapped source check
    https://git.kernel.org/netdev/net/c/dcc32f4f183a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


