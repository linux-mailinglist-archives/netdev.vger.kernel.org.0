Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF4961A6F2
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 03:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiKECkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 22:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKECkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 22:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA03AE62
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CEDBB83068
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 02:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3337C43143;
        Sat,  5 Nov 2022 02:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667616016;
        bh=4wKt8pgeuM6sFeWpG4laDJe03YQZhY9BCNjQfykEjhI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WVquuQs3v8r6Ygv/GMXKrPruiyzgMl2qgjCUKuj3/KrdbHBIM3VN46X+CzaKd9p5w
         yBCmEVjFQPiUdXPVCPjGBUCC4mBwxwbu+0l0oUTW/Deem3NoLkGOPO5LY6dGm9FLG2
         9bMGMUCdcfP2AyoDrY76o/PJ013xGQLfCUZfafh39aTkwx0MBuOB200I2Io4fip6DT
         kxDU97wA6GzRJZvWykh0x0omNHtuGynq0SOHWPKdL4UeoNYfKEfBhNhI9owzvM2SB3
         4ZLHhpOKrOIobJECmr2LsqpibJMBwaqcRkzCLcyjQvBj0IPwJFLZqQrn8uQHRapHJf
         DipsA8Niil02w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A0097E270DF;
        Sat,  5 Nov 2022 02:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: remove redundant check in ip_metrics_convert()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166761601665.5821.669096268599699271.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Nov 2022 02:40:16 +0000
References: <20221104022513.168868-1-shaozhengchao@huawei.com>
In-Reply-To: <20221104022513.168868-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 4 Nov 2022 10:25:13 +0800 you wrote:
> Now ip_metrics_convert() is only called by ip_fib_metrics_init(). Before
> ip_fib_metrics_init() invokes ip_metrics_convert(), it checks whether
> input parameter fc_mx is NULL. Therefore, ip_metrics_convert() doesn't
> need to check fc_mx.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: remove redundant check in ip_metrics_convert()
    https://git.kernel.org/netdev/net-next/c/552acbf576fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


