Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CACE6D1796
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCaGkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjCaGks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:40:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792DA1B366
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 23:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ED74623A2
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5795EC4339B;
        Fri, 31 Mar 2023 06:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680244819;
        bh=0RjMs++z/4Bg2YHWrF7Rn+pRGv4Rdd53KTBhVX/yI8E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fVq+LlO7yQiigKUjwY1ZEmznGTG28OZ8YRfX/r5yKvFCPRRRpNyI7QLvBScqn6xAj
         BiTrgaWvu4FeTayO9wfCsDtcQ1ihB78RLcqMUzjHY3S10wMcl6Wk1HaMKR68Yt/U6B
         kQ//VC4J+xjcHCMQU0TDxlxOjFHHVg8uxDbMZBv1fkpX9JfQ3gsnrZ7rot29+ewNTo
         w3bVWaPWTz8XxXNne3aknZFSjIrT42LQiGGD4r8pychIXwOwq5jsPjxSS6Vu+Xo32g
         4uzIvvtOPPg1XfWJGv2llyyAQQndVwtbo5uwDwPVMXTtuJyVFQ09pzieUX09GyqKiW
         g8fgBrO6oIrJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D85CC73FE0;
        Fri, 31 Mar 2023 06:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeontx2-af: update type of prof fields in
 nix_aw_enq_req
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168024481924.5026.13451121678104405717.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 06:40:19 +0000
References: <20230329112356.458072-1-horms@kernel.org>
In-Reply-To: <20230329112356.458072-1-horms@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, hkelam@marvell.com,
        sbhatta@marvell.com, richardcochran@gmail.com,
        keescook@chromium.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 13:23:56 +0200 you wrote:
> Update type of prof and prof_mask fields in nix_as_enq_req
> from u64 to struct nix_bandprof_s, which is 128 bits wide.
> 
> This is to address warnings with compiling with gcc-12 W=1
> regarding string fortification.
> 
> Although the union of which these fields are a member is 128bits
> wide, and thus writing a 128bit entity is safe, the compiler flags
> a problem as the field being written is only 64 bits wide.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: update type of prof fields in nix_aw_enq_req
    https://git.kernel.org/netdev/net-next/c/709d0b880cea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


