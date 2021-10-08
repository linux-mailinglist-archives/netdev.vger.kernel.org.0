Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395C7426E68
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 18:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhJHQMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 12:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhJHQMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 12:12:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 49C7661029;
        Fri,  8 Oct 2021 16:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633709407;
        bh=kA8/1ce4Jah4acn0p7FVwwMFZM7nzoML9ozwwVpc/aU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rz+2mAVpUAa1a6sucg88c/NNKtICGteogbH6vPAz5Dt8GTy6Jvnz1H/CPt3QYvCn5
         ZImSCZMd/3Pnuh73ezCjxN8Hs1s1dXgHObauxEZn17Qdx/IHQk5e9t9ONDu+Twj4Px
         4OOm+q58oZcIHzFMbj7ugQ0HnelwV3nNn1ozek0OuS5SFOQ3xHWw600ZqVQPeZ8Dzf
         tzPTvlcprnCc+D4KHweD30JwsCc3RZI2ywlYSKIEjdeJuTAwgGS6wVDeHtdIFG0Bgt
         OUvMMlScywktciuhq1mGsG7sBv2jK3Q6Nubt4VCDk6zgPn0/L+Of+woMPAzxR02oiT
         tR2Z66xI9Yt4Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 40314609EF;
        Fri,  8 Oct 2021 16:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: improved fix wait on already cleared link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370940725.21394.7193784857512460931.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 16:10:07 +0000
References: <20211007141440.316121-1-kgraul@linux.ibm.com>
In-Reply-To: <20211007141440.316121-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 16:14:40 +0200 you wrote:
> Commit 8f3d65c16679 ("net/smc: fix wait on already cleared link")
> introduced link refcounting to avoid waits on already cleared links.
> This patch extents and improves the refcounting to cover all
> remaining possible cases for this kind of error situation.
> 
> Fixes: 15e1b99aadfb ("net/smc: no WR buffer wait for terminating link group")
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net] net/smc: improved fix wait on already cleared link
    https://git.kernel.org/netdev/net/c/95f7f3e7dc6b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


