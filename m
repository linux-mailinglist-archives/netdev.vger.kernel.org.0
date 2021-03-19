Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE74342634
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCSTac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229956AbhCSTaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 15:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1821761962;
        Fri, 19 Mar 2021 19:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616182209;
        bh=ua/jo6CrOObOcJJoxNVoUi0aC/WCBwUK3uFVl95EiJ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a+BQALRBi7PBgl50nDKRqF2dRF7FMbToONcnX8jNVnCfvtS7vmX1SmZfvlsFCgZu1
         o8ixkeMAVYsZ85pkFSvGMAd5eu0R7QkISKybcdQsFsNHg71OaF+pxO/dV82LIfHEFz
         6mzyqt4XotguNhrwIaOfgD60rcye7ZbP88TliSY6kHIfj26pV1nOZBkd/hYUtpiwgL
         ESP2xtCNc4Yf/3xxK0iTXdpABbSXLnq+8RKq16b3o2aDZ37fIUOQVDGndNUtWtUyBm
         Yv/o7G0kEwGWSUoyZJjX5NiCws5t4s/1r2VlnKJsNfr8ydP1COK8nvl75p55SOMd6x
         8C1we0/IGyMyw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 049DA60A0B;
        Fri, 19 Mar 2021 19:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] Fixes applied to VCS8584 family
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618220901.9737.17080854366848880553.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 19:30:09 +0000
References: <20210319132905.9846-1-bjarni.jonasson@microchip.com>
In-Reply-To: <20210319132905.9846-1-bjarni.jonasson@microchip.com>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, atenart@kernel.org,
        f.fainelli@gmail.com, vladimir.oltean@nxp.com,
        ioana.ciornei@nxp.com, michael@walle.cc, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 19 Mar 2021 14:29:02 +0100 you wrote:
> Three different fixes applied to VSC8584 family:
> 1. LCPLL reset
> 2. Serdes calibration
> 3. Coma mode disabled
> 
> The same fixes has already been applied to VSC8514
> and most of the functionality can be reused for the VSC8584.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: phy: mscc: Applying LCPLL reset to VSC8584
    https://git.kernel.org/netdev/net-next/c/df4771783d64
  - [net-next,v2,2/3] net: phy: mscc: improved serdes calibration applied to VSC8584
    https://git.kernel.org/netdev/net-next/c/23d12335752f
  - [net-next,v2,3/3] net: phy: mscc: coma mode disabled for VSC8584
    https://git.kernel.org/netdev/net-next/c/36d021d1049f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


