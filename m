Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B3E67E4F3
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 13:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbjA0MTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 07:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbjA0MSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 07:18:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD7F68AC5
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 04:15:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D386B820BC
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 12:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7ECEC4339B;
        Fri, 27 Jan 2023 12:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674821419;
        bh=EbpTzq9RlKGjlCVcFR/FRevjexBMPwlhirKF2tF30eE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YhInR9yQwODVQLwWuQhzTYSlmCZP1E1LwhtCPVbvggvy33hd6w1pt2OMHyhReggG2
         c/gvMUsyTIyj8Mh6E7vYT8aqOLW39le6YSSrzRxMQB6xxbx666jztBItjhmgwcUE9H
         xAGaTuKD90CoaTTrEq9r8DamllNHIsBR5hyPLoQS52YrZ7/cYXRa3i3cwoWdlTSCGB
         97D5cEA1ZDma/FFMim/QCLcKrg/QbD0hK6VXDvG4/O29bEjAsRMoSGLgWswBpwRPg4
         7bCrsWmad0q/Hb4+SC8IweHkJjdAgaMXAQmaN+Rh+Ovt9Z0OwgfA6q2HUnbwDXZbux
         kTDYYQKYm3izw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD70AF83ECD;
        Fri, 27 Jan 2023 12:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] net: skbuff: clean up unnecessary includes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167482141883.27837.17325833604152714760.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Jan 2023 12:10:18 +0000
References: <20230126071424.1250056-1-kuba@kernel.org>
In-Reply-To: <20230126071424.1250056-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 25 Jan 2023 23:14:13 -0800 you wrote:
> skbuff.h is included in a significant portion of the tree.
> Clean up unused dependencies to speed up builds.
> 
> This set only takes care of the most obvious cases.
> 
> Jakub Kicinski (11):
>   net: add missing includes of linux/net.h
>   net: skbuff: drop the linux/net.h include
>   net: checksum: drop the linux/uaccess.h include
>   net: skbuff: drop the linux/textsearch.h include
>   net: add missing includes of linux/sched/clock.h
>   net: skbuff: drop the linux/sched/clock.h include
>   net: skbuff: drop the linux/sched.h include
>   net: add missing includes of linux/splice.h
>   net: skbuff: drop the linux/splice.h include
>   net: skbuff: drop the linux/hrtimer.h include
>   net: remove unnecessary includes from net/flow.h
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] net: add missing includes of linux/net.h
    https://git.kernel.org/netdev/net-next/c/ac62f60619fa
  - [net-next,02/11] net: skbuff: drop the linux/net.h include
    https://git.kernel.org/netdev/net-next/c/9a859da28787
  - [net-next,03/11] net: checksum: drop the linux/uaccess.h include
    https://git.kernel.org/netdev/net-next/c/68f4eae781dd
  - [net-next,04/11] net: skbuff: drop the linux/textsearch.h include
    https://git.kernel.org/netdev/net-next/c/2195e2a024ae
  - [net-next,05/11] net: add missing includes of linux/sched/clock.h
    https://git.kernel.org/netdev/net-next/c/2870c4d6a5e4
  - [net-next,06/11] net: skbuff: drop the linux/sched/clock.h include
    https://git.kernel.org/netdev/net-next/c/9ac849f2c492
  - [net-next,07/11] net: skbuff: drop the linux/sched.h include
    https://git.kernel.org/netdev/net-next/c/422164224e32
  - [net-next,08/11] net: add missing includes of linux/splice.h
    https://git.kernel.org/netdev/net-next/c/509f15b9c551
  - [net-next,09/11] net: skbuff: drop the linux/splice.h include
    https://git.kernel.org/netdev/net-next/c/5255c0ca7983
  - [net-next,10/11] net: skbuff: drop the linux/hrtimer.h include
    https://git.kernel.org/netdev/net-next/c/9dd0db2b1303
  - [net-next,11/11] net: remove unnecessary includes from net/flow.h
    https://git.kernel.org/netdev/net-next/c/21bf73158fe7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


