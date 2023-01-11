Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEEE6651C6
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 03:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjAKCaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 21:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235460AbjAKCaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 21:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2B764C0;
        Tue, 10 Jan 2023 18:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64D8761A00;
        Wed, 11 Jan 2023 02:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6F57C43392;
        Wed, 11 Jan 2023 02:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673404216;
        bh=u9ktnMWXk9Zh4CWSIRVRPnwIZeA0bgXcJJQEivAZoB8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XlJHFt5bs3ALN4uiBXH5ew/3HVRXxMKjW61wKmKVaELkDSPseq7gH1lUpImgE9kv0
         /clMCKkOVHX3ExFkgaFvnwQPV8IaWyCt5d8y69o+uUyUm4WhZSUJb3fSniSqoEhMnY
         +rVDxdm0uBBqo4ocgDVXui8SkwkUa7W/5ksxHbNkkydRP4z6WUTJrg+VvrGGx9RUxu
         Qw8IFQ+kPRpJPzmncutoX/7hxK8MyW3oXshC43WXFDmoJkJSh4GuXll41XTOxV26P/
         a75WM6dt8FQ5XqPyY+jo/bzglSSv4HZLwsALbN8t52sJXCyKK534HGV0/NtxHTWViH
         nhuuiylDr1Rjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A444BE21EE8;
        Wed, 11 Jan 2023 02:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: disallow noqueue for qdisc classes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167340421666.10258.1866242868170260870.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Jan 2023 02:30:16 +0000
References: <20230109163906.706000-1-fred@cloudflare.com>
In-Reply-To: <20230109163906.706000-1-fred@cloudflare.com>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, zymon.heidrich@gmail.com,
        phil@nwl.cc, netdev@vger.kernel.org, kernel-team@cloudflare.com,
        stable@vger.kernel.org, jakub@cloudflare.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  9 Jan 2023 10:39:06 -0600 you wrote:
> While experimenting with applying noqueue to a classful queue discipline,
> we discovered a NULL pointer dereference in the __dev_queue_xmit()
> path that generates a kernel OOPS:
> 
>     # dev=enp0s5
>     # tc qdisc replace dev $dev root handle 1: htb default 1
>     # tc class add dev $dev parent 1: classid 1:1 htb rate 10mbit
>     # tc qdisc add dev $dev parent 1:1 handle 10: noqueue
>     # ping -I $dev -w 1 -c 1 1.1.1.1
> 
> [...]

Here is the summary with links:
  - [net] net: sched: disallow noqueue for qdisc classes
    https://git.kernel.org/netdev/net/c/96398560f26a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


