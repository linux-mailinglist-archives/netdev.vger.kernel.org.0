Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8757049FC76
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349375AbiA1PKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:10:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35184 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349449AbiA1PKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:10:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AABBB8261B
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 15:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62B66C340F8;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643382617;
        bh=Yv+kitLFu1yNr17r6Uj5Dp9+GzmX5eq1l0OtTqWe7q8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ihf96EycY/sDgyCru/l1dHu1JLEMmMXYiZpzbu19z4zmp//Q45D56hxJ4AzFTEDlj
         1Nq+KUfuvLj8I7V5eo4M9nVnWIdJHEKzGSGlFfHAZO/AHTlPBLhlPdkveTbMVjuqsr
         0y5jfMD259LmidUjsTCPrCOulNQJmg+2jiVB8uXl1cGoTr/DGuO7lo/d6PoKn+o3Xc
         WAnH54HfHibws/1V+QaqCWqswzvXpB9WotrywXItYKLfAFmYBPtc9zkHLpZvrjR8hh
         /bICC/u1BHMYDsp5LQrJnJp0TvVDKvWs4eJaYaXJhCRgQeuRXtIQrt7JV8esqVNAlH
         mztZdOcqFQtdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4D5A1F6079F;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mii: remove mii_lpa_mod_linkmode_lpa_sgmii()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338261730.2420.14096287992465255607.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:10:17 +0000
References: <20220127163349.203240-1-kuba@kernel.org>
In-Reply-To: <20220127163349.203240-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Jan 2022 08:33:49 -0800 you wrote:
> Vladimir points out that since we removed mii_lpa_to_linkmode_lpa_sgmii(),
> mii_lpa_mod_linkmode_lpa_sgmii() is also no longer called.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/linux/mii.h | 33 ---------------------------------
>  1 file changed, 33 deletions(-)

Here is the summary with links:
  - [net-next] net: mii: remove mii_lpa_mod_linkmode_lpa_sgmii()
    https://git.kernel.org/netdev/net-next/c/b5b3d10ef638

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


