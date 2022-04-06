Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52CC4F6BF6
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbiDFVBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiDFVBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:01:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34711B29C9
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 12:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E69961CD9
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 19:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B8B4C385A6;
        Wed,  6 Apr 2022 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649273412;
        bh=YqQN0SSokTfqiyEuz3Tepfwz5eLP+QweUuPCy0fP4OU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oZGCYJo539lyzBEgTy6+XiOCJbUmQu85EdQwKaA1xlats9ndgYcLhEcPKqOghLNub
         I/2VURm8x7/fxsG7sEsviqPiyf0vjpoHtbOpCS6I/oeky58tI76bPS3bvIO5tsXJgM
         jTuwbdPB7QyQ3TZ46/ksDu0if5VdrSizo53bkrzkaVnSTdhOPQijPl0I5WeIMpymyD
         E6rKRhWJpPXx2iXQVDJwFLyuf4NoMP4Gtau+WXhZ1UJz2f+oTJWKP975WSxARMA7K8
         haQpUkHhp6G1y5uOVhVd53EB7qLwXPGR/bE2gNB25RgT1GUuCSYiY1nuQ/sc2VgcP5
         Sz70+SFGIUhHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D3DBE4A6CB;
        Wed,  6 Apr 2022 19:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: add accessors to read/set tp->snd_cwnd
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164927341244.23847.2003241101072166006.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 19:30:12 +0000
References: <20220405233538.947344-1-eric.dumazet@gmail.com>
In-Reply-To: <20220405233538.947344-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, ycheng@google.com,
        ncardwell@google.com
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

On Tue,  5 Apr 2022 16:35:38 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We had various bugs over the years with code
> breaking the assumption that tp->snd_cwnd is greater
> than zero.
> 
> Lately, syzbot reported the WARN_ON_ONCE(!tp->prior_cwnd) added
> in commit 8b8a321ff72c ("tcp: fix zero cwnd in tcp_cwnd_reduction")
> can trigger, and without a repro we would have to spend
> considerable time finding the bug.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: add accessors to read/set tp->snd_cwnd
    https://git.kernel.org/netdev/net-next/c/40570375356c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


