Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4E15E66E4
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiIVPUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiIVPUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919C07C777;
        Thu, 22 Sep 2022 08:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E6F561388;
        Thu, 22 Sep 2022 15:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8766AC433D7;
        Thu, 22 Sep 2022 15:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663860014;
        bh=Y/UYpzSr1GDE1c2TA1atoaallVLMUhHYl0REHUJdcTY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eop5zedDRJJAQd6MUsKKPvVths6VaEw+SnkkVXHClXyiuYDQ2kH89N/EbgIvD7QEM
         rlzSS1JYWkKpKkWNCOzOrgR6tM8oc1z/uU//aumUHA+JNxFgw61qdxIJhr49m7Bdl3
         DI9P2Qo+BwQVdqQUBlM6FCpYalU1T/RXw8LG+S04sW/xoBzBW2xVtSXsl4d+lNitjw
         l264DWja94UtiDOUFqSEnW/k9jLlt1thvA/0SXAzOn+4ObQpBVXp2iOjrZm7YfeFQM
         3BUt2Xkb6QFPCpxUUWSh2CPWo3ouXIhCWWDJ/8z3fKxWQL1TsEsH4dGSE6XpukhUHz
         Nwx77PCQVHTgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A0BCE21ED1;
        Thu, 22 Sep 2022 15:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v3] xsk: inherit need_wakeup flag for shared sockets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166386001443.15287.1242641673670233629.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 15:20:14 +0000
References: <20220921135701.10199-1-jalal.a.mostapha@gmail.com>
In-Reply-To: <20220921135701.10199-1-jalal.a.mostapha@gmail.com>
To:     Jalal Mostafa <jalal.a.mostapha@gmail.com>
Cc:     maciej.fijalkowski@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, hawk@kernel.org, ast@kernel.org,
        linux-kernel@vger.kernel.org, jalal.mostafa@kit.edu
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 21 Sep 2022 13:57:01 +0000 you wrote:
> The flag for need_wakeup is not set for xsks with `XDP_SHARED_UMEM`
> flag and of different queue ids and/or devices. They should inherit
> the flag from the first socket buffer pool since no flags can be
> specified once `XDP_SHARED_UMEM` is specified.
> 
> Fixes: b5aea28dca134 ("xsk: Add shared umem support between queue ids")
> 
> [...]

Here is the summary with links:
  - [bpf,v3] xsk: inherit need_wakeup flag for shared sockets
    https://git.kernel.org/bpf/bpf/c/60240bc26114

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


