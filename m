Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B900F4349D1
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhJTLMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230180AbhJTLM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 07:12:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E1B5761409;
        Wed, 20 Oct 2021 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634728212;
        bh=l1SO9g7J0R9qXSU4ykxOIJIFyZ31oiOl7zV4A6VDNJM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bL5cDKjvGYfeW6uPXuVgWYj5PJK+HwPv7cXc8tbt7gVi820qssPhM9GlDTbMmEYXR
         vGgMjEDBFin/5x1ce9ucEZ0XXarCc0hdCNbqolwgkfFOKF8qY6g7CeevOdFaRsUpXm
         R2h2kluS2TQfu+vZFiZvDrHrVN20hCPnYyaRdlypiyJaitMYyB8xt32yzzr+n9W8/Y
         B7ZIPulB+VETIWVb6TzHF49l3GLrwrLDBDwLcCRs7yTrERb6qpE2/nbtyWPTF+9UKf
         EZNH/3vBk/aDDcViDnJxxi6RHxORnH5dp/ZytJ+HJDv9IYilRK28u5bD4QWCL/uINA
         TPpUuPRta5Asw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D659560A47;
        Wed, 20 Oct 2021 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] New RGMII delay DT bindings for the SJA1105 DSA
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163472821287.2036.7867829179866355496.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 11:10:12 +0000
References: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, prasanna.vengateshan@microchip.com,
        ansuelsmth@gmail.com, alsi@bang-olufsen.dk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Oct 2021 22:29:48 +0300 you wrote:
> During recent reviews I've been telling people that new MAC drivers
> should adopt a certain DT binding format for RGMII delays in order to
> avoid conflicting interpretations. Some suggestions were better received
> than others, and it appears we are still far from a consensus.
> 
> Part of the problem seems to be that there are still drivers that apply
> RGMII delays based on an incorrect interpretation of the device tree,
> and these serve as a bad example for others.
> I happen to maintain one of those drivers and I am able to test it, so I
> figure that one of the ways in which I can make a change is to stop
> providing a bad example.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] dt-bindings: net: dsa: sja1105: fix example so all ports have a phy-handle of fixed-link
    https://git.kernel.org/netdev/net-next/c/7a414b6e1a1c
  - [net-next,2/4] dt-bindings: net: dsa: inherit the ethernet-controller DT schema
    https://git.kernel.org/netdev/net-next/c/e00eb643324c
  - [net-next,3/4] dt-bindings: net: dsa: sja1105: add {rx,tx}-internal-delay-ps
    https://git.kernel.org/netdev/net-next/c/ac41ac81e331
  - [net-next,4/4] net: dsa: sja1105: parse {rx, tx}-internal-delay-ps properties for RGMII delays
    https://git.kernel.org/netdev/net-next/c/9ca482a246f0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


