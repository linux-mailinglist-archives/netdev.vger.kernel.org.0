Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC2C503104
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354731AbiDOVcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356154AbiDOVcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:32:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822A6369EB
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B0A162197
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 21:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D85CC385AD;
        Fri, 15 Apr 2022 21:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650058213;
        bh=QU4i8t17dVbpiiBsTvxSbEyeF5VdGSLeOV2ouIOnTDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B5IWkAxwcsr10b1G9tiTz43Pbzeq2CWoPs85iTJtlO4QJfRSOca1A3jPCfPdsttL4
         LMyzmXn+JMysk+Ougpkk3AIwCsDBbHwjDWmOovXMaYysbmvTmvxjZ+GP71MWv6FLMJ
         NlSAVOOeFC0ukQR3kgVJnUyHxMH7AAWQuIV8swj92vIdJugMBNSQmG7cJjtjPkRz50
         26rr+QM6NE+ZYMXvhAZTek/C8ljb5Hts6IfTD039GAQU165nDAt3KsTZWwysqtKasA
         Ba1JO+zTgkD6+KkoMch5ZzHu1Rl/C5NyrGsxUz8RaokdOCG7EZFAw0QR0MC4RJl7rc
         +lX7xcpC9xvkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F08CEAC096;
        Fri, 15 Apr 2022 21:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net_sched: make qdisc_reset() smaller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165005821332.11686.10568876565445902324.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 21:30:13 +0000
References: <20220414011004.2378350-1-eric.dumazet@gmail.com>
In-Reply-To: <20220414011004.2378350-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, edumazet@google.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Apr 2022 18:10:04 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> For some unknown reason qdisc_reset() is using
> a convoluted way of freeing two lists of skbs.
> 
> Use __skb_queue_purge() instead.
> 
> [...]

Here is the summary with links:
  - [net-next] net_sched: make qdisc_reset() smaller
    https://git.kernel.org/netdev/net-next/c/c9a40d1c87e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


