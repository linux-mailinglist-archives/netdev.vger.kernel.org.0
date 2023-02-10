Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C13691897
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 07:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjBJGkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 01:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjBJGkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 01:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512865CBC2;
        Thu,  9 Feb 2023 22:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E483DB82369;
        Fri, 10 Feb 2023 06:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95787C433AA;
        Fri, 10 Feb 2023 06:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676011218;
        bh=XhNCP0FYObxHApyeE/lXgL5fXZlQz/LO/1pLPxNdhD8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QKJ4Clu5u/6QJtSTpAwDS0ZX5r+H2hbdNl6xYDj8pmnI6WVkSwUEGCGyH0QC0mq8O
         V5LQOLfoPqAxWY1Ge+8UcdUnNUQIRgV71CHnP5rtDYl5SFLJtNZe1le+vo/8GXiy9P
         XENM4dOVc58s5Hs91aG7RPlW57+SpLCMpuTtkWQHpChx/s7ipkDN6aUSGDzBythvQk
         qcLHK1dRrgnnwoznAnnx2M+rFYzc6kXpZJFIUnoEi7L6wfI+Lz8EJrKVcwtzguvWvl
         feRIClGJ7HXLqV93Q/qFTKnPwnyIq/5FPcM1LBv9VnzxtNh8rWga2x5BGyzaFIV+Ly
         zTZfYeGUHnXzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 819DDE55EFD;
        Fri, 10 Feb 2023 06:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: micrel: Cable Diagnostics feature for lan8841
 PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601121852.3411.18294006515177056207.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 06:40:18 +0000
References: <20230208114406.1666671-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230208114406.1666671-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 8 Feb 2023 12:44:06 +0100 you wrote:
> Add support for cable diagnostics in lan8841 PHY. It has the same
> registers layout as lan8814 PHY, therefore reuse the functionality.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 5 +++++
>  1 file changed, 5 insertions(+)

Here is the summary with links:
  - [net-next] net: micrel: Cable Diagnostics feature for lan8841 PHY
    https://git.kernel.org/netdev/net-next/c/a136391ae421

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


