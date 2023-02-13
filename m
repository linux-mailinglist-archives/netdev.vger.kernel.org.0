Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49DA69422F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 11:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjBMKAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 05:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjBMKAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 05:00:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35E2DBE7;
        Mon, 13 Feb 2023 02:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6194CB81084;
        Mon, 13 Feb 2023 10:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF037C4339B;
        Mon, 13 Feb 2023 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676282421;
        bh=sR6ucV74HEnKq4ELFjdRAJd1uxKpePwQF+DJOle+LQA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P0Y7RW+xvUIYPDwofO/7HYlbyrR4kq5oqLih5M6haN07ZgX+bNv0g3oO8dZewJ3HD
         LaYybsQDu7P73vx0MXq1mrLx1gA9EArk01nlHT+SSZgWhhu1jxivym5mYycQnLpPyj
         QcKAxRL3UDhhb2inBS5JY7x7cLwONevqHpkMoMTS8B5cgcJ1/QUnexFHMxsSSje7Tc
         1owz5S0trM8iBSok1CscsLTEUd6zStxhgsErXUYp/9eevUlELlhz1YYN1t6Iu/mA5X
         upCJ8xgHgudmLZ3iKj5wfGzvWET3TMAGZcnHmdFeZZ1UsFNTpk0De3YMvrkXpRUYQ3
         nAsv6MCq1Ozcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8178E270C2;
        Mon, 13 Feb 2023 10:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: micrel: Add PHC support for lan8841
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628242087.19101.7230287431405072207.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 10:00:20 +0000
References: <20230210102701.703569-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230210102701.703569-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Feb 2023 11:27:01 +0100 you wrote:
> Add support for PHC and timestamping operations for the lan8841 PHY.
> PTP 1-step and 2-step modes are supported, over Ethernet and UDP both
> ipv4 and ipv6.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 623 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 599 insertions(+), 24 deletions(-)

Here is the summary with links:
  - [net-next] net: micrel: Add PHC support for lan8841
    https://git.kernel.org/netdev/net-next/c/cafc3662ee3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


