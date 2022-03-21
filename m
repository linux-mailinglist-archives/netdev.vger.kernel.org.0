Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C244E324B
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 22:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiCUVWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 17:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiCUVWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 17:22:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87F62B65A1
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 14:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 510BFB819FE
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 21:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10607C340EE;
        Mon, 21 Mar 2022 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647897610;
        bh=wVAqm2yiO2ffIk6H5B36tVOZt4XIqLamQVNY4Y1u8Aw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dvm5MJ8yCM1O0beUs2c0wjEpkvGwTbZ8t9wHSJKSNv80EvSHhhhABHUJy3j7Sxwu1
         1cb22f7u5DeYBelq4+jfJwAnmp49agt/W0lfbeElLvcy1xzXwChcjli3QiCcPa6jZB
         fuK2ZGYbU3mf24H+VsueCLN29GJxdugNhABOZKNUt4jXGd0DNwswgevUXPmv6tgNcR
         wc2LTEYgMCH3jdJSFXjnjp0FAIPns7KjuV9BPXe3jvEjRIOhg3zDoNtMwpyQ/blfnK
         YDZqT3NIM2j1amKw78htEtsHzkArqpNZOXoeTrgmMwQwEzL+TSRfiDfxgHYsjCC++p
         K/9u0JYyjOq2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E656BEAC096;
        Mon, 21 Mar 2022 21:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Revert the softirq will run annotation in
 ____napi_schedule().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164789760993.23659.8023699884075183252.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 21:20:09 +0000
References: <YjhD3ZKWysyw8rc6@linutronix.de>
In-Reply-To: <YjhD3ZKWysyw8rc6@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     kuba@kernel.org, Jason@zx2c4.com, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, tglx@linutronix.de,
        peterz@infradead.org, toke@redhat.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 21 Mar 2022 10:22:37 +0100 you wrote:
> The lockdep annotation lockdep_assert_softirq_will_run() expects that
> either hard or soft interrupts are disabled because both guaranty that
> the "raised" soft-interrupts will be processed once the context is left.
> 
> This triggers in flush_smp_call_function_from_idle() but it this case it
> explicitly calls do_softirq() in case of pending softirqs.
> 
> [...]

Here is the summary with links:
  - [net-next] net: Revert the softirq will run annotation in ____napi_schedule().
    https://git.kernel.org/netdev/net-next/c/351bdbb6419c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


