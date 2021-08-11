Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E064E3E9ABB
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhHKWKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232297AbhHKWK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7BEB86101E;
        Wed, 11 Aug 2021 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628719805;
        bh=MzjzJhVUvF4/V37Lqh67EOYsrrmk40MIuk4NP8o8MSw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qEAwDGEb6iNsyg8bhC5zbs3gQSkalXmRJ2dS9MIWKLNgsPVYUnQpcRv9qW+upoCJJ
         nNITuxKWTPrXGfh0nBES9cbX3zC1/pKnwPWHf9coE2sKISnfjKe5cnEzXuxw6JGzdO
         dY7wpmOHqR1pib9B/jvCdWmc/6n35EEwKf0CLyM72wvC+XUuyNF+2BlPuaZAbcRLUy
         7XDXfuUtGMoz0ecrx0dcFCfiCv5nDxJK+oqyhq5OzdBngnhTTbC0eUqGMh9h3fP8PT
         wZmM5B0J3ChJiWuvk8expz8rBkpcgdBK2YilC17Ilwdq6GVEHchfpnfiCWJc8rrMZc
         8ibM9ip58oGIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 69C7B609AD;
        Wed, 11 Aug 2021 22:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: pcs: xpcs: fix error handling on failed to
 allocate memory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162871980542.25380.8477165081066808140.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 22:10:05 +0000
References: <20210810085812.1808466-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210810085812.1808466-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 10 Aug 2021 16:58:12 +0800 you wrote:
> Drivers such as sja1105 and stmmac that call xpcs_create() expects an
> error returned by the pcs-xpcs module, but this was not the case on
> failed to allocate memory.
> 
> Fixed this by returning an -ENOMEM instead of a NULL pointer.
> 
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: pcs: xpcs: fix error handling on failed to allocate memory
    https://git.kernel.org/netdev/net/c/2cad5d2ed1b4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


