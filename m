Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E6C584F9B
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 13:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiG2LaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 07:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiG2LaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 07:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0A113D60
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 04:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2A9BB8267B
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 11:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93715C433D7;
        Fri, 29 Jul 2022 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659094213;
        bh=5Gqu0l+QipDlAyMCaz+lE8FLs5XbOoAWt6+gaHqhwbs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pi3hORYzAREyArualNJXqRwKmvUsO/L9t81vICXQIj7g+IeAEBBvnda1qGl88sG2m
         P2T+aXK5f85dmToc66MwMVC5MuyJnXVcyGJRbw0GBTrs1v4ZdYQK8kDIvd5ENsUgPA
         91gF/8SqiZXML+i29lu382TVYRzOcsj7khXlCH4WK8Qgm4fxUijmgZ7pp4bCiPfmF0
         UAvVUAqACv1vxYneSzOq3xozPnBrCB2Xzqv7P4cBPAmx3qt1PS8k5nYbaLz7afN7yT
         etR4pMqosfxGTxsY1AmjjLFHN6GHiIak83H9BZU4dks4whMlL4lWIFLE212IWMSSeC
         3MIO9pncKgtQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B3B5C43143;
        Fri, 29 Jul 2022 11:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] netdevsim: fib: Fix reference count leak on route
 deletion failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165909421350.27900.1726932234825962937.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 11:30:13 +0000
References: <20220728114535.3318119-1-idosch@nvidia.com>
In-Reply-To: <20220728114535.3318119-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, amcohen@nvidia.com,
        dsahern@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Jul 2022 14:45:32 +0300 you wrote:
> Fix a recently reported netdevsim bug found using syzkaller.
> 
> Patch #1 fixes the bug.
> 
> Patch #2 adds a debugfs knob to allow us to test the fix.
> 
> Patch #3 adds test cases.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netdevsim: fib: Fix reference count leak on route deletion failure
    https://git.kernel.org/netdev/net/c/180a6a3ee60a
  - [net,2/3] netdevsim: fib: Add debugfs knob to simulate route deletion failure
    https://git.kernel.org/netdev/net/c/974be75f2503
  - [net,3/3] selftests: netdevsim: Add test cases for route deletion failure
    https://git.kernel.org/netdev/net/c/40823f3ee05f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


