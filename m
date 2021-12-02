Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D822466371
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357887AbhLBMXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:23:42 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58698 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357835AbhLBMXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:23:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5059DCE22AC;
        Thu,  2 Dec 2021 12:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88907C58328;
        Thu,  2 Dec 2021 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638447611;
        bh=8fcE9M+MmmC5ejqHVi05G1HVed0nk11G8uSKiVFC1ZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IY1HH5bMqmhDPOWpoz8Vy1cXuedeeBbZSFfWbxG0avniPYPjm2+r2w1+y8KiYV2xJ
         JxSDXMuvL+MbVpCOH1uykk0J1rpS/moumBpdWGA603z5XkFxI4P/ZWlMk9sKbWGRuL
         Q74U0zq/AwcdQLD08QiqJp+edRJWAnOE968IUvB2+HHtQfkN4wIc3tgN8E6BkbvMFz
         Ok1y5TvrRvFWdJ84l7b62bYn+zMjw4Mf3biszLxyT+OVia4bdhv2ygM/vYpuR+MB3k
         YHXz7Ul3lDNRCDzbRy3d7QyPP2SI1mB7wXuU1s3gAjfCDlNTrR88/zGRLEJb7T90Kx
         5dIEBI1ZNshjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 76270609EF;
        Thu,  2 Dec 2021 12:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Fix duplicate check in frame
 extraction
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844761147.9736.10176987879956906206.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:20:11 +0000
References: <20211201145351.152208-1-horatiu.vultur@microchip.com>
In-Reply-To: <20211201145351.152208-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 1 Dec 2021 15:53:51 +0100 you wrote:
> The blamed commit generates the following smatch static checker warning:
> 
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c:515 lan966x_xtr_irq_handler()
>          warn: duplicate check 'sz < 0' (previous on line 502)
> 
> This patch fixes this issue removing the duplicate check 'sz < 0'
> 
> [...]

Here is the summary with links:
  - [net-next] net: lan966x: Fix duplicate check in frame extraction
    https://git.kernel.org/netdev/net-next/c/a290cf692779

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


