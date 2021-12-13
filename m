Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA6D472FC0
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbhLMOuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239592AbhLMOuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 09:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45FAC06173F;
        Mon, 13 Dec 2021 06:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6679D6112B;
        Mon, 13 Dec 2021 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BEA64C3460B;
        Mon, 13 Dec 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639407009;
        bh=268hMa68tOIqIISKu0MmmjtYkne2i8AuG+hKxXaR7a4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=acVSnhSOWW2xwWr3v3guKhLVyf2ZYPnmiLpvqxDU+gXFmFLbhGG4pwhcmSy0rmqjy
         EEcUMNwNFDziT9fQMytvtZ8Y9mRWWMEXWTPN6tAT2dX2c0TKFw6y2uQcLZWFUMfEFg
         V8m97SIRzaE9xoqJNAcFxNZRTmBJky7rcbVZAwrXObq5x6HL6jRso6Lq8/Z4lINz1a
         ko2GvwfzqzM/kCzGdqLugfhD6CpCn0qCjwqv5Gncr7fqNZA+vPoQI6KHpIJbTOvAMn
         zCrPCL9oC3z1UXySgmqxkLzFWBWR4mwJXckSDP4w9mUw4k0wrwDFPSTxzhliRepOr8
         /wwn5EJUa7XkQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AAC99609F5;
        Mon, 13 Dec 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Fix the configuration of the pcs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940700969.22565.14478986408069586277.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 14:50:09 +0000
References: <20211211214420.1283938-1-horatiu.vultur@microchip.com>
In-Reply-To: <20211211214420.1283938-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Dec 2021 22:44:20 +0100 you wrote:
> When inserting a SFP that runs at 2.5G, then the Serdes was still
> configured to run at 1G. Because the config->speed was 0, and then the
> speed of the serdes was not configured at all, it was using the default
> value which is 1G. This patch stop calling the serdes function set_speed
> and allow the serdes to figure out the speed based on the interface
> type.
> 
> [...]

Here is the summary with links:
  - [net-next] net: lan966x: Fix the configuration of the pcs
    https://git.kernel.org/netdev/net-next/c/b26980ab2a97

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


