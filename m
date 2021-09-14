Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9E840AEB7
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbhINNQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233218AbhINNQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0A054610E6;
        Tue, 14 Sep 2021 13:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631625289;
        bh=fUex7wQvO0zbSR2isytRvogKnEwudA8k79GsUi7rsBE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pna2ECYGRv+td7tL7HaWBu4JUSaJZwDNCg88lN3hvNzj6lffhu2iFHXOKMEMNeJ3P
         SnnmYhEd6SiiciOxVRw+qkzLpOI/3u0cNF9tfj2F3gT2xGKyoTIA4vD25c77ItbI6w
         +3WUyL17y/ZSUOZJzYeX9RzA3LOEcHGbfVjcMD1JyLyoqa8asGP7/Vx547fogZnRjh
         piKsFh0IanA2yTN+8ZXJ9ul5VavvJA3Jc/wbsvMJqCKenmM0t7Or/BgqqvbW/BHvsl
         Bjbav4IQGIySp29WVDJWZXuKYFgCJA8+VRGn4MjdHLWLYoh5ik8SWyiEld2Xbtot8g
         o2JNKhhWCEWDg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F3A9E60A7D;
        Tue, 14 Sep 2021 13:14:48 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: remove support for chip version
 RTL_GIGA_MAC_VER_27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162528899.7287.10575747689807632437.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 13:14:48 +0000
References: <7892bfe6-ad86-2b1e-e2ea-7e1667e17151@gmail.com>
In-Reply-To: <7892bfe6-ad86-2b1e-e2ea-7e1667e17151@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 13 Sep 2021 21:46:06 +0200 you wrote:
> This patch is a follow-up to beb401ec5006 ("r8169: deprecate support for
> RTL_GIGA_MAC_VER_27") that came with 5.12. Nobody complained, so let's
> remove support for this chip version.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169.h          |  2 +-
>  drivers/net/ethernet/realtek/r8169_main.c     | 41 +------------
>  .../net/ethernet/realtek/r8169_phy_config.c   | 59 -------------------
>  3 files changed, 3 insertions(+), 99 deletions(-)

Here is the summary with links:
  - [net-next] r8169: remove support for chip version RTL_GIGA_MAC_VER_27
    https://git.kernel.org/netdev/net-next/c/01649011cc82

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


