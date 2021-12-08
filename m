Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B113146CCE9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhLHFXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:23:50 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55064 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhLHFXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:23:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C1FC0CE1F59
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 05:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4342C341C3;
        Wed,  8 Dec 2021 05:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638940815;
        bh=rIUw6dBNeZnfDVkaVaZxPWH1afTNGIm16xk1E1PyPys=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JXETpBqXH46s+BMTsoMfg1Ziipf8eLXfMOYiHJJg4CJM8C0geYmJyH2Vghd9l5fUz
         sUKpP8gTdD0owjcJQBIe9tt0zTJ+tjv2Wh06aZtIdXA80xv0gw2nnkeEv5S0xgZfeE
         fQ2y8jg0a4SmO6hfm1I/xfBkQg1lKgQCMFr9IMAbnRWsCeEJeWuXnzjPxf/TPrkQQF
         p1zev/DJ2kfaFAGlY2SkmKC4GOL0wSe+DEbjFEjbmb95skmtzigLDT+NQb7qwyMfOt
         2I+YjW/MYTft8PR9gyeH8kTRv4QPiyGD9eRzghX/PzOxdUGU/t1xXOvRuce6aThNJ0
         yCpqZ+iVUtakw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C950860A36;
        Wed,  8 Dec 2021 05:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13] net: second round of netdevice refcount
 tracking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163894081581.587.1073118137521126627.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 05:20:15 +0000
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Dec 2021 17:30:26 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> The most interesting part of this series is probably
> ("inet: add net device refcount tracker to struct fib_nh_common")
> but only future reports will confirm this guess.
> 
> Eric Dumazet (13):
>   net: eql: add net device refcount tracker
>   vlan: add net device refcount tracker
>   net: bridge: add net device refcount tracker
>   net: watchdog: add net device refcount tracker
>   net: switchdev: add net device refcount tracker
>   inet: add net device refcount tracker to struct fib_nh_common
>   ax25: add net device refcount tracker
>   llc: add net device refcount tracker
>   pktgen add net device refcount tracker
>   net/smc: add net device tracker to struct smc_pnetentry
>   netlink: add net device refcount tracker to struct ethnl_req_info
>   openvswitch: add net device refcount tracker to struct vport
>   net: sched: act_mirred: add net device refcount tracker
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] net: eql: add net device refcount tracker
    https://git.kernel.org/netdev/net-next/c/08f0b22d731f
  - [net-next,02/13] vlan: add net device refcount tracker
    https://git.kernel.org/netdev/net-next/c/19c9ebf6ed70
  - [net-next,03/13] net: bridge: add net device refcount tracker
    https://git.kernel.org/netdev/net-next/c/b2dcdc7f731d
  - [net-next,04/13] net: watchdog: add net device refcount tracker
    https://git.kernel.org/netdev/net-next/c/f12bf6f3f942
  - [net-next,05/13] net: switchdev: add net device refcount tracker
    https://git.kernel.org/netdev/net-next/c/4fc003fe0313
  - [net-next,06/13] inet: add net device refcount tracker to struct fib_nh_common
    https://git.kernel.org/netdev/net-next/c/e44b14ebae10
  - [net-next,07/13] ax25: add net device refcount tracker
    https://git.kernel.org/netdev/net-next/c/66ce07f7802b
  - [net-next,08/13] llc: add net device refcount tracker
    https://git.kernel.org/netdev/net-next/c/615d069dcf12
  - [net-next,09/13] pktgen add net device refcount tracker
    https://git.kernel.org/netdev/net-next/c/035f1f2b96ae
  - [net-next,10/13] net/smc: add net device tracker to struct smc_pnetentry
    https://git.kernel.org/netdev/net-next/c/b60645248af3
  - [net-next,11/13] netlink: add net device refcount tracker to struct ethnl_req_info
    https://git.kernel.org/netdev/net-next/c/e4b8954074f6
  - [net-next,12/13] openvswitch: add net device refcount tracker to struct vport
    https://git.kernel.org/netdev/net-next/c/e7c8ab8419d7
  - [net-next,13/13] net: sched: act_mirred: add net device refcount tracker
    https://git.kernel.org/netdev/net-next/c/ada066b2e02c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


