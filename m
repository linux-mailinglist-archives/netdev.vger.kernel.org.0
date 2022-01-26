Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B810E49CFDD
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243173AbiAZQkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbiAZQkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:40:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03108C06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96D0061A66
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5675C340EE;
        Wed, 26 Jan 2022 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643215210;
        bh=ugGQGOxFGkHnuHOx7oqRZH9pghQ/QMRuOh79DxOsAMg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jox6F4GK7oJeDgOJj6kofL9VJE3gDrjH0u5ObEJdweJDFlUcgI1btgI1f7KnUI+Pg
         qzPniVp/VZlET3ecFqJXl1qq9WcvS8iA5tqmm4EazjWBVc/6OH8jJb7njkGsqT7b0n
         JyrfZZNmP2l6UNqfUIY5eeo9IZzmEOqBzH0ndKskzQZSHsEV3YkvLPYbJMSTwSRPCK
         MNwd6AvIQP4qluOEDXiXS77xLhbxujbiJXWCT3XKOGBhydi6SZfkljt4is7q7wyRET
         z4Yu8IflpH/fMngUtk1KmQgCHep/NuTW/K5MK6VGVcdNmDNR1uzTRMxGs/BkP0O7PB
         s0GNCw5uYZUzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA163E5D087;
        Wed, 26 Jan 2022 16:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: enetc: use .mac_select_pcs() interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164321521082.5014.15663957375276167717.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Jan 2022 16:40:10 +0000
References: <E1nCOis-005LHL-LJ@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nCOis-005LHL-LJ@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 25 Jan 2022 16:31:10 +0000 you wrote:
> Convert the PCS selection to use mac_select_pcs, which allows the PCS
> to perform any validation it needs.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> CFT patch message id E1mxq4r-00GWrp-Ay@rmk-PC.armlinux.org.uk
> 
> [...]

Here is the summary with links:
  - [net-next] net: enetc: use .mac_select_pcs() interface
    https://git.kernel.org/netdev/net-next/c/5fd16021578e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


