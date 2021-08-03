Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAD13DED48
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235815AbhHCMAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235589AbhHCMAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 08:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 669DC60F11;
        Tue,  3 Aug 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627992006;
        bh=nq/wcx/rCCf2VCHT85z+I3P+nAX/Jnc9Khgrv2uJMiM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q3AF74ZRBDrfFPMCURCskISUlOs/ohlEdOFKuPUCaaKY3vwXqNI3A3h5S9/zt7ff2
         H1a5khmKYfyHqMm5MGCR0My7ufVD8K0MM8/iB0YXsAytCISmuAYMj4xH5g1AHauQTc
         fCjIL/jVJ63CiqfIA179mH1A5JMl9ElNVfeueNmivll1qVMt1uHuUPfBkrg0X71FAq
         6Fm/JZoGdj2j7pJGmNYZaklaS5TTek1cJVZ5QnoOTbyE7bfmXXHteZ1BgTeffNR30c
         ge4J4Vsg8CT1jhYG1C3/QVWrm+9ntZ9M1tsN1jslPJu88nflAOMWgKBMbzaVD/BGlL
         HtEhRbOw6r62A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5F97360A49;
        Tue,  3 Aug 2021 12:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipv6: fix returned variable type in ip6_skb_dst_mtu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162799200638.3942.14318980003212361146.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 12:00:06 +0000
References: <20210803100016.314960-1-atenart@kernel.org>
In-Reply-To: <20210803100016.314960-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vfedorenko@novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  3 Aug 2021 12:00:16 +0200 you wrote:
> The patch fixing the returned value of ip6_skb_dst_mtu (int -> unsigned
> int) was rebased between its initial review and the version applied. In
> the meantime fade56410c22 was applied, which added a new variable (int)
> used as the returned value. This lead to a mismatch between the function
> prototype and the variable used as the return value.
> 
> Fixes: 40fc3054b458 ("net: ipv6: fix return value of ip6_skb_dst_mtu")
> Cc: Vadim Fedorenko <vfedorenko@novek.ru>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: ipv6: fix returned variable type in ip6_skb_dst_mtu
    https://git.kernel.org/netdev/net/c/4039146777a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


