Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B9D5BEEFC
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 23:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiITVKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 17:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiITVKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 17:10:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E933E3BC63;
        Tue, 20 Sep 2022 14:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3175BCE1ABC;
        Tue, 20 Sep 2022 21:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46B73C433D7;
        Tue, 20 Sep 2022 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663708216;
        bh=BZZGi3hYFUpjAsLMFZfe90sFwd6kU18p+SQdYQ+AJ5Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Iunr1MjsyXni49ETAC/ZkN19BAggXp4lkMAGHl4U2u1TeixMUW/iEx68hPrfhQuGG
         qCSet57w3GZJWMvv+DSJUHnZZ5+K+xRmAEi7AvX6yuUSRk3dW2mg2M6I6x911blsRF
         l3EiAjjYzP4R6GmTkZ+McmAfE7FzKN5ZelGQdJANKJM2Xrx1+EknaCY+v4OIUg+31W
         HjPdbUzOa6umYXNMN+Y6wgbPuWmxUdORr14KX5eogPD7geRqUuUIQ4zvtbHGqTss1U
         L0jdeByzse2i1oiu81mkLOjRlTX+K+qUn6heMZAQHuHYZK/oRgGJ9xaHgN6tiur6Ss
         ZPyrHU9fPzvNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AE87E21EE2;
        Tue, 20 Sep 2022 21:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/7] Small tc-taprio improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166370821616.24931.5990103349727092023.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 21:10:16 +0000
References: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        weifeng.voon@intel.com, olteanv@gmail.com, kurt@linutronix.de,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Sep 2022 13:50:39 +0300 you wrote:
> This series contains:
> - the proper protected variant of rcu_dereference() of admin and oper
>   schedules for accesses from the slow path
> - a removal of an extra function pointer indirection for
>   qdisc->dequeue() and qdisc->peek()
> - a removal of WARN_ON_ONCE() checks that can never trigger
> - the addition of netlink extack messages to some qdisc->init() failures
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/7] net/sched: taprio: taprio_offload_config_changed() is protected by rtnl_mutex
    https://git.kernel.org/netdev/net-next/c/c8cbe123be6d
  - [v2,net-next,2/7] net/sched: taprio: taprio_dump and taprio_change are protected by rtnl_mutex
    https://git.kernel.org/netdev/net-next/c/18cdd2f0998a
  - [v2,net-next,3/7] net/sched: taprio: use rtnl_dereference for oper and admin sched in taprio_destroy()
    https://git.kernel.org/netdev/net-next/c/9af23657b336
  - [v2,net-next,4/7] net/sched: taprio: remove redundant FULL_OFFLOAD_IS_ENABLED check in taprio_enqueue
    https://git.kernel.org/netdev/net-next/c/fa65edde5e49
  - [v2,net-next,5/7] net/sched: taprio: stop going through private ops for dequeue and peek
    https://git.kernel.org/netdev/net-next/c/25becba6290b
  - [v2,net-next,6/7] net/sched: taprio: add extack messages in taprio_init
    https://git.kernel.org/netdev/net-next/c/026de64d7bc3
  - [v2,net-next,7/7] net/sched: taprio: replace safety precautions with comments
    https://git.kernel.org/netdev/net-next/c/2c08a4f898d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


