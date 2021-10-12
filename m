Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3389642A224
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhJLKcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235153AbhJLKcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 06:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A129861100;
        Tue, 12 Oct 2021 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634034606;
        bh=5vYqtrhdvNEvXIHmpJjLVPqr54kR5V2eucOYXFMDoX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NbNGcoldHtqcYHd1YzNOFgU/17cKxn1kPcCmCEGib0vrxYJOSTaz6+KwYx2V4LfDQ
         N3g+CVFIkviG4pVJ7rTXstqJeEPt5v11gKTXqXeuYoqRbwPXJ2XgT2THEqiJj2VF8b
         71Nh9EwVjtFX34S3wHbnz9NhiaNJ6EwSbG+VBg3kkbTBr9682pFM/qNsUhEX26FXPU
         CmHBHWdppbwsLRQqmGpgpt/8IRv0SdcegYX7Q5UsqXwe1XCRZurPX97NyGW2ubBC6a
         7bvj6NPJyzOvX4Ddg/fmM+4lZiz2Y2n2gbbGRfDZbRid0F0Oym7M86avzKWDTX+1BM
         9HYs9uCMPnxWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9467760965;
        Tue, 12 Oct 2021 10:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mscc: ocelot: Fix dumplicated argument in ocelot
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163403460660.20758.17907661038717928533.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Oct 2021 10:30:06 +0000
References: <20211011022742.3211-1-wanjiabing@vivo.com>
In-Reply-To: <20211011022742.3211-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 11 Oct 2021 10:27:41 +0800 you wrote:
> Fix the following coccicheck warning:
> drivers/net/ethernet/mscc/ocelot.c:474:duplicated argument to & or |
> drivers/net/ethernet/mscc/ocelot.c:476:duplicated argument to & or |
> drivers/net/ethernet/mscc/ocelot_net.c:1627:duplicated argument
> to & or |
> 
> These DEV_CLOCK_CFG_MAC_TX_RST are duplicate here.
> Here should be DEV_CLOCK_CFG_MAC_RX_RST.
> 
> [...]

Here is the summary with links:
  - net: mscc: ocelot: Fix dumplicated argument in ocelot
    https://git.kernel.org/netdev/net/c/74a3bc42fe51

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


