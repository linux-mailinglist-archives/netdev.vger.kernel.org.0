Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9323CFC7D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240043AbhGTN75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240000AbhGTNup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 41EEF6121F;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626791406;
        bh=tNus3u7mPyyuLS71m5DfbEdbP+v0iAfnJdlzLqCAAgs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G8g2goenTugCP3H0jogS2yVyzRiWvZ97SToitGUfyOeu75z4bGxYgG7ZI5DEOQYWT
         9UuWreuU3CXBdDamVkeS5O3xEV1tj5ykzea/vA+20zNn0oJ1uCvHCAQyUtj+vttfWy
         nAWmVIkEwDTMd5mkndDUjuw1USfifWQv/dDsT1uO6yJSWjg9jnDwt0QZ4+5IELjMIL
         GV/oSonB0XZ3AXs7ORMfdMyobN6UdcxhmdTtjcROYW6/Py6UKPD3hXp0Amui1nlKjv
         pWU8uZb92i+05mw3yPFTKUGyuMEabgP4WNGKIo9xuWJRkXZzxrlgS3gbPD2GeqJAnk
         J2Je63+kXGjXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33F5660CD3;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: add phy change pause mode debug
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679140620.23944.520450869114918919.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:30:06 +0000
References: <E1m5nia-0003Ml-Um@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1m5nia-0003Ml-Um@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 12:15:20 +0100 you wrote:
> Augment the phy link debug prints with the pause state.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: phylink: add phy change pause mode debug
    https://git.kernel.org/netdev/net-next/c/d34869b44a17

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


