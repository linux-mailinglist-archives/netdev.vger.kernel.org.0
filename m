Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D963B47EE58
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 11:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352486AbhLXKuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 05:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343969AbhLXKuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 05:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869BAC061401;
        Fri, 24 Dec 2021 02:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDBBD62054;
        Fri, 24 Dec 2021 10:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F6B4C36AEA;
        Fri, 24 Dec 2021 10:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640343009;
        bh=W/UG6w38GPX8niIa44zDjYA6tqWKhqCJMbuFNjYTr5o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ASWd85a0S0YdAgOJZGKYWtFQod4jKfd1dSKDnLbBiztseWzwran8a9AjcZaNGGnPz
         H7c6rJ4YrzZWeWFFF9290tE613KxoI5K8NTJmkMVdkNLpZy9OJmjp5Rk68jm5Ho690
         JdbhunEyT4Z+FStW49dw0PWq2o+S7OVL33FJxmuxuAXnoAb2frSvfDwt8tzybvINRq
         0hv0Jy5BCRuDBn4C0IWRNuE4mncmxviLHnIyCFyjYiKhEf7nF63j8KYUx7Mxelloyg
         LCBovv/5Py7TyV1M8Tx6yuL0qLW3X96ui1dz50ZilO6rF39RBSUImlVqpimBF5GONP
         t3QyDhch1FjpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAE90EAC068;
        Fri, 24 Dec 2021 10:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH resend net-next] net: phy: micrel: Add config_init for LAN8814
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164034300889.19957.7875308291020154180.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Dec 2021 10:50:08 +0000
References: <20211223082826.1726649-1-horatiu.vultur@microchip.com>
In-Reply-To: <20211223082826.1726649-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Dec 2021 09:28:26 +0100 you wrote:
> Add config_init for LAN8814. This function is required for the following
> reasons:
> - we need to make sure that the PHY is reset,
> - disable ANEG with QSGMII PCS Host side
> - swap the MDI-X A,B transmit so that there will not be any link flip-flaps
>   when the PHY gets a link.
> 
> [...]

Here is the summary with links:
  - [resend,net-next] net: phy: micrel: Add config_init for LAN8814
    https://git.kernel.org/netdev/net-next/c/7467d716583e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


