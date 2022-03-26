Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88BFC4E845E
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 22:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235389AbiCZVVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 17:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiCZVVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 17:21:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3461C54FA1
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 14:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53A7C60E71
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 21:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D3E2C340F3;
        Sat, 26 Mar 2022 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648329610;
        bh=RE8uE2dUd5xZUYW8W3ng9WHtsXzyo5OWJEao4J3r19M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W9xangEhtMo7EkUSzyyKUYiznvJ1NV7bS1XZZbEFlcXMA+Ssh9Y1WKSWTAE+BEaT+
         qP6fY5qbRTkFsVpejGMamAMEM0HQP2HK2oYD8vZODNf/l0KoDd3Asz76Z72u0+eYmS
         PjuDTKeUCGMivE9or5ZOTpveoGeWpfTbfgugKb6E53gA3Vt8aFSj5UwzZC4NZjo84y
         F9cLbtCImd1wdAwAj0ErzfE0ZmsgBUscR83Z6wYv7tjfMBnyXKA5KqWpKnkRBNDgtW
         H0b5MUm8YsGIj0p9BoXzEnrFHcd6A2VRRHWAP9JsFj/ZnrU6vmrFmCKy2fC4C1IBWs
         8Ly7UCR7uYygQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 783BEEAC081;
        Sat, 26 Mar 2022 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: fix a memory leak in smc_sysctl_net_exit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164832961048.3419.2705852243081396804.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Mar 2022 21:20:10 +0000
References: <20220325165021.570708-1-eric.dumazet@gmail.com>
In-Reply-To: <20220325165021.570708-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com, tonylu@linux.alibaba.com,
        dust.li@linux.alibaba.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 25 Mar 2022 09:50:21 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Recently added smc_sysctl_net_exit() forgot to free
> the memory allocated from smc_sysctl_net_init()
> for non initial network namespace.
> 
> Fixes: 462791bbfa35 ("net/smc: add sysctl interface for SMC")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Tony Lu <tonylu@linux.alibaba.com>
> Cc: Dust Li <dust.li@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net] net/smc: fix a memory leak in smc_sysctl_net_exit()
    https://git.kernel.org/netdev/net/c/5ae6acf1d00b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


