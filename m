Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7406694226
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 11:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjBMKAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 05:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjBMKAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 05:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E749CBDD8;
        Mon, 13 Feb 2023 02:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 895DE60E33;
        Mon, 13 Feb 2023 10:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7C52C433D2;
        Mon, 13 Feb 2023 10:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676282417;
        bh=4AWhgzWN7SEasVhSxLasQmCgMZDeri3Rl2pd3ei9Lns=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SiJyFh4RUBRiJ3Floi4bYk/+Ss+a3zMN/Ii7U5e6JTtK7spAUSEzo+hOpqk8Wfz7L
         VO7mErkUd8dcwgXSHfDsOqcE1/mz4IbC6nJl77MUdp7qw1R3wu0D6uHlA7sLKwgCmJ
         oktMegjhnIsRf58HsJPzRE67tui3TuwdYBKc2h75SiLamKN330cxmasXNdB9L2x0tY
         1B9/IPMALu5/A2UiWObmRSODqkpDtn271e3Hq+Qoo95Sd/Jc4VeDwkUeTjOUxLzKE/
         qanjV6YYFJZPy6+Vi81k3Yyygf4jK9jH6y/eJ6MI4tYnowMu6/RurOGy7sB+xnW+yH
         ovLJPHkjUAUyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BAB2AE68D2E;
        Mon, 13 Feb 2023 10:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: Fix unwanted sign extension in netdev_stats_to_stats64()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628241776.19101.3651405719184157565.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 10:00:17 +0000
References: <20230210123644.489-1-svc.sw.rte.linux@sma.de>
In-Reply-To: <20230210123644.489-1-svc.sw.rte.linux@sma.de>
To:     Felix Riemann <svc.sw.rte.linux@sma.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, kuba@kernel.org, davem@davemloft.net,
        felix.riemann@sma.de
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Feb 2023 13:36:44 +0100 you wrote:
> From: Felix Riemann <felix.riemann@sma.de>
> 
> When converting net_device_stats to rtnl_link_stats64 sign extension
> is triggered on ILP32 machines as 6c1c509778 changed the previous
> "ulong -> u64" conversion to "long -> u64" by accessing the
> net_device_stats fields through a (signed) atomic_long_t.
> 
> [...]

Here is the summary with links:
  - net: Fix unwanted sign extension in netdev_stats_to_stats64()
    https://git.kernel.org/netdev/net/c/9b55d3f0a69a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


