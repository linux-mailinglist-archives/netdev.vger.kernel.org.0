Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FFA4B251B
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238581AbiBKMA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:00:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiBKMAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D229F5C
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 04:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2479B829B9
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 12:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAE2FC340EE;
        Fri, 11 Feb 2022 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644580813;
        bh=crqIR6NLi5jblhTMkolJlpJxGy2LUJQTzlnp8LEx+Nw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JLZMEYPG2JX2k6LubdXm2Lof/WcFuAd9V2xQXzipvDUVMPoXj10o2iXdtbBhwqgft
         x3Z6RPviDZCuy99/nkn8i0lpEroXpvho/NAmP7hZR+FBoYwtjx2XHV4ACZo3/c2qGo
         s1Z0WkUJBRvn3hZBj1epo2Z5GHw5OYELPZNqnmL3Kj/qGJZVrlOkDy2JWzwazJ1Sus
         6p2HtuPEI0YJ7dnpwEP5iGrDBfxR08UjxZZXy/TvR24hGhNzRLdd8yg8b2LS2+2Vuq
         LiyyHGYZ6CyddXMlTG3FANZpk1ZLFaEKB5VAJ3yTva/c+Xw2YOUfgNB8CUb2Wxhiuh
         s1i9PJzTJwvUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C107E6BBCA;
        Fri, 11 Feb 2022 12:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] ipv6: remove addrconf reliance on loopback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164458081363.17283.599959777879539507.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 12:00:13 +0000
References: <20220210214231.2420942-1-eric.dumazet@gmail.com>
In-Reply-To: <20220210214231.2420942-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, maheshb@google.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Feb 2022 13:42:27 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Second patch in this series removes IPv6 requirement about the netns
> loopback device being the last device being dismantled.
> 
> This was needed because rt6_uncached_list_flush_dev()
> and ip6_dst_ifdown() had to switch dst dev to a known
> device (loopback).
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] ipv6: get rid of net->ipv6.rt6_stats->fib_rt_uncache
    https://git.kernel.org/netdev/net-next/c/2d4feb2c1ba7
  - [net-next,2/4] ipv6: give an IPv6 dev to blackhole_netdev
    https://git.kernel.org/netdev/net-next/c/e5f80fcf869a
  - [net-next,3/4] ipv6: add (struct uncached_list)->quarantine list
    https://git.kernel.org/netdev/net-next/c/ba55ef81637c
  - [net-next,4/4] ipv4: add (struct uncached_list)->quarantine list
    https://git.kernel.org/netdev/net-next/c/29e5375d7fcb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


