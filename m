Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52B553062F
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 23:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiEVVaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 17:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiEVVaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 17:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6DD14D2A
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 14:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D81260EEF
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 21:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0595DC385AA;
        Sun, 22 May 2022 21:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653255014;
        bh=nVb2K4n8sOSU7qYy1al9t4XmohswyTnwCkMbgCNr3MY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nr49K3S3fLwwFG0s/Buz5/pZY5jCr9Pz4sOjwj/V/Ssb3RriUi0s3dps8UB1EV8rS
         W42y3xX9af3ViyC4W7MWXnabGS19+jC6NY1tz5kbp4/rUPPKHRXpnaoBrkkjAEFJ3U
         C7pysSJFTgG306kY6cISm9ePsY2YxSdXS4Ai3/FCS6QzVSkKsr+f4aFOpJl3Qqvobr
         hWrvG5Wsm7ztP03hJtaRK3/ik9rMir/mE7gdc2k6KttFW3Z3jfv/bU7Lt29kNOOBg/
         6zB+nM3YM4sUQ+uyYbl15fFiyoUFKl6LGfC5BqU1ha460CQXa3/aQ9uv1bHmvx1kJi
         Hij2zlNoohvUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E023CF03943;
        Sun, 22 May 2022 21:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] eth: silence the GCC 12 array-bounds warnings 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325501391.6697.6257899248261101798.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 21:30:13 +0000
References: <20220520195605.2358489-1-kuba@kernel.org>
In-Reply-To: <20220520195605.2358489-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 20 May 2022 12:56:02 -0700 you wrote:
> Silence the array-bounds warnings in Ethernet drivers.
> v2 uses -Wno-array-bounds directly.
> 
> Jakub Kicinski (3):
>   eth: mtk_eth_soc: silence the GCC 12 array-bounds warning
>   eth: ice: silence the GCC 12 array-bounds warning
>   eth: tg3: silence the GCC 12 array-bounds warning
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] eth: mtk_eth_soc: silence the GCC 12 array-bounds warning
    https://git.kernel.org/netdev/net-next/c/06da3e8f390a
  - [net-next,v2,2/3] eth: ice: silence the GCC 12 array-bounds warning
    https://git.kernel.org/netdev/net-next/c/385bc51b41ea
  - [net-next,v2,3/3] eth: tg3: silence the GCC 12 array-bounds warning
    https://git.kernel.org/netdev/net-next/c/9dec850fd7c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


