Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7C264811E
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 11:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiLIKuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 05:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 05:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5129C326CC;
        Fri,  9 Dec 2022 02:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0A1E62208;
        Fri,  9 Dec 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34099C433EF;
        Fri,  9 Dec 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670583016;
        bh=MTexFu+6ZdVpcZiQhi2YpahyiGphE6QvVYKj9+1Jh18=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WqggJX3lVZrzABV4DVRN15SOPhjc/AtdQzYkbO6/PtgtHliiX85JG5iXkkqVEX9Of
         03ccMmGAqg41KT9zYJepmnWbOB5naoZZnNaFznURWFENlU/rBoV9yabnyFcfqtXITN
         L0Dmib3rvLgH/b/hvif9KdeT8Ayuswm1EUlfpmXk3Bd+yzgUNQlw/JOmlZHS6tm8bj
         sUj9zMooSYAtW3sfemDx7WGi4TdoP9L+nZJMfupbNjyK7Bisi2UowiWD6hdn88l6ye
         bHOMC9Gc7TKCBecal4QrwVXuFzRucfSlyLLdFjNNPRa4CbwVTzkNv7sqwceH83ig7O
         pQepW72x+eg1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12C42E1B4D8;
        Fri,  9 Dec 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: defxx: Fix missing err handling in dfx_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167058301607.16848.9914580419717900322.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 10:50:16 +0000
References: <20221207072045.604872-1-liuyongqiang13@huawei.com>
In-Reply-To: <20221207072045.604872-1-liuyongqiang13@huawei.com>
To:     Yongqiang Liu <liuyongqiang13@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        macro@orcam.me.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ralf@linux-mips.org,
        jeff@garzik.org, akpm@linux-foundation.org, zhangxiaoxu5@huawei.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 7 Dec 2022 07:20:45 +0000 you wrote:
> When eisa_driver_register() or tc_register_driver() failed,
> the modprobe defxx would fail with some err log as follows:
> 
>  Error: Driver 'defxx' is already registered, aborting...
> 
> Fix this issue by adding err hanling in dfx_init().
> 
> [...]

Here is the summary with links:
  - [net] net: defxx: Fix missing err handling in dfx_init()
    https://git.kernel.org/netdev/net/c/ae18dcdff0f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


