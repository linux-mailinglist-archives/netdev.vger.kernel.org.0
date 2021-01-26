Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F943048D7
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388117AbhAZFj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbhAZDUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 22:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EAAE022AAC;
        Tue, 26 Jan 2021 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611631211;
        bh=0BYXnPwP/7+FDy+ACZrXbGfA1ZDJYTwE8vtnENsCVNQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F/7gZBD48vDK9w4c64ZBsQ03x7wkIpODzeFTv/nX6uTsAN0IYL3aQRIZfgACk7x0v
         ve2Rgg9PU4PTiRZhpCJ4mLIMttr6L/4dLszZtuZWqRgQvVACFvNIeFKclCnqgj6zQS
         qy2DqvAOtyLPaxc3kF8GqNJbqmi2UqBaEiH1PyAh6TGOyOpn1qoMmc/v1o2lRUzUUP
         Zyrhi6fG8zv35EDMh6IQzRE0E0njiFUNZ9Ll6Q3GTwXBNN5kJXwZm02Ltv4rMDbWgB
         brHPZ2y+DJv5IgZc9J/jTznH9osmA6lZcQaw6P0bHTmcYOxPfFI77vIFmMYo2OcBT/
         Sbf2Lsst+JKMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DAF8461E41;
        Tue, 26 Jan 2021 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] dsa: add MT7530 GPIO support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161163121089.4087.613122174827769113.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jan 2021 03:20:10 +0000
References: <20210125044322.6280-1-dqfext@gmail.com>
In-Reply-To: <20210125044322.6280-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, matthias.bgg@gmail.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, p.zabel@pengutronix.de,
        linux@armlinux.org.uk, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, frank-w@public-files.de,
        opensource@vdorst.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 12:43:20 +0800 you wrote:
> MT7530's LED controller can be used as GPIO controller. Add support for
> it.
> 
> DENG Qingfang (2):
>   dt-bindings: net: dsa: add MT7530 GPIO controller binding
>   net: dsa: mt7530: MT7530 optional GPIO support
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] dt-bindings: net: dsa: add MT7530 GPIO controller binding
    https://git.kernel.org/netdev/net-next/c/974d5ba60df7
  - [net-next,v2,2/2] net: dsa: mt7530: MT7530 optional GPIO support
    https://git.kernel.org/netdev/net-next/c/429a0edeefd8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


