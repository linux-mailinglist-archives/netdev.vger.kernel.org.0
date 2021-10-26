Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CF243B3D6
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbhJZOWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236478AbhJZOWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 60AB7610A1;
        Tue, 26 Oct 2021 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635258008;
        bh=KiH3TsRr0KmzuDwQGBL7j8vBUP5+4L0wOf/Hy4MQ0lU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NzutWYr4E1Kq+J9QI5kWMC8Y/n6CbdquPDiM1P70F8V+OME5Jx983t5o2a7ZediV2
         g6x/27EpEEFE0SdZiVARHbJanPTsTtvuEm4MCuRTqEXmXZwYKLOtFm03wNj4Gt8IZb
         XJ9emA+DHx49tqCmhQQyGwuRMeqxfpkGXwMoDn8Ki3OAnCgW8d67dwszgQbEZHNE2z
         N7t0xG5rEF+RNYonkK5lzHaCsJovSnfJrlspdF3Ihe7fyOn/ZlgjABOrwHsci8CKAh
         5y/691Icr7wTtDwRQ7vFSLBsYiUUnU7LGXkdXDdwnQll5ZtZ7ftzkF5lYpUxuLCtR4
         SzLQkfRA/Ghtw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 56F78608FE;
        Tue, 26 Oct 2021 14:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Introduce supported interfaces bitmap
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525800835.18574.4489238669469918667.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 14:20:08 +0000
References: <YXfS8K/7c14UFIyq@shell.armlinux.org.uk>
In-Reply-To: <YXfS8K/7c14UFIyq@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, sean.anderson@seco.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 11:05:36 +0100 you wrote:
> This series introduces a new bitmap to allow us to indicate which
> phy_interface_t modes are supported.
> 
> Currently, phylink will call ->validate with PHY_INTERFACE_MODE_NA to
> request all link mode capabilities from the MAC driver before choosing
> an interface to use. This leads in some cases to some rather hairly
> code. This can be simplified if phylink is aware of the interface modes
> that  the MAC supports, and it can instead walk those modes, calling
> ->validate for each one, and combining the results.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: phy: add phy_interface_t bitmap support
    https://git.kernel.org/netdev/net-next/c/8e20f591f204
  - [net-next,2/3] net: phylink: add MAC phy_interface_t bitmap
    https://git.kernel.org/netdev/net-next/c/38c310eb46f5
  - [net-next,3/3] net: phylink: use supported_interfaces for phylink validation
    https://git.kernel.org/netdev/net-next/c/d25f3a74f30a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


