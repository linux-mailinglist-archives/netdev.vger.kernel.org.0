Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943C46711BA
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjARDUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjARDUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8544FCC9;
        Tue, 17 Jan 2023 19:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBD09615F4;
        Wed, 18 Jan 2023 03:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42D60C433EF;
        Wed, 18 Jan 2023 03:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674012017;
        bh=xoYAxsyudEntmtzESge+LUA8LPl0IhQkHhyVlHB9jGI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iwNIY7psXqv6eOW0mvtB5uUmnaueTl2mx0sGdA16Gt63b4OiUtTkPF1lvypQoMs83
         WaDvHfEIWoL7NA9StGNzHreotyyF4D2S8xscevcl3he/rDsCHhPmnFN3bamVX/E8RO
         ypiVc7m8zB8rGVQSlutpSEg2FQDMQ1LnxgBVtmtobL/a08tbAA04ZeWexbFohD7SAp
         fUBYM4eVT8Fnbt+dSAzody0aWFIPfM64OlUJPKGeGoNqfB5F3ZtB9sx4vXlZogek7i
         7ScktC8B/lnX707nG4j1SxBlH+6ZgRqn987rSDmjoHXMtPqXQn3zbkf3JRCkPDxgIj
         CbEpzGAEB24QA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2841AC43147;
        Wed, 18 Jan 2023 03:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2023-01-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167401201716.10723.4793610924544630359.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 03:20:17 +0000
References: <20230116230745.21742-1-daniel@iogearbox.net>
In-Reply-To: <20230116230745.21742-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 Jan 2023 00:07:45 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 6 non-merge commits during the last 8 day(s) which contain
> a total of 6 files changed, 22 insertions(+), 24 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2023-01-16
    https://git.kernel.org/netdev/net/c/423c1d363c46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


