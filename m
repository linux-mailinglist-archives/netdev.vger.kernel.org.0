Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A903C35FCB0
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244237AbhDNUaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243606AbhDNUax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:30:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 09F4661158;
        Wed, 14 Apr 2021 20:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618432231;
        bh=4VlWWU3GEqpQ+16K3t4rxpIwr6vGs5Jm6GP8EGgY0lw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XWiy9Z8BvZrU9TmJGhnafUP+S0JjjDG/0ftC4H8FLI2jLNJ+8zpfQ+viOBv0aCWGC
         RkBM9kq9alJJwy7Jzu9O8sMVCSfzfDbaSWdA/UwE/GO5Bo6/NYzpytgtM9zFPjR3si
         5DzXhlKZCDI5ek6jAIPPf8MHxF5tmF1mK3jWjzX8DooAe+XZldZpG0dmNhMbPQcAYv
         gXG4BeTsv5xQEWm8rfP0hoT1dlCz4Y3TppM8SRvKkgEOlEHbbTE5d9cZrGejzn4Rqa
         O1+CzjTClT2OacjgcrRowDXT4jU6NgcXj3k20IF5HbKJfm1X6813SzdvrmfWVc16mj
         SuOgxsHeoj/JA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F128760CD2;
        Wed, 14 Apr 2021 20:30:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net-next): ipsec-next 2021-04-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843223098.20162.9825806188391299525.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 20:30:30 +0000
References: <20210414101701.324777-1-steffen.klassert@secunet.com>
In-Reply-To: <20210414101701.324777-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 12:16:58 +0200 you wrote:
> Not much this time:
> 
> 1) Simplification of some variable calculations in esp4 and esp6.
>    From Jiapeng Chong and Junlin Yang.
> 
> 2) Fix a clang Wformat warning in esp6 and ah6.
>    From Arnd Bergmann.
> 
> [...]

Here is the summary with links:
  - pull request (net-next): ipsec-next 2021-04-14
    https://git.kernel.org/netdev/net-next/c/8c1186be3f1b
  - [2/3] esp6: remove a duplicative condition
    https://git.kernel.org/netdev/net-next/c/f076835a8bf2
  - [3/3] ipv6: fix clang Wformat warning
    https://git.kernel.org/netdev/net-next/c/6ad2dd6c14d3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


