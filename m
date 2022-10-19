Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614D4604696
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbiJSNPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbiJSNPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:15:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA371D376D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:00:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0CE7B82456
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 13:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AF03C4314E;
        Wed, 19 Oct 2022 13:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666184421;
        bh=BYMN67A+PCUU5pbGpL0u9KfFUsEN4xUpjdNV18hwZrE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L73U+9AKH8KZIX/RsTzkjbH+YwEj3VyWdO9DRkzvSW1bWwB1WZ5flrEe2EfhUTvny
         5RBHT1apAfwjV+J64YgTNBXBRvgMDQIqsFnc/aLRmvvSs37rAznqefSbD47DXKtX/R
         i9P3v45eO3YArEpViwUsXjgYTLL7YLFxhEBFmSFM6sqILejbaXYm2dsAhvu1iO9aCm
         6asyLTIntnUdgDdxR7N4RSc4/dTm7f+sd8WhbIzY083JPzSzFtPEvwrS/bhCWCkSHF
         an/qLKuL0vT98X+Afi22ntPX4gZg2U00NrFeTi2L+Z816wnunhzxV97f/JJBv6/DWe
         EZSfq6UcrsF1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 665B7E29F37;
        Wed, 19 Oct 2022 13:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,v2 0/3] fix null pointer access issue in qdisc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166618442140.15395.5116564225643728829.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 13:00:21 +0000
References: <20221018063201.306474-1-shaozhengchao@huawei.com>
In-Reply-To: <20221018063201.306474-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     cake@lists.bufferbloat.net, netdev@vger.kernel.org, toke@toke.dk,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dave.taht@gmail.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 18 Oct 2022 14:31:58 +0800 you wrote:
> These three patches fix the same type of problem. Set the default qdisc,
> and then construct an init failure scenario when the dev qdisc is
> configured on mqprio to trigger the reset process. NULL pointer access
> may occur during the reset process.
> 
> ---
> v2: for fq_codel, revert the patch
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] net: sched: cake: fix null pointer access issue when cake_init() fails
    https://git.kernel.org/netdev/net/c/51f9a8921cea
  - [net,v2,2/3] Revert "net: sched: fq_codel: remove redundant resource cleanup in fq_codel_init()"
    https://git.kernel.org/netdev/net/c/f5ffa3b11973
  - [net,v2,3/3] net: sched: sfb: fix null pointer access issue when sfb_init() fails
    https://git.kernel.org/netdev/net/c/2a3fc78210b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


