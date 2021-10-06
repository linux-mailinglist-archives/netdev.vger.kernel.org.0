Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683C0423FDD
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbhJFOME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238859AbhJFOMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4BE1D61181;
        Wed,  6 Oct 2021 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633529409;
        bh=xYLy/YmYSn0/tSFD3F+ZlXS35Jia5lI7wEw9aSt1R2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BCx8ZT5NUIVH2zNEdVTFJuoWWx0jjuKEQ0xPEWiHfmnWJlz5UcIaIYm72PvBGKJCd
         BGb09W2WqPmW9ju5wPtY3WMbJK8NqFS8hZz1LyzIqmGvxizzjyjwBxIW0SUKQA+bcg
         v83hIjKvIdPT004TF9mFX97kQZtFrNK/nsgGR+jZgGgDg9Gq0XZXpy1XqEaujJ6GVd
         nAyivtha55e9BL0S7wenKuXmtoPFR2zoE6aiGogdFnkpp/HEVuRLp874m2AZoLG/03
         WaWA7gO5MOMhmF+0OW8oYdm4+lQvb3SI4xulsOSpMdhEjeEwk6nN+R2ha7O3N2Aoou
         VjvyqK3+XZejw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4565560A44;
        Wed,  6 Oct 2021 14:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3 v5] RTL8366RB enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163352940927.9599.12155831277553877874.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 14:10:09 +0000
References: <20211005194704.342329-1-linus.walleij@linaro.org>
In-Reply-To: <20211005194704.342329-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  5 Oct 2021 21:47:01 +0200 you wrote:
> This patch set is a set of reasonably mature improvements
> for the RTL8366RB switch, implemented after Vladimir
> challenged me to dig deeper into the switch functions.
> 
> ChangeLog v4->v5:
> - Drop dubious flood control patch: these registers probably
>   only deal with rate limiting, we will deal with this
>   another time if we can figure it out.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3,v5] net: dsa: rtl8366rb: Support disabling learning
    https://git.kernel.org/netdev/net-next/c/56d8bb71a811
  - [net-next,2/3,v5] net: dsa: rtl8366rb: Support fast aging
    https://git.kernel.org/netdev/net-next/c/1fbd19e10b73
  - [net-next,3/3,v5] net: dsa: rtl8366rb: Support setting STP state
    https://git.kernel.org/netdev/net-next/c/e674cfd08537

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


