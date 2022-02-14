Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202434B5220
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 14:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353150AbiBNNuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 08:50:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354628AbiBNNuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 08:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444FB49FB2;
        Mon, 14 Feb 2022 05:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F035AB80E6C;
        Mon, 14 Feb 2022 13:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 936B8C340EE;
        Mon, 14 Feb 2022 13:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644846610;
        bh=M3/XfpP3O61vn0oG5hpwvaCCgXT1nnEXNNVoWaXYow0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jq8zOMdo8Sn/BzpIXmQclihPR3cVW96IqpOxDnmA/cG6RfNyo40B0Q1mXvDKzlMLW
         SguSoTcIUf/8M9MCdlnOJSaEPHuMXTJKOywRbwYzM8B9+z82WfGGrtMdPlXb+CbfpE
         oUkZ19zg7oNDQoRiabhSEViybaIC0j0JT6rOMJjRnlRbvbaGB9vR+rbfAnHXW1IvGH
         asoCY5pqL9hmRg1ij+zX1mvhY9hdgIFC9+bnAx7sjy8DWOyqwF9EJNitNeqwF54IzX
         Ux2gN+deTEuUPbSvMW3lVS8qWbVuknUYbrmpx620PpqMVT26raEPlVEQtNjjbYnThl
         JQjLb+1mq0Yow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7BF15E6D447;
        Mon, 14 Feb 2022 13:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] net: dev: PREEMPT_RT fixups.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484661050.29461.14064214200893714668.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 13:50:10 +0000
References: <20220211233839.2280731-1-bigeasy@linutronix.de>
In-Reply-To: <20220211233839.2280731-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, edumazet@google.com,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        tglx@linutronix.de, toke@toke.dk
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 12 Feb 2022 00:38:36 +0100 you wrote:
> Hi,
> 
> this series removes or replaces preempt_disable() and local_irq_save()
> sections which are problematic on PREEMPT_RT.
> Patch 2 makes netif_rx() work from any context after I found suggestions
> for it in an old thread. Should that work, then the context-specific
> variants could be removed.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] net: dev: Remove preempt_disable() and get_cpu() in netif_rx_internal().
    https://git.kernel.org/netdev/net-next/c/f234ae294761
  - [net-next,v3,2/3] net: dev: Makes sure netif_rx() can be invoked in any context.
    https://git.kernel.org/netdev/net-next/c/baebdf48c360
  - [net-next,v3,3/3] net: dev: Make rps_lock() disable interrupts.
    https://git.kernel.org/netdev/net-next/c/e722db8de6e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


