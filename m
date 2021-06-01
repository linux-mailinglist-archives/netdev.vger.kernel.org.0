Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C50A396D04
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhFAFvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232972AbhFAFvr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:51:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 588ED613B1;
        Tue,  1 Jun 2021 05:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622526606;
        bh=Wdj8wIBJxsodkxBqNDmGFQDJczP+3OnWP0cnZj+KBvM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pMBVX4Dke7OrY9BcXvz7PUMRQyhcnP1ZjCRhBULBzGqwxP6Ez77i38V5S3ZeSwNrB
         mATASxmHEsBZsy8N4PSAn0mcLu7MF2VjIyjO2EDoFnVpnMGz/c3WH4L9LWF5NbpQ/x
         nPPxYpdVQYbxduEyhqFZbmpcmeumKnANn01hXhmN5czInwm/iv224URy1CNYbNgPfv
         BOv361N3Zr192XK+SgAipuziPTUhi8ifRpGtYXgPn/FQvUh2VZYzOrQIsTqj/l31vQ
         3CxFePpxQkFuSyA+tk4nyyPgtP+0KzIN7hNJfr2dPUKIkMQCAMU+D3i8v9kgnGd+IU
         VCy47rjkOfLTw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4DD7360A22;
        Tue,  1 Jun 2021 05:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/8] Part 2 of SJA1105 DSA driver preparation for
 new switch introduction (SJA1110)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252660631.4642.16196572580128363008.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 05:50:06 +0000
References: <20210530225939.772553-1-olteanv@gmail.com>
In-Reply-To: <20210530225939.772553-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 31 May 2021 01:59:31 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series is a continuation of:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210524131421.1030789-1-olteanv@gmail.com/
> 
> even though it isn't the first time these patches are submitted (they
> were part of the group previously called "Add NXP SJA1110 support to the
> sja1105 DSA driver"):
> https://patchwork.kernel.org/project/netdevbpf/cover/20210526135535.2515123-1-vladimir.oltean@nxp.com/
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/8] net: dsa: sja1105: be compatible with "ethernet-ports" OF node name
    https://git.kernel.org/netdev/net-next/c/15074a361fee
  - [v3,net-next,2/8] net: dsa: sja1105: allow SGMII PCS configuration to be per port
    https://git.kernel.org/netdev/net-next/c/84db00f2c043
  - [v3,net-next,3/8] net: dsa: sja1105: the 0x1F0000 SGMII "base address" is actually MDIO_MMD_VEND2
    https://git.kernel.org/netdev/net-next/c/4c7ee010cf75
  - [v3,net-next,4/8] net: dsa: sja1105: cache the phy-mode port property
    https://git.kernel.org/netdev/net-next/c/bf4edf4afb87
  - [v3,net-next,5/8] net: dsa: sja1105: add a PHY interface type compatibility matrix
    https://git.kernel.org/netdev/net-next/c/91a050782cbf
  - [v3,net-next,6/8] net: dsa: sja1105: add a translation table for port speeds
    https://git.kernel.org/netdev/net-next/c/41fed17fdbe5
  - [v3,net-next,7/8] net: dsa: sja1105: always keep RGMII ports in the MAC role
    https://git.kernel.org/netdev/net-next/c/f41fad3cb8b7
  - [v3,net-next,8/8] net: dsa: sja1105: some table entries are always present when read dynamically
    https://git.kernel.org/netdev/net-next/c/96c85f51f123

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


