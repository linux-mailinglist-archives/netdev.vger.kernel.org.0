Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BC73F2D44
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbhHTNkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229829AbhHTNkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:40:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C4366113D;
        Fri, 20 Aug 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629466808;
        bh=UFBUTq618TtcT/YxIm+dN6KV327WLqIO20nJD/ctcrw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K7AkTc9fUV/DtKSg6u7P9JaEm4ExgE+UV7xzaPgP3NHtswl5kmlov1q3JAQ3UmzTd
         Jy27h8HTUK9vwfGYlIfcWqQvsIWgxZ3XmviVj7nDi4elvp543UHnxtFQg9ViPxCxDF
         0zV5pTXTGF5gQrf55RmqX6Q/yMiUt+Cx9AtZIm2UWrhB3d7Ukbqqd5u/myPB7Dde1z
         viwxCXqcw7pq6rdN31f3cRiyLXG21sBZ1DlLldsYyFjm2t/p9ka9TqdFvAR+LCuoS4
         NM/sXmA/kmJRgL6V//1tRCDMKeOL4tHOEJToW71nGoJZ/y5x8TZFmOTvMD46Mbe3U8
         P7jnKoy1YQNXQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 918C260A50;
        Fri, 20 Aug 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] Adding Frame DMA functionality to Sparx5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946680859.23508.488868985364862077.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 13:40:08 +0000
References: <20210819073940.1589383-1-steen.hegelund@microchip.com>
In-Reply-To: <20210819073940.1589383-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@bootlin.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Aug 2021 09:39:38 +0200 you wrote:
> v2:
>     Removed an unused variable (proc_ctrl) from sparx5_fdma_start.
> 
> This add frame DMA functionality to the Sparx5 platform.
> 
> Until now the Sparx5 SwitchDev driver has been using register based
> injection and extraction when sending frames to/from the host CPU.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: sparx5: switchdev: adding frame DMA functionality
    https://git.kernel.org/netdev/net-next/c/10615907e9b5
  - [net-next,v2,2/2] arm64: dts: sparx5: Add the Sparx5 switch frame DMA support
    https://git.kernel.org/netdev/net-next/c/920c293af8d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


