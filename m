Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B684AF283
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiBINUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiBINUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:20:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927F2C0613C9;
        Wed,  9 Feb 2022 05:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43E08B82144;
        Wed,  9 Feb 2022 13:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02228C340EE;
        Wed,  9 Feb 2022 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644412810;
        bh=XViH5LUsqxeoWkYyHrdYklvq0k90VZt8E17PeZEL9FA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aQKqfQup9f9CHtDTl9FoADOdI2FqGiGmmJTXPL9RjjMO9MA7ihmWqPBJQKyhP5L1+
         zVHieWA8b2N5qyTb2USfFGsJYCWjVSfAsegDyO43fO2zezFUlq92J2ARU+TPS/ZoEW
         enUAyH/ZXLDtMxHvdRShCEYhvk9EGPi/bNqVEXSZ5aFl9vyyXhAUzimvA1GV8lnYfR
         DdopiQqcIW4aIkn8w7JdRO8lZDsUWxRUYRD0mHOZ9z/6uRMy1uRTrF4i6Q8/2ilHdx
         eEz0lrFL/1+m9+ErfhtPrK3N7V7mxbIZPKRtJHLzzqZ9Rx8UIB2gwdLl+oDMPgqCaH
         G/lqcW9LRiFlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0E4FE5D07D;
        Wed,  9 Feb 2022 13:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH V2 0/4] Priority flow control support for RVU netdev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164441280991.17901.900814529553893748.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 13:20:09 +0000
References: <20220209071519.10403-1-hkelam@marvell.com>
In-Reply-To: <20220209071519.10403-1-hkelam@marvell.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com
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

On Wed, 9 Feb 2022 12:45:15 +0530 you wrote:
> In network congestion, instead of pausing all traffic on link
> PFC allows user to selectively pause traffic according to its
> class. This series of patches add support of PFC for RVU netdev
> drivers.
> 
> Patch1 adds support to disable pause frames by default as
> with PFC user can enable either PFC or 802.3 pause frames.
> Patch2&3 adds resource management support for flow control
> and configures necessary registers for PFC.
> Patch4 adds dcb ops registration for netdev drivers.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,1/4] octeontx2-af: Don't enable Pause frames by default
    https://git.kernel.org/netdev/net-next/c/d957b51f7ed6
  - [net-next,V2,2/4] octeontx2-af: Priority flow control configuration support
    https://git.kernel.org/netdev/net-next/c/1121f6b02e7a
  - [net-next,V2,3/4] octeontx2-af: Flow control resource management
    https://git.kernel.org/netdev/net-next/c/e740003874ed
  - [net-next,V2,4/4] octeontx2-pf: PFC config support with DCBx
    https://git.kernel.org/netdev/net-next/c/8e67558177f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


