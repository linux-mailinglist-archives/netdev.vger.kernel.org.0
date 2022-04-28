Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935D4513A96
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350292AbiD1RDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350450AbiD1RD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:03:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D653662F1;
        Thu, 28 Apr 2022 10:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 742D6620F8;
        Thu, 28 Apr 2022 17:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7BAEC385AA;
        Thu, 28 Apr 2022 17:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651165212;
        bh=cCtrgjgusVEBkTAX3hK6ikV2bq1QG8oodSSC/P5hisk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B2PW4ThI1NgppRwHKqCPAqxOxFFF8XRwmU7tbhWcsQddTbpwo2vSRfKy58l7b2FpS
         okgjPoPYPgDeF9IV2mMoZMA5C9EwiKnsUdylwTFZEf9NaHIT7pw5sR/8PCriUkuZZ2
         /5TZWwimyW/UId8Hk91xUW1DTraAVR8IwMjof3OthgjcTV77V3rGbVYTa3hOc+jXKG
         YQTuB3Q3slp9Pd4WQXQNU8NutqamG4NlcCkAvExvHIpEiqu+lBUAZAWOh/LcZ1opq6
         ptBtixiLWUJ9I38J3qdoD/GDPTQ+ZhT/a6Z6DOXIw9P8VyDlfEJydCJzLJED+fRtdp
         5Q81E99If21vA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A27ECF03840;
        Thu, 28 Apr 2022 17:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nf_conntrack_tcp: re-init for syn packets
 only
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165116521266.24173.17359123747982099697.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 17:00:12 +0000
References: <20220428142109.38726-2-pablo@netfilter.org>
In-Reply-To: <20220428142109.38726-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 28 Apr 2022 16:21:07 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Jaco Kroon reported tcp problems that Eric Dumazet and Neal Cardwell
> pinpointed to nf_conntrack tcp_in_window() bug.
> 
> tcp trace shows following sequence:
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nf_conntrack_tcp: re-init for syn packets only
    https://git.kernel.org/netdev/net/c/c7aab4f17021
  - [net,2/3] netfilter: conntrack: fix udp offload timeout sysctl
    https://git.kernel.org/netdev/net/c/626873c446f7
  - [net,3/3] netfilter: nft_socket: only do sk lookups when indev is available
    https://git.kernel.org/netdev/net/c/743b83f15d40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


