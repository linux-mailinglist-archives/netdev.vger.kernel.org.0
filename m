Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48B46A05B0
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbjBWKKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbjBWKK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:10:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F2E498BA;
        Thu, 23 Feb 2023 02:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 469AA61645;
        Thu, 23 Feb 2023 10:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4178C43442;
        Thu, 23 Feb 2023 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677147017;
        bh=AdumiRk978R6TMFS+JiE9B+BeaaZpYEUXuz7bZc0usI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D5cXDBdvGkhiDic7fB96H4yy1G3TZ4YX6T66aHnsca3W646KtP6Qf2WjFGzLxiWdK
         V3ls0q5Z5AJXJBR8oQNGGutAGRjqhOo3FKa6O4gVQ6VfMzYXUCP2HiA+VWvJUyoXo/
         sBPQxqUVJycF7zMpLAPbDAFhEbpm4g2/BcjDvs9T3SIjk78FR/vD/Saw8/6hW0aWYU
         eCzP3e3FhUU4sLWnec5ZJd7Nh6sjlgdEIO2TJVMQMSABAJ0Dsq8sOwuuipI6FbHA6j
         II6dUNeUZ9QNvpbUGbYwv96AvsDb49X6IT2wEIOoaKp1uw1IiPk3quiut5mOB1XIKU
         9W6zww10BdIyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 993F5C395E0;
        Thu, 23 Feb 2023 10:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,v4,0/2] Fix a fib6 info notification bug
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167714701762.24300.10986774943559374291.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Feb 2023 10:10:17 +0000
References: <20230222083629.335683-1-luwei32@huawei.com>
In-Reply-To: <20230222083629.335683-1-luwei32@huawei.com>
To:     Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 22 Feb 2023 16:36:27 +0800 you wrote:
> This patch set fixes a length calculation bug in fib6 info notification
> and adds two testcases.
> 
> The test reult is listed as follows:
> 
> before the fix patch:
> 
> [...]

Here is the summary with links:
  - [net,v4,1/2] ipv6: Add lwtunnel encap size of all siblings in nexthop calculation
    https://git.kernel.org/netdev/net/c/4cc59f386991
  - [net,v4,2/2] selftests: fib_tests: Add test cases for IPv4/IPv6 in route notify
    https://git.kernel.org/netdev/net/c/44bd0394fe10

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


