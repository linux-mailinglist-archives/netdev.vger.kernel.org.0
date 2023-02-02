Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8C4687CEE
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjBBMKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBBMKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:10:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B368885D8;
        Thu,  2 Feb 2023 04:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4AC161AFA;
        Thu,  2 Feb 2023 12:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37D62C433D2;
        Thu,  2 Feb 2023 12:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675339819;
        bh=EYyR3LlMemN6yj7mj1Mps+XgK1d+V1ssywmXN5xBVtM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vNk0PH5jmie8SC26XhcyUvsVcsbeAWhin7CzwctGRslUUKYPwCXcB0I8kw44/JAPR
         hFugRWDQv7CprH9TZH8ISw+de/+O8uhF5baAvsJk3FyWgXIQpM63xxk/1CQSDD1/Ea
         O21SYOB9pYA2wJroIpC+0ENOkV34PHzeTwqywQp1997ImgL4NgPRRLmD3PrHrFhg/7
         lwHy3neELL12uY5V0jUKoFIsKUb7R5ogKyxCO2/YN+c2mLtnFZtevASPbrMHbacVzd
         90xIPDQbva/L/jioi5F/QktnXTvznltYvPbw4KEXiOgT3pWQApUQpRD77kewPgOdJT
         bthrGD/mF2A/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1605EE21EEC;
        Thu,  2 Feb 2023 12:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13] rxrpc: Increasing SACK size and moving away
 from softirq, part 5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167533981908.1062.9553023107876708277.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 12:10:19 +0000
References: <20230131171227.3912130-1-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, marc.dionne@auristor.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David Howells <dhowells@redhat.com>:

On Tue, 31 Jan 2023 17:12:14 +0000 you wrote:
> Here's the fifth part of patches in the process of moving rxrpc from doing
> a lot of its stuff in softirq context to doing it in an I/O thread in
> process context and thereby making it easier to support a larger SACK
> table.
> 
> The full description is in the description for the first part[1] which is
> now upstream.  The second and third parts are also upstream[2].  A subset
> of the original fourth part[3] got applied as a fix for a race[4].
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] rxrpc: Fix trace string
    https://git.kernel.org/netdev/net-next/c/8395406b3495
  - [net-next,02/13] rxrpc: Remove whitespace before ')' in trace header
    https://git.kernel.org/netdev/net-next/c/371e68ba0306
  - [net-next,03/13] rxrpc: Shrink the tabulation in the rxrpc trace header a bit
    https://git.kernel.org/netdev/net-next/c/828bebc80a03
  - [net-next,04/13] rxrpc: Convert call->recvmsg_lock to a spinlock
    https://git.kernel.org/netdev/net-next/c/223f59016fa2
  - [net-next,05/13] rxrpc: Allow a delay to be injected into packet reception
    https://git.kernel.org/netdev/net-next/c/af094824f20b
  - [net-next,06/13] rxrpc: Generate extra pings for RTT during heavy-receive call
    https://git.kernel.org/netdev/net-next/c/84e28aa513af
  - [net-next,07/13] rxrpc: De-atomic call->ackr_window and call->ackr_nr_unacked
    https://git.kernel.org/netdev/net-next/c/5bbf953382be
  - [net-next,08/13] rxrpc: Simplify ACK handling
    https://git.kernel.org/netdev/net-next/c/f21e93485bcb
  - [net-next,09/13] rxrpc: Don't lock call->tx_lock to access call->tx_buffer
    https://git.kernel.org/netdev/net-next/c/b30d61f4b128
  - [net-next,10/13] rxrpc: Remove local->defrag_sem
    https://git.kernel.org/netdev/net-next/c/e7f40f4a701b
  - [net-next,11/13] rxrpc: Show consumed and freed packets as non-dropped in dropwatch
    https://git.kernel.org/netdev/net-next/c/f20fe3ff82b3
  - [net-next,12/13] rxrpc: Change rx_packet tracepoint to display securityIndex not type twice
    https://git.kernel.org/netdev/net-next/c/83836eb4df75
  - [net-next,13/13] rxrpc: Kill service bundle
    https://git.kernel.org/netdev/net-next/c/550130a0ce30

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


