Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148FB456E78
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhKSLxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234061AbhKSLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D86E61B1E;
        Fri, 19 Nov 2021 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637322616;
        bh=SYMPjxY/tz/0XCKiLgDr+vefLiP9lLs1a9rwLqWbjXo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pu8XhXkKwBh68mMpdywg8sasTvzdWJ5h86JTJptLMilJxNVD3pXZbefUREj9YJl7G
         Z+1LKqBRR1AaQELBGVwqC1C9K03iXenPWTW5Vxmtk5kTWx2ibkcVOpKVAcLmu3xeyY
         7WRXixf1NG2CbcRlCcFvy8xh/mIX4UyH6dP/S5DNMsi0yeZhXzbgt89UAK0cB7A4tA
         fAjqXzKK/T3ULFVgdZ7Va8ZUn+5x3izkjS5hzC+/X2H6dsfT63+CdNjPP5Czu3RNfv
         wrYfWwsg+e4WTsQQfvZVB+CNG7nCqw4u2nR8Gz+csawKzKN2GhUj6uXHA0p6yZiZIG
         xW72Skq6u4G7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 081AA6096E;
        Fri, 19 Nov 2021 11:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sky2: use PCI VPD API in eeprom ethtool ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732261602.10547.2543637089722597576.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:50:16 +0000
References: <a12724c0-2aba-3d3c-358d-a26e0c73eb38@gmail.com>
In-Reply-To: <a12724c0-2aba-3d3c-358d-a26e0c73eb38@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 21:04:23 +0100 you wrote:
> Recently pci_read/write_vpd_any() have been added to the PCI VPD API.
> These functions allow to access VPD address space outside the
> auto-detected VPD, and they can be used to significantly simplify the
> eeprom ethtool ops.
> 
> Tested with a 88E8070 card with 1KB EEPROM.
> 
> [...]

Here is the summary with links:
  - [net-next] sky2: use PCI VPD API in eeprom ethtool ops
    https://git.kernel.org/netdev/net-next/c/92e888bc6f1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


