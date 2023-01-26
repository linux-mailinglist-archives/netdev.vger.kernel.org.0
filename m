Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D7067C4C9
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjAZHUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjAZHUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4535A5E52C;
        Wed, 25 Jan 2023 23:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E55A6B81D0D;
        Thu, 26 Jan 2023 07:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BC03C433EF;
        Thu, 26 Jan 2023 07:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717617;
        bh=jf0xKWNcM8d76wm6oHy7yRJ+j/b63EcW5S2lCCXlOL4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HTUH/BAGKoZddHLqhICbDJzWtHKUx0JXaMCLYjcdWb3vcmSNGhq7Zk/oiiRLbeoTd
         Xgl/C89Y6GgfZq1rxt2uU4BNGrQXoBTiQwmgAGy9SuMtFY8KN3g2H9dat5WXFmn8vL
         oAxX+jGa+LMU33HJmfbPsIOXUahK+XIbm4JmDpb2JfGfLPGW9dUytUWLc4wHIy82GH
         44rDLnkPgQwl4ftDWjvTqxGn5bhZe5tL25CCUhQXH9CdUmAFhu8g3UJ1/lIsvlEv3c
         bWhssUYqfyNDnY1YOZ4MBKGqL7lEIsMiKW7Ml65mxDvXwsStuUKJ+7R25XcEEJdjY8
         MOu0bfP85nQ9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71E28F83ED5;
        Thu, 26 Jan 2023 07:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/2] Add IP_LOCAL_PORT_RANGE socket option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167471761745.28103.11884369370891284812.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Jan 2023 07:20:17 +0000
References: <20221221-sockopt-port-range-v6-0-be255cc0e51f@cloudflare.com>
In-Reply-To: <20221221-sockopt-port-range-v6-0-be255cc0e51f@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
        ncardwell@google.com, leon@kernel.org, selinux@vger.kernel.org,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, kernel-team@cloudflare.com,
        marek@cloudflare.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Jan 2023 14:36:43 +0100 you wrote:
> This patch set is a follow up to the "How to share IPv4 addresses by
> partitioning the port space" talk given at LPC 2022 [1].
> 
> Please see patch #1 for the motivation & the use case description.
> Patch #2 adds tests exercising the new option in various scenarios.
> 
> Documentation
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/2] inet: Add IP_LOCAL_PORT_RANGE socket option
    https://git.kernel.org/netdev/net-next/c/91d0b78c5177
  - [net-next,v6,2/2] selftests/net: Cover the IP_LOCAL_PORT_RANGE socket option
    https://git.kernel.org/netdev/net-next/c/ae5439658cce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


