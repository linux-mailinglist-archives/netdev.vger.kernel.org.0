Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E0057EA5B
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 01:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiGVXkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 19:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiGVXkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 19:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4733D6458
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 16:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05BE362258
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 23:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CB15C341CA;
        Fri, 22 Jul 2022 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658533213;
        bh=1pwrUCW85d3062fkKBHyljJL8ut8qEyc21jwhAcyijk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bb/LUAp+Yzv74q8pyag51ueMUXDcxGAfgoU7d0xMoEXeyFd15drWz0f432yio//Mb
         FZKmONpOsEJQZHxODSRaM4O4v3RZj7jWOLStOD1VpLn4Ns/Q87mWqYrFwAp9rVhXma
         JhOfoU8V3m1/2zMVenI2s17QgrCcI5uezxndPviqtrfiG8AwmuS9k1hDQPTpq5aU72
         TQr+NAmypojQxfO+i92f4Xcn9Yq2/ICtjtQ78LwxanW2VgIPicPYV4xEFYHW+S7LGI
         M47AHO7wgN2Wzq1HRjx2hQ3OnkNBSNkhYeaNNvFHv8L39Ipc2pAwokmJQYkd0MXRbL
         ub38IEiOJ6YKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31081E451BD;
        Fri, 22 Jul 2022 23:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] Revert "tcp: change pingpong threshold to 3"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165853321319.22315.1115617668029518886.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 23:40:13 +0000
References: <20220721204404.388396-1-weiwan@google.com>
In-Reply-To: <20220721204404.388396-1-weiwan@google.com>
To:     Wei Wang <weiwan@google.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, soheil@google.com, ycheng@google.com,
        hlm3280@163.com, ncardwell@google.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Jul 2022 20:44:04 +0000 you wrote:
> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> 
> This to-be-reverted commit was meant to apply a stricter rule for the
> stack to enter pingpong mode. However, the condition used to check for
> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> jiffy based and might be too coarse, which delays the stack entering
> pingpong mode.
> We revert this patch so that we no longer use the above condition to
> determine interactive session, and also reduce pingpong threshold to 1.
> 
> [...]

Here is the summary with links:
  - [net,v2] Revert "tcp: change pingpong threshold to 3"
    https://git.kernel.org/netdev/net/c/4d8f24eeedc5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


