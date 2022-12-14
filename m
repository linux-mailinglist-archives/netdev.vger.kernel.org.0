Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF46B64C2F5
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 05:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237333AbiLNEAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 23:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237300AbiLNEAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 23:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BE017886;
        Tue, 13 Dec 2022 20:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55865617DB;
        Wed, 14 Dec 2022 04:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93EC6C433D2;
        Wed, 14 Dec 2022 04:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670990418;
        bh=xYxuiqcBJV0kcYIpJnRIXcwSQNFqwMkVyxdxTBaeTKY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KsKSs0T6+/YI3AphEbAQdQVp/VBhlPZL6lwczlX11i3wH3hcyA8CdRCNPXtouC73N
         jTAiuv3LRMoC2KZ1g3eq3zKxrcr7zYeNbZqIRfrZUeIXQNLdhRAfSpaj2JrkWov0ny
         H8AZWUMKArxIy176sH7yf/IItpkGHDue3ottqMMuK9L47rTQG50VQLqPaxg6i+xX93
         DR6hxzVVjlbOdGrRKwP1Wq/G6sIB/Hn/a/jOQG7+0n+jR90lBLzlf0Tr+jgylOYynb
         2Mr7G1RDmgfPgMVuTXEu6wDcoTk6wKexheQWqyYSTWQVrwZT1fyaHtoO61SdRZafYJ
         TskzzLMlfFlhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66B7AC41612;
        Wed, 14 Dec 2022 04:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: flowtable: really fix NAT IPv6 offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167099041841.9337.6614576753638501976.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Dec 2022 04:00:18 +0000
References: <20221213140923.154594-2-pablo@netfilter.org>
In-Reply-To: <20221213140923.154594-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue, 13 Dec 2022 15:09:21 +0100 you wrote:
> From: Qingfang DENG <dqfext@gmail.com>
> 
> The for-loop was broken from the start. It translates to:
> 
> 	for (i = 0; i < 4; i += 4)
> 
> which means the loop statement is run only once, so only the highest
> 32-bit of the IPv6 address gets mangled.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: flowtable: really fix NAT IPv6 offload
    https://git.kernel.org/netdev/net/c/5fb45f95eec6
  - [net,2/3] ipvs: add a 'default' case in do_ip_vs_set_ctl()
    https://git.kernel.org/netdev/net/c/ba57ee0944ff
  - [net,3/3] netfilter: conntrack: document sctp timeouts
    https://git.kernel.org/netdev/net/c/f9645abe4255

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


