Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26124545AF
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbhKQLdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:33:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235203AbhKQLdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 06:33:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1B56763236;
        Wed, 17 Nov 2021 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637148612;
        bh=9NAWKiUPeaw8SPyXsy2T6rO5y9Fvz/XK5iqN1WAx2SY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MMYpEL2nGIV7Aw/0VwnZ+sAhkcpG72oqd3/aTrrRHwi/XJb4sxXRnNWyKpBEi6IRQ
         A4SDl9bzlLr4kYWDP3q248H3/kd4gDOjsYWjQoYOaLvei1BCEl8Zv8fK9rshz/h2rV
         mUEwPPcdQeVRUBShp6LBdvA4orjUvWwJbEgDCFtQxnylHxVZdyL+EBU3bCSLpFBqjk
         hNc7+H7h541KBOrWLJfF9nOz8QIg09EWOuygIVXH1z7oNeukk5cUUFIozW92nLuI8T
         iHce+lH5xTIByT/mLP8sxggY0qvEeXZQzYcOQ8xMxRAe2WkvhwJaiGC/5OYDvfUgTG
         +J6z5aH1SQkaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0F9BF60A4E;
        Wed, 17 Nov 2021 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: mtk_eth_soc: phylink validate
 implementation updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163714861205.14428.6218012722892751788.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 11:30:12 +0000
References: <YZOCn1vMUAbhq3j0@shell.armlinux.org.uk>
In-Reply-To: <YZOCn1vMUAbhq3j0@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     nbd@nbd.name, john@phrozen.org, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com, sean.wang@mediatek.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 10:06:23 +0000 you wrote:
> Hi,
> 
> This series converts mtk_eth_soc to fill in the supported_interfaces
> member of phylink_config, cleans up the validate() implementation, and
> then converts to phylink_generic_validate().
> 
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 111 ++++++----------------------
>  1 file changed, 24 insertions(+), 87 deletions(-)

Here is the summary with links:
  - [net-next,1/4] net: mtk_eth_soc: populate supported_interfaces member
    https://git.kernel.org/netdev/net-next/c/83800d29f0c5
  - [net-next,2/4] net: mtk_eth_soc: remove interface checks in mtk_validate()
    https://git.kernel.org/netdev/net-next/c/db81ca153814
  - [net-next,3/4] net: mtk_eth_soc: drop use of phylink_helper_basex_speed()
    https://git.kernel.org/netdev/net-next/c/71d927494463
  - [net-next,4/4] net: mtk_eth_soc: use phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/a4238f6ce151

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


