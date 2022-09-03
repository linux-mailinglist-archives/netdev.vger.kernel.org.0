Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05E85ABE47
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 11:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiICJuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 05:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiICJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 05:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3BA40563;
        Sat,  3 Sep 2022 02:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FCC6B82014;
        Sat,  3 Sep 2022 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C707EC433B5;
        Sat,  3 Sep 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662198614;
        bh=6h3WJfdb973R11ta8ga8cyYVvH7pmTb9x4OmF3f7Iyc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PBJvBje/Nv3n2fRLLZp/N7UyRTRjn/40AT5cRYQLboiowbJ8BXW8Mmpr8aLUJIyMM
         0RAg8QK0s/KQLF+pO71sOwZaD1DUnBbbU3dwAtG8Hi4xEIctDte6VGpZdZhw7VOgmO
         yFZ9BXWLK4wNQbh3YIJcyeddH84G4ty5n4WPXgjNoI3VdC6RC9ZHomWEe558j63RXU
         Tybm60qf/z3JSxxoujjMZQspr0SJIz1tqogkW9m7CCUmcdmqPI06BZ6g+cUPiNVPXX
         3dVnesOa6S3YGas+95lLsYxD3WsJEgNZhZ4rmxG5o5DOU7o2Upp90KCilyWbJVVnIy
         eUcwJSkQXnvWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6405C73FE2;
        Sat,  3 Sep 2022 09:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1 1/1] net: dsa: microchip: fix kernel oops on ksz8
 switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166219861467.29702.12484622154736078055.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 09:50:14 +0000
References: <20220902092737.2576142-1-o.rempel@pengutronix.de>
In-Reply-To: <20220902092737.2576142-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Sep 2022 11:27:37 +0200 you wrote:
> After driver refactoring we was running ksz9477 specific CPU port
> configuration on ksz8 family which ended with kernel oops. So, make sure
> we run this code only on ksz9477 compatible devices.
> 
> Tested on KSZ8873 and KSZ9477.
> 
> Fixes: da8cd08520f3 ("net: dsa: microchip: add support for common phylink mac link up")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net,v1,1/1] net: dsa: microchip: fix kernel oops on ksz8 switches
    https://git.kernel.org/netdev/net/c/3015c5038474

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


