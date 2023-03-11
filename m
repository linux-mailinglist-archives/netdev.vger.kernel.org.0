Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5116B58C6
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCKFu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCKFuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:50:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12270659F;
        Fri, 10 Mar 2023 21:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC03CB824BC;
        Sat, 11 Mar 2023 05:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58D9CC433D2;
        Sat, 11 Mar 2023 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678513822;
        bh=2vUgG6NICV1m4O/p0F0xew9DlmJEngCgIlpFHNCYXUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m6o0aLHFdjKjU7VaoHXPrclCH+s8Wen43kmwO/BGC+C69QVSIufzsrBkuNNpfLLv9
         2brDFCYLqCIpl4+OrDUmBQKuOOZm1Pwr6clK1UwLRhSiw0PtrwryGk+/95CNhF3297
         lDr+TCZf5zqv/dfI5A8C4/mDLP0lKIfp8AstP/e4czD3SgyinpeGTqcHIK91TT2aYq
         WzgVXDUT08jCNN6MopEbL/llZ7VQUHCOdK4iIrLkHMe4o7QTjpKXj9DaGZc0tDQBZ1
         yc/ZERATpw1i0ctv6Y99ME9fdTRNwSVeZLNgEWJpmcTnN4FKDQccn4RYAe8XoFrRAE
         UACulKWxF4dsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F570E61B65;
        Sat, 11 Mar 2023 05:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/8] mptcp: fixes for 6.3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167851382225.22535.4511360531108483772.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 05:50:22 +0000
References: <20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net>
In-Reply-To: <20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mptcp@lists.linux.dev, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, martineau@kernel.org,
        benbjiang@tencent.com, imagedong@tencent.com,
        mengensun@tencent.com, shuah@kernel.org, fw@strlen.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, cpaasch@apple.com,
        stable@vger.kernel.org, geliang.tang@suse.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 09 Mar 2023 15:49:56 +0100 you wrote:
> Patch 1 fixes a possible deadlock in subflow_error_report() reported by
> lockdep. The report was in fact a false positive but the modification
> makes sense and silences lockdep to allow syzkaller to find real issues.
> The regression has been introduced in v5.12.
> 
> Patch 2 is a refactoring needed to be able to fix the two next issues.
> It improves the situation and can be backported up to v6.0.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/8] mptcp: fix possible deadlock in subflow_error_report
    https://git.kernel.org/netdev/net/c/b7a679ba7c65
  - [net,v2,2/8] mptcp: refactor passive socket initialization
    https://git.kernel.org/netdev/net/c/3a236aef280e
  - [net,v2,3/8] mptcp: use the workqueue to destroy unaccepted sockets
    https://git.kernel.org/netdev/net/c/b6985b9b8295
  - [net,v2,4/8] mptcp: fix UaF in listener shutdown
    https://git.kernel.org/netdev/net/c/0a3f4f1f9c27
  - [net,v2,5/8] selftests: mptcp: userspace pm: fix printed values
    https://git.kernel.org/netdev/net/c/840742b7ed0e
  - [net,v2,6/8] mptcp: add ro_after_init for tcp{,v6}_prot_override
    https://git.kernel.org/netdev/net/c/822467a48e93
  - [net,v2,7/8] mptcp: avoid setting TCP_CLOSE state twice
    https://git.kernel.org/netdev/net/c/3ba14528684f
  - [net,v2,8/8] mptcp: fix lockdep false positive in mptcp_pm_nl_create_listen_socket()
    https://git.kernel.org/netdev/net/c/cee4034a3db1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


