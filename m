Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9110310411
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhBEEat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229795AbhBEEas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 23:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9237364FBF;
        Fri,  5 Feb 2021 04:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612499407;
        bh=XmAV8jcB3Vog6lZWdlU7r+AlB6vNXuPRFlBgenqq9jw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FzsZyqVhCK4BOFHToKx2tBfnSCwTCnRihAomSJ9CjYEF6Z867ZXP42PKLcpBWuDrO
         Z05geDWaTBdKCxg8xMETTfC7E77wPox9bFWCGwvtr7AmHpJA5n7uecg2ouOkPvpJSd
         zIKXNShqtKIjX6i6WtW3XLM6ZhanKkhco+xEdbj0T8CrqlHnYBzKfPpV7C61nKD7u4
         Kzv8U4m2UDhvCXAUFcNlonyvzpX81osSTyds4AVDy0zv7hiblXdcdwOFfpNZvOD+sI
         kNugjKJOApxNSIod/nVBVP8CxrexRNMaKm070i+C5PyyB90w1uwyTZIDX/VyJ8WJCM
         lwaQX6zzttcKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8346C609F5;
        Fri,  5 Feb 2021 04:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next] net: dsa: bcm_sf2: Check egress tagging of
 CFP rule with proper accessor
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249940753.23963.3057302629365510838.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 04:30:07 +0000
References: <20210203193918.2236994-1-olteanv@gmail.com>
In-Reply-To: <20210203193918.2236994-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  3 Feb 2021 21:39:18 +0200 you wrote:
> The flow steering struct ethtool_flow_ext::data field is __be32, so when
> the CFP code needs to check the VLAN egress tagging attribute in bit 0,
> it does this in CPU native endianness. So logically, the endianness
> conversion is set up the other way around, although in practice the same
> result is produced.
> 
> Gets rid of build warning:
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] net: dsa: bcm_sf2: Check egress tagging of CFP rule with proper accessor
    https://git.kernel.org/netdev/net-next/c/b53014f0791c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


