Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E906515E24
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 16:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382854AbiD3OXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 10:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382833AbiD3OXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 10:23:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35024634D
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 07:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96300B83085
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 14:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C6E2C385A7;
        Sat, 30 Apr 2022 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651328411;
        bh=JE67vo7VWh9skI4W3D4RtU3MlLS3dOF1koK7QzcCs0U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BqHGv9bQSGztWB9SV0ds3qtN9dB58hUqn7DTHMuJLljl74Vu5Dzs/RGGz1/Y4tAAY
         SemYUVnuoS4lfi5HjvD5/RMku5N+D6ySTktNZkeH1zR6syXqgYhOJvr+Gs2gi4wz1H
         HmCKgZ+wK4Q21fGMOuqujq410lxHEi3/zuBVbyETx0a+jc7r/EGD5LzDTsInHa8yWw
         /KjHgdybHKzjtVDizG9RPuZ1XxxON8aJf7UxFXGHXnGNAqGpotkiKWTWhfeEJAxVkb
         vOBfdLHbI730fqNyjFsg8znts+TZLH0VuWZiYB2E5fu+8C+PiEZkv6LiPSctyFwGCg
         3AzgR/nhWXehw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21884E8DBDA;
        Sat, 30 Apr 2022 14:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: igmp: respect RCU rules in ip_mc_source() and
 ip_mc_msfilter()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132841113.7113.10658727043076313489.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 14:20:11 +0000
References: <20220429154257.2054294-1-eric.dumazet@gmail.com>
In-Reply-To: <20220429154257.2054294-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com, fbl@sysclose.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Apr 2022 08:42:57 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot reported an UAF in ip_mc_sf_allow() [1]
> 
> Whenever RCU protected list replaces an object,
> the pointer to the new object needs to be updated
> _before_ the call to kfree_rcu() or call_rcu()
> 
> [...]

Here is the summary with links:
  - [net] net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()
    https://git.kernel.org/netdev/net/c/dba5bdd57bea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


