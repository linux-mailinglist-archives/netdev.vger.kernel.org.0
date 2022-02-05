Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0C74AA9A0
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358769AbiBEPUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358041AbiBEPUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B076C061348
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 07:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F01360F57
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 15:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8ED9EC340EC;
        Sat,  5 Feb 2022 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644074409;
        bh=JxAE6mzpMDAGNfyJec9vJVWMweVMhDc627cw4UUyahU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m9sDxWB3W+/S/6OUb+A4vSxQBo+8AAkEi1/Y5mhfZPpYuwriNdC69slMEKKqQJFgn
         5I0bk19qo3mjDW+y5a9GhmNkvEjZPxPDEKs4Bo4kFCrKYpYLzMYI8Dt/IgvRoqmgac
         O0pEcnTxcfX1rtpD1UYWB8M2pEkLbiyxQGhEAtEOJSzT9RiSe5ivno28Pc2/u+4qI3
         D4PNHZTo4w7HeOz1stElWW1BTWqUs3117yCwdApQtPj49lhA5qJXYhIpLoxc7NP53O
         heP6ar/7+Mss1FV5OSxLe0tTztWCcNKq0PfhPX4n+xm0sfAmea7vePVgy04jiDNRZ1
         /SkViU3ziCb9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7BA4EE5D07E;
        Sat,  5 Feb 2022 15:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sparx5: remove phylink_config.pcs_poll usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407440950.21243.17301285917257418213.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 15:20:09 +0000
References: <E1nFx4D-006Ywj-Vw@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nFx4D-006Ywj-Vw@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 04 Feb 2022 11:47:53 +0000 you wrote:
> Phylink will use PCS polling whenever phylink_config.pcs_poll or the
> phylink_pcs poll member is set. As this driver sets both, remove the
> former.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [net-next] net: sparx5: remove phylink_config.pcs_poll usage
    https://git.kernel.org/netdev/net-next/c/3682e7b841bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


