Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57B564803D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 10:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiLIJkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 04:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiLIJkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 04:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87333A2CF
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 01:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E5FAB82827
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CAC1C433F0;
        Fri,  9 Dec 2022 09:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670578819;
        bh=OM+oCWSs4V9jlSbCOrBMcbIAjxSHnuvNXM1KPut1hY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kBxdXQtK/kSmgIgvapLIQ46fUfsyE8uU54NhfsXy6gxuCdU5s7NqS5/H41k3VXAuZ
         4+i0ye42OQKqJDz0jYb8cCfHdAiQvLdXVoB2Pfp1tlZYojh6eqjKUIKV9hHCE1yFLu
         zN0W+ED8PAHDRRN/lDI/LI9YHDAVkl2U9HgmbVzabCKgh5jOWe/i4YvpX+3oUavXS+
         UGbUPWYHb5MaOTOC8I3BkbQztfq8ykyjuTPhCsfev1vp87G41vqwwX6G37H2bHdp2o
         HAtAKWYMlJJZIRjm7z2Hr+A42LC/sUSumw7eEe4ReHsXx3uti78r+8e3Jg0mcJneCi
         EcNljDwNsf8kQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F38E1E1B4D9;
        Fri,  9 Dec 2022 09:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/4] net/sched: retpoline wrappers for tc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167057881899.16143.12680741866204985455.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 09:40:18 +0000
References: <20221206135513.1904815-1-pctammela@mojatatu.com>
In-Reply-To: <20221206135513.1904815-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuniyu@amazon.com
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
by David S. Miller <davem@davemloft.net>:

On Tue,  6 Dec 2022 10:55:09 -0300 you wrote:
> In tc all qdics, classifiers and actions can be compiled as modules.
> This results today in indirect calls in all transitions in the tc hierarchy.
> Due to CONFIG_RETPOLINE, CPUs with mitigations=on might pay an extra cost on
> indirect calls. For newer Intel cpus with IBRS the extra cost is
> nonexistent, but AMD Zen cpus and older x86 cpus still go through the
> retpoline thunk.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/4] net/sched: move struct action_ops definition out of ifdef
    https://git.kernel.org/netdev/net-next/c/2a7d228f1ae7
  - [net-next,v6,2/4] net/sched: add retpoline wrapper for tc
    https://git.kernel.org/netdev/net-next/c/7f0e810220e2
  - [net-next,v6,3/4] net/sched: avoid indirect act functions on retpoline kernels
    https://git.kernel.org/netdev/net-next/c/871cf386dd16
  - [net-next,v6,4/4] net/sched: avoid indirect classify functions on retpoline kernels
    https://git.kernel.org/netdev/net-next/c/9f3101dca3a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


