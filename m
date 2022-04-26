Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8E350F390
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344570AbiDZIXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbiDZIXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:23:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B6237BDC;
        Tue, 26 Apr 2022 01:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09ADF617E4;
        Tue, 26 Apr 2022 08:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5019CC385AE;
        Tue, 26 Apr 2022 08:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650961211;
        bh=ugo6y6jiYnqSUXmZRfk+DmmPi2q5AZ1H/WOY8Ca7Lwc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qywktqcx1E46JxwpO18a/reuO2eDEsGHII+Cj5Z+oKNAgysipOJX/3gl5FnBWdp7B
         G3+Op1x/Gue0BkzAqnEXv13/A22HsVwj/HUESnzZ3qw3P9a8LVgNv5j3L13iLTrYUK
         qsyobfDACvojg7BGOoHmFFSpOxHCFo+ZtdpY9yRjPGaDV5WgjW2bxhR5U7e69xKr00
         UEhB+A+pMf3YhW2s3ffoJTXazfCLpnCJhKBa/NrC2VEOVej71Jdg2H4aXIM+BAuyct
         FQNbq/T2UFTFU29GLfNodsju0oS9VgmwfYhPTu9wnsKDofQmy9eRNbhlMVSiadUu6d
         2+IZVbOg5iP1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39DAAE8DD85;
        Tue, 26 Apr 2022 08:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next] net: phy: LAN937x: add interrupt support for link
 detection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165096121123.19252.3865282895465550073.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 08:20:11 +0000
References: <20220423154727.29052-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220423154727.29052-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 23 Apr 2022 21:17:27 +0530 you wrote:
> Added the config_intr and handle_interrupt for the LAN937x phy which is
> same as the LAN87xx phy.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/phy/microchip_t1.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: LAN937x: add interrupt support for link detection
    https://git.kernel.org/netdev/net-next/c/fb0a43f5bd45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


