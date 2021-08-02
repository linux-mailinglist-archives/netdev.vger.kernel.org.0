Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7F23DDA51
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhHBONT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237711AbhHBOKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CFFF560725;
        Mon,  2 Aug 2021 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627913405;
        bh=sV2U3p0t0rnDrqHuufRVrvIzKCmpSS/poccSxBUYwus=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FjMKBqf0CfQ5i0piNGzwYuR3yhKmAiuFIEj2p8b1aM+T5uM2Eb6oygubozqsUtE8Q
         t1wpdkfMBp4L8TPljtj3i7JfQahWCsXfo8ADUNgg576tAB1yGRRA7M/a/Btbp0fP6Z
         xRrYkgU8Cs2bk+jpeLtPyNyMLVV88LuXdED5dEjV9s0J5qjEZwemAbyyOQEo7bDIs0
         9OFN71/3k/+zRRgPL0bjeY0svnv7rB0kl/ODUMGWTSXU+AYfk9Nl4bN7IFXcPnzeBq
         cB86PqwH8JVmeKiHhl1ANoJgQpwx/DcI17511XC1Kgcv0pMahuaVxdIoYzd2WarbxH
         FYhSG4nKzrGMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C29C26098C;
        Mon,  2 Aug 2021 14:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: phy: micrel: Fix detection of ksz87xx switch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162791340579.12354.8922253597572859072.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 14:10:05 +0000
References: <20210730225750.98849-1-steveb@workware.net.au>
In-Reply-To: <20210730225750.98849-1-steveb@workware.net.au>
To:     Steve Bennett <steveb@workware.net.au>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, marex@denx.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 31 Jul 2021 08:57:50 +1000 you wrote:
> The logic for discerning between KSZ8051 and KSZ87XX PHYs is incorrect
> such that the that KSZ87XX switch is not identified correctly.
> 
> ksz8051_ksz8795_match_phy_device() uses the parameter ksz_phy_id
> to discriminate whether it was called from ksz8051_match_phy_device()
> or from ksz8795_match_phy_device() but since PHY_ID_KSZ87XX is the
> same value as PHY_ID_KSZ8051, this doesn't work.
> 
> [...]

Here is the summary with links:
  - [v2] net: phy: micrel: Fix detection of ksz87xx switch
    https://git.kernel.org/netdev/net/c/a5e63c7d38d5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


