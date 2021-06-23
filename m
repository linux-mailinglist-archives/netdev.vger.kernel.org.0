Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CB13B2169
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhFWTwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWTwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 15:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 38BF961185;
        Wed, 23 Jun 2021 19:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624477804;
        bh=1Df6zZIkOBQvUbG6VKAASiIGcRyHMpCf4XB6mC/u/zU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OpgsFQ9oW+s7cDstUFq8LiW0SacldgAMIXmEZQbHPw+mdUjAAwpyICpmm3tDLnv7Q
         jhCBkivlkSXuNFyNumRnG5a5e0nft+1wrUWqt7g1rSVvf5OdBTlTZUXW+jr6XSFCZN
         EeXBsl9C8N311qFzcvqEbdDvUoAZIXsv92Toty9qxHbGt1ACyGE2AIJnonK6/UB55w
         h9k/HPTL6KsQSLdljnBJlDNu0tY5aIj2hICsMOaveCOzOIyWiiT3xicdysTK72Ew8E
         NvMOXv0XcLZ1MeFnDEzQwDxoOjzTtK0aLyneVlINoFTP7XoJr6W9xnnV38iHokNwas
         1Qc+JXLD7aO3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2D1636094F;
        Wed, 23 Jun 2021 19:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net): ipsec 2021-06-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162447780417.22134.12745993593606106642.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 19:50:04 +0000
References: <20210623065449.2143405-1-steffen.klassert@secunet.com>
In-Reply-To: <20210623065449.2143405-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Wed, 23 Jun 2021 08:54:43 +0200 you wrote:
> 1) Don't return a mtu smaller than 1280 on IPv6 pmtu discovery.
>    From Sabrina Dubroca
> 
> 2) Fix seqcount rcu-read side in xfrm_policy_lookup_bytype
>    for the PREEMPT_RT case. From Varad Gautam.
> 
> 3) Remove a repeated declaration of xfrm_parse_spi.
>    From Shaokun Zhang.
> 
> [...]

Here is the summary with links:
  - pull request (net): ipsec 2021-06-23
    https://git.kernel.org/netdev/net/c/7c2becf7968b
  - [2/6] xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype
    https://git.kernel.org/netdev/net/c/d7b0408934c7
  - [3/6] xfrm: Remove the repeated declaration
    https://git.kernel.org/netdev/net/c/6e1e89418a5c
  - [4/6] xfrm: remove the fragment check for ipv6 beet mode
    https://git.kernel.org/netdev/net/c/eebd49a4ffb4
  - [5/6] xfrm: Fix error reporting in xfrm_state_construct.
    https://git.kernel.org/netdev/net/c/6fd06963fa74
  - [6/6] xfrm: Fix xfrm offload fallback fail case
    https://git.kernel.org/netdev/net/c/dd72fadf2186

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


