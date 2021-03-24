Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F2834854D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 00:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbhCXXaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 19:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234193AbhCXXaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 19:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9935061A1D;
        Wed, 24 Mar 2021 23:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616628608;
        bh=PC0pmUUuPDr5/gagL/fKKtnKk7q9Bs5BtagNU1zxE+I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eRALBrKz2Zytu2i9V670RaUTi41NKz8RcJy1TrMv2hxTB9+skFpFxDb7j/zY4S6W3
         V6WspciNs9wMfNajfeMEmKQH2ITUo2QRZJKFH52Um+d9gKr42zU3kKnTZjyKJaUtTW
         bSkyg+Hj7aVwse4if8u49E5jmqFcmFwrLJLlWxhAADhzMZO5jl/l2DKY3mc93YXFBs
         ePIJ46Ol8NZj39gztkwnL0/UjEZgZNJO8uFKfIhb1MZl/PUn1M5mGf2YIrWTPMnjlz
         8WzQOC6Ab99RSt6gEBkts82byCWl5e7mxrrA3WhRweDTYkB616l4+w6fWLeG7TBRWx
         l8GXKs0wiZtwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8763860A0E;
        Wed, 24 Mar 2021 23:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Add support for Clause-45 PHY Loopback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161662860855.17876.13164915233705341509.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 23:30:08 +0000
References: <20210323164641.26059-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210323164641.26059-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, weifeng.voon@intel.com,
        boon.leong.ong@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 00:46:39 +0800 you wrote:
> This patch series add support for Clause-45 PHY loopback.
> 
> It involves adding a generic API in the PHY framework, which can be
> accessed by all C45 PHY drivers using the .set_loopback callback.
> 
> Also, enable PHY loopback for the Marvell 88x3310/88x2110 driver.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: phy: add genphy_c45_loopback
    https://git.kernel.org/netdev/net-next/c/0ef25ed104ac
  - [net-next,2/2] net: phy: marvell10g: Add PHY loopback support
    https://git.kernel.org/netdev/net-next/c/d137c70d0e7a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


