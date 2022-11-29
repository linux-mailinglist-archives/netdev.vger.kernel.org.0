Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3BE163C610
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbiK2RDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236458AbiK2RCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:02:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081EF6DCCF
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:00:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92C386186E
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 17:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C51CDC43154;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669741218;
        bh=XAHVW08XrMfIxoz7ba1R/a5dWTTtcV6aJw8XzNxkENw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IM6+KaR/Um9TjKGPtznl9iSD2LrleXh5gQVU3tit4scIJrtKkxggRIlmgWYuxpDKA
         OAlMMx339T46ocKXfak5TEwB+SY/JXNmVUxG2k0UBq+QmHMDHzmAOb5L1aOpizCjFO
         m+bqAI1Uz5e+Xv4J1Rh48Xssxyy198i/juuJHtKL6Xjp9DaeCk3Si9i4mtgKny0g1u
         NyCmMgP1/+UV+zks/i+dRbVwrx17OoyScH+f1A1zpAbXCLyHzjhver0oDOxgSfSD45
         AIrtaO/NFiRoRXvujYFPhUYg2xc1EcmVck9CCKBNogISKisR3dKR/J6/hI/bVDrO3A
         NJO9l75TnIEEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAD36C395EC;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] udp_tunnel: Add checks for nla_nest_start() in
 __udp_tunnel_nic_dump_write()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166974121868.7750.5190506211030829840.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 17:00:18 +0000
References: <20221129013934.55184-1-yuancan@huawei.com>
In-Reply-To: <20221129013934.55184-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 29 Nov 2022 01:39:34 +0000 you wrote:
> As the nla_nest_start() may fail with NULL returned, the return value needs
> to be checked.
> 
> Fixes: c7d759eb7b12 ("ethtool: add tunnel info interface")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
> Changes in v2:
> - return directly without calling nla_nest_cancel if nest_start fails
> 
> [...]

Here is the summary with links:
  - [v2] udp_tunnel: Add checks for nla_nest_start() in __udp_tunnel_nic_dump_write()
    https://git.kernel.org/netdev/net-next/c/7a945ce0c19b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


