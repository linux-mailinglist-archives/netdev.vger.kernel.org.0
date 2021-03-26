Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181AF34B187
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 22:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCZVuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 17:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230027AbhCZVuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 17:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2CFB961A28;
        Fri, 26 Mar 2021 21:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616795411;
        bh=VSiORVhE5bbVWGkpsyZBo/Y2Y+CBK2P+ganjE8Idzes=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lGlpZgxwG77cQdQAEw5do3xJuWXboVQMAj6rEOE7JvMkh9ZPSN9IH4/TRc+cD0axm
         PBSwwCGcE+hW5XkcaOXXDuiP4NwztkF/zjpEVGK5p5DQqvh6BiB5ZUzvo3eum0zRdv
         E0yfhJ8Jdm8UTaQB4NHBuZ9KgiBpLyL3acNah4IIXTWFvNDdImg/Rj9Xas2PEaLWm1
         YyTirPw48TANAlc7NAxvj6Vd7FLgzkYlY2srmEGOAwEGbeQQctbYuYtlXW1Uylciav
         niXs4Bb0NLLxIGODy5gen6NvUggEbGg1ERQVacuP2+veGbxwvGBfC69ObDVj6y+WOb
         wJw5D7bO27iqQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0431C6096E;
        Fri, 26 Mar 2021 21:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: use less storage for most sysctl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679541101.17455.16509636515797446378.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 21:50:11 +0000
References: <20210325180817.840042-1-eric.dumazet@gmail.com>
In-Reply-To: <20210325180817.840042-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 11:08:12 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This patch series adds a new sysctl type, to allow using u8 instead of
> "int" or "long int" types.
> 
> Then we convert mosts sysctls found in struct netns_ipv4
> to shrink it by three cache lines.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] sysctl: add proc_dou8vec_minmax()
    https://git.kernel.org/netdev/net-next/c/cb9444130662
  - [net-next,2/5] ipv4: shrink netns_ipv4 with sysctl conversions
    https://git.kernel.org/netdev/net-next/c/4b6bbf17d4e1
  - [net-next,3/5] ipv4: convert ip_forward_update_priority sysctl to u8
    https://git.kernel.org/netdev/net-next/c/1c69dedc8fa7
  - [net-next,4/5] inet: convert tcp_early_demux and udp_early_demux to u8
    https://git.kernel.org/netdev/net-next/c/2932bcda070d
  - [net-next,5/5] tcp: convert elligible sysctls to u8
    https://git.kernel.org/netdev/net-next/c/4ecc1baf362c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


