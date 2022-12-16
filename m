Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16E264F13A
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 19:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiLPSuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 13:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiLPSuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 13:50:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE4A28E30;
        Fri, 16 Dec 2022 10:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8673CCE1EA8;
        Fri, 16 Dec 2022 18:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B43E1C433D2;
        Fri, 16 Dec 2022 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671216616;
        bh=NBg0jATPI3lp9yR3ODNQSziCW7jTl6Q1Wvz1dv2+Ol8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SJmyAYZV+QHwSexGEIUCfafq2G462rOMw5mTJEKo3GnMNn+ZZ6jQL2R4Sn8+4rcDI
         TefOQg+PmgzDpXuCQdLbgvFjOxCc+QBtIkd7r20vJ2Y6zHrGEEpp43wiP53J5x6eRr
         +UBNRGNCWVgQlWGPPLh3vzokTzGqYo8tAaasN+SmfJx0cMw0chIXfE0SfckLTgIEzH
         XCy2CQKR6KEoq1ZoixDuUGlPyQUEsHxJzkEcFVVU/3pKEiWHQ4O8BMzvY79k7+HPUv
         PeWP5RfqzmPtZ7d09SVmmNvxFKwly69bQ+MLI/nObStWgIdiH/Lbvug+JD6WeNkel4
         JFmOJyLS3XSUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9FBD1E4D00B;
        Fri, 16 Dec 2022 18:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-12-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167121661665.30644.14713669442421324398.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Dec 2022 18:50:16 +0000
References: <20221216174540.16598-1-daniel@iogearbox.net>
In-Reply-To: <20221216174540.16598-1-daniel@iogearbox.net>
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

On Fri, 16 Dec 2022 18:45:40 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 7 non-merge commits during the last 2 day(s) which contain
> a total of 9 files changed, 119 insertions(+), 36 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-12-16
    https://git.kernel.org/netdev/net/c/13e3c7793e2f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


