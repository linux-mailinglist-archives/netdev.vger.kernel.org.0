Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A654C0AD5
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 05:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236919AbiBWEKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 23:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiBWEKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 23:10:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E38666AF9
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 20:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C0FBB81E79
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F773C340F0;
        Wed, 23 Feb 2022 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645589410;
        bh=nICz95m9pwS6b7NulC5kXENRg+2FEsdTf4MiSah7TsQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SbIY9TPsZRhKQYgpu69oeJvCnUM1X9OjeyyG06Q1/niTyr4cIUVC0oNLBQTJMvj2d
         WnMsdeCcZKNHYek2+7RVl01Qh85xi6Y5CFrixX1cRpOJr3nRvqBkYOpPV52InK3FtV
         SIu3c6iJVBABtuEl564iYKJojOqlNjBtY5v3+IlXNpqG6wk5I+PxRYsTwKmPSCtxfg
         vv2aZtZc+sFnokevMvQXDsi56h4ImQTN1kHDZiYQvMyHYd1L3CplyO1R5FiXJU12w2
         wknxdkgt6fKWRROMifkKa83H+MpvCJyFMEFH+aTQybOfwJ7j6uHUQKWrGVH+hHJS34
         SHMC1vPw3N1NQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7939CE5D09D;
        Wed, 23 Feb 2022 04:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ionic: use vmalloc include
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164558941049.26093.16745028855243004182.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 04:10:10 +0000
References: <20220223015731.22025-1-snelson@pensando.io>
In-Reply-To: <20220223015731.22025-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 22 Feb 2022 17:57:31 -0800 you wrote:
> The ever-vigilant Linux kernel test robot reminded us that
> we need to use the correct include files to be sure that
> all the build variations will work correctly.  Adding the
> vmalloc.h include takes care of declaring our use of vzalloc()
> and vfree().
> 
> drivers/net/ethernet/pensando/ionic/ionic_lif.c:396:17: error: implicit
> declaration of function 'vfree'; did you mean 'kvfree'?
> 
> [...]

Here is the summary with links:
  - [net-next] ionic: use vmalloc include
    https://git.kernel.org/netdev/net-next/c/922ea87ff6f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


