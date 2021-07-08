Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145313BF629
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhGHHWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229780AbhGHHWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 03:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 310B761CE3;
        Thu,  8 Jul 2021 07:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625728803;
        bh=y9x//qnYbZ60iD5JC3r2b9vSUV5MTN0pVbCCPd5Nyhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hahe3Oht/a5/tbzsdoMI14oQzGn+ZACOsgojKLAuX1BDhoMWpcqG+cRb3Crt6O+mz
         eGqCQ6vJT7FTQ6G3kI/YrIQ7UqDQPWVKvR3xU2cIE7HiQlCk2sdqMHFyjTMFfDCSZb
         azpTENnU0kLRlwhNB2wY61zpCrtfYwB8Hh3rwvMPjLe5PlObGvLD45s8qhZ+xQXwSy
         qv6+V5v7HwRlcFH9oMapy+spoaKZwts5Jf3YAzuTOEUS6gq+xbXSrpT9I3eNofMzZl
         tJxEshgFx3M6HRuLH+IBhQtQEQ5vW7mxFhx0Wg9oixVODc/f/Jtvzn0+5r9HtZYEIH
         HFoN73aUszJaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2447E60A54;
        Thu,  8 Jul 2021 07:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] skbuff: Fix build with SKB extensions disabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162572880314.15901.10011561624152819596.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Jul 2021 07:20:03 +0000
References: <20210708041051.17851-1-f.fainelli@gmail.com>
In-Reply-To: <20210708041051.17851-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, paulb@nvidia.com, eric.dumazet@gmail.com,
        davem@davemloft.net, kuba@kernel.org, mika.penttila@nextfour.com,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        saeedm@nvidia.com, ozsh@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  7 Jul 2021 21:10:51 -0700 you wrote:
> We will fail to build with CONFIG_SKB_EXTENSIONS disabled after
> 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used
> skbs") since there is an unconditionally use of skb_ext_find() without
> an appropriate stub. Simply build the code conditionally and properly
> guard against both COFNIG_SKB_EXTENSIONS as well as
> CONFIG_NET_TC_SKB_EXT being disabled.
> 
> [...]

Here is the summary with links:
  - [net] skbuff: Fix build with SKB extensions disabled
    https://git.kernel.org/netdev/net/c/9615fe36b31d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


