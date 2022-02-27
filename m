Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBD14C5A97
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 12:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiB0LK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 06:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiB0LKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 06:10:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3028C5B3CA;
        Sun, 27 Feb 2022 03:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 717D0B80B98;
        Sun, 27 Feb 2022 11:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16AB8C340F2;
        Sun, 27 Feb 2022 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645960215;
        bh=VDx1NMN5Fnle4AH471Xi19ig0epwy/svHVYRHa6+6Yc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eGhS1nNeRe/x3rWpCOFSYmNaMa6lon8i/F+6LjkDLEriqdqxrPPtKop7DHWUhQVkT
         mU9ncwzkibInpoBbXAZmjYH2IwMOpquV3x465TuMniWMvWM6ncaQxXbA6LO6RGk+ir
         WQ28MR0R1mtQBQ1J5v1mGJw/eijbby9+AEXYdbqBqSllmE8s4FsbXVSkEZiB9MlU1M
         b1VGSuXU/m6n6Mtuiaqqplgwaa6wPlhKOP1NxeS6+dA6RaDf3otvcSUv5C1e0KsdnB
         cesAWl2Hk8P9yVBd7PQ76SGCi68WEyOyF3eCXJ2RgAgBWhErj5V4irOHG6fTCXczCa
         OIEScvl0K4vdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E99DFF03839;
        Sun, 27 Feb 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] net: use kfree_skb_reason() for ip/neighbour
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164596021495.1414.14538654076309776973.git-patchwork-notify@kernel.org>
Date:   Sun, 27 Feb 2022 11:10:14 +0000
References: <20220226041831.2058437-1-imagedong@tencent.com>
In-Reply-To: <20220226041831.2058437-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     dsahern@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, alobakin@pm.me,
        cong.wang@bytedance.com, paulb@nvidia.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org,
        memxor@gmail.com, flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 26 Feb 2022 12:18:28 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the series "net: use kfree_skb_reason() for ip/udp packet receive",
> reasons for skb drops are added to the packet receive process of IP
> layer. Link:
> 
> https://lore.kernel.org/netdev/20220205074739.543606-1-imagedong@tencent.com/
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] net: ip: add skb drop reasons for ip egress path
    https://git.kernel.org/netdev/net-next/c/5e187189ec32
  - [net-next,v3,2/3] net: neigh: use kfree_skb_reason() for __neigh_event_send()
    https://git.kernel.org/netdev/net-next/c/a5736edda10c
  - [net-next,v3,3/3] net: neigh: add skb drop reasons to arp_error_report()
    https://git.kernel.org/netdev/net-next/c/56d4b4e48ace

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


