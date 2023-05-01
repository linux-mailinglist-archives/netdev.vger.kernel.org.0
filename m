Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381F36F2EAF
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 08:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjEAGaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 02:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjEAGaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 02:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB46F4
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 23:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 182726198A
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 06:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F9CDC4339B;
        Mon,  1 May 2023 06:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682922619;
        bh=PhbVmo9ZMq+AkJp+3iRPcQ4cB+w6NC69iePeKvVPpYY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XUIBxMXvHZXxwzCB9YmCpu9Myj4zjUpkHN686bvAnmFB9aNjWNe/thn3751CLrcTV
         tACLPKwuoZqWieQiRInfv8nO6OsMrZqXzFxoOwAgXuUtOf29iMHUTK3l4iPARyF/vQ
         hACMhiDqFqKem5+1C5U50K/jTLVVxGXDCTYDSRXDlIG8AtcpVfdM6h9Ik4U0cvuLS5
         YzMDcPM/7q50BTmqrpBLFaHKT1hUGIVhEqeSwYTcsAY8R1enh1exoTL8fLH5dd7jaq
         gsq9C7otkTNomJtLUeIZFLDiQosw5Y2sEQnk6urtJ6supgbHi9006swav9hQg5dXa7
         ymBZMtA1mL+Sw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C431C40C5E;
        Mon,  1 May 2023 06:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net/sched: act_mirred: Add carrier check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168292261924.13620.2484957727660628070.git-patchwork-notify@kernel.org>
Date:   Mon, 01 May 2023 06:30:19 +0000
References: <20230426151940.639711-1-victor@mojatatu.com>
In-Reply-To: <20230426151940.639711-1-victor@mojatatu.com>
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Apr 2023 15:19:40 +0000 you wrote:
> There are cases where the device is adminstratively UP, but operationally
> down. For example, we have a physical device (Nvidia ConnectX-6 Dx, 25Gbps)
> who's cable was pulled out, here is its ip link output:
> 
> 5: ens2f1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
>     link/ether b8:ce:f6:4b:68:35 brd ff:ff:ff:ff:ff:ff
>     altname enp179s0f1np1
> 
> [...]

Here is the summary with links:
  - [net,v3] net/sched: act_mirred: Add carrier check
    https://git.kernel.org/netdev/net/c/526f28bd0fbd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


