Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E54245D35D
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243816AbhKYDFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:05:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239073AbhKYDDU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C6F0D60ED4;
        Thu, 25 Nov 2021 03:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637809209;
        bh=LmJUha2zb60ihEdnC9zg911zJbs4tIX/sNn9GBg857I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ucr4MAl9TxqWS3/Hy7o1dJNLTEMejNwEE0VIRsPFf5sEwUryrHXIxspvAHbOl6CdT
         9MX3LQCpyU2jUNVCLrqKlfPni1yuCtVLFU7DFcnKT+eEeGHYMc0880U3jyxxcctEdK
         mgI90NylgbSmNjSCeZeS7gSTvdih3GeTSE25TMPdj5yj8yfVMNhDvp8CFvlpyVDqVf
         YlgauOooa/du6QSrlCdEWdEG5hDI+KmT2t/AcpYQ79l5LYRrextG/ovivyCdnybDi4
         NCIeFXazW3L8n+lzW22PqmdAEMz/ZW5JB7j8p6uYO29O11gZH4E6DRFMqv5wA9VkVA
         +ot6Jl8afqxYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B6A1360A0A;
        Thu, 25 Nov 2021 03:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] phylink resolve fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780920974.10128.232616050211394190.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 03:00:09 +0000
References: <20211123154403.32051-1-kabel@kernel.org>
In-Reply-To: <20211123154403.32051-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        kuba@kernel.org, andrew@lunn.ch, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Nov 2021 16:44:01 +0100 you wrote:
> With information from me and my nagging, Russell has produced two fixes
> for phylink, which add code that triggers another phylink_resolve() from
> phylink_resolve(), if certain conditions are met:
>   interface is being changed
> or
>   link is down and previous link was up
> These are needed because sometimes the PCS callbacks may provide stale
> values if link / speed / ...
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: phylink: Force link down and retrigger resolve on interface change
    https://git.kernel.org/netdev/net/c/80662f4fd477
  - [net,v2,2/2] net: phylink: Force retrigger in case of latched link-fail indicator
    https://git.kernel.org/netdev/net/c/dbae3388ea9c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


