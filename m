Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A955E882C
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 06:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbiIXEKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 00:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbiIXEKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 00:10:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139A27A501
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 21:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3C70B81FC2
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 04:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75C92C43140;
        Sat, 24 Sep 2022 04:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663992621;
        bh=Ih3OACpDnGVOVT95136GkvBpR0ldMdoU078Y4+rVGRc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n971ybU5ApqDhzJhLUctbAena9hIp1oXqm9PxuOTlLz4mpk7rTq0gn9uBPWaFWLeK
         Lr3iWBZ3USl+1gxAGKR1ElMXMrldqnwtJNT0zRN9THL6kgueOCi6ETVC9pRi1kpv2/
         q7ASwdJqmU1yV057lPAHR6JQqyzZaAIUlJoGDRqsNkHl971kXf/KfG0/JKNS0MHDVB
         14Mm97SfxwrlVdPq6xMF4cVVSncdYaDNlAmyEFcMJYx2sSrOMN8GzH25CsYy9u8cK6
         kvlwES3mTmjl5twAjRo6ZysiMBZSo74ZLyGIF6TMAU3pM/auFYyJAjxhfjEWrgIhp7
         GunNaIdWtU/1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5303EE4D03D;
        Sat, 24 Sep 2022 04:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: tcp: send consistent autoflowlabel in RST
 packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166399262133.11836.1538663087998989375.git-patchwork-notify@kernel.org>
Date:   Sat, 24 Sep 2022 04:10:21 +0000
References: <20220922165036.1795862-1-eric.dumazet@gmail.com>
In-Reply-To: <20220922165036.1795862-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ncardwell@google.com, edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 22 Sep 2022 09:50:36 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Blamed commit added a txhash parameter to tcp_v6_send_response()
> but forgot to update tcp_v6_send_reset() accordingly.
> 
> Fixes: aa51b80e1af4 ("ipv6: tcp: send consistent autoflowlabel in SYN_RECV state")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: tcp: send consistent autoflowlabel in RST packets
    https://git.kernel.org/netdev/net-next/c/9258b8b1be2e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


