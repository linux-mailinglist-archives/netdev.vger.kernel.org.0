Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55EC657655
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 13:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbiL1MUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 07:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiL1MUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 07:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACDEFAD9
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 04:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A29DB61314
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 12:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0E42C433F0;
        Wed, 28 Dec 2022 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672230016;
        bh=o7CHcM55VaLr4Q1dneeBHKU256iApQn9HnejqcRoeIo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GH3PATgwxNZEU5eQcCsjqWAf23CG9G05MeLSGGFAym56NgUaO95Mt+DwPsquBZuPJ
         7AC4nB2JW4sl1upii0AiUMneoo2XGp4hc5hiXfix2kBpaBZc5d7QtyQLqL8bgM9MHa
         DwwXg86vqvZOGIYOb8jfM/oqsy3FuelNvcyL60ZpN6rzdgHZD/x3m5sCi2eTCbxmzr
         KeGw3yN3OSt0fRd80+VS69gsQdisoXXeB5aRvOsm68eVm6NoPDNONNIpFAC6/9QKw7
         t3sReRPChHAXUrj2a17fwb8pFDthx9Uzhp2JrU8vZE1kx8LkxTXu5segh7tTg34ZHl
         6Y4xuOfezgwGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5BA9C395DF;
        Wed, 28 Dec 2022 12:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/sched: fix retpoline wrapper compilation on configs
 without tc filters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167223001587.30539.13110558137721055235.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Dec 2022 12:20:15 +0000
References: <20221227140459.3836710-1-pctammela@mojatatu.com>
In-Reply-To: <20221227140459.3836710-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, rudi@heitbaum.com
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

On Tue, 27 Dec 2022 11:04:59 -0300 you wrote:
> Rudi reports a compilation failure on x86_64 when CONFIG_NET_CLS or
> CONFIG_NET_CLS_ACT is not set but CONFIG_RETPOLINE is set.
> A misplaced '#endif' was causing the issue.
> 
> Fixes: 7f0e810220e2 ("net/sched: add retpoline wrapper for tc")
> 
> Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> 
> [...]

Here is the summary with links:
  - net/sched: fix retpoline wrapper compilation on configs without tc filters
    https://git.kernel.org/netdev/net/c/40cab44b9089

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


