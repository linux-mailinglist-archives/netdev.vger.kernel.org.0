Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5646503075
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiDOVcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356152AbiDOVcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:32:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69873205FF
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0607562196
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 21:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 577A2C385A5;
        Fri, 15 Apr 2022 21:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650058213;
        bh=ii+weITtP0kXb0+ktPEYsOLMgRbnOZ5OJ7ZLnzZMZo8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YJGPwMhC6PwKS/iePxQO1edJdJFTqYlSxpOf1PNx3im2VxLHj13fchSUDCJWmBms0
         lHJxN/lfC4u9k5OwNHeg9OMNrA7i5qrHtmNJfvf5PY/RZzRfSfCDTocyuUnWKWEcuH
         01RVGTjqNlZDmeLiX4cbs/3J9r2DC1iP0x2Vvuh6z0rLqdjh+z45H1C6dbxzP7tM9Z
         ogRQghzoc56F0FsHCJSMBjMagsnXsY5j6/0VAxRw5dOK6u2lHDDs8Hro/b0EF6NU/i
         ZA1UNfzgrsEk8W0OIf9L/efTDdXfaTwXdFwy8hrrH11Rk7OBYBvmro9gjK73/8yCip
         JnUGZcC8+SeAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37F71E7399D;
        Fri, 15 Apr 2022 21:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: fix NULL deref in ip6_rcv_core()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165005821322.11686.8977962130641188189.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 21:30:13 +0000
References: <20220413205653.1178458-1-eric.dumazet@gmail.com>
In-Reply-To: <20220413205653.1178458-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        imagedong@tencent.com, benbjiang@tencent.com,
        flyingpeng@tencent.com
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

On Wed, 13 Apr 2022 13:56:53 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> idev can be NULL, as the surrounding code suggests.
> 
> Fixes: 4daf841a2ef3 ("net: ipv6: add skb drop reasons to ip6_rcv_core()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Menglong Dong <imagedong@tencent.com>
> Cc: Jiang Biao <benbjiang@tencent.com>
> Cc: Hao Peng <flyingpeng@tencent.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: fix NULL deref in ip6_rcv_core()
    https://git.kernel.org/netdev/net-next/c/0339d25a2807

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


