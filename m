Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28F84A92B3
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 04:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356780AbiBDDUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 22:20:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52866 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356772AbiBDDUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 22:20:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1656661991;
        Fri,  4 Feb 2022 03:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C0BEC340F1;
        Fri,  4 Feb 2022 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643944810;
        bh=d6pCDIR/pbq9RCk5p1jLVnLD2OZ9bM0bnSWn0niMAPE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fkMQDqipGuiFnChwhy91KeUvVggZy8phJ7761gpct+GceA7XTNjfCGUtAvfTEgKsi
         D3PfoElAfUyaE15f1hvxYUDpjJmmSLVpPA6pY2ykBWEzDxOpgfN729979svFTPKtjS
         DTYMk0Wzyq6t3vmmT8lANTplxwItCNl8PSr77qF5JagGT3cgwzASfDSGk3PhBBjn0H
         FymxQfTsBrZh2KnWYGSIWPbfAlmq0D5CvTZUCW6WKofTjhzvSplAQ+J4YM4840wodA
         RuRbPkPGMjfTdOqSO+cgYdXOkFwd9gAtPCkLjQwAygBbnqgAnehGMOxczXg/YrNmI2
         MoqmdDVFPhWKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6468AE5D09D;
        Fri,  4 Feb 2022 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: use .mac_select_pcs() interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164394481040.31803.16110916498512069085.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 03:20:10 +0000
References: <20220202114949.833075-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220202114949.833075-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Feb 2022 12:49:49 +0100 you wrote:
> Convert lan966x to use the mac_select_interface instead of
> phylink_set_pcs.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c    | 1 -
>  drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c | 9 +++++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: lan966x: use .mac_select_pcs() interface
    https://git.kernel.org/netdev/net-next/c/41414c9bdbb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


