Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C614C0665
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbiBWAui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiBWAui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:50:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B534B3EA95
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08CDE61341
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 00:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 589B5C340EB;
        Wed, 23 Feb 2022 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645577410;
        bh=19HYayD7sa21K0Ytt9KhXe65vUHPZ1LrIdxn68q4BuI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sEC1c5ABP1eIEcan1YpTNilGHQVuzOidJhgdg/1XQKojqQDvC4cVzyiRXxf67x0Nu
         dUl36S+hNUTrow69G/K6ih6VAihMMv3gqo5LhRb3f9cymdAeO75FqXs8TqZbxt6ayK
         Xel/wqfzzOGGQ/ihgvh78d8uSH0+qWNqM9+cAMRPzkVkjWNYFV7ZenrlI0+mNhlWya
         cT0xU9frWRlNJQLfN7A6AhP6agNlhsaWMa8jcLu3nrBlB1kUCHqWuiRPo5piWXvCvC
         6nkgvfb32aDzILHQEc6mpP6JcAIyIXujZCgrABYTgEkjhDaqIROBZxBpIUtT2OuraA
         RIlG0MeNN/F4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 40C58EAC081;
        Wed, 23 Feb 2022 00:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: __pskb_pull_tail() & pskb_carve_frag_list()
 drop_monitor friends
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164557741026.21569.5119589420369122420.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 00:50:10 +0000
References: <20220220154052.1308469-1-eric.dumazet@gmail.com>
In-Reply-To: <20220220154052.1308469-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 20 Feb 2022 07:40:52 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Whenever one of these functions pull all data from an skb in a frag_list,
> use consume_skb() instead of kfree_skb() to avoid polluting drop
> monitoring.
> 
> Fixes: 6fa01ccd8830 ("skbuff: Add pskb_extract() helper function")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net] net: __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor friends
    https://git.kernel.org/netdev/net/c/ef527f968ae0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


