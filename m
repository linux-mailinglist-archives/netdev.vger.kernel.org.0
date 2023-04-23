Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6416EBFB8
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 15:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjDWNUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 09:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDWNUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 09:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2261726;
        Sun, 23 Apr 2023 06:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1522C6113A;
        Sun, 23 Apr 2023 13:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63FA2C4339C;
        Sun, 23 Apr 2023 13:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682256020;
        bh=zDVGjoKSqKq4/xSreP9Fn9wJhv5ttLzEaqYxQK2ZJPY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mkGrynONdWJzUkYWqEY2sA9Rl4bG5aMdRJvo+lhPbX9E7iIKVwVbChGoj7zcNTbil
         grS5+cCixKsBG1h6XZEfMTX+GjORk5Wl4u/ZplAuG+fuojuKDb13lc/EEX5s9YvKSA
         tAE08GP9gJsh5P7BLtMGHyY8JhOAE7o8POLyax8zNHTdcyb68HV9Ap7JAykZXfdrXp
         kLT65YvWp3XJhbAKJx0+lb1AmFEERUDZaLjo2BJ0jkk6wlE2EvdhD6iGaInNTs9qGD
         E53PkDNAH6owBhmG2z2cjSsvFVEPi9SdOtwd8pKU/UD5jYoAMKxHLKhTm544Uyw48V
         pmLiVD7CxjAsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49079E4D000;
        Sun, 23 Apr 2023 13:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sched: Print msecs when transmit queue time out
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168225602029.29216.4122381734808769273.git-patchwork-notify@kernel.org>
Date:   Sun, 23 Apr 2023 13:20:20 +0000
References: <20230421082606.551411-1-yajun.deng@linux.dev>
In-Reply-To: <20230421082606.551411-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Apr 2023 16:26:06 +0800 you wrote:
> The kernel will print several warnings in a short period of time
> when it stalls. Like this:
> 
> First warning:
> [ 7100.097547] ------------[ cut here ]------------
> [ 7100.097550] NETDEV WATCHDOG: eno2 (xxx): transmit queue 8 timed out
> [ 7100.097571] WARNING: CPU: 8 PID: 0 at net/sched/sch_generic.c:467
>                        dev_watchdog+0x260/0x270
> ...
> 
> [...]

Here is the summary with links:
  - net: sched: Print msecs when transmit queue time out
    https://git.kernel.org/netdev/net-next/c/2f0f9465ad9f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


