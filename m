Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B227581BE3
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 00:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiGZWAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 18:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGZWAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 18:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD662BEA
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 15:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 427FCB81F01
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 22:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7448C433D6;
        Tue, 26 Jul 2022 22:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658872815;
        bh=dB4qJIrzT+UVB3BgBJYRSrzoZu/K1HqP45H/gI7v4c8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VcGAIcS9PYxgN6GECTRTkpHxb41hqQhhF5p6f5Ze26rdMkAvOS/+y10c4Iims6ai4
         kYdtXuS/sA8UOmbRvHtYATLRitj98XFnev6A3Z8IuH8YqI7braZZ1chnFfcp3BdJs4
         tIy00zXnmHka6lJggjPHAEVmH+WNWdilwuATTIWzfQSN/k4szYSQymoZ9uGZDGjGQS
         DV9n85V2utaBBUPJ1Qbh4lQfWBd1M7JuJguVlzI0Ye3RPETEwjXtYx0pQEL0MIOUT3
         MkA4b4Nj0jtcFA2qOT2SqwSUWp6A5+JLC41dp+T+cpYbRi2Bjvi66tsMAW/y29ohAI
         pZROd4QQxyiWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9007C43140;
        Tue, 26 Jul 2022 22:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/7] tls: rx: decrypt from the TCP queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165887281481.18038.16801688552848755722.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 22:00:14 +0000
References: <20220722235033.2594446-1-kuba@kernel.org>
In-Reply-To: <20220722235033.2594446-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
        maximmi@nvidia.com, tariqt@nvidia.com, vfedorenko@novek.ru
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 Jul 2022 16:50:26 -0700 you wrote:
> This is the final part of my TLS Rx rework. It switches from
> strparser to decrypting data from skbs queued in TCP. We don't
> need the full strparser for TLS, its needs are very basic.
> This set gives us a small but measurable (6%) performance
> improvement (continuous stream).
> 
> v2: drop the __exit marking for the unroll path
> v3: drop tcp_recv_skb() in patch 5
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/7] tls: rx: wrap recv_pkt accesses in helpers
    https://git.kernel.org/netdev/net-next/c/b92a13d488de
  - [net-next,v3,2/7] tls: rx: factor SW handling out of tls_rx_one_record()
    https://git.kernel.org/netdev/net-next/c/dd47ed3620e6
  - [net-next,v3,3/7] tls: rx: don't free the output in case of zero-copy
    https://git.kernel.org/netdev/net-next/c/b93f5700164d
  - [net-next,v3,4/7] tls: rx: device: keep the zero copy status with offload
    https://git.kernel.org/netdev/net-next/c/d4e5db645221
  - [net-next,v3,5/7] tcp: allow tls to decrypt directly from the tcp rcv queue
    https://git.kernel.org/netdev/net-next/c/3f92a64e44e5
  - [net-next,v3,6/7] tls: rx: device: add input CoW helper
    https://git.kernel.org/netdev/net-next/c/8b3c59a7a0be
  - [net-next,v3,7/7] tls: rx: do not use the standard strparser
    https://git.kernel.org/netdev/net-next/c/84c61fe1a75b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


