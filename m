Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B899C5FF99E
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 12:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJOKUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 06:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiJOKUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 06:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD262AC4B
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 03:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6687A60C6A
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38D61C43146;
        Sat, 15 Oct 2022 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665829216;
        bh=EzrYI8O/qGFauVLutnLTzOBNyAzUSS97K1yfAfkzZOk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h9aVA6OD8YRqDCHP7nPkiVsdgFmROc78RNP7U5q7rf2OeOWA47GcYdoBNh/DNClDg
         t2ib83FnCwdTsdkSWNVCxr5nYwjvJQGYUjSSChujhSIhLvrlyC91y9c5O3ZpXZ5rPI
         bl+ffTpHAK9iappYcQRRzQ2dikPIc67Ks6NiGlDriIbtwyTBzEVhF+3TngPs8q/FYi
         XvvM0bsPRWDnyGUoii+/W+wF+NmYeA+ts6PKrXDb37vpm+bi+6QnZRCJK36AnNnb3G
         lLzIeFCaskeRAlZDLfT1zhfp3AK+VAzlIlvBOj8lhOcugKEdcBovte2WAIiMGUeT4y
         HfLf6rdyC6N0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F56FE52527;
        Sat, 15 Oct 2022 10:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net: fix cpu_max_bits_warn() usage in
 netif_attrmask_next{,_and}"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166582921612.1299.769135677399153914.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Oct 2022 10:20:16 +0000
References: <20221014160746.553813-1-kuba@kernel.org>
In-Reply-To: <20221014160746.553813-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, guoren@kernel.org, yury.norov@gmail.com
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

On Fri, 14 Oct 2022 09:07:46 -0700 you wrote:
> This reverts commit 854701ba4c39afae2362ba19a580c461cb183e4f.
> 
> We have more violations around, which leads to:
> 
>   WARNING: CPU: 2 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x14e/0x770
> 
> Let's back this out and retry with a larger clean up in -next.
> 
> [...]

Here is the summary with links:
  - [net] Revert "net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}"
    https://git.kernel.org/netdev/net/c/fc8695eb11f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


