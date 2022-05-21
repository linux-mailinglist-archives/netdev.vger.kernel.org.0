Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D599152F6B3
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344008AbiEUAUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbiEUAUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:20:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3C4190D04
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 637D161E6F
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7F55C34116;
        Sat, 21 May 2022 00:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653092411;
        bh=dj26Jwdzm9QiNBl+RaMkZB1u1pZQ8OMe4EpQihRQXy0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XdhGwl2cC6H0H6mtYwlrsx9VjOj8/SxH0culcY4twgiUrVp0imIRxi+Lt08BaOH1C
         EGuQvDH4zeMlXceevWVIlqu44fP0ndJhOovxWAC/pWAJ1nzyszn7/hqTJo2mBLer0i
         2fdNaLv7AMStI9ekotSyGdO63ydNzfYP2D8dIp70pzC0LB+ypbvCK7Vua7pZMb9kpn
         ivHz5EgSomJGTDA4vo2rXLgcYne/5bKtA2E9nYchngrUe5veG4KBsAlc+lB6uv0OJv
         mPeCVmHnN+1u1tIsMgXfW0zMRGy+z3JBxP7qtHgitPaBk3jZdaG1Q3GYlfxQfej7Fj
         X+iTdCxYBrycw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 992CCF0393B;
        Sat, 21 May 2022 00:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: avoid strange behavior with skb_defer_max == 1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165309241162.18678.15841559913999276688.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 00:20:11 +0000
References: <20220518185522.2038683-1-kuba@kernel.org>
In-Reply-To: <20220518185522.2038683-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     edumazet@google.com, netdev@vger.kernel.org, pabeni@redhat.com,
        davem@davemloft.net
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 May 2022 11:55:22 -0700 you wrote:
> When user sets skb_defer_max to 1 the kick threshold is 0
> (half of 1). If we increment queue length before the check
> the kick will never happen, and the skb may get stranded.
> This is likely harmless but can be avoided by moving the
> increment after the check. This way skb_defer_max == 1
> will always kick. Still a silly config to have, but
> somehow that feels more correct.
> 
> [...]

Here is the summary with links:
  - [net-next] net: avoid strange behavior with skb_defer_max == 1
    https://git.kernel.org/netdev/net-next/c/c09b0cd2cc6c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


