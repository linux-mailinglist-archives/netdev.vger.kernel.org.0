Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2E931957A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhBKWAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhBKWAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 15AE864DEE;
        Thu, 11 Feb 2021 22:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613080808;
        bh=Eh+d0Fg9CEUYXI9ZS5DPAtDRJV4pM5Lhvl59b/LQM0g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JhJDaHhWhKDamw7uhLfAF0uOaD9yeMITFxcGnJTV0uBHFZOb5pxNiuUkXEqCaeJM2
         Jtw8ZeQEqxVX0MfDIRJqVJ+2HIVZ9FzKJUVKtfAjy1NDEr8XBV2cebHBp87UXkC5yQ
         Hif4X+bP/B0PxUr7XP0B3QojjlVZADP8IOooaEVKr9yq3e3yoyAi+mFsgLyUoJaEEu
         aiwU8UQfJmzpPUy1Y1ZfPEVg3Df5bFLn6xd9QFmMAS2EKtFefrTWZAtu8oAIpE0KjI
         XXRNYB1o4KHTwVJ+E4uBNECw0SZ86iX7hZjov62FC9pVi+J8fRCCAENhoRsw8yVJry
         7MyCUFcNv3mMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01885609D6;
        Thu, 11 Feb 2021 22:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] add HSR offloading support for DSA switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308080800.27128.4389313712067341849.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:00:08 +0000
References: <20210210010213.27553-1-george.mccollister@gmail.com>
In-Reply-To: <20210210010213.27553-1-george.mccollister@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tobias@waldekranz.com,
        corbet@lwn.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  9 Feb 2021 19:02:09 -0600 you wrote:
> Add support for offloading HSR/PRP (IEC 62439-3) tag insertion, tag
> removal, forwarding and duplication on DSA switches.
> This series adds offloading to the xrs700x DSA driver.
> 
> Changes since RFC:
>  * Split hsr and dsa patches. (Florian Fainelli)
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] net: hsr: generate supervision frame without HSR/PRP tag
    https://git.kernel.org/netdev/net-next/c/78be9217c401
  - [net-next,v3,2/4] net: hsr: add offloading support
    https://git.kernel.org/netdev/net-next/c/dcf0cd1cc58b
  - [net-next,v3,3/4] net: dsa: add support for offloading HSR
    https://git.kernel.org/netdev/net-next/c/18596f504a3e
  - [net-next,v3,4/4] net: dsa: xrs700x: add HSR offloading support
    https://git.kernel.org/netdev/net-next/c/bd62e6f5e6a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


