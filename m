Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBD65047C0
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 14:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiDQMmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 08:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbiDQMmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 08:42:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6229122529
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 05:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0851AB80CBA
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 12:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D4E8C385AD;
        Sun, 17 Apr 2022 12:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650199214;
        bh=7AVqY0kFN4wDzO12sIUkQb/mH7ecEC/fIkYxuReKW9c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JFeR3VnCGVjypZT5qYotD/EI+HPWqhxq7wyHlw6mKEairrMFyeXuGQ7RnypHFYojc
         uxw935KZibBe/foq1SoxUozN3BoNBVBE8F1B78Zfhu5G4NIjXWRn8MM2QoM0fYJuNO
         9GrbArTvGzXqhvZ+epqz8k/dinLsbJ7kEbylsJRvAnsBWFuRuoPquBdOJKPaGLXgOF
         qswWA/eIsze37mJTKffE2PPqmd2k6JhpoD3uAQl2lTXGNYrdNXZ9wkMhy6SDez5kCQ
         qfHsOp+wXqAAFlCQzdg5nDHH4vQVzIAYepErzo6tESF+ImUaJtuNWKi6YqPOblk0AV
         PJvgR2/1Dr0ag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 77F21EAC09B;
        Sun, 17 Apr 2022 12:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] tcp: drop reason additions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165019921448.7317.10694523247294915482.git-patchwork-notify@kernel.org>
Date:   Sun, 17 Apr 2022 12:40:14 +0000
References: <20220416001048.2218911-1-eric.dumazet@gmail.com>
In-Reply-To: <20220416001048.2218911-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 15 Apr 2022 17:10:38 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Currently, TCP is either missing drop reasons,
> or pretending that some useful packets are dropped.
> 
> This patch series makes "perf record -a -e skb:kfree_skb"
> much more usable.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] tcp: consume incoming skb leading to a reset
    https://git.kernel.org/netdev/net-next/c/d9d024f96609
  - [net-next,02/10] tcp: get rid of rst_seq_match
    https://git.kernel.org/netdev/net-next/c/b5ec1e6205a1
  - [net-next,03/10] tcp: add drop reason support to tcp_validate_incoming()
    https://git.kernel.org/netdev/net-next/c/da40b613f89c
  - [net-next,04/10] tcp: make tcp_rcv_state_process() drop monitor friendly
    https://git.kernel.org/netdev/net-next/c/37fd4e842391
  - [net-next,05/10] tcp: add drop reasons to tcp_rcv_state_process()
    https://git.kernel.org/netdev/net-next/c/669da7a71890
  - [net-next,06/10] tcp: add two drop reasons for tcp_ack()
    https://git.kernel.org/netdev/net-next/c/4b506af9c5b8
  - [net-next,07/10] tcp: add drop reason support to tcp_prune_ofo_queue()
    https://git.kernel.org/netdev/net-next/c/e7c89ae4078e
  - [net-next,08/10] tcp: make tcp_rcv_synsent_state_process() drop monitor friend
    https://git.kernel.org/netdev/net-next/c/c337578a6592
  - [net-next,09/10] tcp: add drop reasons to tcp_rcv_synsent_state_process()
    https://git.kernel.org/netdev/net-next/c/659affdb5140
  - [net-next,10/10] tcp: add drop reason support to tcp_ofo_queue()
    https://git.kernel.org/netdev/net-next/c/8fbf195798b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


