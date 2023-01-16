Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2317F66BFCB
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjAPNaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjAPNaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5C11CF6D
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 05:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36E4260FB3
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 13:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96E0AC433F2;
        Mon, 16 Jan 2023 13:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673875816;
        bh=M8QqWHI0I5N0zIL8doVStBLB+gNRGcIt39Zp90VHOMc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G2EggJUvfBGaSiW3kE68gvmvAYQyRXMERgDgjpgj6xka/SRyYlpLSzi1tOwL0itJu
         XbcC89UkwjdlUGVPuJAmDOn9yHFDQRopD+Lb5F2pCZQPMlGeYKJfvAAeokzPKOnkjV
         kbU0fTWTHlrL6Dsjq4+QbicDju1fFkt2n+Xp+3pZE95AyzvuRXCGFrAZzV+xPTMkX3
         dLS1eo2XiqeapljIR7/pIO0UhS529VwHBCunCT8cBow4rRN8IA1GeJjjpKL4zXN7LQ
         oznHFFjzWQQLFDRpcGlA81UfuBPmm1vXPv/pooDLLrtB7NcqOJumtQ/R1quAVMv6iY
         RdErOf5KZ85jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 833D6E54D2E;
        Mon, 16 Jan 2023 13:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: sch_taprio: fix possible use-after-free
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167387581653.2747.13878941339893288655.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 13:30:16 +0000
References: <20230113164849.4004848-1-edumazet@google.com>
In-Reply-To: <20230113164849.4004848-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, glider@google.com,
        vinicius.gomes@intel.com
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

On Fri, 13 Jan 2023 16:48:49 +0000 you wrote:
> syzbot reported a nasty crash [1] in net_tx_action() which
> made little sense until we got a repro.
> 
> This repro installs a taprio qdisc, but providing an
> invalid TCA_RATE attribute.
> 
> qdisc_create() has to destroy the just initialized
> taprio qdisc, and taprio_destroy() is called.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: sch_taprio: fix possible use-after-free
    https://git.kernel.org/netdev/net/c/3a415d59c1db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


