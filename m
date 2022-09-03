Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FDA5ABE45
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 11:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiICJuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 05:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiICJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 05:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96842419A2;
        Sat,  3 Sep 2022 02:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D62FB80DC3;
        Sat,  3 Sep 2022 09:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C42D9C43149;
        Sat,  3 Sep 2022 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662198615;
        bh=3Cf6eRcmqE9hgAVP/mWhJ3zpwPyi/oCa/UozB1/GWNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NdM7RN5mrBMZEY+KJ0mdzmMfN03QhZdu5nBRyLLbmrUk3Sw+mbAcDxO0c8brx7XU7
         VgO0LCVnIexh9dBHmprIfgAuADYipHTmwjUu6w9yX2Bk8i80x4Eagoech3Smj6Rkd3
         Rzn+kP9kKXHWc5HMYThdhxp7KvYZoMtcL8oq7R1N9+T6v4ERtvbK1xvEGJFNi0E4Am
         P6935EmqNeF9G4KL7Oa+J0iJjbR99HWzWFEjighxBiae60UUxg8+hjf6IwUBZ+FA5S
         BMD5MbuJCkF6YhjI57GsedWukr8y6MIhzjARjsr5DvJSK6+f/+ZtqhU+6DXXiTdrb8
         TeFdZbjXIxbVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF70BE924D9;
        Sat,  3 Sep 2022 09:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2 0/2] net: sched: remove redundant resource cleanup
 when init() fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166219861571.29702.10140473276609430885.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 09:50:15 +0000
References: <20220902083430.24378-1-shaozhengchao@huawei.com>
In-Reply-To: <20220902083430.24378-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Fri, 2 Sep 2022 16:34:28 +0800 you wrote:
> qdisc_create() calls .init() to initialize qdisc. If the initialization
> fails, qdisc_create() will call .destroy() to release resources.
> 
> Zhengchao Shao (2):
>   net: sched: fq_codel: remove redundant resource cleanup in
>     fq_codel_init()
>   net: sched: htb: remove redundant resource cleanup in htb_init()
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: sched: fq_codel: remove redundant resource cleanup in fq_codel_init()
    https://git.kernel.org/netdev/net-next/c/494f5063b86c
  - [net-next,v2,2/2] net: sched: htb: remove redundant resource cleanup in htb_init()
    https://git.kernel.org/netdev/net-next/c/d59f4e1d1fe7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


