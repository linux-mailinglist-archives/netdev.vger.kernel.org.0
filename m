Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4795AD3BD
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbiIENUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236697AbiIENUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:20:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AE96469
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 06:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 16CC5CE1293
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 13:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73D8BC43470;
        Mon,  5 Sep 2022 13:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662384014;
        bh=to12EN/c2fteqMJ3AFgsMFzgX7nPu2TQFvveSNP+IOM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eQ5STnb3LRnQJO7IhaaUIjEThx/evtbdwl4rq85y9c1J//ugpELm/cu7l+Q4SjwuP
         m6SbXD740ga360+hutyVHUpf2MDqVc5xvQVDi1u14EZxBnVfQEpg2ZvTBVefC61ddC
         XIhSsjnwnu7fHawKD/Ym4j/NQpvpqFwtiIyIxoY+9CcUVuGkAFXlTfdHmBbrgu9K1d
         B2YV6GHQtB41R58gMwirX8QDSPJmMep0HXruGHAsV2Wlcp00yc63zdbod4FQE1gsI1
         BrVWVa+MCFUdTUsQYqEIfhRABXVdGLVHch9Fl2rr/kRhZawg77wGPiFKZxPSkCRfU6
         KyEzp76Dj+IDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5AC8DC73FE8;
        Mon,  5 Sep 2022 13:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: sr: fix out-of-bounds read when setting HMAC data.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166238401436.22589.16036887188431737321.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 13:20:14 +0000
References: <20220902094506.89156-1-dav.lebrun@gmail.com>
In-Reply-To: <20220902094506.89156-1-dav.lebrun@gmail.com>
To:     David Lebrun <dav.lebrun@gmail.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, wmliang.tw@gmail.com,
        dlebrun@google.com
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
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Sep 2022 10:45:06 +0100 you wrote:
> From: David Lebrun <dlebrun@google.com>
> 
> The SRv6 layer allows defining HMAC data that can later be used to sign IPv6
> Segment Routing Headers. This configuration is realised via netlink through
> four attributes: SEG6_ATTR_HMACKEYID, SEG6_ATTR_SECRET, SEG6_ATTR_SECRETLEN and
> SEG6_ATTR_ALGID. Because the SECRETLEN attribute is decoupled from the actual
> length of the SECRET attribute, it is possible to provide invalid combinations
> (e.g., secret = "", secretlen = 64). This case is not checked in the code and
> with an appropriately crafted netlink message, an out-of-bounds read of up
> to 64 bytes (max secret length) can occur past the skb end pointer and into
> skb_shared_info:
> 
> [...]

Here is the summary with links:
  - [net] ipv6: sr: fix out-of-bounds read when setting HMAC data.
    https://git.kernel.org/netdev/net/c/84a53580c5d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


