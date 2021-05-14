Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4524380F22
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 19:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhENRlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 13:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235202AbhENRlW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 13:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A240361451;
        Fri, 14 May 2021 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621014010;
        bh=Ouwg2X1yITI/2mT9GF+8IrZdIbbp8zCDU1Go8f1P6Jo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AdIv3jWyIOcuhd51Cx3/kYfeJVzg1BSEsmFg98ascFvtdDaR+G0hzOhpcy5rM8GiC
         RIzJNjQAkculIASQfWCKXmRpgPcDva04JHvn7N2lvVQBh0IJIPp0UxBtq5vvmpSu9h
         EarrueaolBfzc2Y5AHiZm0dgSM9UStPTaDc7HdATpsdduxEBfx2EHE9t9tCgfxW4i/
         il2FzNl3mbEN+gfC1iA44ijmdBkQzl/bkfWFpYrazs5w3cfv8+ulF8nxxPVde399mN
         YDvXmmNxklHJ/cuxmzvTSNEfGa1oXrMCifX4JW6+aHTsP90yufwe0OwLK+goQque0R
         CUhW6G9Aax1Hg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9737560A47;
        Fri, 14 May 2021 17:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: fix br_multicast_is_router stub when
 igmp is disabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162101401061.20897.7240694501805545455.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 17:40:10 +0000
References: <20210514073233.2564187-1-razor@blackwall.org>
In-Reply-To: <20210514073233.2564187-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, davem@davemloft.net,
        linus.luessing@c0d3.blue, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 14 May 2021 10:32:33 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> br_multicast_is_router takes two arguments when bridge IGMP is enabled
> and just one when it's disabled, fix the stub to take two as well.
> 
> Fixes: 1a3065a26807 ("net: bridge: mcast: prepare is-router function for mcast router split")
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: fix br_multicast_is_router stub when igmp is disabled
    https://git.kernel.org/netdev/net-next/c/bbc6f2cca74e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


