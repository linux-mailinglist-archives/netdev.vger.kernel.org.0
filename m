Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4108648F9B6
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 23:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbiAOWuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 17:50:13 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48512 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbiAOWuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 17:50:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 568F4CE0B1B;
        Sat, 15 Jan 2022 22:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 481ACC36AEC;
        Sat, 15 Jan 2022 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642287009;
        bh=Z9gSvvip9m1oDvrqSPUEB1vi4702+JJ0Xru7hnKxTW0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nVN/8ROirvWBGT5QFqomdIV8cMRs3G98fLXe9ofq+JzW0qqYqkxBADnGSmTT4qBAO
         GEzm/7ne8CQ0SrIinOqFOLmq2HTY0RVUpbrsXLYy4KAqw2H4nenhCSArOEWhFvLsQY
         5lKYMlUSTCm2VRnhNgnTMQxxbmGNA4cYNSiRBanl8ieUO1/Wkg6bKOs8C9DghcetBk
         12begki0YdNrQ4ehuXonch+bG3oiicQvFAa/WXMBoGA2dyrHWrjXmHhBaCeb2ljH/B
         3m6ptMoIK6OM8MyeLjyUxzoI8Nrk7T0XDwzacQEg1BxeZzUxOAsPAEPZ+e9bP3Ddyy
         y+c6T9HSRIc7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C317F6079A;
        Sat, 15 Jan 2022 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] net: phy: marvell: add Marvell specific PHY loopback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164228700917.30034.60722406247180208.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Jan 2022 22:50:09 +0000
References: <20220115092515.18143-1-mohammad.athari.ismail@intel.com>
In-Reply-To: <20220115092515.18143-1-mohammad.athari.ismail@intel.com>
To:     Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        linux@rempel-privat.de, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 15 Jan 2022 17:25:15 +0800 you wrote:
> Existing genphy_loopback() is not applicable for Marvell PHY. Besides
> configuring bit-6 and bit-13 in Page 0 Register 0 (Copper Control
> Register), it is also required to configure same bits  in Page 2
> Register 21 (MAC Specific Control Register 2) according to speed of
> the loopback is operating.
> 
> Tested working on Marvell88E1510 PHY for all speeds (1000/100/10Mbps).
> 
> [...]

Here is the summary with links:
  - [net,v4] net: phy: marvell: add Marvell specific PHY loopback
    https://git.kernel.org/netdev/net/c/020a45aff119

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


