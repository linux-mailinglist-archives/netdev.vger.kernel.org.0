Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337596B5730
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 02:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjCKBAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 20:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCKBAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 20:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C3F127120
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 17:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCF5F61D85
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 01:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21320C4339B;
        Sat, 11 Mar 2023 01:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678496419;
        bh=qmv/fn3RQjn3nbmL6VNhyB66PCwMmT0CCpUfiG9JiGo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ahCdath84Cks8uhc6Q+G7rLhgGZCp1TTTv5NRT2lsdxgGIW/QRUSvCpw//9pKUmKQ
         MD+5nvuOESxC5cAAq4lTC6UDop/cwmsHQjeVxar/ab6jSosYGmRKaEyU5bNf8k+igd
         2ncPC3+ZLoLugoKZvQgIwry52ZMw+xDpngFAxxyslmym4xN1LdLa2C72yPGEZEc7Np
         psJ6GdqCjAQFc2p8UKHRD/GJWGboCPhZR6NMVzMxmGlxe720cnTZRCGLPldGIEDTg3
         d1flbANza1YTa2gvVhpKMXPsL70TQ7szH4CAW0lrszBlSJo0r3nlpkil/7gx5YNuzy
         e2klPe59TrpRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0702EE21EEA;
        Sat, 11 Mar 2023 01:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] Couple of minor improvements to build_skb
 variants
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167849641902.30287.6318519771853912228.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 01:00:19 +0000
References: <20230308131720.2103611-1-gal@nvidia.com>
In-Reply-To: <20230308131720.2103611-1-gal@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 8 Mar 2023 15:17:18 +0200 you wrote:
> First patch replaces open-coded occurrences of
> skb_propagate_pfmemalloc() in build_skb() and build_skb_around().
> The secnod patch adds a likely() to the skb allocation in build_skb().
> 
> Changelog -
> v1->v2: https://lore.kernel.org/netdev/20230215121707.1936762-1-gal@nvidia.com/
> * Add 'frag_size' into the likely call
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] skbuff: Replace open-coded skb_propagate_pfmemalloc()s
    https://git.kernel.org/netdev/net-next/c/566b6701d5df
  - [net-next,v2,2/2] skbuff: Add likely to skb pointer in build_skb()
    https://git.kernel.org/netdev/net-next/c/3c6401266f91

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


