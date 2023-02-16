Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E306997A2
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjBPOkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjBPOkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:40:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67522311C3;
        Thu, 16 Feb 2023 06:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0381060EC0;
        Thu, 16 Feb 2023 14:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B152C433EF;
        Thu, 16 Feb 2023 14:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676558422;
        bh=HOpcvbihO1wM9wl0npQyoYRB+fMquamFRbYEfFcVv+Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lbbDU0u+8cphkIEh9l2u4kET+FuefVPHSlioXqWcClJk0opi2PWU6hQos03XLgZ3g
         69p6En+FTP0lGNfYtPFrWpntYaqX25xOb6X5nqomgvJHNKeqr8d9mkG7C5SD02LlIL
         4r/TPZw/uC/SyKmeDrkP3om+43bu8tf0+8nPtQfvrXinM4/Ye5EFXZBZQygiVkRaFj
         jwYyBu//4R+MMwxYSTpBgdjG9tJLBSBRgdlefZYt5+Mq7QGehGvdaM6B9awoaEzt+d
         2AqavL1joTLYDPTPgySTC2hQG6zHSFqFrFRE8KL71UOVM2EW3ArbeXW3GKnMkmPzsx
         N+DSLDy2Vnj5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B9D1E21EC4;
        Thu, 16 Feb 2023 14:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 0/3] seg6: add PSP flavor support for SRv6 End behavior
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167655842216.23013.1967734576952648169.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 14:40:22 +0000
References: <20230215134659.7613-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20230215134659.7613-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, stefano.salsano@uniroma2.it,
        paolo.lungaroni@uniroma2.it, ahabdels.dev@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 15 Feb 2023 14:46:56 +0100 you wrote:
> Segment Routing for IPv6 (SRv6 in short) [1] is the instantiation of the
> Segment Routing (SR) [2] architecture on the IPv6 dataplane.
> In SRv6, the segment identifiers (SID) are IPv6 addresses and the segment list
> (SID List) is carried in the Segment Routing Header (SRH). A segment may be
> bound to a specific packet processing operation called "behavior". The RFC8986
> [3] defines and standardizes the most common/relevant behaviors for network
> operators, e.g., End, End.X and End.T and so on.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] seg6: factor out End lookup nexthop processing to a dedicated function
    https://git.kernel.org/netdev/net-next/c/525c65ff5696
  - [net-next,2/3] seg6: add PSP flavor support for SRv6 End behavior
    https://git.kernel.org/netdev/net-next/c/bdf3c0b9c10b
  - [net-next,3/3] selftests: seg6: add selftest for PSP flavor in SRv6 End behavior
    https://git.kernel.org/netdev/net-next/c/5198cb408fcf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


