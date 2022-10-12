Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10645FC1DC
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 10:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJLIVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 04:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiJLIUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 04:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219C3ABD45
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 01:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1995261347
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A277C43470;
        Wed, 12 Oct 2022 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665562816;
        bh=EvMmRCUXRQpGpboYQy2m7vEVnYbgoEkOcV1XV6ycm2w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hB/4IpBV6K/wvahOhRSg70YLANPaIKIIUQVWyCgwwJBQLDdbwCBQH13QV98FoSZ6p
         ScTQN6JY63HY+leMHP2stEYKZhFwJ5ExaGMXNkCU+bnKp7LRBkrKY2AxabIhUyuZqi
         /hHpo4cZnlUqOS26BXwJQoMg8cePzh++5R3WCJ7GCINpoZqjOER0SzEywhFXAz6rTP
         cIg3taxwi4RDEKx1eMOT/ONo1sXBYvMuDJ45Ko+4WpjckL4RK4gEMVBJUm3AvgaM3C
         jVmQn3Hy2SWmR4lMjnNMFPuMWAh0H8gqBnZb90pyJ8bmYQnOEZ9bYXFp5yQraNO5RU
         oXQQg+xZvfFpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 514E2E50D97;
        Wed, 12 Oct 2022 08:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: cdg: allow tcp_cdg_release() to be called multiple
 times
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166556281632.4495.11765915690857418103.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Oct 2022 08:20:16 +0000
References: <20221011220748.3801134-1-eric.dumazet@gmail.com>
In-Reply-To: <20221011220748.3801134-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 11 Oct 2022 15:07:48 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Apparently, mptcp is able to call tcp_disconnect() on an already
> disconnected flow. This is generally fine, unless current congestion
> control is CDG, because it might trigger a double-free [1]
> 
> Instead of fixing MPTCP, and future bugs, we can make tcp_disconnect()
> more resilient.
> 
> [...]

Here is the summary with links:
  - [net] tcp: cdg: allow tcp_cdg_release() to be called multiple times
    https://git.kernel.org/netdev/net/c/72e560cb8c6f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


