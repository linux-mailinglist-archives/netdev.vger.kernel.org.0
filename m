Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08ADD4A5E4F
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 15:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239314AbiBAOaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 09:30:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36550 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239277AbiBAOaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 09:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6300161601;
        Tue,  1 Feb 2022 14:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFD29C340ED;
        Tue,  1 Feb 2022 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643725810;
        bh=HqRSxpkZqoWU/dNr1mUkUpRcK8ShpkNiF0WwpKJc1Hc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fPadu+UgvDdEX++01hcjaQ5Bwmq7+lgU4cU7WMsjkvL7TnnKaKthWVYokG629cPLX
         ERiDBuFPU9cbWKHpasjfDog4ablUeDkP42/FWjcEQKTfq/wsurisM45HptQd4ig65w
         Zi857XSkyaRmkx2IzoO+4CUI+kbzjGtueyjqV6m37Wpwa92pwv7VIVLa1U6XPKFXkf
         X0E0Ir2WiGrzHmNBK00zIpjUI3qbleV8a0GJaMgMNu/aILdyW0rbLEjhq3zuD6rUZR
         vnrUCDRuBrROpL6YBzwl90ZIB4LHlJ5cOudO+7N+nFXBgcuzig6MRxhlj59gxR2HZ7
         RQ/v1JbKMY2EA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE834E6BAC6;
        Tue,  1 Feb 2022 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] net: lan966x: Add PTP Hardward Clock support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164372581071.3866.12987877077214392601.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 14:30:10 +0000
References: <20220131100122.423164-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220131100122.423164-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk, richardcochran@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 31 Jan 2022 11:01:15 +0100 you wrote:
> Add support for PTP Hardware Clock (PHC) for lan966x. The switch supports
> both PTP 1-step and 2-step modes.
> 
> v1->v2:
> - fix commit messages
> - reduce the scope of the lock ptp_lock inside the function
>   lan966x_ptp_hwtstamp_set
> - the rx timestamping is always enabled for all packages
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] dt-bindings: net: lan966x: Extend with the ptp interrupt
    https://git.kernel.org/netdev/net-next/c/2f92512e1c52
  - [net-next,v2,2/7] net: lan966x: Add registers that are use for ptp functionality
    https://git.kernel.org/netdev/net-next/c/d700dff41d92
  - [net-next,v2,3/7] net: lan966x: Add support for ptp clocks
    https://git.kernel.org/netdev/net-next/c/d096459494a8
  - [net-next,v2,4/7] net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
    https://git.kernel.org/netdev/net-next/c/735fec995b21
  - [net-next,v2,5/7] net: lan966x: Update extraction/injection for timestamping
    https://git.kernel.org/netdev/net-next/c/77eecf25bd9d
  - [net-next,v2,6/7] net: lan966x: Add support for ptp interrupts
    https://git.kernel.org/netdev/net-next/c/e85a96e48e33
  - [net-next,v2,7/7] net: lan966x: Implement get_ts_info
    https://git.kernel.org/netdev/net-next/c/966f2e1a4a34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


