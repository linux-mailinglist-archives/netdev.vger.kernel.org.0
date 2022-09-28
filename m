Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BA75EE355
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 19:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiI1RkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 13:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbiI1RkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 13:40:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56285367BE;
        Wed, 28 Sep 2022 10:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7E017CE1F64;
        Wed, 28 Sep 2022 17:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15C9BC433D7;
        Wed, 28 Sep 2022 17:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664386816;
        bh=w8/sOkRaaIh4cG4Ms33eui8djgD2kmpLxvkOv6YZXfo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NW+M7WHnm1VkuVCPexkl4IGifhJtwYLxqzz1zzw0RANM7HvjM+Tle62SyLeFmHBHc
         Jj5em2W/E32zZoltnZ3BSKX+8yBDEw/BTnrR9Rn2124YQDhAG/Xr9SKbI+bq3xCGym
         bJc32LFJWUbuRR4zYQ4ckLXCXqUY9dxEnuzZO5wkj+HMRqsWkj0gWzHgLDBI8YCTp/
         tZaR3x/duFfidlW2g/z0QOiNiasJWeiMfAH4I49MgMIgiu9cmv/bODHXd/ynvhv9Uh
         GiTJU14QHPXssz2uzgXr7ZbKKDf8UBAESyBzRvYGsXBQHATuhdZ5ndi0O9W+qIKW3Q
         Vl895TFG9376Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBAB8E21EC0;
        Wed, 28 Sep 2022 17:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] netfilter: nft_fib: Fix for rpath check with VRF devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166438681596.21292.15724140524303273555.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 17:40:15 +0000
References: <20220928113908.4525-2-fw@strlen.de>
In-Reply-To: <20220928113908.4525-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, phil@nwl.cc
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Florian Westphal <fw@strlen.de>:

On Wed, 28 Sep 2022 13:39:08 +0200 you wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> Analogous to commit b575b24b8eee3 ("netfilter: Fix rpfilter
> dropping vrf packets by mistake") but for nftables fib expression:
> Add special treatment of VRF devices so that typical reverse path
> filtering via 'fib saddr . iif oif' expression works as expected.
> 
> [...]

Here is the summary with links:
  - [1/1] netfilter: nft_fib: Fix for rpath check with VRF devices
    https://git.kernel.org/netdev/net-next/c/2a8a7c0eaa87

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


