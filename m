Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2445F2ECD
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiJCKaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiJCKaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653B417E2B
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 03:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0548561030
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 10:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59E71C433D7;
        Mon,  3 Oct 2022 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664793015;
        bh=j0D8oTj9RkGPx3r+Y9zbrKKnmLhBl2zPTpt96ZZXzX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lBmh68IH3n6WiqnlESAgdF6rWbFl+w1/xcz0wJruElFA2zksX7ITsfOK7GrWh3IZu
         wTUMwHaLIgA75IarPjRljTPnRxq2eaPDuMhAVEOT27SYLvidhcXIiAU87M3Cn64UyW
         DpSvDWkFIHzffRvUs3sxozscdmHapwjRGzP6pqH7j6BqlrHmQzxO6o7qztMpKNp5GF
         U9xT/UFgT33h694irkTZJuyDbOtWbKn3mJvqpIKkRs0PlHHaD1j3Ub9mZYNUh3eh8d
         jOgiIjInon+CqOQPytomHWloEunpGPHR/fUCUbY+7PUh+XU+gB3TkRqZXIhBleSvF/
         VAfuXcsPa0orQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E982E49FA3;
        Mon,  3 Oct 2022 10:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mptcp: Fastclose edge cases and error handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166479301525.16659.10170233560491819369.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 10:30:15 +0000
References: <20220930155934.404466-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220930155934.404466-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 30 Sep 2022 08:59:30 -0700 you wrote:
> MPTCP has existing code to use the MP_FASTCLOSE option header, which
> works like a RST for the MPTCP-level connection (regular RSTs only
> affect specific subflows in MPTCP). This series has some improvements
> for fastclose.
> 
> Patch 1 aligns fastclose socket error handling with TCP RST behavior on
> TCP sockets.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] mptcp: propagate fastclose error
    https://git.kernel.org/netdev/net-next/c/69800e516e96
  - [net-next,2/4] mptcp: use fastclose on more edge scenarios
    https://git.kernel.org/netdev/net-next/c/d21f83485518
  - [net-next,3/4] selftests: mptcp: update and extend fastclose test-cases
    https://git.kernel.org/netdev/net-next/c/6bf41020b72b
  - [net-next,4/4] mptcp: update misleading comments.
    https://git.kernel.org/netdev/net-next/c/d89e3ed76b6e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


