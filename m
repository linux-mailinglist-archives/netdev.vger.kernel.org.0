Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0CD35FD62
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhDNVkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232311AbhDNVke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 17:40:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B588561222;
        Wed, 14 Apr 2021 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618436412;
        bh=eiH3r1vP7wS5U+49nCupIYtD0eAYNNZvoCCz3foWgI8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aW5L+034c+OcmKs4Y+RTEVeMkpT/zPh7pcig/TpflfOHSySSoX4LM6y4uhih8OCgB
         LU6IEQEBDDbU7jvuieBJaNpQggprxcH//IdEcOLHDfhbh/PwSe2kstOqP5fddyR50u
         t21+3d3F4JLP8mXadLc7Ebsp8KpWuXH41qOdwFdqZpsQr/cUvB1Px5NuN3EmKhBgtx
         6TPmL0TfC15Ons+a2mz127WolmWKsfiJgkRu1+Cv7elTjRXCogZTaHoizZyAt4/1fj
         nYLOLMsSlFvgKRTPLCXE4MkI+uuWQAU74NK8BSAE2WJ1MW0BiEksTT20TCzqtlq4vl
         yma7pwZTVsIJQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A785160CD1;
        Wed, 14 Apr 2021 21:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: bridge: propagate error code and extack from
 br_mc_disabled_update
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843641268.17301.3268403480222413795.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 21:40:12 +0000
References: <20210414192257.1954575-1-olteanv@gmail.com>
In-Reply-To: <20210414192257.1954575-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, jiri@resnulli.us,
        idosch@idosch.org, roopa@nvidia.com, nikolay@nvidia.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 22:22:57 +0300 you wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> Some Ethernet switches might only be able to support disabling multicast
> snooping globally, which is an issue for example when several bridges
> span the same physical device and request contradictory settings.
> 
> Propagate the return value of br_mc_disabled_update() such that this
> limitation is transmitted correctly to user-space.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: bridge: propagate error code and extack from br_mc_disabled_update
    https://git.kernel.org/netdev/net-next/c/ae1ea84b33da

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


