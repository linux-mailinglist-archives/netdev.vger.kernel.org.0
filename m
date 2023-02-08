Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892DD68EB13
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjBHJXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjBHJWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:22:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B219CC0F;
        Wed,  8 Feb 2023 01:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A04EFCE1FD2;
        Wed,  8 Feb 2023 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E23DAC4339B;
        Wed,  8 Feb 2023 09:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675848019;
        bh=Y/pIbh0rWkjslkB8F7JYEo7yVX5/0U4GPW/P5zBjX+Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pcGI5JlQ0fT0yL3SHuw2bTprMCYEFY0IeqD0HgLOr83yPxuTCqi8w9oh3nSgs0iTP
         GAIsjPikVfJvM/OeuVkIiLXrvtIIbJMs4B4mftTF5oEhnA1B43t60i4OXlgoiBzqY1
         8UBd5cFzNP2U89I8hSjIIahvg23GnHNKXV2lEP+BffXjCSV+i1yxvWIKDQAHMAALJM
         koB1qpAfO1w8TN9ODHBQBfvy8gWqbM7e1Ayvd/ngb862njRKPFto9209FyEVd4yfc+
         41LWlMmx1vR4bj5zB4QTsIY5KbTY8CP2+mFlZBvJSGHEY28PJvaGSnApIPijs/sxQz
         arxBEc1wqwbtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C50A8E55F06;
        Wed,  8 Feb 2023 09:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: lan966x: Add support for TC flower filter
 statistics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167584801880.16330.14350644952227860488.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 09:20:18 +0000
References: <20230207103549.1273592-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230207103549.1273592-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        simon.horman@corigine.com
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

On Tue, 7 Feb 2023 11:35:49 +0100 you wrote:
> Add flower filter packet statistics. This will just read the TCAM
> counter of the rule, which mention how many packages were hit by this
> rule.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: lan966x: Add support for TC flower filter statistics
    https://git.kernel.org/netdev/net-next/c/9ed138ff3767

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


