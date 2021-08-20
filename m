Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC4E3F2D6B
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240793AbhHTNuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240787AbhHTNuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:50:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D41EB61155;
        Fri, 20 Aug 2021 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629467406;
        bh=aikCOafley3SG63heEqr76DnyF+uOPtbGwcLdN7chSA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ejM7MWWEYzwWG/+9dkG5I04Qgh03XmBXZugjatE97w1iJKTX4rBtPUHuSzIOAKMvN
         lSxgfqoBXwPMp67Ozd9vSl+vk5r50scv44MWkyokdT0Xz7CiaSR6uiL9VIcSshA8cE
         l1I4CIVwMpfuSlASuIqF8Iy+6qv2lUma1+m4Iu5LI2RvY7IIz5jLowkwCFozFqTWus
         SlUiv6tKoQxJAk9KH6ESItmzrK0btolLcnTEKS+OrZMHl1qa+PI3BMOeeWqmI1Id1v
         Fhk079C7IWIBc4LsLjPeWvkj9g6PjsWXgZLkWMUMEzxD27DlOL9Elg+goOtex1kP5U
         BDnPo2irbQFDw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C97CA60A6B;
        Fri, 20 Aug 2021 13:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/3] Small ocelot VLAN improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946740682.29437.594690908302605937.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 13:50:06 +0000
References: <20210819174008.2268874-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210819174008.2268874-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Aug 2021 20:40:05 +0300 you wrote:
> This small series propagates some VLAN restrictions via netlink extack
> and creates some helper functions instead of open-coding VLAN table
> manipulations from multiple places.
> 
> This is split from the larger "DSA FDB isolation" series, hence the v2
> tag:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] net: mscc: ocelot: transmit the "native VLAN" error via extack
    https://git.kernel.org/netdev/net-next/c/01af940e9be6
  - [v2,net-next,2/3] net: mscc: ocelot: transmit the VLAN filtering restrictions via extack
    https://git.kernel.org/netdev/net-next/c/3b95d1b29386
  - [v2,net-next,3/3] net: mscc: ocelot: use helpers for port VLAN membership
    https://git.kernel.org/netdev/net-next/c/bbf6a2d92361

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


