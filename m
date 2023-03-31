Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF81B6D1A95
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjCaImY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbjCaIl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:41:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AD21BF43;
        Fri, 31 Mar 2023 01:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FBF5B82D3D;
        Fri, 31 Mar 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0691FC4339E;
        Fri, 31 Mar 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680252019;
        bh=FWKsKe1yHbWimPn7XK0smhGOkdRzTdqrqBDmVegrqP0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QiTfzEg2XDupVkrpzwxGAvkaUqIufd7g8rRDWSUUBhNDviz9dh7SprLOhyVs7h6V0
         SJ2udDdkbAHNfIdfvFtqm2tZtp6dfX2JqbuvaZkZrjEZQ8hAHvTYLhIAecjgSl+uh1
         f7WTcC2SEgDFiG9zuW7RaaSFUuHr6fhH5RQx62FsrlGJD37/Kl1Yi1lREa2ld4KCx2
         Bu5Ch6AEyzA9Pkzh7e2XnVFUU95Tgf4C7Ym7HhKP2gTtXO+j6Du1i2M8CVqUTzvafF
         +f8fjtL+ZGR8P3SbNNA4VxxVq/U91iCu/SQJgCTN/+S7JAWsK37mqL4VR9YyeNDy6w
         KKimrnQrcjhKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1E6EE2A032;
        Fri, 31 Mar 2023 08:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: netcp: MAX_SKB_FRAGS is now 'int'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168025201885.3875.15510680598248652530.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 08:40:18 +0000
References: <20230331074919.1299425-1-arnd@kernel.org>
In-Reply-To: <20230331074919.1299425-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     kuba@kernel.org, arnd@arndb.de, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, razor@blackwall.org,
        kerneljasonxing@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, 31 Mar 2023 09:48:56 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The type of MAX_SKB_FRAGS has changed recently, so the debug printk
> needs to be updated:
> 
> drivers/net/ethernet/ti/netcp_core.c: In function 'netcp_create_interface':
> drivers/net/ethernet/ti/netcp_core.c:2084:30: error: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Werror=format=]
>  2084 |                 dev_err(dev, "tx-pool size too small, must be at least %ld\n",
>       |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - net: netcp: MAX_SKB_FRAGS is now 'int'
    https://git.kernel.org/netdev/net/c/c5b959eeb7f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


