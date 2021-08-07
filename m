Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC143E3425
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 10:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhHGIkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 04:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231509AbhHGIkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 04:40:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E8449610A6;
        Sat,  7 Aug 2021 08:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628325606;
        bh=sax0nwzMW0QK0S6OTM/6c4GU4567Go1ED9HkiK5WUoo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bRjiGDwroeDwdPxt/6Tecq3dIcteakL25F5xwTwc8JKbjFRNtD2ZwneX25Gh0d5vp
         c3u4/2Lfco25Ui5u8E2joqQE8mcQjOh6vDG6Abs/sPo8l4Wb2S3/i14ZODW4+X/LsR
         SXnJoLRn4d46o0v3qxqZlnbK34jRWmS75oRHBG8RB7oru765q5DkAQlHop2mjN4hdB
         mGnG6Fmjs1ZqhBO3e3UnpB5G1sBD5b/neTfozlYDAMEyfq/eHTwOw0XdGMpOlgJuKp
         mN93zVFA6e3F8R+J7NENq2g41hJc0KKZqjNz6oxM0vPXv22f/vY2396m6f9DVs7f1I
         TKUPkYXvYf83Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D7AF760A94;
        Sat,  7 Aug 2021 08:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 1/1] net: dsa: qca: ar9331: make proper initial port
 defaults
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162832560587.30769.3952932254667872373.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Aug 2021 08:40:05 +0000
References: <20210806094723.19221-1-o.rempel@pengutronix.de>
In-Reply-To: <20210806094723.19221-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  6 Aug 2021 11:47:23 +0200 you wrote:
> Make sure that all external port are actually isolated from each other,
> so no packets are leaked.
> 
> Fixes: ec6698c272de ("net: dsa: add support for Atheros AR9331 built-in switch")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/qca/ar9331.c | 73 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 72 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net,v3,1/1] net: dsa: qca: ar9331: make proper initial port defaults
    https://git.kernel.org/netdev/net/c/47fac45600aa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


