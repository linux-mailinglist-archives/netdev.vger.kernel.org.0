Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AEF39E782
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhFGTb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230261AbhFGTb4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 15:31:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 360A361130;
        Mon,  7 Jun 2021 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623094205;
        bh=bGfrNQ3DtHesrIaJvcgyjd0KjeCXIbm0dla0dqkrS6Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hd5tVHsw6QZb3E/6XWRDyQpSe+0Pfmgn0WCOqd5NMt4cKZiDUgVcVzng+MVxKocZA
         Ut8pGRiD8X6w6jTEt3gVz0S2suQCQE8wTl0c9fezpx7TpixiKlFSe+TZUjfqYV4xaS
         NpXK5HMNPqKMCdT/OxakzpJfmkVAZCyYRZ1YI7vDc0bKnlSkiGhTeNXio4SajYkZPz
         aoK1VdbdtcyLHxI+r5O0daWojDu69TxC7tztYXA+8d5Ahuv01y7REGm0FSC/UVRxze
         Un1CkrB4t9E0Pp+MaS4FhewocuHovyT4OFYrzBByu4+aIpFQRFxTDKKG0vIsz6M3Mh
         swA8ZKZkkp38g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2853460A54;
        Mon,  7 Jun 2021 19:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/4] Convert NXP SJA1105 DSA driver to YAML
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309420515.18633.12069881649313693934.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 19:30:05 +0000
References: <20210604140151.2885611-1-olteanv@gmail.com>
In-Reply-To: <20210604140151.2885611-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, robh+dt@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  4 Jun 2021 17:01:47 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is an attempt to convert the SJA1105 driver to the YAML schema.
> 
> The SJA1105 driver has some custom device tree properties which caused
> validation problems in the previous attempt:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210531234735.1582031-1-olteanv@gmail.com/
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/4] net: phy: introduce PHY_INTERFACE_MODE_REVRMII
    https://git.kernel.org/netdev/net-next/c/c858d436be8b
  - [v2,net-next,2/4] net: dsa: sja1105: apply RGMII delays based on the fixed-link property
    https://git.kernel.org/netdev/net-next/c/29afb83ac98e
  - [v2,net-next,3/4] net: dsa: sja1105: determine PHY/MAC role from PHY interface type
    https://git.kernel.org/netdev/net-next/c/5d645df99ac6
  - [v2,net-next,4/4] dt-bindings: net: dsa: sja1105: convert to YAML schema
    https://git.kernel.org/netdev/net-next/c/62568bdbe6f6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


