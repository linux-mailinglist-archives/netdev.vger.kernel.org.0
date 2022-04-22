Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90C750B6B8
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 14:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447251AbiDVMDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 08:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446938AbiDVMDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 08:03:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C68963F2
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 05:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECA67B82A99
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 12:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA7E5C385AB;
        Fri, 22 Apr 2022 12:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650628812;
        bh=sZdDlzOaSm+rHxfe3mHgbmCVCuRcQlgGiqOl5G1mPis=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qjyo2HzCLJIKLB1dDmuss8wDCYxjsTWtSeMelXyZ6206wB7jlpOrb8AatMACTK/Qr
         BVb++jwQRKP3b51/uvBFxfdYoQsMzNX0q9JAtkmKARub6ExQ9h8vsUTCg4YfZIOTgi
         tz1fbeMv7ZtGLLbo0q0YbVigw6ejkDvNgnaUljdkdN7ZsRhVjux4SMcFB8EJGETqJ+
         PjwHbr64nci9w4PHsjV2g3gNLKYVxbBgRqu6oLyjCXn55kl7kSirv/qZC2xY1wvPMm
         /rWaOgWIIhQrqGegmftkSF5yZVlwHLPnLS5Qllj8UrlPWiOWYMPq4R4edVwIXORWYK
         Jjnw8+fnrDdDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8DC8CE8DD61;
        Fri, 22 Apr 2022 12:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] ipv6: Use ipv6_only_sock helper function.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165062881256.32249.11706792649172160945.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 12:00:12 +0000
References: <20220420015851.50237-1-kuniyu@amazon.co.jp>
In-Reply-To: <20220420015851.50237-1-kuniyu@amazon.co.jp>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        kuni1840@gmail.com, netdev@vger.kernel.org
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

On Wed, 20 Apr 2022 10:58:49 +0900 you wrote:
> The first patch removes __ipv6_only_sock(), and the second replaces
> ipv6only tests with ipv6_only_sock().
> 
> 
> Kuniyuki Iwashima (2):
>   ipv6: Remove __ipv6_only_sock().
>   ipv6: Use ipv6_only_sock() helper in condition.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ipv6: Remove __ipv6_only_sock().
    https://git.kernel.org/netdev/net-next/c/89e9c7280075
  - [net-next,2/2] ipv6: Use ipv6_only_sock() helper in condition.
    https://git.kernel.org/netdev/net-next/c/81ee0eb6c0fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


