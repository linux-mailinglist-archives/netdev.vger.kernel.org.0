Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A568568A80C
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 05:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbjBDEAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 23:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjBDEAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 23:00:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9188F25E
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 20:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1D816205C
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 04:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FF2BC433EF;
        Sat,  4 Feb 2023 04:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675483222;
        bh=YdmMhCeHwAMADoMWYg8CsSTrkCSqJAZkVYBjk1kua5s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p7g66MZg22TiUwvuTzlUU9GNnYSrf+mQHzPXS45aWsjQSjl6hsqpf3qnQ61soazTW
         fDGvgY3z17uEDQalv38f/LgBv0JVt+axZevHHrHS61S3Rlq1P1YVOfvlEi8hREaVpZ
         QA84i4CrKlQPU5CdkjUpe7GZHvpxMwCUocwu+I1yhG1UVetCI0oVh/KuvUhtQsqm7+
         pkXt478SfRzB090bG/1knNWpTyBLvXaKg3fzNjeRB7R8YEm1hULyiXguPmNcZTO3UI
         5Q9mD8aDBBoC9etqznzJF2eIYsn79ANVgKC4bbPqI6Rr3sm5jX82nlTsxAt5eotSSw
         f5ZJfYKyK9vQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB526C0C40E;
        Sat,  4 Feb 2023 04:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: phy: meson-gxl: use MMD access dummy stubs for
 GXL, internal PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167548322182.10981.1983902175330966920.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Feb 2023 04:00:21 +0000
References: <84432fe4-0be4-bc82-4e5c-557206b40f56@gmail.com>
In-Reply-To: <84432fe4-0be4-bc82-4e5c-557206b40f56@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, cphealy@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 2 Feb 2023 21:45:36 +0100 you wrote:
> Jerome provided the information that also the GXL internal PHY doesn't
> support MMD register access and EEE. MMD reads return 0xffff, what
> results in e.g. completely wrong ethtool --show-eee output.
> Therefore use the MMD dummy stubs.
> 
> v2:
> - Change Fixes tag to the actually offending commit. As 4.9 is EOL
>   this fix will apply on all stable versions.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY
    https://git.kernel.org/netdev/net/c/69ff53e4a4c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


