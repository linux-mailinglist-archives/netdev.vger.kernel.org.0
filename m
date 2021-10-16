Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A50D4302DE
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 16:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244311AbhJPOMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 10:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236207AbhJPOMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 10:12:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 06902611C1;
        Sat, 16 Oct 2021 14:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634393407;
        bh=erH01x84fzWNhqUeM717403Vw8lEpcsZcHJsVpbR1p4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TBmBG7/9a71DWVSFrGlXp1g2B/gniJ5OJrlABBGHJV+5VKcgUKHkpp7Tt1UkB+tlw
         C/6f5Lq2u1PtxLY3mw/iw7RnsUB7tliqxUU7WcFDmQ4m5sxQf1ptBPj1gM9ZX3WAcs
         8OSeu6IJhfaxITpCGzYJxCEWiT9gkEU7kfooH1YGabb7jwCEkL2zAmxLkPN+uM+yVZ
         8jL/pmiuHTpEVTMz6jUNgbIc4vF1LwRKWq/4AmPeWqi9j6sfD6eQCw1nkVbtUx1Xcl
         2ziu/kawllRHzViMVM4tqMix0MTLLTaGZ8VMRchKNVJYy+eA1B4deAdvHIUcouGozD
         Kv+u+kxrCXI6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB47260A44;
        Sat, 16 Oct 2021 14:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bridge: mcast: use multicast_membership_interval for
 IGMPv3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163439340695.2147.18399180717988406191.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Oct 2021 14:10:06 +0000
References: <20211015090546.19967-1-razor@blackwall.org>
In-Reply-To: <20211015090546.19967-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, nikolay@nvidia.com, liuhangbin@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Oct 2021 12:05:46 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> When I added IGMPv3 support I decided to follow the RFC for computing
> the GMI dynamically:
> " 8.4. Group Membership Interval
> 
>    The Group Membership Interval is the amount of time that must pass
>    before a multicast router decides there are no more members of a
>    group or a particular source on a network.
> 
> [...]

Here is the summary with links:
  - [net] net: bridge: mcast: use multicast_membership_interval for IGMPv3
    https://git.kernel.org/netdev/net/c/fac3cb82a54a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


