Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FB03616A1
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 02:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbhDPAAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 20:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235833AbhDPAAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 20:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1F0DF6115B;
        Fri, 16 Apr 2021 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618531210;
        bh=Hf4YArPG399Sc7AWzaJQwig0C8OdaI6+X2QW2WjTZqw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fc9ybXexSpu8RIO+g2HFXXHzFlWVR7KmS3ORfNRYmTt5jU7X8ucNZA6iarxL9I1dD
         yFybp+79ymvyV0W2UN4dlDZfiTUJrPEAak9tDkop5AD1sn2jFtxJEt2eQZXAgnoPcD
         /jpioTaTbVORP38Jpa2GDtp2nL+/A8YsoX0rD6d4Olxva5vO9i51kTuHYIZW36V9uG
         qQo2mF0I3Ce3D+M9hL6CtKM5ui33BykhToscjTYN7iFhi3Mrey3bppOlVjggFpPTLP
         13e6mrXDUYqD/e4RXyqotnCgm99VtUNhqlcc8Pa+rC+6y0VqBXViuFZCCPcmP143AD
         9SiXzk3M6GSLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 12FFD60CD6;
        Fri, 16 Apr 2021 00:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: at803x: select correct page on config
 init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161853121007.2137.13987324820655160329.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 00:00:10 +0000
References: <20210415012650.9825-1-mail@david-bauer.net>
In-Reply-To: <20210415012650.9825-1-mail@david-bauer.net>
To:     David Bauer <mail@david-bauer.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Apr 2021 03:26:50 +0200 you wrote:
> The Atheros AR8031 and AR8033 expose different registers for SGMII/Fiber
> as well as the copper side of the PHY depending on the BT_BX_REG_SEL bit
> in the chip configure register.
> 
> The driver assumes the copper side is selected on probe, but this might
> not be the case depending which page was last selected by the
> bootloader. Notably, Ubiquiti UniFi bootloaders show this behavior.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: at803x: select correct page on config init
    https://git.kernel.org/netdev/net-next/c/c329e5afb42f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


