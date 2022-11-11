Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213CF6259F0
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 13:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiKKMAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 07:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbiKKMAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 07:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FC1623AC
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 04:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58E4261FB1
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3E5FC433D7;
        Fri, 11 Nov 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668168016;
        bh=D0c9+qhl4s2QKpQw2HbDKHmQxJfwmUGzKIOKzQgexB8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NUqL/N81lvXHly6wdWtbeo/q9vKZ4plQHZlYOgxK0ufttX21n8WUpXQ5Jvzu93ceL
         m/pQeGNX6tTR/Nwfnc0puwmqDIc7oI7KhCSMC08U6+oQSbYinGr/dQygYcNdlWN5w5
         7LwG3PuJStRk6OHpp4Ey9jKrGjo7CP4GiTUdPyTu3qOq/074ubWpxYi/1d0PGnxMxr
         95QrgEifX9JDVjLH2M959y2D9TxrHnNEvDPNQgTEnK4NYieu/ZZMwG1sIx63ucAJuE
         pXjM7ASgWZSugQXz4lYp7rjoDYy9Usshg0CxdkXHouk8qROS6KA3RrWC4PWuzAU1pq
         dunZHtb/895qg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86737E270C6;
        Fri, 11 Nov 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] ptp: convert remaining users of .adjfreq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166816801654.11070.12352746454131401806.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 12:00:16 +0000
References: <20221109230945.545440-1-jacob.e.keller@intel.com>
In-Reply-To: <20221109230945.545440-1-jacob.e.keller@intel.com>
To:     Keller@ci.codeaurora.org, Jacob E <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, richardcochran@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Nov 2022 15:09:36 -0800 you wrote:
> A handful of drivers remain which still use the .adjfreq interface instead
> of the newer .adjfine interface. The new interface is preferred as it has a
> more precise adjustment using scaled parts per million.
> 
> A handful of the remaining drivers are implemented with a common pattern
> that can be refactored to use the adjust_by_scaled_ppm and
> diff_by_scaled_ppm helper functions. These include the ptp_phc, ptp_ixp64x,
> tg3, hclge, stmac, cpts and bnxt drivers. These are each refactored in a
> separate change.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] ptp_phc: convert .adjfreq to .adjfine
    https://git.kernel.org/netdev/net-next/c/2e77eded8ec3
  - [net-next,2/9] ptp_ixp46x: convert .adjfreq to .adjfine
    https://git.kernel.org/netdev/net-next/c/319d77e9d059
  - [net-next,3/9] ptp: tg3: convert .adjfreq to .adjfine
    https://git.kernel.org/netdev/net-next/c/e3f18e9d353a
  - [net-next,4/9] ptp: hclge: convert .adjfreq to .adjfine
    https://git.kernel.org/netdev/net-next/c/974557020a59
  - [net-next,5/9] ptp: stmac: convert .adjfreq to .adjfine
    (no matching commit)
  - [net-next,6/9] ptp: cpts: convert .adjfreq to .adjfine
    https://git.kernel.org/netdev/net-next/c/a45392071cee
  - [net-next,7/9] ptp: bnxt: convert .adjfreq to .adjfine
    https://git.kernel.org/netdev/net-next/c/a29c132f92ed
  - [net-next,8/9] ptp: convert remaining drivers to adjfine interface
    https://git.kernel.org/netdev/net-next/c/e2bd9c76c89f
  - [net-next,9/9] ptp: remove the .adjfreq interface function
    https://git.kernel.org/netdev/net-next/c/75ab70ec5cef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


