Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C67E3F4A2F
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 14:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbhHWMAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 08:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236440AbhHWMAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 08:00:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1EAC561378;
        Mon, 23 Aug 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629720006;
        bh=Me86FB2P8TqMfrSH9A0jCWGiH+pSOryxC/uaIpdWwFk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F+Jul0elTL90fD0vytxGkPiut+4Q+g1mmikzX4ic1EYUkx2t8nEsiM5o86twJyYhK
         rB2bsAIArfg8J1PAdWQbbpFdw3E6klzKLdGMlcFWTnSwk1AY3BYwTxaoMZXDoU6vqU
         /V2yx3PoAVG40NKl9aOtp9C7zsUQcMQD6EAmu/sDJRrjzAj1B5BAV8XtFVHgHJqQLl
         f8jJIrrw/ceVbQtZ5sOcqVhw0xltDsJqBUuIao8YPtkK+7k/dMGSmdcjk5ACXMspT7
         Wa9YZOjQdYoYs6Vfl+KgWSAqLz1FugFNkJX/E7Ct9k21zV5vQV3tnE1keN8OAIF4Sg
         vAsVl13fkuInw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 114EB609ED;
        Mon, 23 Aug 2021 12:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] asix fixes 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162972000606.531.11817848524482218971.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 12:00:06 +0000
References: <20210823073748.22384-1-o.rempel@pengutronix.de>
In-Reply-To: <20210823073748.22384-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 23 Aug 2021 09:37:46 +0200 you wrote:
> changes v2:
> - rebase against current net
> - add one more fix for the ax88178 variant
> 
> Oleksij Rempel (2):
>   net: usb: asix: ax88772: move embedded PHY detection as early as
>     possible
>   net: usb: asix: do not call phy_disconnect() for ax88178
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: usb: asix: ax88772: move embedded PHY detection as early as possible
    https://git.kernel.org/netdev/net/c/7a141e64cf14
  - [net,v2,2/2] net: usb: asix: do not call phy_disconnect() for ax88178
    https://git.kernel.org/netdev/net/c/1406e8cb4b05

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


