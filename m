Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725E333DC79
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239983AbhCPSUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239930AbhCPSUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 14:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 16F7465140;
        Tue, 16 Mar 2021 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615918809;
        bh=WC6zuw4ZSNJO/RKRPqzlquG9bercuNoH/LtZr9g/xLg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cnxr9rpJOQxjei2S5scOjImMq8ckrHFhu8Iu6tQVhGkTOaoFUZA9BQ6/B9Q/G7DNo
         xVIVxwchu0cUk84RkWanUJTtRzfyABKViG8tKv66ZjiFIiyY7UsJVGalw/A0L3gN+1
         Nv0AGh2HliV4SgW+UN96kP/UnIlhGp9iLWRtFMcU5ixAOXCJiTUIKvQKoVlzVLMMZQ
         8ToaZxFzdFDQOaYM97UeWAPX9QwR9XolwNqrojeM6bMo8BRDJ+Ce5Ujt2pU6DQkVYo
         pzMSPG0mcGHUA5mXSmPCgmAcY5xndUnaaPocyaPyGo5hLhn9sVQtYcIXEBQysut8Eg
         bzL/xhe2NRn1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0AFEF60A60;
        Tue, 16 Mar 2021 18:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mdio: Alphabetically sort header inclusion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161591880904.7330.64380807872631289.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 18:20:09 +0000
References: <20210315104905.8683-1-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210315104905.8683-1-calvin.johnson@oss.nxp.com>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, opendmb@gmail.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        iyappan@os.amperecomputing.com, kuba@kernel.org,
        keyur@os.amperecomputing.com, quan@os.amperecomputing.com,
        rjui@broadcom.com, linux@armlinux.org.uk, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Mar 2021 16:19:05 +0530 you wrote:
> Alphabetically sort header inclusion
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
>  drivers/net/mdio/mdio-bcm-unimac.c      | 16 +++++++---------
>  drivers/net/mdio/mdio-bitbang.c         |  4 ++--
>  drivers/net/mdio/mdio-cavium.c          |  2 +-
>  drivers/net/mdio/mdio-gpio.c            | 10 +++++-----
>  drivers/net/mdio/mdio-ipq4019.c         |  4 ++--
>  drivers/net/mdio/mdio-ipq8064.c         |  4 ++--
>  drivers/net/mdio/mdio-mscc-miim.c       |  8 ++++----
>  drivers/net/mdio/mdio-mux-bcm-iproc.c   | 10 +++++-----
>  drivers/net/mdio/mdio-mux-gpio.c        |  8 ++++----
>  drivers/net/mdio/mdio-mux-mmioreg.c     |  6 +++---
>  drivers/net/mdio/mdio-mux-multiplexer.c |  2 +-
>  drivers/net/mdio/mdio-mux.c             |  6 +++---
>  drivers/net/mdio/mdio-octeon.c          |  8 ++++----
>  drivers/net/mdio/mdio-thunder.c         | 10 +++++-----
>  drivers/net/mdio/mdio-xgene.c           |  6 +++---
>  drivers/net/mdio/of_mdio.c              | 10 +++++-----
>  16 files changed, 56 insertions(+), 58 deletions(-)

Here is the summary with links:
  - net: mdio: Alphabetically sort header inclusion
    https://git.kernel.org/netdev/net-next/c/1bf343665057

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


