Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D950424B88
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhJGBMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232361AbhJGBMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 21:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B7296112D;
        Thu,  7 Oct 2021 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633569008;
        bh=KhIrT8/YGWg0WPmyh7KipjqKorCOnOkwHMS6pPzPCHU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NZ/S1dPpECGx68l/9dwj5s2wgmf9xma9/DBjVidYtByU/Jmi6bX6HzVafjKoU0tTB
         2lw+5ixPfbo4UrC38KssryWkA1+NKDZXR3aaDEqifYVMnzw7AlJga+wQjtZjMhUbWi
         1ZI8eDEWuR1+caDNg34kiZGFXDRCSgosemLIz2j3/SwC82OQfXaV+wySPURBuK/eOz
         lOLUdudWFBdjBzCwU5nUuGCDWp8VGzJTDW61SDsmonUq5jcCtVwm7LUd25Ghl5IcTG
         dtwK31dxK47cFmqfCoO7J3uSu1Ucz+pAppw9tNv38zqcK1S45/fYAAkKV2ro3oMXGC
         rheSndzHjw3Bg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 852BE609F4;
        Thu,  7 Oct 2021 01:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Add mdiobus_modify_changed() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163356900854.5781.6792151272949479633.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Oct 2021 01:10:08 +0000
References: <YV2UIa2eU+UjmWaE@shell.armlinux.org.uk>
In-Reply-To: <YV2UIa2eU+UjmWaE@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, sean.anderson@seco.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 6 Oct 2021 13:18:41 +0100 you wrote:
> Hi,
> 
> Sean Anderson's recent patch series is introducing more read-write
> operations on the MDIO bus that only need to happen if a change is
> being made.
> 
> We have similar logic in __mdiobus_modify_changed(), but we didn't
> add its correponding locked variant mdiobus_modify_changed() as we
> had very few users. Now that we are getting more, let's add the
> helper.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] net: mdio: add mdiobus_modify_changed()
    applied by Jakub Kicinski <kuba@kernel.org>
    https://git.kernel.org/netdev/net-next/c/79365f36d1de
  - [v2,net-next,2/2] net: phylink: use mdiobus_modify_changed() helper
    applied by Jakub Kicinski <kuba@kernel.org>
    https://git.kernel.org/netdev/net-next/c/078e0b5363db

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


