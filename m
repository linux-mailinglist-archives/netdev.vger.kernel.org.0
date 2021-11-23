Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C022F45A26B
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbhKWMXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:23:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236958AbhKWMXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:23:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 14D3C61038;
        Tue, 23 Nov 2021 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670012;
        bh=6cX0x3svP3QdakfCd/p6Ei3HN6TR5m/dGjG7ml7QelU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rNHfLhPeYNt/xh1XnyVixce0sZRq0W/Ts1/8YQzlwFoIEclcNlMIfsVfgYH/vc6Nv
         a2UYkqmfCYK+dyV1XXjQVstwek7/lNqZYydDDyA37A0x+VxPp/mXmjFumPXIIM4i9z
         ad1NGL+WU/1VQjLAQr2nGlAFwfJygcF1zN8TfULHWzkkgT0oet5Qqp6Jx/d/RPqrqn
         /EWzxrf/BKjkB1B6YOABwRpnWgk1gjC2/Fvbj0vi2xFfBLKwo3kb6zzkxUEy9ucCrP
         gPM28rf6YcXhTak7kU5+7jYE9YAPmK8Ea7X3ZOSMTAqh84Qymn9Nk5Gs/n3VLWwbuh
         dZ6/qwLC1NPbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 064C8609BB;
        Tue, 23 Nov 2021 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Add 5gbase-r support for mvpp2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767001202.10565.9680629278046876801.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:20:12 +0000
References: <20211122205111.10156-1-kabel@kernel.org>
In-Reply-To: <20211122205111.10156-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        kuba@kernel.org, andrew@lunn.ch, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 21:51:09 +0100 you wrote:
> Hello,
> 
> this adds support for 5gbase-r for mvpp2 driver. Current versions of
> TF-A firmware support changing the PHY to 5gbase-r via SMC calls, at
> least on Macchiatobin.
> 
> Tested on Macchiatobin.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] phy: marvell: phy-mvebu-cp110-comphy: add support for 5gbase-r
    https://git.kernel.org/netdev/net-next/c/a1fb410a5751
  - [net-next,2/2] net: marvell: mvpp2: Add support for 5gbase-r
    https://git.kernel.org/netdev/net-next/c/4043ec701c43

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


