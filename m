Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A9D6C9CC2
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbjC0Hui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbjC0Hue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:50:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAE744BA;
        Mon, 27 Mar 2023 00:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30F2EB80E9D;
        Mon, 27 Mar 2023 07:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB5CFC4339C;
        Mon, 27 Mar 2023 07:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679903420;
        bh=so1OnpfijwflVOtweah2v9BOoWst1VABwtJ5gAs1vXY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ro/we0tyqIRuSEb7S6zsAEcYxyNx4YzrIxF+Zd0Au4tDb7YtVkYxp3QSEe3YCJB5S
         K4v3WPS9zovjMygf1FOlTIi9IQ4PblKUtGmhGaRepUTk2hAYvHasIaSTaWcfO53wrg
         fzT3tHFBdtfkuvGl2v0fct9TIOSlAVOWodmY5eorhcW54u5Pw38Ddx3Vat1yzpTG0Q
         8RNUOX72GT+Rmo1f+YRq4j7kZkZjga8cGNWcYgCkylO3OmgNDAAeUaaFz4YF139kTR
         kcjD+FxA+rNy1EuDbsOUcTinD/8boXagVhy7Cm3UKTvV56HfOyprZKZWOzqkkgMxz9
         7l1SDGQpqe+/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9DC07E4D029;
        Mon, 27 Mar 2023 07:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 00/10] net: sunhme: Probe/IRQ cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990342063.21476.7775706161280440153.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 07:50:20 +0000
References: <20230324175136.321588-1-seanga2@gmail.com>
In-Reply-To: <20230324175136.321588-1-seanga2@gmail.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        simon.horman@corigine.com, linux-kernel@vger.kernel.org,
        debian-sparc@lists.debian.org, rescue@sunhelp.org, sparc@gentoo.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 13:51:26 -0400 you wrote:
> Well, I've had these patches kicking around in my tree since last October, so I
> guess I had better get around to posting them. This series is mainly a
> cleanup/consolidation of the probe process, with some interrupt changes as well.
> Some of these changes are SBUS- (AKA SPARC-) specific, so this should really get
> some testing there as well to ensure nothing breaks. I've CC'd a few SPARC
> mailing lists in hopes that someone there can try this out. I also have an SBUS
> card I ordered by mistake if anyone has a SPARC computer but lacks this card.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/10] net: sunhme: Fix uninitialized return code
    https://git.kernel.org/netdev/net-next/c/d61157414d0a
  - [net-next,v4,02/10] net: sunhme: Just restart autonegotiation if we can't bring the link up
    https://git.kernel.org/netdev/net-next/c/70b1b4b86227
  - [net-next,v4,03/10] net: sunhme: Remove residual polling code
    https://git.kernel.org/netdev/net-next/c/3427372d0bd8
  - [net-next,v4,04/10] net: sunhme: Unify IRQ requesting
    https://git.kernel.org/netdev/net-next/c/27b9ea8f37a6
  - [net-next,v4,05/10] net: sunhme: Alphabetize includes
    (no matching commit)
  - [net-next,v4,06/10] net: sunhme: Switch SBUS to devres
    https://git.kernel.org/netdev/net-next/c/cc216e4b44ce
  - [net-next,v4,07/10] net: sunhme: Consolidate mac address initialization
    https://git.kernel.org/netdev/net-next/c/273fb669c62c
  - [net-next,v4,08/10] net: sunhme: Clean up mac address init
    https://git.kernel.org/netdev/net-next/c/d1f088196057
  - [net-next,v4,09/10] net: sunhme: Inline error returns
    https://git.kernel.org/netdev/net-next/c/902fe6e90368
  - [net-next,v4,10/10] net: sunhme: Consolidate common probe tasks
    https://git.kernel.org/netdev/net-next/c/ecdcd0428c59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


