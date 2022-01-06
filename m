Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144EF486447
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbiAFMUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:20:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54386 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238058AbiAFMUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45203B81E8B
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13CA2C36AED;
        Thu,  6 Jan 2022 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641471611;
        bh=GiSJLFXFZTM9zlU6M+SBwrtc5Zf4Jr48UHoJ3qbv6Wg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S+Jg1NVhUB24Ebl3an0UU5bGwo38Y7mhswxigfdjCG0uZHZeOFChWxvV6qs6zjq/y
         EHCxHZ4/o4y6eDAb6D4wyJdNxWIIQ1tW7Ps9fZJV/ee4YNqveZahHQGaCW+dsL/L7S
         MYKBsrn8jE6rg3GwOdfHw35deohnWC5Kiuyho3IC/TNhsgZ4gQJ4EBky8p5At8tz6O
         5q6zlbOrLeU8hIQSbFioqPZwnH0zsvIuuOl+2biWRgCaY8y0MdiIokxrd0eDSz50OS
         NRLVcmU5wFc2MMYsE/1tN1WKthTVcF7nC99C7eSLMuBNTslv6ZhBb4c2t62RnVJq2x
         bdr4+gxMaTmBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E9D5FF7940B;
        Thu,  6 Jan 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/6] xfrm: fix policy lookup for ipv6 gre packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147161095.27983.2505174339598036867.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 12:20:10 +0000
References: <20220106093606.3046771-2-steffen.klassert@secunet.com>
In-Reply-To: <20220106093606.3046771-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Thu, 6 Jan 2022 10:36:01 +0100 you wrote:
> From: Ghalem Boudour <ghalem.boudour@6wind.com>
> 
> On egress side, xfrm lookup is called from __gre6_xmit() with the
> fl6_gre_key field not initialized leading to policies selectors check
> failure. Consequently, gre packets are sent without encryption.
> 
> On ingress side, INET6_PROTO_NOPOLICY was set, thus packets were not
> checked against xfrm policies. Like for egress side, fl6_gre_key should be
> correctly set, this is now done in decode_session6().
> 
> [...]

Here is the summary with links:
  - [1/6] xfrm: fix policy lookup for ipv6 gre packets
    https://git.kernel.org/netdev/net/c/bcf141b2eb55
  - [2/6] xfrm: fix dflt policy check when there is no policy configured
    https://git.kernel.org/netdev/net/c/ec3bb890817e
  - [3/6] xfrm: fix a small bug in xfrm_sa_len()
    https://git.kernel.org/netdev/net/c/7770a39d7c63
  - [4/6] xfrm: interface with if_id 0 should return error
    https://git.kernel.org/netdev/net/c/8dce43919566
  - [5/6] xfrm: state and policy should fail if XFRMA_IF_ID 0
    https://git.kernel.org/netdev/net/c/68ac0f3810e7
  - [6/6] net/xfrm: IPsec tunnel mode fix inner_ipproto setting in sec_path
    https://git.kernel.org/netdev/net/c/45a98ef4922d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


