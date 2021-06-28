Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725F33B6A7E
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 23:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbhF1Vml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 17:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236941AbhF1Vmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 17:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6CCB361D01;
        Mon, 28 Jun 2021 21:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624916403;
        bh=4qCTtg8i9etGRroJHCm2HA5Z7SprXigilycNeBPaxkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZTJy7/cVr7uStJ13pkrSnUvUeot1eVETD8wLsZNL3NJ1he1W9azF7fWxx1Fgel1TU
         8wrur2Gtnsbe2Kb4MleFDr9DmeehGTj2qz90lWCxRJZa5GEWya/UlKaKNFApAh8NGp
         +X3HDD7K+Nwei/xD9c2x5VgzQ/auual9DKf+FQugrN3MaONdvKRHqBal528gM9olE8
         kjiOGQocIfSDeYlodEUymrxG/2dLDlUq0r3bdY3MgxBfvoJQ76XwmRVtA0lxciPwO5
         Qn6uOpeKjD42AZeJ2jmuIAW38mbcOGy7nMpiMhqksp/0QcudnWO0HyNbm7mlHuZwn7
         b7lwEhIBf4yzQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 59E0160A56;
        Mon, 28 Jun 2021 21:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V4] ipv6: ICMPV6: add response to ICMPV6 RFC 8335
 PROBE messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491640336.18953.1569430020745381913.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 21:40:03 +0000
References: <c9bd6d9006f446b7eebd3a5bf06cb92f61e5f3a8.1624716130.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <c9bd6d9006f446b7eebd3a5bf06cb92f61e5f3a8.1624716130.git.andreas.a.roeseler@gmail.com>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 26 Jun 2021 09:07:46 -0500 you wrote:
> This patch builds off of commit 2b246b2569cd2ac6ff700d0dce56b8bae29b1842
> and adds functionality to respond to ICMPV6 PROBE requests.
> 
> Add icmp_build_probe function to construct PROBE requests for both
> ICMPV4 and ICMPV6.
> 
> Modify icmpv6_rcv to detect ICMPV6 PROBE messages and call the
> icmpv6_echo_reply handler.
> 
> [...]

Here is the summary with links:
  - [net-next,V4] ipv6: ICMPV6: add response to ICMPV6 RFC 8335 PROBE messages
    https://git.kernel.org/netdev/net-next/c/1fd07f33c3ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


