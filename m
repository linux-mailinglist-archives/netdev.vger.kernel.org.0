Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623E04617A3
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242247AbhK2OPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbhK2ONr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:13:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202BFC08EADE;
        Mon, 29 Nov 2021 04:50:10 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFE626144B;
        Mon, 29 Nov 2021 12:50:09 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 288FD6056B;
        Mon, 29 Nov 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638190209;
        bh=5V7lYTDKX2swQPFzu+N1CLGQVf0hXKiXJWB/l+UN31I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qXrkaO9BiEKP2MdIxGGw/WQ+9YQ0dbGGvYWiwqahg+pSJU2jOdAKDu/IG52vpCC2+
         Pyal78830GuzeqobCtUnwLGq2n6/SA5Pebimfw1xOQZ3KNrcFSEu+OzUo2pAWtGwtN
         TWliN4eYyL/6NT/pQsGEUK1qN8efpOXUHWCDNBhXQpQwIOFZf/QZIoaarZPWXlYS5W
         uIq9XtXc4L/8tYpyvRzadGZbOkE1GhfTi67YAWyFqiYDW8Pf85C9GQa/iRI1j52Y+X
         rYXJ9WHbF+rRt17hOfm8eK5HaxQ6F5qP7ktMT7JLRU0ZKFWpwbm2wmAYLYAy6touwJ
         ocozQiUGg5i2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1729260A5A;
        Mon, 29 Nov 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL
 instead of "0" if no IRQ is available
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819020909.1533.3070032856854739598.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:50:09 +0000
References: <20211127104707.2546-1-schuchmann@schleissheimer.de>
In-Reply-To: <20211127104707.2546-1-schuchmann@schleissheimer.de>
To:     Sven Schuchmann <schuchmann@schleissheimer.de>
Cc:     john.efstathiades@pebblebay.com, kuba@kernel.org, andrew@lunn.ch,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 27 Nov 2021 11:47:07 +0100 you wrote:
> On most systems request for IRQ 0 will fail, phylib will print an error message
> and fall back to polling. To fix this set the phydev->irq to PHY_POLL if no IRQ
> is available.
> 
> Fixes: cc89c323a30e ("lan78xx: Use irq_domain for phy interrupt from USB Int. EP")
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Sven Schuchmann <schuchmann@schleissheimer.de>
> 
> [...]

Here is the summary with links:
  - [v2] net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available
    https://git.kernel.org/netdev/net/c/817b653160db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


