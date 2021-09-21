Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D6A4133A5
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 15:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhIUNBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 09:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhIUNBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 09:01:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D353E6109E;
        Tue, 21 Sep 2021 13:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632229206;
        bh=afuelZ0mDk8o98TQu5CD6xMPqi0ZYEVN8DEyTwDKTGo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nweRsb+Vga6MJHueyAImhZCHyLKMNGt+fHOV2Q3AsmapSaLAgjx6XQl3fMoxRSWAu
         e1GBRlJVJzPlTc6Q/UiHSTPP6IH2NPY3+PifdI8jrEEFWO31z7ZRbVi2aiomYnO0JU
         pu6PiymVyEGs3nWLXLJPwHyhaOLzW08CK3jFLFBrFaz7z7AVgg5fpwb2KKawF06j60
         /SRTahGRibkMZmPAhP1m63lQTexMXYXwk6Q65TbPDulKOAsJ8T7vpTxW1NcGE97bpB
         +rULtC2Mw9+SphfFcqbR2C2Y7RlyaBO/0lYn4KCZaWRFIOPo413lx1Nd3M6y5Kp1c7
         ZRQpNrSASEJiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C185660A6B;
        Tue, 21 Sep 2021 13:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Fix mdiobus users with devres
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163222920678.21952.11910181167162155116.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Sep 2021 13:00:06 +0000
References: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, bgolaszewski@baylibre.com,
        wsa@kernel.org, linux-i2c@vger.kernel.org, broonie@kernel.org,
        linux-spi@vger.kernel.org, alsi@bang-olufsen.dk,
        LinoSanfilippo@gmx.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 21 Sep 2021 00:42:07 +0300 you wrote:
> Commit ac3a68d56651 ("net: phy: don't abuse devres in
> devm_mdiobus_register()") by Bartosz Golaszewski has introduced two
> classes of potential bugs by making the devres callback of
> devm_mdiobus_alloc stop calling mdiobus_unregister.
> 
> The exact buggy circumstances are presented in the individual commit
> messages. I have searched the tree for other occurrences, but at the
> moment:
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: dsa: don't allocate the slave_mii_bus using devres
    https://git.kernel.org/netdev/net/c/5135e96a3dd2
  - [net,2/2] net: dsa: realtek: register the MDIO bus under devres
    https://git.kernel.org/netdev/net/c/74b6d7d13307

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


