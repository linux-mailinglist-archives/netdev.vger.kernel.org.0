Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180A1545BC3
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346231AbiFJFk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244868AbiFJFkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FEB4198E
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 22:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0320961E67
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 05:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 531BEC3411B;
        Fri, 10 Jun 2022 05:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654839616;
        bh=Mm5UXV+lk4cnIeIKQjczDlqJPRRpr2aNazB+Ie9/vQg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bxipXuYHCs7fkwUBgQgKvbRr8L+06cv/XFMgF0xuqjkk8tVdZ5EmhRzdtKjQ7LLF6
         GON1t/kaaGRbkWK2QzEt+HXidmuQT60+gYUVX4lQFyHSdPC8YKof06rgyfcoYvQIJS
         heyYSTtqt110Jb6NU5+MiGzrvj9XKXNbqMWqRHi/5nRLzxdelchS6ZX7xFd/JO7q7d
         Pt2aEz6p5H6fakLPivWqefcgud6LFlOkeab3z0q0ogv7G3E8PThWs9sNLHCcy4mFCq
         V94Rid5Gjf0EIcfPd0jdBDHYgdFH3tLH2nIKUE1C3c/K451qFAhGJRj4dwgcjOvTlR
         7q14+oKU3oA7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 368E4E737F6;
        Fri, 10 Jun 2022 05:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/9] net: adopt u64_stats_t type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165483961621.13976.13189343193189487946.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 05:40:16 +0000
References: <20220608154640.1235958-1-eric.dumazet@gmail.com>
In-Reply-To: <20220608154640.1235958-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Jun 2022 08:46:31 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While KCSAN has not raised any reports yet, we should address the
> potential load/store tearing problem happening with per cpu stats.
> 
> This series is not exhaustive, but hopefully a step in the right
> direction.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/9] vlan: adopt u64_stats_t
    https://git.kernel.org/netdev/net-next/c/09cca53c1656
  - [v2,net-next,2/9] ipvlan: adopt u64_stats_t
    https://git.kernel.org/netdev/net-next/c/5665f48ef309
  - [v2,net-next,3/9] sit: use dev_sw_netstats_rx_add()
    https://git.kernel.org/netdev/net-next/c/3a960ca7f6e5
  - [v2,net-next,4/9] ip6_tunnel: use dev_sw_netstats_rx_add()
    https://git.kernel.org/netdev/net-next/c/afd2051b1840
  - [v2,net-next,5/9] wireguard: receive: use dev_sw_netstats_rx_add()
    https://git.kernel.org/netdev/net-next/c/eeb15885ca30
  - [v2,net-next,6/9] net: adopt u64_stats_t in struct pcpu_sw_netstats
    https://git.kernel.org/netdev/net-next/c/9962acefbcb9
  - [v2,net-next,7/9] devlink: adopt u64_stats_t
    https://git.kernel.org/netdev/net-next/c/958751e0807d
  - [v2,net-next,8/9] drop_monitor: adopt u64_stats_t
    https://git.kernel.org/netdev/net-next/c/c6cce71e7468
  - [v2,net-next,9/9] team: adopt u64_stats_t
    https://git.kernel.org/netdev/net-next/c/9ec321aba2ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


