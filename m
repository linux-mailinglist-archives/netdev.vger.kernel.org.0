Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2758E3D960D
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhG1TaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhG1TaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 15:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 339DF61040;
        Wed, 28 Jul 2021 19:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627500607;
        bh=OTgYxz9VSW3dM58+PSuy0/Ja265fczwHhEusPDlB3DY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EyQ/ZDw4ssVPGF1WRfNz1W4njthUWuvb1ZX0ycxPAoODkTelMI9ifeS0cqtDMN9sE
         6kLhomw93+/qr9CGAmZ/tkEePlrAtIm70udvmPb+kn1EdJGSp9C7H56dtZzUTOlIp6
         w0FHRGYZKeUUcoYpcg/5TRg+d5lg/cQzpXhVk1o1cG5FKaj/c6r1kfBdvmyk3iRoqO
         jAYcV9zcUWx7v482nB2eU7T8YN8t7lKkYAZtQQAYkaXn/OHiAGwKyie20rFMgyF+t0
         eMgzN02qnO/P0f5VyJCpy83F/A4VZat+ofiNWqAVDQ9SQuC1mRhJiHuLn0nvgjle9e
         +CzwgCqJ1Mn2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 293E760A7E;
        Wed, 28 Jul 2021 19:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: sja1105: be stateless when installing FDB
 entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162750060716.2664.15491688724417301615.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 19:30:07 +0000
References: <20210728185315.3572464-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210728185315.3572464-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Jul 2021 21:53:15 +0300 you wrote:
> Currently there are issues when adding a bridge FDB entry as VLAN-aware
> and deleting it as VLAN-unaware, or vice versa.
> 
> However this is an unneeded complication, since the bridge always
> installs its default FDB entries in VLAN 0 to match on VLAN-unaware
> ports, and in the default_pvid (VLAN 1) to match on VLAN-aware ports.
> So instead of trying to outsmart the bridge, just install all entries it
> gives us, and they will start matching packets when the vlan_filtering
> mode changes.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: sja1105: be stateless when installing FDB entries
    https://git.kernel.org/netdev/net-next/c/b11f0a4c0c81

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


