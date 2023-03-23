Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF82A6C6239
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjCWIuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCWIuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EFE1043D
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 01:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9980BB82014
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 534A9C4339B;
        Thu, 23 Mar 2023 08:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679561418;
        bh=yHqVgBn3haKTIhXTwzRQ6KOJcoSlyjedhEQnSqsP4Ac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kOTNMyv+dub7DvuVY31gBn+Eo7zAyDAx6jRQYCvDGgiHKtUoAuleLOQftTbkw6Mou
         0ZRmc/hFdn7pTmAmLGtySsESNa0zABVgM31p7nZRf3QbruQkipHqU0RpfBiBBG+4Gt
         hVv/B/BM8IGr89UJ6rTLpivsl1b1GScG72oCosQJzacwozA0QlrMUUPeIYm+txVsU+
         luB+RKfI9Yx4C+z4l9n/DYeXcB8tHFfCrt9QxzCA0JOCiggahjtBwXZZU3Xlds3tJ9
         cExa1vQ2Ok02ZnKpdfSWqfSXtbL7WjKim5R3RmnzSNSjCLpF07maIHMMuOz6tn6GzL
         /CE9TomSi8N+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DD78E61B86;
        Thu, 23 Mar 2023 08:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mdio: thunder: Add missing fwnode_handle_put()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167956141816.5143.17401042209421365106.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 08:50:18 +0000
References: <20230322062057.1857614-1-windhl@126.com>
In-Reply-To: <20230322062057.1857614-1-windhl@126.com>
To:     Liang He <windhl@126.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, david.daney@cavium.com
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

On Wed, 22 Mar 2023 14:20:57 +0800 you wrote:
> In device_for_each_child_node(), we should add fwnode_handle_put()
> when break out of the iteration device_for_each_child_node()
> as it will automatically increase and decrease the refcounter.
> 
> Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
> Signed-off-by: Liang He <windhl@126.com>
> 
> [...]

Here is the summary with links:
  - net: mdio: thunder: Add missing fwnode_handle_put()
    https://git.kernel.org/netdev/net/c/b1de5c78ebe9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


