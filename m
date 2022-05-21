Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F8852F6CD
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240979AbiEUAaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbiEUAaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419051A8E33
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8B6161E7A
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3871BC34113;
        Sat, 21 May 2022 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653093012;
        bh=WMVlvRY/Xb/uCPlG4nLfNoK9Pua7EYrfqbkyspSLLXI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XGPi6zedRk75QT0LifHYeQ05+b9Wa3Ni86rOAX5nHuO3O8wT9gti6Tsd9wKRA9duA
         sUBcuIGxYxqxKbJpOX1TPVjaHe4XwVudGbym/tfy0yvCruSw5vUX2G+UWNLhCeVteX
         W43aQVzI/q8TCa3ONvjbzhrvBXgAvJeQ37zkAyLlF/blseIzv5g1l42tu6LuGtuNow
         qqJVZ8irNO6mNlb6HxTU3eGqgw0sShr9P2muSzIif3x3KBh1dZqtmTX0+/rUu8V4xS
         OwYOVrSj/yMuzWOrzuCVBx+Y530jd1ayMWVnvsIRV0/Wl7agGu9El5z6GGVidlnxYK
         HGJgsZJL7B+nQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E76EF03935;
        Sat, 21 May 2022 00:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] amt: fix several bugs in gateway mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165309301212.22995.11228908547499592477.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 00:30:12 +0000
References: <20220519031555.3192-1-ap420073@gmail.com>
In-Reply-To: <20220519031555.3192-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 May 2022 03:15:53 +0000 you wrote:
> This patchset fixes bugs in amt module.
> 
> First patch fixes amt gateway mode's status stuck.
> amt gateway and relay established so these two mode manage status.
> But gateway stuck to change its own status if a relay doesn't send
> responses.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] amt: fix gateway mode stuck
    https://git.kernel.org/netdev/net/c/937956ba404e
  - [net,v3,2/2] amt: fix memory leak for advertisement message
    https://git.kernel.org/netdev/net/c/fe29794c3585

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


