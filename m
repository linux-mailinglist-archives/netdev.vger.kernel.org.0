Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B899B4B52D0
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354934AbiBNOKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:10:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbiBNOKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B62B25F4
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 06:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBE8E60FA5
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 14:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 241F4C340EF;
        Mon, 14 Feb 2022 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644847810;
        bh=VDXSxs7SO9gRFV9tfNHwicQ4W9iXm/RD0BMD41DBTWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MYBl66w3DS0MteBZiAlROE9wYJTmpE4yBDkHcUNpPGz78VMZCeO9UklVbvIWaCHeH
         CSIibMcIDZ1q4NQ5okvtfruOSgXjLFxhWvoNnbpU7U2uQEWEkzxh3MpTDGAZliQI+B
         3DgSUP5QY28WwM7bklNd6oGEk4p2fNIyAvbD4xtyk0ZLGN6B71YFMkAQtIQK4GzqSu
         o0H1YmZvhJlk4hudlOBWnA9nW2Zmw9IAlrsqvMXFRktrCJoL62L3F8eDQ6V72EMAFq
         SRsdpP0QGC8fACN2w7jZJMYtg70qCEdNxbEuNL8ZAwcaGGAMgFpTwRffSZCI9t2jYz
         Cwihn6kAQh0MQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F1CFE6D453;
        Mon, 14 Feb 2022 14:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net_sched: add __rcu annotation to netdev->qdisc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484781005.8191.13711292340663514681.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 14:10:10 +0000
References: <20220211200623.3718950-1-eric.dumazet@gmail.com>
In-Reply-To: <20220211200623.3718950-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, maheshb@google.com, vladbu@mellanox.com,
        syzkaller@googlegroups.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 11 Feb 2022 12:06:23 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot found a data-race [1] which lead me to add __rcu
> annotations to netdev->qdisc, and proper accessors
> to get LOCKDEP support.
> 
> [1]
> BUG: KCSAN: data-race in dev_activate / qdisc_lookup_rcu
> 
> [...]

Here is the summary with links:
  - [net] net_sched: add __rcu annotation to netdev->qdisc
    https://git.kernel.org/netdev/net/c/5891cd5ec46c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


