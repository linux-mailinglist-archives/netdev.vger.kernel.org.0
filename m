Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AB2645333
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiLGEu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiLGEuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3457328E00
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D060FB81CFD
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81D63C433D7;
        Wed,  7 Dec 2022 04:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670388616;
        bh=w+iN9nQOPyQ8a9UGv0mJb5rAVG5BHm7gLalGUrJRzpU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OKH3lOIX9aRVvZZKuLtmISUIFihu4+SkBRLJcbjNShb7dcbDaCGSAdHuyrAChuSI4
         A3LoU07aN8Jk2NgUuBaS7if3ZDzHXKWlatYnZ72cXaG7HDZFIgcODGZ7MyrbirgtV0
         L2aDNubIlKzTaM7dDbgc5LnxdD4yndceCZ2hUJd5KIDC+zN5Uu4RP04Vd7xttCy9lh
         UzSJLjaP87N/Y5PlsUKXxWrKDnZ5jJ01x/cmLZqgCTKziR/C9VGkz29o2UyY3QBhy3
         wlrLg4RRUFr6MCxVprriFtWqnVdZfGpWgs7vJCe+dH4UuiNn+bovjPqsGdrmi+wuF/
         zp2pNDm4l5drw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DA0FC5C7C6;
        Wed,  7 Dec 2022 04:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2022-12-05 (i40e)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167038861644.25696.8432380905804887657.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 04:50:16 +0000
References: <20221205212523.3197565-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221205212523.3197565-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon,  5 Dec 2022 13:25:20 -0800 you wrote:
> This series contains updates to i40e driver only.
> 
> Michal clears XPS init flag on reset to allow for updated values to be
> written.
> 
> Sylwester adds sleep to VF reset to resolve issue of VFs not getting
> resources.
> 
> [...]

Here is the summary with links:
  - [net,1/3] i40e: Fix not setting default xps_cpus after reset
    https://git.kernel.org/netdev/net/c/82e0572b2302
  - [net,2/3] i40e: Fix for VF MAC address 0
    https://git.kernel.org/netdev/net/c/085019704720
  - [net,3/3] i40e: Disallow ip4 and ip6 l4_4_bytes
    https://git.kernel.org/netdev/net/c/d64aaf3f7869

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


