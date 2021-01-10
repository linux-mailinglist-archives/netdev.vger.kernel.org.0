Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB752F0497
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhAJAau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbhAJAat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 76572239E5;
        Sun, 10 Jan 2021 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610238609;
        bh=yi3LRBJKHRRbLh47FOlViRiDl2LLg32U3XArcDZnJ7o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=khMqt1Hw83pGhajNWnc6DrBYRFXXSZRJVSnWWGnLqHNyqjrtPlojKhbIH36ATdvkK
         YVUWIA1Qcep2+14x/YMYvyDH21Wl7EFULdLDKGYIAv4wOWKx05BCMudlRpLP6jZR5y
         yRdyYgKqurpREfd8apKx5y90LZs4Gj0gjWrWSI10zZAtn8mMWahIvE8hGIktFOy3r1
         fQUEhRaZptzRbWxXxNLr80yB785tO0LMxrE6FVNnobFCXXbC7vGQhFLVcT/9iTxkUl
         o3qE26DaAU60QWONgFeoyeQoO3v7Ii2nVnd4OhB/1uPgARaRczFhr4SmJB0CDQnSWP
         1GWjxgQvzvmOw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 70F0060188;
        Sun, 10 Jan 2021 00:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] dpaa2-mac: various updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161023860945.20943.17870848125525075416.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Jan 2021 00:30:09 +0000
References: <20210108090727.866283-1-ciorneiioana@gmail.com>
In-Reply-To: <20210108090727.866283-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  8 Jan 2021 11:07:21 +0200 you wrote:
> The first two patches of this series extends the MAC statistics support
> to also work for network interfaces which have their link status handled
> by firmware (TYPE_FIXED).
> 
> The next two patches are fixing a sporadic problem which happens when
> the connected DPMAC object is not yet discovered by the fsl-mc bus, thus
> the dpaa2-eth is not able to get a reference to it. A referred probe
> will be requested in this case.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] dpaa2-mac: split up initializing the MAC object from connecting to it
    https://git.kernel.org/netdev/net-next/c/095dca16d92f
  - [net-next,v2,2/6] dpaa2-mac: export MAC counters even when in TYPE_FIXED
    https://git.kernel.org/netdev/net-next/c/d87e606373f6
  - [net-next,v2,3/6] bus: fsl-mc: return -EPROBE_DEFER when a device is not yet discovered
    https://git.kernel.org/netdev/net-next/c/ef57e6c9f7d9
  - [net-next,v2,4/6] dpaa2-eth: retry the probe when the MAC is not yet discovered on the bus
    https://git.kernel.org/netdev/net-next/c/47325da28ef1
  - [net-next,v2,5/6] dpaa2-mac: remove an unnecessary check
    https://git.kernel.org/netdev/net-next/c/ca7633407639
  - [net-next,v2,6/6] dpaa2-mac: remove a comment regarding pause settings
    https://git.kernel.org/netdev/net-next/c/14002089888b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


