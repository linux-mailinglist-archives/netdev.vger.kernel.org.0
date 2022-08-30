Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E9F5A65B1
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiH3Nzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiH3NzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:55:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B79F22528;
        Tue, 30 Aug 2022 06:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42CFAB81BE0;
        Tue, 30 Aug 2022 13:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABE86C433D7;
        Tue, 30 Aug 2022 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661866817;
        bh=/FnZxDKSLo9LrWC08IxjXeMpRFAHK/7E68wtFYgJmVM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jKy0NFPXSQof04cfJoaSeUfintscoKwz693pH9CJ/Jq9pq6JJhiyf8tKvmWcJr7le
         p8mkMAEqoBIEU0fs/LRYQk8k0wgjE4pVrUjX4JEVzDtS6w+0+xz4pKQe3214vgY9kZ
         urT7AOw3CWIZ3LZPf8W8jqOA5NQXOOJ+UERL1I0WL1dXbHip1ZkytpeZ3CMTMnYAYc
         qlxftSex42sSWNLgwC5jsaZqhMeODqlTujV3Y3tajZzHHOWGB++jb6UXVUUpwOH0hs
         QygUKZtEJhHBC4VQN9x+DV/jgtkUZM79EeqMipsS6LO9E4PNqvDQ5RZ8FhcWXm+OF1
         4RV3FF2Kpd/Jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8DF8DE924D4;
        Tue, 30 Aug 2022 13:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/sched: fix netdevice reference leaks in
 attach_default_qdiscs()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166186681757.11746.2553114028017365543.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Aug 2022 13:40:17 +0000
References: <20220826090055.24424-1-wanghai38@huawei.com>
In-Reply-To: <20220826090055.24424-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 26 Aug 2022 17:00:55 +0800 you wrote:
> In attach_default_qdiscs(), if a dev has multiple queues and queue 0 fails
> to attach qdisc because there is no memory in attach_one_default_qdisc().
> Then dev->qdisc will be noop_qdisc by default. But the other queues may be
> able to successfully attach to default qdisc.
> 
> In this case, the fallback to noqueue process will be triggered. If the
> original attached qdisc is not released and a new one is directly
> attached, this will cause netdevice reference leaks.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/sched: fix netdevice reference leaks in attach_default_qdiscs()
    https://git.kernel.org/netdev/net/c/f612466ebecb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


