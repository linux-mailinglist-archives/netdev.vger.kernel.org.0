Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2E168E785
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 06:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjBHFaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 00:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjBHFaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 00:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE89819F31;
        Tue,  7 Feb 2023 21:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86590614B4;
        Wed,  8 Feb 2023 05:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD9D8C4339B;
        Wed,  8 Feb 2023 05:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675834217;
        bh=X869hs5QRmL6Keo1c4rmIMNoGGataqLDrebSA37ZfzE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RWQQeklVXIvgsc2dqb8x/LrEXLz6Dih1DxeV4zzflkQaLhGnODvmcfD6IpHlqY7sc
         EJWLCwIZUKU4Ll25ECaBSy8Qx7cfY4SKAWRlpIEgujTWMM3RcmVlaqg7VQ5W+AcZF8
         SkN2KDciS67irgKBjQPTk3dO7vQZedyFoWXP31suLFL6xTAktCUXVyL1Kib9X5BKgy
         zWnaWGx/x3k2+RfMjr/6sLl+Ex/ojSY/Cp5s/WOxKc033M/lqRabyubYNDDiVNDq46
         U9bU/VC6tjl8yl8nt6IWtFlUNORHgGMlA93igm3KtfJvByD9fglhqCShJJ7ZH7cCrG
         jE7P/U0X7vmmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD83EE50D62;
        Wed,  8 Feb 2023 05:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] hv_netvsc: Allocate memory in netvsc_dma_map() with
 GFP_ATOMIC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167583421770.16532.4468711541508652547.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 05:30:17 +0000
References: <1675714317-48577-1-git-send-email-mikelley@microsoft.com>
In-Reply-To: <1675714317-48577-1-git-send-email-mikelley@microsoft.com>
To:     Michael Kelley (LINUX) <mikelley@microsoft.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Feb 2023 12:11:57 -0800 you wrote:
> Memory allocations in the network transmit path must use GFP_ATOMIC
> so they won't sleep.
> 
> Reported-by: Paolo Abeni <pabeni@redhat.com>
> Link: https://lore.kernel.org/lkml/8a4d08f94d3e6fe8b6da68440eaa89a088ad84f9.camel@redhat.com/
> Fixes: 846da38de0e8 ("net: netvsc: Add Isolation VM support for netvsc driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> 
> [...]

Here is the summary with links:
  - [net,1/1] hv_netvsc: Allocate memory in netvsc_dma_map() with GFP_ATOMIC
    https://git.kernel.org/netdev/net/c/c6aa9d3b43cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


