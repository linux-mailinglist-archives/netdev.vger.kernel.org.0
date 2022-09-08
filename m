Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235D75B18B4
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiIHJaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIHJaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D0C8E997
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 02:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C23261C1A
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4E06C433C1;
        Thu,  8 Sep 2022 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662629415;
        bh=9nXACygSB1q1TEYnjW6HffwsyB5e1mnZ90xMUYE3uyo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z2+WldxhyBlj9BTXc6ZrXD+JkxpRdcbV1Ws/El9CWY3DyiKfEpPubTfRTkuYwmr/1
         g7RaJwlsLBPNcjOGMxPi7fFKq/6gQ9gOUl8SMLwEg+hwB6EcqDbpX33aAp1EvLzM/x
         /smbFA0uF51p+jp1vnFNFT2cAMMziojA7IuVea6Fd+lGvgDEyt1o0N+G4MzCx/b8ep
         x3OZ5k3B0Dksp1D/+rl9s71jcQBz51oLTwo9bOa1YIWSXGtgsoUuMfnxHM8iZ+8TeE
         lgjhb/PgM4N9e/dlAMowX68b/nNByvAxy0mo8ZRILkBylmSCOoLVjPAKC5NZcW8Toq
         7wkt8mH++wNnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AEAE0C73FEC;
        Thu,  8 Sep 2022 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sch_sfb: Also store skb len before calling child enqueue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166262941571.17191.4142047101598818384.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Sep 2022 09:30:15 +0000
References: <20220905192137.965549-1-toke@toke.dk>
In-Reply-To: <20220905192137.965549-1-toke@toke.dk>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHRva2UuZGs+?=@ci.codeaurora.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  5 Sep 2022 21:21:36 +0200 you wrote:
> Cong Wang noticed that the previous fix for sch_sfb accessing the queued
> skb after enqueueing it to a child qdisc was incomplete: the SFB enqueue
> function was also calling qdisc_qstats_backlog_inc() after enqueue, which
> reads the pkt len from the skb cb field. Fix this by also storing the skb
> len, and using the stored value to increment the backlog after enqueueing.
> 
> Fixes: 9efd23297cca ("sch_sfb: Don't assume the skb is still around after enqueueing to child")
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> 
> [...]

Here is the summary with links:
  - [net] sch_sfb: Also store skb len before calling child enqueue
    https://git.kernel.org/netdev/net/c/2f09707d0c97

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


