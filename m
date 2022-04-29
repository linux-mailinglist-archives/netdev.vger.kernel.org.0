Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB25147B3
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244275AbiD2LDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358033AbiD2LDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:03:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFF0220E1
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 04:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E67D661C3D
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 11:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C85BC385AD;
        Fri, 29 Apr 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651230015;
        bh=5XQoAtQjUGqYF5nDwmm8y+P/jBhtckQReMiq9GiD1n0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KVr5KS9r9XzwQde4bLLaxf/JcpVTrRj/FGlwCdp4y6lk5F5tfiNAQMhs7LG4y8e2r
         OxFcFI80qrhTPokqU/KRueDmJL9DphXL+h8gm0ecj2R/H9yosdbmtjjwl8HFbVDF6Z
         MJ+CuQ4C8PmGcJ+ZACTH4hx89+HMyWjIxmGWTJa0xaCpYMeq8iy46ytOd+OJifH15O
         8qpOj2b5+dqIJ9sUgl+hN6xiXr99d9UCLDlietV5spqxM5u7ImKF+jiWY66Pf6oJLo
         FM+3zBB1V4GTXhTFfrHlW8JPLv9t2TTZqcgQ29Bb4Sw/4rUl6Aw//ksWHtdbsS+O11
         kqoMcnQVn7t2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2FCF6F67CA0;
        Fri, 29 Apr 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/15] remove copies of the NAPI_POLL_WEIGHT
 define
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165123001519.25474.14622526763872302099.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Apr 2022 11:00:15 +0000
References: <20220428212323.104417-1-kuba@kernel.org>
In-Reply-To: <20220428212323.104417-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Apr 2022 14:23:08 -0700 you wrote:
> netif_napi_add() takes weight as the last argument. The value of
> that parameter is hard to come up with and depends on many factors,
> so driver authors are encouraged to use NAPI_POLL_WEIGHT.
> 
> We should probably move weight to an "advanced" version of the API
> (__netif_napi_add()?) and simplify the life of most driver authors.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/15] eth: remove copies of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/5f012b40ef63
  - [net-next,v2,02/15] eth: smsc: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/e2a303295d28
  - [net-next,v2,03/15] eth: cpsw: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/055e13f31f28
  - [net-next,v2,04/15] eth: pch_gbe: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/feda771f1b9e
  - [net-next,v2,05/15] eth: mtk_eth_soc: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/889e3691b9d6
  - [net-next,v2,06/15] usb: lan78xx: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/f130683b1e24
  - [net-next,v2,07/15] slic: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/b3c2b61ef621
  - [net-next,v2,08/15] net: bgmac: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/592df3663789
  - [net-next,v2,09/15] eth: atlantic: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/0258f5399f0c
  - [net-next,v2,10/15] eth: benet: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/e702def527ec
  - [net-next,v2,11/15] eth: gfar: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/bbbe6ecbc36d
  - [net-next,v2,12/15] eth: vxge: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/288696565f2d
  - [net-next,v2,13/15] eth: spider: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/26450aa7ca42
  - [net-next,v2,14/15] eth: velocity: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/e9c6ec651030
  - [net-next,v2,15/15] qeth: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/4bb0c7f09a19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


