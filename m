Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC5C63FF6F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiLBEUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiLBEUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:20:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A55D159F
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 20:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DAA561238
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66EF1C43470;
        Fri,  2 Dec 2022 04:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669954815;
        bh=pDC0TAPYQHsiaDCQ4vKiVZybdu3DmFtvtIx89IAGToM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=slczaE7h2VLKylKt/OVmkXz1zbtnNEHRrmqNpAhY57R5Gfs/o7zK92SZUUposaGGZ
         ou3iqFQ77cgdTsCeG62/G4ytAYYefha+hac0zPr5cSqOA+klbkIX7gTYcRwiE6XLy0
         /hlD8kTjS31clQsYi0Cg71PNgn3HPC+D9XdLOaXoS5h7eUKUbhxLEcfSvTTb2zg+A3
         lhtiAxKspuP23p/DrjwEcF1h5vVQA5FnRh4V53IDDxJ/ABGQzCpNNTdeeqwL+f8VrA
         muriEYg6XOHxW0VovFtN+Xijf55EVr7SW+Wa4piPylETiSNgLgFp+e8Ps2+I+21rGZ
         TQ2x4ddyHfJIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C73AE29F38;
        Fri,  2 Dec 2022 04:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-11-30 (e1000e, igb)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166995481530.23610.6478921023189893172.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 04:20:15 +0000
References: <20221130194228.3257787-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221130194228.3257787-1-anthony.l.nguyen@intel.com>
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

On Wed, 30 Nov 2022 11:42:26 -0800 you wrote:
> This series contains updates to e1000e and igb drivers.
> 
> Akihiko Odaki fixes calculation for checking whether space for next
> frame exists for e1000e and properly sets MSI-X vector to fix failing
> ethtool interrupt test for igb.
> 
> The following are changes since commit 01f856ae6d0ca5ad0505b79bf2d22d7ca439b2a1:
>   Merge tag 'net-6.1-rc8-2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE
> 
> [...]

Here is the summary with links:
  - [net,1/2] e1000e: Fix TX dispatch condition
    https://git.kernel.org/netdev/net/c/eed913f6919e
  - [net,2/2] igb: Allocate MSI-X vector when testing
    https://git.kernel.org/netdev/net/c/28e96556baca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


