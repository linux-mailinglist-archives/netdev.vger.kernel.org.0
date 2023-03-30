Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AF86D0435
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjC3MAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjC3MAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14ADA24B
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 485BFB828A4
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01F7FC433EF;
        Thu, 30 Mar 2023 12:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680177619;
        bh=pzf6xeKUKGwNyll4u+NGrBnUcwfncKDEFYVkI0GJQDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dQ6VAM5TNsebr2eVHo3flPYy7E2u5+suxoKo9ZCQDmfSDCxJ07pcSgRsubsUTPmYk
         1tcPbDUgdQ61H4w4pT/kAwktZx7QtosemZtlbkSX7o9xvmuuoE6E9VVFRpvgBCNaSt
         s4FvpPKp85gVYIOrMt3Qzly8l6Ic2Fly0VyjMBhsEJRqo7lFMH6aBWi/EQPUo4kazc
         0N44vjWvp1dvOsYNTzCg3LRkGj5tgxWdR7Sdf4//pyCBoeJO7GzWQJ1m60jx2mJPDr
         6WGknyfUFL/6aNVU4zRvn+9MKtze44fgpTY7wi3SfqU1XsIbH/Onuv1e3KIRI7Vjli
         XlbhRothLesrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB752E49FA7;
        Thu, 30 Mar 2023 12:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168017761889.14481.3652625864507169315.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 12:00:18 +0000
References: <20230328235021.1048163-1-edumazet@google.com>
In-Reply-To: <20230328235021.1048163-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        kernelxing@tencent.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 28 Mar 2023 23:50:17 +0000 you wrote:
> Jason Xing attempted to optimize napi_schedule_rps() by avoiding
> unneeded NET_RX_SOFTIRQ raises: [1], [2]
> 
> This is quite complex to implement properly. I chose to implement
> the idea, and added a similar optimization in ____napi_schedule()
> 
> Overall, in an intensive RPC workload, with 32 TX/RX queues with RFS
> I was able to observe a ~10% reduction of NET_RX_SOFTIRQ
> invocations.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: napi_schedule_rps() cleanup
    https://git.kernel.org/netdev/net-next/c/8fcb76b934da
  - [net-next,2/4] net: add softnet_data.in_net_rx_action
    https://git.kernel.org/netdev/net-next/c/c59647c0dc67
  - [net-next,3/4] net: optimize napi_schedule_rps()
    https://git.kernel.org/netdev/net-next/c/821eba962d95
  - [net-next,4/4] net: optimize ____napi_schedule() to avoid extra NET_RX_SOFTIRQ
    https://git.kernel.org/netdev/net-next/c/8b43fd3d1d7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


