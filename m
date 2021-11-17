Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7CD4545AD
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbhKQLdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:33:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235164AbhKQLdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 06:33:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1360063237;
        Wed, 17 Nov 2021 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637148612;
        bh=xaTW1nDEjYqiIEg80yiqT/H+ANWHPVl1N3Q6MVIU/dc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FHmu7EoWwcFHrxOeFVM4yg9y7GRDyOzQ1dxGVPCK/Ogn/S6shaevpUaXaioDhD8/X
         W9Hb4oyywO2OKFNeIKvRazSBmlhrG+Gr/yotT0HrF2RxZQhEtW0Lokyn2p0iiX8/tM
         uTQ0WJ1mnYdd/7aRgURDLtT+L5mW6mwf5+wIUm/JfG4kgF7YOrFzgWdUzD9oJirIXM
         2rVdf8aVUAg8vLFFkV2AxkfCjVrpa7wk0k1tmBq5TAttJ+6OOErs+oBqzanFt70SYL
         I+gF3mrEV791zNsdZS8zbU38l2S9VFVoyQyZ3KYuOIsrQgdwdLVFwn3UaBzTAr8JaJ
         z24RTNPGmq4Gw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 06DA160C16;
        Wed, 17 Nov 2021 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: enetc: phylink validate implementation
 updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163714861202.14428.6149171286939947282.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 11:30:12 +0000
References: <YZOAxY8PjO38j+j6@shell.armlinux.org.uk>
In-Reply-To: <YZOAxY8PjO38j+j6@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     claudiu.manoil@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 09:58:29 +0000 you wrote:
> This series converts enetc to fill in the supported_interfaces member
> of phylink_config, cleans up the validate() implementation, and then
> converts to phylink_generic_validate().
> 
>  drivers/net/ethernet/freescale/enetc/enetc_pf.c | 53 ++++++-------------------
>  1 file changed, 13 insertions(+), 40 deletions(-)

Here is the summary with links:
  - [net-next,1/3] net: enetc: populate supported_interfaces member
    https://git.kernel.org/netdev/net-next/c/4e5015df5211
  - [net-next,2/3] net: enetc: remove interface checks in enetc_pl_mac_validate()
    https://git.kernel.org/netdev/net-next/c/5a94c1ba8e33
  - [net-next,3/3] net: enetc: use phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/75021cf02ff8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


