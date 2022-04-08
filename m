Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633284F941E
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 13:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbiDHLc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 07:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiDHLcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 07:32:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E6116BF5C;
        Fri,  8 Apr 2022 04:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE58561FF5;
        Fri,  8 Apr 2022 11:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FB69C385A1;
        Fri,  8 Apr 2022 11:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649417416;
        bh=N++kWg6tmJMduGzzAXaaygWea3gRrf1JYMIm/yTrKXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cHewQVj+pcC9ybfjCA/W5eCNRvGtR7gDIAIN9zHA/ZtIUmgqQ3UMW4Qg/bJz/F9kW
         Hv4vH7xiF9Fh/R6dnDNB5Y5dIwzTt3lSmT2fYK5QMJ/nV9zfbU5munKLpZ4YPekqiZ
         Z3cRHIDXB8M4hxNnATjlvxu7BeznfidvOzHGVBeOy7sbyzcWrTXhfo6e9W9W809/KJ
         Tbdbcr5jxZ/N6ZN/gzPY1lHUlUzxUdNna6W9KwNTUAnLzM/7kf9Rh4WghBT73p8X27
         3PjqdeqbLlNeStEuXA12OtfSaX1gr1CHbPSqmFYTcNUKKM3r/g83XxbY5IiQZ4cWq/
         Br29I8zlwfRFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06EB4E8DBDA;
        Fri,  8 Apr 2022 11:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] Add Clause 45 support for Aspeed MDIO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164941741602.31457.17503589605450894981.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 11:30:16 +0000
References: <20220407011738.7189-1-potin.lai@quantatw.com>
In-Reply-To: <20220407011738.7189-1-potin.lai@quantatw.com>
To:     Potin Lai <potin.lai@quantatw.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, joel@jms.id.au,
        andrew@aj.id.au, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        patrick@stwcx.xyz
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Apr 2022 09:17:35 +0800 you wrote:
> This patch series add Clause 45 support for Aspeed MDIO driver, and
> separate c22 and c45 implementation into different functions.
> 
> 
> LINK: [v1] https://lore.kernel.org/all/20220329161949.19762-1-potin.lai@quantatw.com/
> LINK: [v2] https://lore.kernel.org/all/20220406170055.28516-1-potin.lai@quantatw.com/
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] net: mdio: aspeed: move reg accessing part into separate functions
    https://git.kernel.org/netdev/net-next/c/737ca352569e
  - [net-next,v3,2/3] net: mdio: aspeed: Introduce read write function for c22 and c45
    https://git.kernel.org/netdev/net-next/c/eb0571932314
  - [net-next,v3,3/3] net: mdio: aspeed: Add c45 support
    https://git.kernel.org/netdev/net-next/c/e6df1b4a2759

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


