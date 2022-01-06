Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0BE48647D
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238954AbiAFMkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:40:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33190 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238945AbiAFMkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B77AEB82105
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88997C36AF5;
        Thu,  6 Jan 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641472811;
        bh=fGZkHtJ83GB8EPl5rxdOhJHHJmCO9Ns+zt6c+u6BQaE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hn+hXEJk30xvkb2RFiL2BmK6J2qelaHV+hcxU06eVI3g0GjNcDlMyAzZIW2lxosVW
         vVGxsNNHdkhHBDH8Z+vFAWzPBxfa7PkYIpL5grp30uLT/NrkX/3jWNU1d1i/QDMesw
         4zlOQIkDDt1oMSOEC7JydubKfzXInYSACFQp/y+zjVteuBfn0fE2ReeoGb1k/Fho0s
         9yDmiJf2EqZsvQ5yYiFFxWvt75xTqU+JYVupldPni0x/e1FHDMyVPQ9d9QPkZBlG9o
         ZRshXMYEQMejufUfUBrFgcKdZmtFp+pWIBZLwgt2Z4FOQ97CYlehH3xPNjsIzmbeeZ
         KNEqz2EnyY4ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7064DF79403;
        Thu,  6 Jan 2022 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: macb: use .mac_select_pcs() interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147281145.4515.7402776947538556318.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 12:40:11 +0000
References: <E1n568J-002SZX-Gr@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1n568J-002SZX-Gr@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 05 Jan 2022 13:15:15 +0000 you wrote:
> Convert the PCS selection to use mac_select_pcs, which allows the PCS
> to perform any validation it needs.
> 
> We must use separate phylink_pcs instances for the USX and SGMII PCS,
> rather than just changing the "ops" pointer before re-setting it to
> phylink as this interface queries the PCS, rather than requesting it
> to be changed.
> 
> [...]

Here is the summary with links:
  - [net-next] net: macb: use .mac_select_pcs() interface
    https://git.kernel.org/netdev/net-next/c/8876769bf936

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


