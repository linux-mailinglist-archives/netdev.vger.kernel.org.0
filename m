Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659D267F5C8
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 08:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbjA1HuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 02:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbjA1HuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 02:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B20A3669F;
        Fri, 27 Jan 2023 23:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CB73B80DFA;
        Sat, 28 Jan 2023 07:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D789DC433D2;
        Sat, 28 Jan 2023 07:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674892218;
        bh=rnhPJsFXtsSuTxpIr9CsLrDqEjtyIAZ5c1xMieB7DQY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RVqR47xntR1q7QsYS9cEk4CFxaNx4b94m1w1HscR1qJ65Dj2CViM9jBz6dTIPtY8C
         7pAw+U3q4WQ06PlFXHI3zJ0fg1L0ETK9AtCk5QWEErUevBm/PCwymbolVCq9gjmE91
         peldpdN+Y6SQ3X33rncpJW8L3b0wXNKHrL2UaRquN1JqY0xcQUEZ1D3lhAXhp/jKkZ
         BJ7O5tsDdW8pVVWUAUyqROf2dwkN16acu+Qc3wyw0kKVMcj2uxFBZCzg0ZiWIDF7VT
         mME0jUHn8l0DD5eAc4wCcCdhAC5vq2RkLMbI9o6S2U4THeHCcRmCl8/SgmD7w86XN0
         IHCcoBcgminjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5BD9C39564;
        Sat, 28 Jan 2023 07:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2023-01-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167489221874.30137.5005634055300425754.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 07:50:18 +0000
References: <20230128004827.21371-1-daniel@iogearbox.net>
In-Reply-To: <20230128004827.21371-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 28 Jan 2023 01:48:27 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 124 non-merge commits during the last 22 day(s) which contain
> a total of 124 files changed, 6386 insertions(+), 1827 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2023-01-28
    https://git.kernel.org/netdev/net/c/0548c5f26a0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


