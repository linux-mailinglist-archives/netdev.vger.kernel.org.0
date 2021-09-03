Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75D0400018
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 15:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348816AbhICNBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 09:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229645AbhICNBF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 09:01:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C309E610C8;
        Fri,  3 Sep 2021 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630674005;
        bh=AGgbOdSzpaAML4LgVInM2rkoEUdrV9Ncc/pxqjPQmE4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a0NQcz6dswV9m90yGOVybZcuAwoS9jGhdMzDBENKcxCeMTTBED6B7ifnUgVb1U1G2
         10Th34CfDV47zgkf+cynhVZCKNZVJ0WcxL8uB0aHWe30npA6PadBXX0pAS0ZGYSxCP
         V47xK7uL/63vWOKfh+q1Hm7RIlRekuXyF+/75bn8VdzSkAEsJQe/xgYK83LYg7xVDN
         FP770EI2qxnHes7PD8tBekerM6B0a94Rh9z5QbGuXOlCOxjGhGTO4KFqecm7gMcAuU
         BRJoMMIG7ULXNGsArBvWrha/G4aUplySw68rD8eb2JTPLmcpaGGfOAtjf+l9V5XbV2
         ITB6lFh+3nCJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B7988609D9;
        Fri,  3 Sep 2021 13:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bridge: mcast: fix vlan port router deadlock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163067400574.8696.628852222789312507.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Sep 2021 13:00:05 +0000
References: <20210903093415.1544837-1-razor@blackwall.org>
In-Reply-To: <20210903093415.1544837-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  3 Sep 2021 12:34:15 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Before vlan/port mcast router support was added
> br_multicast_set_port_router was used only with bh already disabled due
> to the bridge port lock, but that is no longer the case and when it is
> called to configure a vlan/port mcast router we can deadlock with the
> timer, so always disable bh to make sure it can be called from contexts
> with both enabled and disabled bh.
> 
> [...]

Here is the summary with links:
  - [net] net: bridge: mcast: fix vlan port router deadlock
    https://git.kernel.org/netdev/net/c/ddd0d5293810

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


