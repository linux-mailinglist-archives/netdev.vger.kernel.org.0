Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CF16D3FBD
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjDCJKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjDCJKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625CC7687;
        Mon,  3 Apr 2023 02:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF6856170B;
        Mon,  3 Apr 2023 09:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52CF2C433EF;
        Mon,  3 Apr 2023 09:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680513018;
        bh=QhLDNdEiaN3LHvtHyZ2tp9+tljVlsGrNGzkkKi0M4dQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gAT4bYkU56FPP41Uc9UDT/Cog6s/OA71QR3ivGTfXU0qPGDkn8IW5n6S/u8ig7nzB
         iw0ayYm3PcLD/7uaQzDYoD3FoCtvP8MwgYtgb4OWFhaARkZqxshqPLcTYh9kwcDSS8
         uh6BD/cu7CYDc+Yd6yUSDpkttpvYmKcuJSSgJBj9ZDpxC+PVnFHxPaVacSZpvUr8x4
         rARUo3OaV0r8VwA9GDzOLsc6Bt+cBxvVLCx1tbfPv1mglt9LR+N2naNx/qKgzmeRBD
         iUaQ5mY+QSC/XrUvHnE8i/MFAzPGfhyjYPGOVPTHAX3LVnFWW81LTBDqoZvv7YPtGP
         1AJmJr3bhzecA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 373CCE5EA83;
        Mon,  3 Apr 2023 09:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sfp: add qurik enabling 2500Base-x for HG MXPD-483II
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168051301822.10375.14312965431860147385.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Apr 2023 09:10:18 +0000
References: <5e9a87a3f4c1ccc30625c8092b057f0fbd8a9947.1680435823.git.daniel@makrotopia.org>
In-Reply-To: <5e9a87a3f4c1ccc30625c8092b057f0fbd8a9947.1680435823.git.daniel@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, chowtom@gmail.com, frank-w@public-files.de
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sun, 2 Apr 2023 12:44:37 +0100 you wrote:
> The HG MXPD-483II 1310nm SFP module is meant to operate with 2500Base-X,
> however, in their EEPROM they incorrectly specify:
>     Transceiver type                          : Ethernet: 1000BASE-LX
>     ...
>     BR, Nominal                               : 2600MBd
> 
> Use sfp_quirk_2500basex for this module to allow 2500Base-X mode anyway.
> 
> [...]

Here is the summary with links:
  - net: sfp: add qurik enabling 2500Base-x for HG MXPD-483II
    https://git.kernel.org/netdev/net/c/ad651d68cee7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


