Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC655F0B98
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 14:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiI3MUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 08:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiI3MUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 08:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1BC9B876
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 05:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E7676231C
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 12:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8EE6C433C1;
        Fri, 30 Sep 2022 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664540415;
        bh=0Q8t+Iwy2EMqcaynBcuKVd08PF641P8z48kNf2BHbDs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kD1wB8QgEL+Ey2TNa2/ThyyPV7EPb0OAGth62LTf9zeDQlRA/QuQekKrqa+QpUXMz
         WSiJbw2VjmTWoC5K41IjW2auRH3NIWvDoCBkit6LMEydO0gnkyogDEPfN8SBe7eyK8
         MwAjxSGFf8cNiXOpQz0B2kN1yPdC73/PCVz5si9PEoD2JM57k0DEM2d7VvaNjHU+RV
         EiZH68egnJ8Y1mhWpUC1UA6iz5kOy30XSbXhpY2ST6lUCCRQUd3mjPhkKgnnvb8m4x
         seNC1BQ9ptJ/xmprCwWv21Gyx0Qirax4lJ0qEH3B1pZTPjD+KG4SUfvXgxZ8cWeb/K
         omrY+6F7cgPuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BACB8E49FA5;
        Fri, 30 Sep 2022 12:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] esp: choose the correct inner protocol for GSO on inter
 address family tunnels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166454041575.28902.4005016601912533275.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 12:20:15 +0000
References: <20220929051357.3497325-2-steffen.klassert@secunet.com>
In-Reply-To: <20220929051357.3497325-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Thu, 29 Sep 2022 07:13:55 +0200 you wrote:
> From: Sabrina Dubroca <sd@queasysnail.net>
> 
> Commit 23c7f8d7989e ("net: Fix esp GSO on inter address family
> tunnels.") is incomplete. It passes to skb_eth_gso_segment the
> protocol for the outer IP version, instead of the inner IP version, so
> we end up calling inet_gso_segment on an inner IPv6 packet and
> ipv6_gso_segment on an inner IPv4 packet and the packets are dropped.
> 
> [...]

Here is the summary with links:
  - [1/3] esp: choose the correct inner protocol for GSO on inter address family tunnels
    https://git.kernel.org/netdev/net/c/26dbd66eab80
  - [2/3] xfrm: Update ipcomp_scratches with NULL when freed
    https://git.kernel.org/netdev/net/c/8a04d2fc700f
  - [3/3] xfrm: Reinject transport-mode packets through workqueue
    https://git.kernel.org/netdev/net/c/4f4920669d21

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


