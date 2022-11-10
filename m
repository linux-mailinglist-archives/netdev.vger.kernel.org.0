Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C44623A0A
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbiKJCuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiKJCuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:50:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5D823EBB
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB29FB8206A
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 457EAC43141;
        Thu, 10 Nov 2022 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668048614;
        bh=aAFsD8DGzna1jqWes6p3lywJJGM6VlylrV+Euwef0H4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tVKX5MCyWeohKevii4Y6+5jZRCbOlQ6fptFxz4S56K/NUhdqGZxXs2dKxBz2QnN5Y
         8TmHza+iimpFeioU8/OUF8W1N199d/JiBMq9OAks6ri004eUtlreCHffr4fSAcBjD5
         4hrOdAJpM5u059jWqSVkyMcjJTYQlbB+2LZvUct0twNryI/1p+6ai71k6N38NB9pVK
         LAMleYqkV/eHq/3K2rwm5xF8pMoAGByZaSnIyKGb3NodGWpYFcapD5tyAL1HUuSGK5
         zclXcc3UUIihr9KeYK13zTwAX8NM7evIOr+ZvHUPuppxTQwmDEhi5rc64QYncvlR0n
         wsnjHU1sss9og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2948CC395FD;
        Thu, 10 Nov 2022 02:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: cxgb3_main: disable napi when bind qsets failed
 in cxgb_up()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166804861416.6959.11320091943863478738.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 02:50:14 +0000
References: <20221109021451.121490-1-shaozhengchao@huawei.com>
In-Reply-To: <20221109021451.121490-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, rajur@chelsio.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jeffrey.t.kirsher@intel.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 9 Nov 2022 10:14:51 +0800 you wrote:
> When failed to bind qsets in cxgb_up() for opening device, napi isn't
> disabled. When open cxgb3 device next time, it will trigger a BUG_ON()
> in napi_enable(). Compile tested only.
> 
> Fixes: 48c4b6dbb7e2 ("cxgb3 - fix port up/down error path")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()
    https://git.kernel.org/netdev/net/c/d75aed1428da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


