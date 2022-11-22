Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B70633F20
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiKVOkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbiKVOkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4D62B1AD;
        Tue, 22 Nov 2022 06:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17D2C61741;
        Tue, 22 Nov 2022 14:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D752C433D6;
        Tue, 22 Nov 2022 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669128017;
        bh=ZdUOPikyCG80XtHDnM2rGG9TSWAkvMCXAo+3DdnnZnY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z3U1U0YaPUGWa+E3QQtLfU26qUd7pWht5fsQmND3VCvU/L7pi5f6PIWpruwvuA7D8
         LgI+JPMKQoa08L0kJhOky7Jbv3aPYxaEZ2gH1BWTMsqr3f28RgjYvxtSEvkqbE6EyZ
         aH1l8QQ03gEyUMM9Sc9r8O5ZdyA2X2ahJv1vJ3iOKIy/3DwYFqcV1szwkeWUuNnAcj
         waizuuLBDFN+jNZd1N5rG8FrOt6358KQF+kjka2teqkRkbXIenk+cIdQa04kJQwloj
         uMrslTew19gILSsG3xDK9Ehlj13n/qxa7pFJ99SBc8HuT0YlR3AGE5SJHLu2IxSPvk
         sAaPxQ1XJknxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5FCE4E270E3;
        Tue, 22 Nov 2022 14:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/3] cleanup ocelot_stats exposure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166912801738.31871.6233306488148993395.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 14:40:17 +0000
References: <20221119231406.3167852-1-colin.foster@in-advantage.com>
In-Reply-To: <20221119231406.3167852-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, edumazet@google.com, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 19 Nov 2022 15:14:03 -0800 you wrote:
> The ocelot_stats structures became redundant across all users. Replace
> this redundancy with a static const struct. After doing this, several
> definitions inside include/soc/mscc/ocelot.h no longer needed to be
> shared. Patch 2 removes them.
> 
> Checkpatch throws an error for a complicated macro not in parentheses. I
> understand the reason for OCELOT_COMMON_STATS was to allow expansion, but
> interestingly this patch set is essentially reverting the ability for
> expansion. I'm keeping the macro in this set, but am open to remove it,
> since it doesn't _actually_ provide any immediate benefits anymore.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] net: mscc: ocelot: remove redundant stats_layout pointers
    https://git.kernel.org/netdev/net-next/c/33d5eeb9a684
  - [v2,net-next,2/3] net: mscc: ocelot: remove unnecessary exposure of stats structures
    https://git.kernel.org/netdev/net-next/c/a3bb8f521fd8
  - [v2,net-next,3/3] net: mscc: ocelot: issue a warning if stats are incorrectly ordered
    https://git.kernel.org/netdev/net-next/c/877e7b7c3b12

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


