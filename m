Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573D852F6D0
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354221AbiEUAaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236632AbiEUAaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA3E1A90ED
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 601E661E6B
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B460DC3411A;
        Sat, 21 May 2022 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653093012;
        bh=LHZfGdgU15lbYxzFsMFtICUZGokkIXy8Wo7uS67jn9w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jXgklLZofjfDeHrIc1TNUAl65s/OmF5flW1AoHMNKkSkowPdO2n/SQRpTyAnR72AE
         oo6J3EZKS59Qnj8berXZpjE33IkmzDFgHb41647pZzYs+yYS56vWP5Wo8sHXjTq8ar
         dWYp1i/4BSEto/d1jMqkvdgAZzcNLKpFunPPIrh+JmkT+qZH1tNF6+IBES8URku8lQ
         kGqRC+rjXqqy53sVJB5mJ5QvOuarPv/lK5806R28H1o9cfoIqUfvicIzuQJj/0tU6q
         dGo9iSJlQ+0V02tjUR2uzvjWIoeJ4Z2aZl+5Cm1JY+mwbJdpISoqccd3Jvl/azEJGS
         tM/FQpN6SNrWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 977A5F0383D;
        Sat, 21 May 2022 00:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: fib_nexthops: Make ping timeout
 configurable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165309301261.22995.13698685103289498120.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 00:30:12 +0000
References: <20220519070921.3559701-1-amcohen@nvidia.com>
In-Reply-To: <20220519070921.3559701-1-amcohen@nvidia.com>
To:     Amit Cohen <amcohen@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        dsahern@gmail.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 19 May 2022 10:09:21 +0300 you wrote:
> Commit 49bb39bddad2 ("selftests: fib_nexthops: Make the test more robust")
> increased the timeout of ping commands to 5 seconds, to make the test
> more robust. Make the timeout configurable using '-w' argument to allow
> user to change it depending on the system that runs the test. Some systems
> suffer from slow forwarding performance, so they may need to change the
> timeout.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: fib_nexthops: Make ping timeout configurable
    https://git.kernel.org/netdev/net-next/c/5feba4727395

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


