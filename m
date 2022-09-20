Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8070B5BD8FC
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiITBA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiITBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6616A4A81F
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19195B81D49
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6483C433D6;
        Tue, 20 Sep 2022 01:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663635615;
        bh=die9vT08riHWIh7JH9KXxItK607D0W6o+ZyVamcA4Bw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sxuqw80APE3+xHKtL9dSP8fK1k6cQVC5Of2wk7NF81gr6eqTxkuFAHVyAMj7aKFyD
         NJvHY6erK3UjdK36ssSg2tpYDVmFyiE84HUmKRkOX8ybutlnPAoNGe3DKDgOl66tmr
         SlvjeoHBMqT1mCVFLk1TanBeN+t3A1IYU9inYFp5L8XGFj58zfopuxr0gqy2Zu2oBT
         CmKjZEFpkepGCKW2hOYNC/bkQFIrVCio2cyopzV8x3yo8gV2Jz6BYxZDSz9u23BqmB
         vUowWSFIKYOtaGQegKEJ7NTcQJ8qz+sqFxySZbN4DvYs/OhmRn5kQHuD0NuGFA6xKq
         umbJ7qm4e/EGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8805CE52537;
        Tue, 20 Sep 2022 01:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: gve: update developers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363561555.18776.12499679552749251057.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:00:15 +0000
References: <20220913185319.1061909-1-jeroendb@google.com>
In-Reply-To: <20220913185319.1061909-1-jeroendb@google.com>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
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

On Tue, 13 Sep 2022 11:53:19 -0700 you wrote:
> Updating active developers.
> 
> Signed-off-by: Jeroen de Borst <jeroendb@google.com>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - MAINTAINERS: gve: update developers
    https://git.kernel.org/netdev/net/c/6fb2dbdb2689

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


