Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA763D1967
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhGUVJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 17:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhGUVJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 17:09:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 67D5E61208;
        Wed, 21 Jul 2021 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626904204;
        bh=8tkeDtxOoppgqWkTF5198Sw+Ha/XDXYFXWHjo7kC51c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EosbHorcyJdiBrK0nvFn+OI1sSzhF1iVW7RPE7hAMejgdzjOoqj90ZRCQfbGGF9wS
         YQAVy5VtSPhXap6TvkZTuW9dFVUke8aDaZnhJeiUsEotaJ+u6KNHLJbiTZ2Y9A04hc
         5lPBPiAH/Q4yFZ5vO6mrBE4eYVof4Q5Nx+O9VamWC3mOg1Y+KG0TfwcyJoJ1g3Lzl1
         Yipf/NZO0vDWVys3FU/IBMvviH98f+Th/ZH4mSmqsCkDeqZ6/UcciKZ6ywdR9vlIRR
         ep5GJIFC1B9ObHjdPbKa649T3ycX1DJc+bWHw9ikRXc2wepRa87egeQBErjuHDiKo+
         DUzKMRYqdIkBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B40760CD3;
        Wed, 21 Jul 2021 21:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: bridge: multicast: add mdb and host context
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162690420436.1414.1687254067791597948.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 21:50:04 +0000
References: <20210721140127.773194-1-razor@blackwall.org>
In-Reply-To: <20210721140127.773194-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Jul 2021 17:01:25 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This is a minor context improvement which chooses the proper multicast
> context when adding user mdb entries or host-joined entries (pointing to
> the bridge device). Patch 01 adds a helper which chooses the proper
> context when user-space is adding an mdb entry, note that it requires
> the vlan to be configured on at least 1 device (port or bridge) so it
> would have a multicast context. Patch 02 changes br_multicast_host_join
> to take a bridge multicast context parameter which is passed down from
> the respective functions, currently it is used for the timer config
> value only. This set is in preparation for adding all multicast options
> for vlans.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: bridge: multicast: add mdb context support
    https://git.kernel.org/netdev/net-next/c/6567cb438a51
  - [net-next,2/2] net: bridge: multicast: add context support for host-joined groups
    https://git.kernel.org/netdev/net-next/c/58d913a32664

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


