Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1923439E88F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhFGUmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhFGUl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B041B61153;
        Mon,  7 Jun 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623098407;
        bh=gHuCtipgI2q1I0zjV2FdCI0c5o2XlIfwzzPl815MSqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FbW3Gl+2czTxklICjC8DpfDpmIk5f4J4k9oKyVWxnuktbisNLwQlk0JpHOxGAtX65
         VoTqQ9EXSF9BcWQIfoP6MwT1ISy0W0Sqwc5k3wgrR34E7SNAn7aceAE9I5ddbMmmVA
         QnWc3D8WNx0Oafg6dkSbrEcHpcHUAPUVtjSm5Tl3Vuj/QGXM+XXTdPyre3Pj0F3eh+
         UOL1s22tl6RqFi3oYVg6A7VD+KxQO1BfI0KWSQ3rU8kl88XZGz7r/RFsZWMoEGVjfE
         6fcBDTYCiCK6YpYi0mu9r2wNXrxKmORESZwPtqiJwE5hEv0xz+Vi644PSqvWRzBAI0
         Xn0Iggm79ji1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A8D8E60A16;
        Mon,  7 Jun 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/8] port asix ax88772 to the PHYlib
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309840768.17620.18116264543013097296.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:40:07 +0000
References: <20210607082727.26045-1-o.rempel@pengutronix.de>
In-Reply-To: <20210607082727.26045-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  7 Jun 2021 10:27:19 +0200 you wrote:
> changes v2:
> - add Reviewed-by: Andrew Lunn <andrew@lunn.ch> to some patches
> - refactor asix_read_phy_addr() and add error handling for all callers
> - refactor asix_mdio_bus_read()
> 
> Port ax88772 part of asix driver to the phylib to be able to use more
> advanced external PHY attached to this controller.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/8] net: usb: asix: ax88772_bind: use devm_kzalloc() instead of kzalloc()
    https://git.kernel.org/netdev/net-next/c/218d154f540a
  - [net-next,v2,2/8] net: usb: asix: refactor asix_read_phy_addr() and handle errors on return
    https://git.kernel.org/netdev/net-next/c/7e88b11a862a
  - [net-next,v2,3/8] net: usb/phy: asix: add support for ax88772A/C PHYs
    https://git.kernel.org/netdev/net-next/c/dde258469257
  - [net-next,v2,4/8] net: usb: asix: ax88772: add phylib support
    https://git.kernel.org/netdev/net-next/c/e532a096be0e
  - [net-next,v2,5/8] net: usb: asix: ax88772: add generic selftest support
    https://git.kernel.org/netdev/net-next/c/34a1dee6bc44
  - [net-next,v2,6/8] net: usb: asix: add error handling for asix_mdio_* functions
    https://git.kernel.org/netdev/net-next/c/d275afb66371
  - [net-next,v2,7/8] net: phy: do not print dump stack if device was removed
    https://git.kernel.org/netdev/net-next/c/06edf1a940be
  - [net-next,v2,8/8] usbnet: run unbind() before unregister_netdev()
    https://git.kernel.org/netdev/net-next/c/2c9d6c2b871d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


