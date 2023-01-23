Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D89677E36
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjAWOkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbjAWOkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A587A1027A;
        Mon, 23 Jan 2023 06:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ED31B80DD4;
        Mon, 23 Jan 2023 14:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2E3BC4339B;
        Mon, 23 Jan 2023 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674484816;
        bh=QfA8gUNjJrrrTgCGdpRHptZANu6QZ2+R/AsnDyfuKqg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XzX58hvVHRYW30hpcQ7PqleMS23ldTQKF/2PcLNyTf+h+j7TPDmkDC2L7rkIJsz8o
         ZOA0KAO8nDsxupjY3lff2hmJH67CdTwvd21iOHdRNAwiwiIIImt4so4BCUw9EfCqcY
         yQ8PfTrJ4DpNm3oCcsD4UJY2KNGKewo2x2Ak764kVoAfisbEvZFKz4jypXy9YHgLeU
         K+XzVgz5DP+TRcGFZBW39OCfWKLI3PHinnULLQVxGw+4UWeXXEtEP5nXGqn3AqzO6s
         YfgO5+EZRE04cqSGs9/s871J7hLBJyKyya8QB7cFs05r9VxQ9miXpbRshLI7AI3zlB
         CooNu5ZCB15Tg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A802BC04E34;
        Mon, 23 Jan 2023 14:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: mdiobus: Convert to use
 fwnode_device_is_compatible()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167448481668.20691.16943578040916175967.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Jan 2023 14:40:16 +0000
References: <20230119175010.77035-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230119175010.77035-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux@rempel-privat.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 19 Jan 2023 19:50:10 +0200 you wrote:
> Replace open coded fwnode_device_is_compatible() in the driver.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/mdio/fwnode_mdio.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next,v1,1/1] net: mdiobus: Convert to use fwnode_device_is_compatible()
    https://git.kernel.org/netdev/net-next/c/d408ec0b5d9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


