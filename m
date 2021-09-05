Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E00C400FA2
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 14:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbhIEMVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 08:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231370AbhIEMVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 08:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B21160F3A;
        Sun,  5 Sep 2021 12:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630844405;
        bh=7dF4kD4xR615EQSqHKyCMAQd3Ew3pNRGNIJ4roKHYh8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j+eK1SIz3HoHxwvrgiov+VOsH2wvD/qKbMFhYMWR+VNVeyXc+woyLrsp3XIhAVfAs
         D7jDSy2hLQcalku4/6h7XXToCnq90yNLAhQxn5G5svaFMXKjeWHVDX63J3NL1cBP+3
         ridqUaSy2uQv55XRdIErkXtmu6Fuege5Dpy8xWO3NHgJzSEK++QqLH6IWGhpSdhHPM
         agxV0dqhjReLe0Z6SuO0+f7TxAbxiuetOsKbk07JJNT50MShSM2qyz72Zjhs5v2Jru
         Z5t18G6PKHk5WpgdNPVpEnvHvxg9c/Y3fZ8OEKjr0REouniKLSXuo9RDExmbVud4G2
         Z09pxUsPEWSEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6E30460986;
        Sun,  5 Sep 2021 12:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ip/ip6_gre: use the same logic as SIT interfaces when
 computing v6LL address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163084440544.8315.15916759726501868396.git-patchwork-notify@kernel.org>
Date:   Sun, 05 Sep 2021 12:20:05 +0000
References: <20210903165842.6149-1-a@unstable.cc>
In-Reply-To: <20210903165842.6149-1-a@unstable.cc>
To:     Antonio Quartulli <a@unstable.cc>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, chopps@chopps.org, donaldsharp72@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  3 Sep 2021 18:58:42 +0200 you wrote:
> GRE interfaces are not Ether-like and therefore it is not
> possible to generate the v6LL address the same way as (for example)
> GRETAP devices.
> 
> With default settings, a GRE interface will attempt generating its v6LL
> address using the EUI64 approach, but this will fail when the local
> endpoint of the GRE tunnel is set to "any". In this case the GRE
> interface will end up with no v6LL address, thus violating RFC4291.
> 
> [...]

Here is the summary with links:
  - [net] ip/ip6_gre: use the same logic as SIT interfaces when computing v6LL address
    https://git.kernel.org/netdev/net/c/e5dd729460ca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


