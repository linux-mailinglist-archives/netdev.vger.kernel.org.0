Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F774D6FF4
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 17:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiCLQLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 11:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiCLQLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 11:11:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3F43B559
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 08:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 430A2B80A0B
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 16:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF92EC340EE;
        Sat, 12 Mar 2022 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647101411;
        bh=5c6bfxh36HANspPQH14TzlyYyAHBVMVaBtfsAieQqwk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sA1Rig2HUOVu56r/rZLH9q3jnSAhZci0GpA12pI1lKHsT6hjU6+U8FsqtLkVTwad4
         1sV8ucx6xvtg16HpCF9PmlNIdaV+MfqTprRG23sIeXJ+lwwTqXwldqCmRMw5lB32yN
         BxC/uoje3pG+tKv6OQKlkBLNesh4gAGxVeuZmNcSWc99Y0Vd4SVIpEr+MulS5GJUIL
         17NDSopYtCIf+ZneRV1Xz/siH5+etEVwei5Jzgq0YUvlcSTmkTOA0BUIEsis9YFZu9
         /PUV1kjgss6zsKrWeFdXST2OVsOT1IRm8jIxLZNsi1pfKTE82d3SPB6Rdj9Pbp3Q9F
         8SFz7UMxpsODg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE4D7E6D3DD;
        Sat, 12 Mar 2022 16:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v3 0/7] bridge: support for controlling
 broadcast flooding per port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164710141170.15431.13449021992708210326.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 16:10:11 +0000
References: <20220309192316.2918792-1-troglobit@gmail.com>
In-Reply-To: <20220309192316.2918792-1-troglobit@gmail.com>
To:     Joachim Wiberg <troglobit@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org, razor@blackwall.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed,  9 Mar 2022 20:23:09 +0100 you wrote:
> Hi,
> 
> this patch set address a slight omission in controlling broadcast
> flooding per bridge port, which the bridge has had support for a good
> while now.
> 
> v3:
>   - Move bcast_flood option in manual files to before the mcast_flood
>     option, instead of breaking the two mcast options.  Unfortunately
>     the other options are not alphabetically sorted, so this was the
>     least worst option. (Stephen)
>   - Add missing closing " for 'bridge mdb show' in bridge(8) SYNOPSIS
> v2:
>   - Add bcast_flood also to ip/iplink_bridge_slave.c (Nik)
>   - Update man page for ip-link(8) with new bcast_flood flag
>   - Update mcast_flood in same man page slightly
>   - Fix minor weird whitespace issues causing sudden line breaks
> v1:
>   - Add bcast_flood to bridge/link.c
>   - Update man page for bridge(8) with bcast_flood for brports
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v3,1/7] bridge: support for controlling flooding of broadcast per port
    (no matching commit)
  - [iproute2-next,v3,2/7] man: bridge: document new bcast_flood flag for bridge ports
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=3b681cf9c75e
  - [iproute2-next,v3,3/7] man: bridge: add missing closing " in bridge show mdb
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=909f0d510153
  - [iproute2-next,v3,4/7] ip: iplink_bridge_slave: support for broadcast flooding
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=c354a434b1bf
  - [iproute2-next,v3,5/7] man: ip-link: document new bcast_flood flag on bridge ports
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=b1c3ad848c1c
  - [iproute2-next,v3,6/7] man: ip-link: mention bridge port's default mcast_flood state
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=609b90aa3fb1
  - [iproute2-next,v3,7/7] man: ip-link: whitespace fixes to odd line breaks mid sentence
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=2dee2101f6e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


