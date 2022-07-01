Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8D656338B
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 14:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbiGAMkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 08:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiGAMkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 08:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F2D3B027
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 05:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1DD8619A3
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 12:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E7ABC341C7;
        Fri,  1 Jul 2022 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656679215;
        bh=XkZF9QDE5BboUanwfpPLD7ZnP0eXUrPzW2SgFIEozcs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hIJWP+SiBaVgYqpOvc8JBSKptXO1z9pCcMev2eArv5eVflAhGA7MqdNmnb4G49Yi8
         N/H/XGwwVI2sRvZ+ygSJGm0PcB6sIhS//dF2cTzzOety/+7f0oo5Y9GHIzmhc5h8ns
         iL2n41U/MtK+zKxRGw/EnCIwRVbuQGqxZqAI3iE/noL4iyZYxYWhlxRqWumfDU8L7a
         dqPu7P5N7RLNTtk77FwOkFdWB/RQIyVJU1ucZcL/Ae+gc0HKpXOkwkXyXuV35hi2TH
         NStXVbMtZvAH4di3VyY7qYtO77wuH0P9c5xUWEh61TpVrgYE1oWt1qH/T9Q5mQE4ZS
         ZAsIMfBvbVL7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DB1EE49BB8;
        Fri,  1 Jul 2022 12:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mptcp: Updates for mem scheduling and SK_RECLAIM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165667921504.18764.8434604982955394989.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 12:40:15 +0000
References: <20220630221757.763751-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220630221757.763751-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Jun 2022 15:17:53 -0700 you wrote:
> In the "net: reduce tcp_memory_allocated inflation" series (merge commit
> e10b02ee5b6c), Eric Dumazet noted that "Removal of SK_RECLAIM_CHUNK and
> SK_RECLAIM_THRESHOLD is left to MPTCP maintainers as a follow up."
> 
> Patches 1-3 align MPTCP with the above TCP changes to forward memory
> allocation, reclaim, and memory scheduling.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] mptcp: never fetch fwd memory from the subflow
    https://git.kernel.org/netdev/net-next/c/4aaa1685f750
  - [net-next,2/4] mptcp: drop SK_RECLAIM_* macros
    https://git.kernel.org/netdev/net-next/c/d24141fe7b48
  - [net-next,3/4] mptcp: refine memory scheduling
    https://git.kernel.org/netdev/net-next/c/69d93daec026
  - [net-next,4/4] net: remove SK_RECLAIM_THRESHOLD and SK_RECLAIM_CHUNK
    https://git.kernel.org/netdev/net-next/c/e918c137db40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


