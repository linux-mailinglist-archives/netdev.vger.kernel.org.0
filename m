Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1245531206B
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 00:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhBFXUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 18:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFXUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 18:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 524E664DEC;
        Sat,  6 Feb 2021 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612653607;
        bh=KegevARzGrHrcZRLO4h8YJqx2O9MnH7drGWI6tqEGrg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TwzHEt2PF4jZRuum1pqbEPqB7/1iN3p6Fz62IE97ivvZ5HJq6oXxEmfCCLrk7NH4o
         qfayMkzIRxWVEBTrULRXH6knyndLfclAp/d9TrIYTpo96XwIUK7k13sntb/OYVLXbw
         mC5J27xS/4tufBihgTKllt1bt5aQGrkN5OjJ/gXDqoNECoeTF771zikh/0rmmiuJyX
         RzN/MI5tljv9h8ubzUInwVvVIk+5kxGvx3MKB753pbLojYn9373EMpTWBafGd0ROd0
         Lzb+9MomFtBN2+0sx7MNK0vEPX0TXC2nkcdDqyAXLgPA9xys8zPX+QLvJIo1we56lo
         FzoVLxPmwNCXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 44C6060978;
        Sat,  6 Feb 2021 23:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V1 0/1] Fix XDP bug in ENA driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161265360727.24915.5321563165626171204.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 23:20:07 +0000
References: <20210205195114.10007-1-shayagr@amazon.com>
In-Reply-To: <20210205195114.10007-1-shayagr@amazon.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, gtzalik@amazon.com, netanel@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, akiyano@amazon.com,
        sameehj@amazon.com, ndagan@amazon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 5 Feb 2021 21:51:13 +0200 you wrote:
> Hi all,
> This single patch fixes a bug spotted in previous XDP Redirect implementation in
> ENA.
> 
> Shay Agroskin (1):
>   net: ena: Update XDP verdict upon failure
> 
> [...]

Here is the summary with links:
  - [net,V1,1/1] net: ena: Update XDP verdict upon failure
    https://git.kernel.org/netdev/net/c/225353c070fd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


