Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229E2692D53
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 03:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjBKCUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 21:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjBKCU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 21:20:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AED5FE44;
        Fri, 10 Feb 2023 18:20:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E27961EE5;
        Sat, 11 Feb 2023 02:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA300C433D2;
        Sat, 11 Feb 2023 02:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676082028;
        bh=oRyZiLNqMfKPLZzuqIqozqYIVxamoSGFbd24anE+REY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZtUZtHNWIQqC9VQFHAaPpIdacoUt1m7fDGMoCnbhB+IG/TqKEP43q4sAFFr4WjKwM
         BpjbnNtk072Tqrejx90fKiC3F9yG9FKlsdz4mMEwS+9sEo+xCN9plAHd5CfEn5CHtb
         9k0tiTLg3K5mVM0BbH4W0fjz82kgRO+Yz01l+IW6uhY1esKZDiiXk70wPf+BlhkEIc
         ONYsBXMh+zGlRDO9MKD8TFaOlk27NtnVzjyIwG97xACmwEvHsKk/8+jV03YBhvNxMg
         fCfOw4e2yHftQXBWQCX85vOJPioPjJ/SzjRz9k+Ihehv9Ldt8GD6wc8znBTGAPTVwk
         0dBdx3/FP5Tug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C535AE55EFD;
        Sat, 11 Feb 2023 02:20:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2023-02-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608202778.19252.2274773840562927551.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 02:20:27 +0000
References: <20230211002037.8489-1-daniel@iogearbox.net>
In-Reply-To: <20230211002037.8489-1-daniel@iogearbox.net>
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

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 11 Feb 2023 01:20:37 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 96 non-merge commits during the last 14 day(s) which contain
> a total of 152 files changed, 4884 insertions(+), 962 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2023-02-11
    https://git.kernel.org/netdev/net-next/c/de4287336794

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


