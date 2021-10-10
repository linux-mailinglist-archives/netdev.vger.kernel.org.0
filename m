Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F1542807C
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 12:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhJJKcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 06:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231474AbhJJKcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 06:32:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E10260F22;
        Sun, 10 Oct 2021 10:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633861808;
        bh=u/BeV9D7MLZa55Up3XTeSnYWSdR2wpeFNHpYxTLndfY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WRc9kuQXIm72iYX1/TlrW4IrlIwrlM/SJ7Tp8xMzcVoC75s6h/AmTTVh74ATLigGo
         +IpxEew72VXp1VpAsGTpOKmf0imAO0RU7/kYvK4z+vd5nKTMQMzx66SNx8/r6tJirK
         lpZD7z9CR1v7UUBPCYTo+6gxUUvS6O7usiKjjLTHpQkUgLgy0dy7qPccjjsrIIquvg
         4+TpgxyJfpkfj2R3SGR9GEM9KMzFh29pNr0thSHEuB4xaAFkHlmBK1hNWJ9Dh9LqQm
         zng+SwEuXqpiT428xvJDp+lnEEkmn+4i3EMt7CHplrlcyyOiEcdYRRe67NdTWfALa3
         vf2XMH+FRa+/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5C77D609EF;
        Sun, 10 Oct 2021 10:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net-next: replace open code with helper
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163386180837.17785.10289627869774588387.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Oct 2021 10:30:08 +0000
References: <20211010040329.1078-1-claudiajkang@gmail.com>
In-Reply-To: <20211010040329.1078-1-claudiajkang@gmail.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     michael.chan@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 10 Oct 2021 13:03:26 +0900 you wrote:
> Currently, there are many helper functions on netdevice.h. However,
> some code doesn't use the helper functions and remains open code.
> So this patchset replaces open code with an appropriate helper function.
> 
> First patch modifies to use netif_is_rxfh_configured instead of
> dev->priv_flags & IFF_RXFH_CONFIGURED.
> Second patch replaces open code with netif_is_bond_master.
> Last patch substitutes netif_is_macsec() for dev->priv_flags & IFF_MACSEC.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] bnxt: use netif_is_rxfh_configured instead of open code
    https://git.kernel.org/netdev/net-next/c/4b70dce2c1b9
  - [net-next,2/3] hv_netvsc: use netif_is_bond_master() instead of open code
    https://git.kernel.org/netdev/net-next/c/c60882a4566a
  - [net-next,3/3] mlxsw: spectrum: use netif_is_macsec() instead of open code
    https://git.kernel.org/netdev/net-next/c/019921521697

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


