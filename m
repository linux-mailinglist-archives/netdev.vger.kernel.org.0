Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7294B5A33D7
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345452AbiH0CkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238065AbiH0CkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97B872EC1
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 19:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA3361D52
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 02:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94DC6C43143;
        Sat, 27 Aug 2022 02:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661568015;
        bh=Q9eKbUhPWSis1KI+mqo4yq7qpB7yL07vPAoO+7FydEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gwHWKAx3unGMP21S/f3u4hiO5wpEpb4hqXO9y27lapb4CxaR+eZt3bgnOy76zb+sN
         jQOjEmsqtJHOnoSrTnjUzrx8RNzFwlSP2ungyrHNgj5UO6OmbGcre5uSFVyQa/v6BJ
         otJUazLwGnov/KXclk7SheUfkmOCPbNbN6/ZqQKBlnE8/pEg0NwHGLKkmlq4RoEj10
         yramRxQXT/mu+WAaiBGt8Sld4/wN+khdRJvo2nKwKvSZN8DiXSf9b4+DrNtvtFLzc/
         xP6lJm8DNbcX5ihX27tzBp8+QqCVumFeXQn1lqwB/fUGVXvhJgqzfy3DuDt41Uuny7
         yXgdLgJgL0vqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7285FE2A03B;
        Sat, 27 Aug 2022 02:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ftmac100: add an opportunity to get ethaddr
 from the platform
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156801546.24651.4891467877557509013.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 02:40:15 +0000
References: <20220824151724.2698107-1-saproj@gmail.com>
In-Reply-To: <20220824151724.2698107-1-saproj@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, tangbin@cmss.chinamobile.com,
        caizhichao@yulong.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 18:17:24 +0300 you wrote:
> This driver always generated a random ethernet address. Leave it as a
> fallback solution, but add a call to platform_get_ethdev_address().
> Handle EPROBE_DEFER returned from platform_get_ethdev_address() to
> retry when EEPROM is ready.
> 
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ftmac100: add an opportunity to get ethaddr from the platform
    https://git.kernel.org/netdev/net-next/c/f7650d82e7dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


