Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B883C5FE9B9
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 09:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiJNHkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 03:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJNHkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 03:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD9159269;
        Fri, 14 Oct 2022 00:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C99E619D0;
        Fri, 14 Oct 2022 07:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 744A1C433D6;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665733216;
        bh=pdspCJQ07e6HI7qw8rXouuJbeG2thtb2TGgHsraA+pI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UsfvedrGKi6yYt5aOT8LrX8H6jXgeZekU+bRsjO3gUOmIVTWXcxk4o0YScRunfp7K
         9qPgnQ9l0MnL92CpJMUUfESC3IkeMavZRCnDCy1zdNIEik978iqEekxtqcbUVUCPnn
         wCfIE/0GDwuMzuUfyPmzepCoRMtA0rEv1AbAxj/s20V69nI+7VXFSX8dayF82odUIO
         dwZ2v2bzDYUxFn+h/DG3OpZwEyrjs+ZEzE4U7aXWz9MkZ6Vq5U8a96Yg7+1G0PvEnZ
         HVu6Zuk1UdKk2bNirhC346eFMt4js5KjpHJtLL5LYuxGVZh4Gx9zWPuBaL77tW01aQ
         r9jRz/PHKSVoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A1A5E50D94;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tipc: Fix recognition of trial period
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166573321636.24049.11691596559527099656.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Oct 2022 07:40:16 +0000
References: <20221010024613.2951-1-mark.tomlinson@alliedtelesis.co.nz>
In-Reply-To: <20221010024613.2951-1-mark.tomlinson@alliedtelesis.co.nz>
To:     Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
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

On Mon, 10 Oct 2022 15:46:13 +1300 you wrote:
> The trial period exists until jiffies is after addr_trial_end. But as
> jiffies will eventually overflow, just using time_after will eventually
> give incorrect results. As the node address is set once the trial period
> ends, this can be used to know that we are not in the trial period.
> 
> Fixes: e415577f57f4 ("tipc: correct discovery message handling during address trial period")
> Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
> 
> [...]

Here is the summary with links:
  - tipc: Fix recognition of trial period
    https://git.kernel.org/netdev/net/c/28be7ca4fcfd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


