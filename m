Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECF13A0672
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbhFHVwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234788AbhFHVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 17:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 80DAD613BE;
        Tue,  8 Jun 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623189009;
        bh=7HaHqXDkQAaRmLuluhwhaz+pMlSPbe51C6w0nDiCRmU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iP6t6aRPlOFIxZCTjewUjpLHYg2kCRGviV1B752hTRLqurh/qmP6tWEmJ4d+uuM43
         tuYfk9J8LddEoRvbGDgNjxyY7FormTJT8aTH7jklV0QNnS6LraOKFC4XtBCxRSfehx
         SpaPgyaQ7cqU9rmCMbfPqJRzkXdG0qD4Cb57BUbQqRmcf4fMc/9bYNHR9HQZB5cWjn
         ow4tLwD2+kQD6efQ0MUQDab28jzz1RUso0mMW46I1FLwQu1Dcp0F1X4XnzIuyv+473
         uwVHj/Xr2dCFjiC/nWz4ZbmS1qippQDc/N7tKrSldCxRwOVQzzYb25HxO/4XRjmSax
         mKo7HlgmLMEiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7A558609E3;
        Tue,  8 Jun 2021 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/4] Add NXP SJA1110 support to the sja1105 DSA
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162318900949.8715.14591221292425232059.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 21:50:09 +0000
References: <20210608092538.3920217-1-olteanv@gmail.com>
In-Reply-To: <20210608092538.3920217-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 12:25:34 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The NXP SJA1110 is an automotive Ethernet switch with an embedded Arm
> Cortex-M7 microcontroller. The switch has 11 ports (10 external + one
> for the DSA-style connection to the microcontroller).
> The microcontroller can be disabled and the switch can be controlled
> over SPI, a la SJA1105 - this is how this driver handles things.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/4] dt-bindings: net: dsa: sja1105: add SJA1110 bindings
    https://git.kernel.org/netdev/net-next/c/070f5b701d55
  - [v3,net-next,2/4] net: dsa: sja1105: add support for the SJA1110 switch family
    https://git.kernel.org/netdev/net-next/c/3e77e59bf8cf
  - [v3,net-next,3/4] net: dsa: sja1105: make sure the retagging port is enabled for SJA1110
    https://git.kernel.org/netdev/net-next/c/ceec8bc0988d
  - [v3,net-next,4/4] net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX
    https://git.kernel.org/netdev/net-next/c/5a8f09748ee7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


