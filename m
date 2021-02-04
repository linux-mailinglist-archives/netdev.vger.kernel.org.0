Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C57330EB61
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 05:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhBDECR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 23:02:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhBDEAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 23:00:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C1CF564F64;
        Thu,  4 Feb 2021 04:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612411208;
        bh=mk7stgL2zJKHEZtGOaX+qG7g+0W652ffQAkRbRXxs6E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gw+HOPuLblact10CE5bZ0h11gucRWd+7c1lHCrRdkqv6KoiNIvHhU1mkKMGgitARu
         WAb9Xz0hsWPouSYc+wM9eqnsXJa6brCnVKBYQEZbC8zJWMR3aH5HqEYgjOUw9B8m7f
         6WVUno7ko9+0i7r78UKSzElCz26WekywtGICP2qUF3N3Y2SqZKZf6vvjuCvKnoMKb5
         ewpIxIkCFwHg4PWaJ2CDrGlebhluI8eBPJS8OJPQ+RRW577yw7p4ogL+85vRH195kM
         S3gaP+W9o6Xum5hy+DwATiDf3F0KF6qT5+SyEWOg8x7dFDv3nhvgH42N0ybX1Sy7ke
         mjUijba01/wcQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC7A2609EC;
        Thu,  4 Feb 2021 04:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/8] Support setting lanes via ethtool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161241120870.9496.4683921787679304535.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Feb 2021 04:00:08 +0000
References: <20210202180612.325099-1-danieller@nvidia.com>
In-Reply-To: <20210202180612.325099-1-danieller@nvidia.com>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 2 Feb 2021 20:06:04 +0200 you wrote:
> Some speeds can be achieved with different number of lanes. For example,
> 100Gbps can be achieved using two lanes of 50Gbps or four lanes of
> 25Gbps. This patchset adds a new selector that allows ethtool to
> advertise link modes according to their number of lanes and also force a
> specific number of lanes when autonegotiation is off.
> 
> Advertising all link modes with a speed of 100Gbps that use two lanes:
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/8] ethtool: Validate master slave configuration before rtnl_lock()
    https://git.kernel.org/netdev/net-next/c/189e7a8d9420
  - [net-next,v4,2/8] ethtool: Extend link modes settings uAPI with lanes
    https://git.kernel.org/netdev/net-next/c/012ce4dd3102
  - [net-next,v4,3/8] ethtool: Get link mode in use instead of speed and duplex parameters
    https://git.kernel.org/netdev/net-next/c/c8907043c6ac
  - [net-next,v4,4/8] ethtool: Expose the number of lanes in use
    https://git.kernel.org/netdev/net-next/c/7dc33f0914a9
  - [net-next,v4,5/8] mlxsw: ethtool: Remove max lanes filtering
    https://git.kernel.org/netdev/net-next/c/5fc4053df3d9
  - [net-next,v4,6/8] mlxsw: ethtool: Add support for setting lanes when autoneg is off
    https://git.kernel.org/netdev/net-next/c/763ece86f0c2
  - [net-next,v4,7/8] mlxsw: ethtool: Pass link mode in use to ethtool
    https://git.kernel.org/netdev/net-next/c/25a96f057a0f
  - [net-next,v4,8/8] net: selftests: Add lanes setting test
    https://git.kernel.org/netdev/net-next/c/f72e2f48c710

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


